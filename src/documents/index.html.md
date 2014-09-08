---
title: "ASCII generator mkI"
layout: "normal"
---

<div id="container">
	<h1>Calibrated ASCII image generator</h1>
	<nav id="steps">
		<a href="#calibrate">Calibrate font</a>
		<a href="#adjust">Adjust gradient</a>
		<a href="#image">Convert image</a>
		<a href="#result">Preview result</a>
	</nav>
	<section id="calibrate">
		<h2>Calibrate font</h2>
		<div id="from_font">
			<h3>Installed font</h3>
			<form>
				Font family: <input type="text" id="font_family" value="Monospace"></input>
				Font size: <input type="text" id="font_size" value="24"></input>px <br />
				Line height: <input type="text" id="line_height" value="1.5"></input>* font size
				<input type="checkbox" id="for_print"></input> For printing
			</form>
		</div>
		<div id="from_image">
			<h3>From image</h3>
			<form>
				From url: <input type="text" id="charset_url" value=""></input>
			</form>
			Drag and drop image of character set
		</div>
		<canvas id="character_set" width="500" height="500"></canvas>
	</section>
	<section id="adjust">
		<h2>Adjust gradient</h2>
		Drag blocks to adjust greyscale values
		<canvas id="adjust_gradient" width="500" height="500"></canvas>
	</section>
	<section id="image">
		<h2>Convert image</h2>
		<form>
			From url: <input type="text" id="image_url" value=""></input>
		</form>
		<p>Drag and drop image to be converted</p>
		<canvas id="adjust_image" width="500" height="500"></canvas>
	</section>
	<section id="result">
		<h2>Preview Result</h2>
		<form>
			<input type="checkbox" id="plain_text" checked></input> Output plain text <br />
			Row length: <input type="text" id="row_length" value="78"></input> characters
		</form>
		<pre id="output_ascii"></pre>
		<canvas id="preview_result" width="500" height="500"></canvas>
	</section>
</div>