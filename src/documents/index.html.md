---
title: "ASCII generator mkII"
layout: "normal"
---

<div id="container">

	<div id="sidebar">

		<h2>Drop image file</h2>

		<section id="calibrate">

			<p style="display:none"><a href="#" class="selected" id="font">Specify font</a> or <a href="#" id="scan">use image</a></p>

			<div id="from_font">
				<form>
					Font: <input type="text" id="font_family" value="Luxi Mono"></input><br />
					Character Set (include space if desired): <input type="textarea" id="char_set" value="±1234567890-=°#&quot;/$%*&amp;'()_+qwfpgjluy;[]QWFPGJLUY:arstdhneioARSTDHNEIOzxcvbkm,.ZXCVBKM<>/`ˆ§?éç "></input><br />			
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

			<input type="range" id="customR" min="0" max="3" value="1" step="0.01">Red<br />
			<input type="range" id="customG" min="0" max="3" value="1" step="0.01">Green<br />
			<input type="range" id="customB" min="0" max="3" value="1" step="0.01">Blue<br />

			<input type="range" id="row_length" min="10" max="200" value="98" step="1">Line Length<br />
			<input type="range" id="line_height" min="0" max="2" value="0.6" step="0.01">Line Spacing<br />
			<input type="range" id="subpixels" min="1" max="7" value="1" step="1">Subpixels<br />

			<input type="checkbox" id="dither_fine" checked></input> Dither (Fine)<br />

			<input type="checkbox" id="dither_wide" checked></input> Dither (Wide)<br />

			<input type="checkbox" id="ultimate_mode" checked></input> Ultimate Mode<br />


		</form>

	</div> <!-- end sidebar -->

	<div id="preview_chooser">
		<a id="choose_preview" href="#preview">Preview</a>
		<a id="choose_text" href="#plaintext">Plain text</a>
		<a id="choose_typing" href="#typing">For typing</a>
	</div>

	<div id="preview">
		<canvas id="preview_result" width="500" height="500"></canvas>
		<pre id="output_ascii"></pre>
	</div>

	<!-- end preview -->


</div>


<div id="image">
	<canvas id="adjust_image_1" width="1" height="1" style="display:none"></canvas>
	<canvas id="adjust_image_2" width="1" height="1" style="display:none"></canvas>
	<canvas id="adjust_image_3" width="1" height="1" style="display:none"></canvas>
	<canvas id="adjust_image_4" width="1" height="1" style="display:none"></canvas>
	<canvas id="adjust_image_5" width="1" height="1" style="display:none"></canvas>
	<canvas id="adjust_image_6" width="1" height="1" style="display:none"></canvas>
	<canvas id="adjust_image_7" width="1" height="1" style="display:none"></canvas>
	<canvas id="adjust_image_8" width="1" height="1" style="display:none"></canvas>
	<canvas id="adjust_image_9" width="1" height="1" style="display:none"></canvas>
	<canvas id="adjust_image_0" width="1" height="1" style="display:none"></canvas>
</div>