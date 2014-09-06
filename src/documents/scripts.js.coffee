drawCharacterSet = ->

	fontFamily = $('#font_family').val()
	fontSize = $('#font_size').val()
	chars_canvas = document.getElementById('character_set')
	chars_canvas.width = chars_canvas.width
	chars = chars_canvas.getContext('2d')
	chars.font = fontSize + ' ' + fontFamily
	chars.textBaseline = 'bottom'
	char =
		width: chars.measureText('.').width
		height: fontSize.split('px')[0] * 1.5
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
	chars.font = char.height * 0.25 + 'px ' + fontFamily
	line = ''
	n = 2
	for i in [0...window.weights.length] by 12
		for j in [0...12]
			if i+j >= window.weights.length
				break
			line += Array(5).join window.weights[i+j].character
			line += ' '
		for k in [1..3]
			chars.fillText line, lines[0].length*char.width + 10, char.height * 0.25 * n
			n++
		n++
		line = ''

$('document').ready ->
	drawCharacterSet()

$('#font_family').change ->
	drawCharacterSet()

$('#font_size').change ->
	drawCharacterSet()