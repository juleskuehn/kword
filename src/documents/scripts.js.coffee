aspect = 0

drawCharacterSet = ->

	fontFamily = $('#font_family').val()
	fontSize = $('#font_size').val()
	chars_canvas = document.getElementById('character_set')
	chars_canvas.width = chars_canvas.width
	chars = chars_canvas.getContext('2d')
	chars.font = fontSize + 'px ' + fontFamily
	chars.textBaseline = 'bottom'
	char =
		width: chars.measureText('.').width
		height: fontSize * 1.5
	lines = [
		"1234567890-="
		"!@#$%^&*()_+"
		"qwfpgjluy;[]"
		"QWFPGJLUY:{}"
		"arstdhneio'`"
		"ARSTDHNEIO\"~"
		"zxcvbkm,./\\|"
		"ZXCVBKM<>? "
	]
	window.weights = []
	for i in [0...lines.length]
		chars.fillText lines[i], 0, char.height*(i+1)
		for j in [0...lines[i].length] by 1
			imgData = chars.getImageData(\
				char.width * j, char.height * i, \
				char.width, char.height )
			weight = 0
			for p in [3...imgData.data.length] by 4
				weight += imgData.data[p]
			window.weights.push {img:imgData,darkness:weight,\
				character:lines[i][j]}
	for i in [0...lines.length] by 1
		for j in [0...lines[i].length]
			chars.strokeStyle = '#ffff00'
			chars.beginPath()
			chars.moveTo(char.width * j, char.height * i)
			chars.lineTo(char.width * (j+1), char.height * i)
			chars.lineTo(char.width * (j+1), char.height * (i+1) )
			chars.lineTo(char.width * (j), char.height * (i+1) )
			chars.lineTo(char.width * j, char.height * i)
			chars.stroke() 
	window.weights = _(window.weights).sortBy('darkness')
	maxWeight = _.max(window.weights,(w) -> w.darkness).darkness
	minWeight = _.min(window.weights,(w) -> w.darkness).darkness
	for w in window.weights
		w.brightness = 255 - (255*(w.darkness-minWeight))/(maxWeight-minWeight)
	drawGradient()

drawGradient = ->
	fontFamily = $('#font_family').val()
	fontSize = $('#font_size').val()
	gradient_canvas = document.getElementById('adjust_gradient')
	gradient_canvas.width = gradient_canvas.width
	gradient = gradient_canvas.getContext('2d')
	gradient.font = fontSize + 'px ' + fontFamily
	fontSize *= 0.4
	gradient.font = fontSize + 'px ' + fontFamily
	gradient.textBaseline = 'bottom'
	char =
		width: gradient.measureText('.').width
		height: fontSize * 1.5
	aspect = char.width / char.height
	line = ''
	n = 2
	for i in [0...window.weights.length] by 12
		for j in [0...12]
			if i+j >= window.weights.length
				break
			line += Array(5).join window.weights[i+j].character
			line += ' '
		for k in [1..3]
			gradient.fillText line, 10, char.height * n
			n++
		n++
		line = ''

entityMap =
	"&": "&amp;"
	"<": "&lt;"
	">": "&gt;"
	'"': '&quot;'
	"'": '&#39;'
	"/": '&#x2F;'

escapeHtml = (string) ->
	return String(string).replace(/[&<>"'\/]/g, (s) -> return entityMap[s])

imgToText = ->
	rowLength = $('#row_length').val()
	source = document.getElementById("adjust_image")
	cvs = source.getContext('2d')
	fontFamily = $('#font_family').val()
	$('#output_ascii').css('font-family',fontFamily)
	text = ''
	for i in [0...source.height]
		row = ''
		window.imgData = cvs.getImageData(0,i,source.width,1)
		for p in [0...imgData.data.length] by 4
			b = imgData.data[p]
			# find corresponding ascii character
			closest = null
			for c in window.weights
				if closest is null or Math.abs(c.brightness-b) < closeness
					closest = c
					closeness = Math.abs(c.brightness-b)
			row += closest.character
		text += escapeHtml(row) + '<br />'
	$('#output_ascii').html(text)

render = (src) ->
	image = new Image();
	image.onload = ->
		canvas = document.getElementById("adjust_image")
		ctx = canvas.getContext("2d")
		ctx.clearRect(0, 0, canvas.width, canvas.height)
		canvas.width = image.width
		canvas.height = image.height
		ctx.drawImage(image, 0, 0, image.width, image.height)
		imgToText()
	image.src = src

loadImage = (src) ->
	# Prevent any non-image file type from being read.
	if !src.type.match(/image.*/)
		console.log("The dropped file is not an image: ", src.type)
		return

	# Create our FileReader and run the results through the render function.
	reader = new FileReader()
	reader.onload = (e) ->
		render(e.target.result)
	reader.readAsDataURL(src)

# Drag and drop listeners

target = document.getElementById("adjust_image")
target.addEventListener("dragover", (e) ->
	e.preventDefault()
, true)
target.addEventListener("drop", (e) ->
	e.preventDefault()
	loadImage(e.dataTransfer.files[0])
, true)

$('document').ready ->
	drawCharacterSet()

$('#font_family').change ->
	drawCharacterSet()

$('#font_size').change ->
	drawCharacterSet()