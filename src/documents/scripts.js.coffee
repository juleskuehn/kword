aspect = 0
aspectRatio = 0
char = {}
subpixels = 1
ultimateMode = true
charsetCount = 0
rowLength = 0

drawCharacterSet = ->
	charsetCount = 0
	fontFamily = $('#font_family').val()
	fontSize = $('#font_size').val()
	subpixels = $('#subpixels').val()
	chars_canvas = document.getElementById('character_set')
	chars_canvas.width = chars_canvas.width
	chars = chars_canvas.getContext('2d')
	if document.getElementById('for_print').checked
		fontSize = 72
	chars.font = fontSize + 'px ' + fontFamily
	chars.textBaseline = 'bottom'
	char =
		width: chars.measureText('.').width
		height: fontSize * 1.5
	aspect = (char.width / fontSize) / $('#line_height').val()
	lines = $('#char_set').val()
	window.weights = []

	# count characters

	for i in [0...lines.length]
		for j in [0...lines[i].length]
			charsetCount++

	console.log charsetCount

	for s in [1..subpixels]
		sp = s
		for i in [0...lines.length]
			chars.fillText lines[i], 0, char.height*(i+1)
			for j in [0...lines[i].length]
				for y in [0...sp]
					for x in [0...sp]				##bugs here!!!
						imgData = chars.getImageData(\
							char.width * (j + x / sp), \
							char.height * (i + y / sp), \
							char.width / sp, char.height / sp)
						weight = 0 # subpixel weight
						for p in [3...imgData.data.length] by 4
							weight += imgData.data[p]
						window.weights.push {darkness:weight,character:lines[i][j],sp:sp}

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
		w.brightness = Math.round(255 - (255*(w.darkness-minWeight))/(maxWeight-minWeight))
		console.log('weights')

entityMap =
	"&": "&amp;"
	"<": "&lt;"
	">": "&gt;"
	'"': '&quot;'
	"'": '&#39;'
	"/": '&#y2F;'

escapeHtml = (string) ->
	return String(string).replace(/[&<>"'\/]/g, (s) -> return entityMap[s])

imgToText = ->
	console.log 'imgToText'

	# get the settings right
	ditherFine = document.getElementById('dither_fine').checked
	ditherWide = document.getElementById('dither_wide').checked
	fontFamily = $('#font_family').val()
	fontSize = $('#font_size').val()
	$('#output_ascii').css('font-family',fontFamily)\
		.css('font-size',fontSize+'px')\
		.css('line-height',fontSize*$('#line_height').val()+'px')
	text = ''

	# compare various character supersamples to find best match
	for s in [1..subpixels]

		# get the images and attributes
		source = document.getElementById('adjust_image_'+s)
		cvs = source.getContext('2d')
		[h,w] = [source.height,source.width]
		grD = greyscale(source) # array of pixel values

		for i in [0...h/s] # loop through 'character grid' rows

			for j in [0...w/s] # loop through 'character grid' cols

				compare = []
				
				# each character
				for ch in [0...grD.length] by s*s

					for y in [0...s] # subpixel y

						for x in [0...s] # subpixel x

							# each subpixel
							b = grD[y*s+x]
							c = window.weights[ch+y*s+x]
							thisChar = _.find(compare, (n) ->
								return n.character is c.character and n.sp is s
							)
							if thisChar is undefined
								compare.push({character:c.character,err:[],sp:s})
								thisChar = _.find(compare, (n) ->
									return n.character is c.character
								)
							err = c.brightness - b
							thisChar.err.push err


							# subpixel dithering
							# grD[y*s+x] = c.brightness
							if ditherFine
								if y+1 < s
									grD[y*s+x+1] += (err * 7/16)
								if x+1 < s and y-1 > 0
									grD[(y+1)*s + x-1] += (err * 3/16)
								if x+1 < s
									grD[(y+1)*s + x] += (err * 5/16)
								if x+1 < s and y+1 < s
									grD[(y+1)*s + j+1] += (err * 1/16)

				# now pick the closest shape based on total error summation
				for c in compare
					c.shapeErr = 0
					c.colorErr = 0
					for err in c.err
						c.shapeErr += Math.abs(err)
						c.colorErr += err
				bestChoice[i][j].push _.min(compare,(w) -> w.shapeErr)

			# don't forget to dither again
#			if ditherWide
#				err = bestChoice.err # microdither! :)
#				for y in [0...sp]
#					for x in [0...sp]
#						#gr[i*w*sp + j*sp + y + x*w]
#						if j+1 < w/sp # right side
#							gr[sp*(i*w+j+1)+y*w+x] += (err[y*sp+x] * 7/16)
#						if i+1 < h/sp and j-1 > 0 # left bottom
#							gr[sp*(w*(i+1)+j-1)+y*w+x] += (err[y*sp+x] * 3/16)
#						if i+1 < h/sp # bottom
#							gr[sp*(w*(i+1)+j)+y*w+x] += (err[y*sp+x] * 5/16)
#						if i+1 < h/sp and j+1 < w/sp # bottom right
#							gr[sp*(w*(i+1)+j+1)+y*w+x] += (err[y*sp+x] * 1/16)

	for i in [0..rowLength]

		for j in rowLength*aspectRatio*aspect

			# append best character to row
			row += _.min(bestChoice[i][j],(w) -> w.shapeErr).character

		#append row to output ASCII
		text += escapeHtml(row) + '<br />'

	$('#output_ascii').html(text)

greyscale = (canvas) ->
	greyscaleMethod = $('#bw').val()
	customR = $('#customR').val()
	customG = $('#customG').val()
	customB = $('#customB').val()
	greyArray = []
	cvs = canvas.getContext('2d')
	imgData = cvs.getImageData(0,0,canvas.width,canvas.height)
	imgData = imgData.data
	for p in [0...imgData.length] by 4
		l = 0
		if greyscaleMethod is 'ccir'
			[r,g,b] = [0.2989, 0.5870, 0.1140]
		else if greyscaleMethod is 'cie'
			[r,g,b] = [0.2126, 0.7152, 0.0722]
		else if greyscaleMethod is 'flat'
			[r,g,b] = [0.3333, 0.3333, 0.3333]
		else if greyscaleMethod is 'red'
			[r,g,b] = [1, 0, 0]
		else if greyscaleMethod is 'green'
			[r,g,b] = [0, 1, 0]
		else if greyscaleMethod is 'blue'
			[r,g,b] = [0, 0, 1]
		l += imgData[p] * r * customR * imgData[p+3] / 255 #Red
		l += imgData[p+1] * g * customG * imgData[p+3] / 255 #Green
		l += imgData[p+2] * b * customB * imgData[p+3] / 255 #Blue
		greyArray.push(l)
	return greyArray

render = (src) ->
	console.log 'render'
	$('#image').html ''
	subpixels = $('#subpixels').val()
	image = {}
	for s in [1..subpixels]
		console.log 'subpixel-render'
		imagesHtml = '<canvas id="adjust_image_'+s+'" width="1" height="1" style="display:none"></canvas>'
		$('#image').append imagesHtml
		image[s] = new Image()
		image[s].onload = ->
			console.log 'img-onload'
			rowLength = $('#row_length').val()
			canvas = $('#adjust_image_'+s)
			ctx = canvas.getContext("2d")
			aspectRatio = image.height/image.width
			canvas.width = rowLength * subpixels
			canvas.height = rowLength*aspectRatio*aspect * subpixels
			ctx.drawImage(image, 0, 0, canvas.width, canvas.height)
		image[s].src = src

	image[subpixels].onload = ->
		console.log 'lets go'
		imgToText()

theImage = ''

loadImage = (src) ->
	# Prevent any non-image file type from being read.
	if !src.type.match(/image.*/)
		console.log("The dropped file is not an image: ", src.type)
		return

	# Create our FileReader and run the results through the render function.
	reader = new FileReader()
	reader.onload = (e) ->
		theImage = e.target.result
		console.log 'imgload'
		render(theImage)
	reader.readAsDataURL(src)

# Drag and drop listeners

target = document.getElementById("container")
target.addEventListener("dragover", (e) ->
	e.preventDefault()
, true)
target.addEventListener("drop", (e) ->
	e.preventDefault()
	loadImage(e.dataTransfer.files[0])
, true)

$('document').ready ->
	drawCharacterSet()
	$('#output_ascii').draggable()

$('#font_family').change ->
	fontFamily = $('this').val()
	drawCharacterSet()
	if theImage != ''
		render(theImage)

$('#char_set').change ->
	lines = $('this').val()
	drawCharacterSet()
	if theImage != ''
		render(theImage)

$('#font_size').change ->
	fontSize = $('this').val()
	drawCharacterSet()
	if theImage != ''
		render(theImage)

$('#row_length').change ->
	rowLength = $('this').val()
	if theImage != ''
		render(theImage)

$('#subpixels').change ->
	subpixels = $('this').val()
	drawCharacterSet()
	if theImage != ''
		render(theImage)

$('#customR').change ->
	if theImage != ''
		render(theImage)

$('#customG').change ->
	if theImage != ''
		render(theImage)

$('#customB').change ->
	if theImage != ''
		render(theImage)

$('#shape_val').change ->
	if theImage != ''
		render(theImage)

$('#color_val').change ->
	if theImage != ''
		render(theImage)

$('form').submit ->
	return false

$('#bw').change ->
	if theImage != ''
		render(theImage)

$('#dither_fine').change ->
	if theImage != ''
		render(theImage)

$('#dither_wide').change ->
	if theImage != ''
		render(theImage)

$('#ultimate_mode').change ->
	drawCharacterSet()
	if theImage != ''
		render(theImage)

$('#line_height').change ->
	aspect = (char.width / (char.height / 1.5)) / $($('this')).val()
	if theImage != ''
		render(theImage)

$('#for_print').change ->
	drawCharacterSet()
	if theImage != ''
		render(theImage)

