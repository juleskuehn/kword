---
title: "ASCII generator mkI"
layout: "normal"
---

<div id="container">
	<nav id="steps">
		<a href="#weights">Calibrate weights</a>
		<a href="#geometry">Calibrate geometry</a>
		<a href="#image">Convert image</a>
	</nav>
	<section id="weights">
		<div class="instructions">

		</div>
		<div class="upload">
		</div>
		<form>
			Font family: <input type="text" id="font_family" value="Monospace"></input>
			Font size: <input type="text" id="font_size" value="24px"></input>
		</form>
	</section>
	<section id="geometry">
		<div class="instructions">

		</div>
		<div class="upload">
		</div>
		<form>
			Columns: <input type="text" id="columns"></input>
			Row max: <input type="text" id="row_max"></input>
		</form>
	</section>
	<section id="image">
		<div class="instructions">

		</div>
		<div class="upload">
		</div>
	</section>
</div>
<canvas id="character_set" width="2000" height="7000"></canvas>