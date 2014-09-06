(function() {
  var drawCharacterSet;

  drawCharacterSet = function() {
    var char, chars, chars_canvas, fontFamily, fontSize, i, imgData, j, k, line, lines, n, p, weight, _i, _j, _k, _l, _m, _n, _o, _p, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _results;
    fontFamily = $('#font_family').val();
    fontSize = $('#font_size').val();
    chars_canvas = document.getElementById('character_set');
    chars_canvas.width = chars_canvas.width;
    chars = chars_canvas.getContext('2d');
    chars.font = fontSize + ' ' + fontFamily;
    chars.textBaseline = 'bottom';
    char = {
      width: chars.measureText('.').width,
      height: fontSize.split('px')[0] * 1.5
    };
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
    chars.font = char.height * 0.25 + 'px ' + fontFamily;
    line = '';
    n = 2;
    _results = [];
    for (i = _n = 0, _ref5 = window.weights.length; _n < _ref5; i = _n += 12) {
      for (j = _o = 0; _o < 12; j = ++_o) {
        if (i + j >= window.weights.length) {
          break;
        }
        line += Array(5).join(window.weights[i + j].character);
        line += ' ';
      }
      for (k = _p = 1; _p <= 3; k = ++_p) {
        chars.fillText(line, lines[0].length * char.width + 10, char.height * 0.25 * n);
        n++;
      }
      n++;
      _results.push(line = '');
    }
    return _results;
  };

  $('document').ready(function() {
    return drawCharacterSet();
  });

  $('#font_family').change(function() {
    return drawCharacterSet();
  });

  $('#font_size').change(function() {
    return drawCharacterSet();
  });

}).call(this);
