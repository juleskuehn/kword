---
title: "ASCII generator mkI"
layout: "normal"
---

<div id="container">

<div id="sidebar">

	<h2>Drop image file</h2>

	<section id="calibrate">

		<p style="display:none"><a href="#" class="selected" id="font">Specify font</a> or <a href="#" id="scan">use image</a></p>

		<div id="from_font">
			<form>
				Font: <input type="text" id="font_family" value="Monospace"></input><br />
				Size: <input type="text" id="font_size" value="10"></input><br />
				Character Set (include space if desired): <input type="textarea" id="char_set" value=" .:=-+%#o0XH8M$&amp; "></input><br />			
				<input type="checkbox" id="for_print"></input> For printing
			</form>
			<canvas id="character_set" width="10000" height="10000" style="display:none"></canvas>
		</div>

		<div id="from_image" style="display:none">
			<form>
				URL: <input type="text" id="charset_url" value=""></input>
			</form>
			Drag and drop image file of character set below<br />
			<canvas id="character_img" width="250" height="100"></canvas>
		</div>

		<div id="adjust" style="display:none">
			Drag to move or remove shades<br />
			<canvas id="adjust_gradient" width="250" height="100"></canvas>
		</div>

	</section>

	<section id="image">

		<canvas id="adjust_image" width="250" height="100" style="display:none"></canvas>

	</section>

	<form>

		Greyscale conversion: 

		<select id="bw">
		  <option value="ccir">CCIR 601</option>
		  <option value="cie">CIE Luma</option>
		  <option value="flat">Equal</option>
		  <option value="red">Red</option>
		  <option value="green">Green</option>
		  <option value="blue">Blue</option>
		</select><br />
		<!--
		<input type="checkbox" id="plain_text" checked></input> Plain text 
		-->
		<input type="checkbox" id="dithering" checked></input> Dither<br />

		<input type="range" id="customR" min="0" max="3" value="1" step="0.01">Red<br />
		<input type="range" id="customG" min="0" max="3" value="1" step="0.01">Green<br />
		<input type="range" id="customB" min="0" max="3" value="1" step="0.01">Blue<br />

		<input type="range" id="row_length" min="10" max="200" value="78" step="1">Line Length<br />
		<input type="range" id="line_height" min="0" max="2" value="1" step="0.01">Line Spacing<br />
		<input type="range" id="subpixels" min="1" max="7" value="1" step="1">Subpixels<br />
		<input type="range" id="shape_val" min="0" max="1" value="0.5" step="0.01">Shape<br />
		<input type="range" id="color_val" min="0" max="1" value="0.5" step="0.01">Tone<br />

	</form>

</div> <!-- end sidebar -->

<div id="preview">
	<pre id="output_ascii"></pre>
	<canvas id="preview_result" width="500" height="500" style="display:none"></canvas>
</div>


</div>