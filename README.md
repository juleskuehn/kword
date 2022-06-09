# kword
Javascript image -> ASCII converter. Years later, this project led to a [much improved typewriter art generator](https://github.com/juleskuehn/typewriter-art)

[Live demo here](https://juleskuehn.github.io/kword)

![kword output](https://d23f6h5jpj26xu.cloudfront.net/dggrik0mc1pxg.png "kword output")

*Is a picture worth a 1000 word ASCII image?*

I have been tooling around with typewriter “ASCII art” style image reproduction for some time, well, since I acquired my typewriter.

I found several problems with existing image to ASCII generators for my application (reproducing digital images on a typewriter):

* Character set too small (lack of color depth)
* Character set too large (slows typing and adds false textures if asymmetrical characters are used, adds error)
* No custom font (assumes all fonts have same character gradient)
* Character set not weighed at all (character brightnesses should be measured and colors indexed for correct gamma)
* No image adjustments in-converter (monochrome balance, contrast, crop)
* No realtime preview of settings (such as line spacing, font, and line length)
* No dithering option (losing color depth, especially in highlights)

So, I decided to write an ASCII image generator of my own.
  
## Features
- Calibrates character weights per font / size
- Greyscale conversion presets and adjustment
- Realtime preview of ASCII output
- Line spacing adjustment (try < 1.0)
- Floyd-Steinberg dithering
                                     
**Use monospace fonts!**
