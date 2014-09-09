(function() {
  var aspect, char, drawCharacterSet, drawGradient, entityMap, escapeHtml, greyscale, imgToText, loadImage, render, target, theImage;

  aspect = 0;

  char = {};

  drawCharacterSet = function() {
    var chars, chars_canvas, fontFamily, fontSize, i, imgData, j, lines, maxWeight, minWeight, p, w, weight, _i, _j, _k, _l, _len, _m, _n, _ref, _ref1, _ref2, _ref3, _ref4, _ref5;
    fontFamily = $('#font_family').val();
    fontSize = $('#font_size').val();
    chars_canvas = document.getElementById('character_set');
    chars_canvas.width = chars_canvas.width;
    chars = chars_canvas.getContext('2d');
    if (document.getElementById('for_print').checked) {
      fontSize = 72;
    }
    chars.font = fontSize + 'px ' + fontFamily;
    chars.textBaseline = 'bottom';
    char = {
      width: chars.measureText('.').width,
      height: fontSize * 1.5
    };
    aspect = (char.width / fontSize) / $('#line_height').val();
    lines = ["1234567890-=", "!@#$%^&*()_+", "qwfpgjluy;[]", "QWFPGJLUY:{}", "arstdhneio'`", "ARSTDHNEIO\"~", "zxcvbkm,./\\|", "ZXCVBKM<>? "];
    window.weights = [];
    for (i = _i = 0, _ref = lines.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
      chars.fillText(lines[i], 0, char.height * (i + 1));
      for (j = _j = 0, _ref1 = lines[i].length; _j < _ref1; j = _j += 1) {
        imgData = chars.getImageData(char.width * j, char.height * i, char.width, char.height);
        weight = 0;
        for (p = _k = 3, _ref2 = imgData.data.length; _k < _ref2; p = _k += 4) {
          weight += imgData.data[p];
        }
        window.weights.push({
          img: imgData,
          darkness: weight,
          character: lines[i][j]
        });
      }
    }
    for (i = _l = 0, _ref3 = lines.length; _l < _ref3; i = _l += 1) {
      for (j = _m = 0, _ref4 = lines[i].length; 0 <= _ref4 ? _m < _ref4 : _m > _ref4; j = 0 <= _ref4 ? ++_m : --_m) {
        chars.strokeStyle = '#ffff00';
        chars.beginPath();
        chars.moveTo(char.width * j, char.height * i);
        chars.lineTo(char.width * (j + 1), char.height * i);
        chars.lineTo(char.width * (j + 1), char.height * (i + 1));
        chars.lineTo(char.width * j, char.height * (i + 1));
        chars.lineTo(char.width * j, char.height * i);
        chars.stroke();
      }
    }
    window.weights = _(window.weights).sortBy('darkness');
    maxWeight = _.max(window.weights, function(w) {
      return w.darkness;
    }).darkness;
    minWeight = _.min(window.weights, function(w) {
      return w.darkness;
    }).darkness;
    _ref5 = window.weights;
    for (_n = 0, _len = _ref5.length; _n < _len; _n++) {
      w = _ref5[_n];
      w.brightness = 255 - (255 * (w.darkness - minWeight)) / (maxWeight - minWeight);
    }
    return drawGradient();
  };

  drawGradient = function() {
    return console.log('to-do: gradient code');
  };

  entityMap = {
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;",
    '"': '&quot;',
    "'": '&#39;',
    "/": '&#x2F;'
  };

  escapeHtml = function(string) {
    return String(string).replace(/[&<>"'\/]/g, function(s) {
      return entityMap[s];
    });
  };

  imgToText = function() {
    var b, c, closest, cvs, dither, err, fontFamily, fontSize, gr, h, i, j, row, source, text, w, _i, _j, _k, _len, _ref, _ref1;
    source = document.getElementById("adjust_image");
    cvs = source.getContext('2d');
    dither = document.getElementById('dithering').checked;
    gr = greyscale(source);
    fontFamily = $('#font_family').val();
    fontSize = $('#font_size').val();
    $('#output_ascii').css('font-family', fontFamily).css('font-size', fontSize + 'px').css('line-height', fontSize * $('#line_height').val() + 'px');
    text = '';
    _ref = [source.height, source.width], h = _ref[0], w = _ref[1];
    for (i = _i = 0; 0 <= h ? _i < h : _i > h; i = 0 <= h ? ++_i : --_i) {
      row = '';
      for (j = _j = 0; 0 <= w ? _j < w : _j > w; j = 0 <= w ? ++_j : --_j) {
        b = gr[i * w + j];
        closest = null;
        _ref1 = window.weights;
        for (_k = 0, _len = _ref1.length; _k < _len; _k++) {
          c = _ref1[_k];
          if (closest === null || Math.abs(c.brightness - b) < Math.abs(err)) {
            closest = c;
            err = b - c.brightness;
          }
        }
        if (dither) {
          gr[i * w + j] = c.brightness;
          if (j + 1 < w) {
            gr[i * w + j + 1] += err * 7 / 16;
          }
          if (i + 1 < h && j - 1 > 0) {
            gr[(i + 1) * w + j - 1] += err * 3 / 16;
          }
          if (i + 1 < h) {
            gr[(i + 1) * w + j] += err * 5 / 16;
          }
          if (i + 1 < h && j + 1 < w) {
            gr[(i + 1) * w + j + 1] += err * 1 / 16;
          }
        }
        row += closest.character;
      }
      text += escapeHtml(row) + '<br />';
    }
    return $('#output_ascii').html(text);
  };

  greyscale = function(canvas) {
    var b, customB, customG, customR, cvs, g, greyArray, greyscaleMethod, imgData, l, p, r, _i, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6;
    greyscaleMethod = $('#bw').val();
    customR = $('#customR').val();
    customG = $('#customG').val();
    customB = $('#customB').val();
    greyArray = [];
    cvs = canvas.getContext('2d');
    imgData = cvs.getImageData(0, 0, canvas.width, canvas.height);
    imgData = imgData.data;
    for (p = _i = 0, _ref = imgData.length; _i < _ref; p = _i += 4) {
      l = 0;
      if (greyscaleMethod === 'ccir') {
        _ref1 = [0.2989, 0.5870, 0.1140], r = _ref1[0], g = _ref1[1], b = _ref1[2];
      } else if (greyscaleMethod === 'cie') {
        _ref2 = [0.2126, 0.7152, 0.0722], r = _ref2[0], g = _ref2[1], b = _ref2[2];
      } else if (greyscaleMethod === 'flat') {
        _ref3 = [0.3333, 0.3333, 0.3333], r = _ref3[0], g = _ref3[1], b = _ref3[2];
      } else if (greyscaleMethod === 'red') {
        _ref4 = [1, 0, 0], r = _ref4[0], g = _ref4[1], b = _ref4[2];
      } else if (greyscaleMethod === 'green') {
        _ref5 = [0, 1, 0], r = _ref5[0], g = _ref5[1], b = _ref5[2];
      } else if (greyscaleMethod === 'blue') {
        _ref6 = [0, 0, 1], r = _ref6[0], g = _ref6[1], b = _ref6[2];
      }
      l += imgData[p] * r * customR * imgData[p + 3] / 255;
      l += imgData[p + 1] * g * customG * imgData[p + 3] / 255;
      l += imgData[p + 2] * b * customB * imgData[p + 3] / 255;
      greyArray.push(l);
    }
    return greyArray;
  };

  render = function(src) {
    var image;
    image = new Image();
    image.onload = function() {
      var aspectRatio, canvas, ctx, rowLength;
      rowLength = $('#row_length').val();
      canvas = document.getElementById("adjust_image");
      ctx = canvas.getContext("2d");
      aspectRatio = image.height / image.width;
      canvas.width = rowLength;
      canvas.height = rowLength * aspectRatio * aspect;
      ctx.drawImage(image, 0, 0, canvas.width, canvas.height);
      return imgToText();
    };
    return image.src = src;
  };

  theImage = '';

  loadImage = function(src) {
    var reader;
    if (!src.type.match(/image.*/)) {
      console.log("The dropped file is not an image: ", src.type);
      return;
    }
    reader = new FileReader();
    reader.onload = function(e) {
      theImage = e.target.result;
      return render(theImage);
    };
    return reader.readAsDataURL(src);
  };

  target = document.getElementById("container");

  target.addEventListener("dragover", function(e) {
    return e.preventDefault();
  }, true);

  target.addEventListener("drop", function(e) {
    e.preventDefault();
    return loadImage(e.dataTransfer.files[0]);
  }, true);

  $('document').ready(function() {
    return drawCharacterSet();
  });

  $('#font_family').change(function() {
    drawCharacterSet();
    if (theImage !== '') {
      return render(theImage);
    }
  });

  $('#font_size').change(function() {
    drawCharacterSet();
    if (theImage !== '') {
      return render(theImage);
    }
  });

  $('#row_length').change(function() {
    if (theImage !== '') {
      return render(theImage);
    }
  });

  $('#customR').change(function() {
    if (theImage !== '') {
      return render(theImage);
    }
  });

  $('#customG').change(function() {
    if (theImage !== '') {
      return render(theImage);
    }
  });

  $('#customB').change(function() {
    if (theImage !== '') {
      return render(theImage);
    }
  });

  $('form').submit(function() {
    return false;
  });

  $('#bw').change(function() {
    if (theImage !== '') {
      return render(theImage);
    }
  });

  $('#dithering').change(function() {
    if (theImage !== '') {
      return render(theImage);
    }
  });

  $('#line_height').change(function() {
    aspect = (char.width / (char.height / 1.5)) / $(this).val();
    if (theImage !== '') {
      return render(theImage);
    }
  });

  $('#for_print').change(function() {
    drawCharacterSet();
    if (theImage !== '') {
      return render(theImage);
    }
  });

}).call(this);
