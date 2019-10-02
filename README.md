Ramen 2.0

a 2D game dev framework and optional engine for making commercial-quality PC games in Forth.

i've gone from a submodule-based system to including all dependencies in the repository.

the following repositories will house the stable releases of each dependency from now on:

- [AllegroForthKit](https://github.com/RogerLevy/afkit) 
- [Ramen](https://github.com/RogerLevy/ramen) (archived for history)
- [Workspace](https://github.com/RogerLevy/ws)
- [Venery](https://github.com/RogerLevy/venery)

## Features

* Built on Allegro 5, using [AllegroForthKit](https://github.com/RogerLevy/AllegroForthKit).
* Sprite animation
* Multiple display list support
* Interactive commandline console
* Fast rectangle collision detection
* Roundrobin multitasking
* Graphics primitives such as line, rectangle, ellipse, blit, text, etc.
* Publish facility
* Z-sorted rendering
* Basic sound support
* Collections with [Venery](https://github.com/RogerLevy/venery)

## Getting Started

1. Download [SwiftForth](https://www.forth.com/swiftforth/). 
1. After installation is complete, add SwiftForth's bin\ folder to your PATH.
1. Copy kitconfig.f to your drive's root folder and customize it if desired.
1. Run ramen.bat

Note: SwiftForth's evaluation version doesn't support creating executables, therefore none of the make scripts will work.  Work on porting to GForth is underway.

## Help

* Submit [Issues](https://github.com/RogerLevy/ramen/issues)
* Tweet [@RamenEngine](https://twitter.com/RamenEngine) 

## Links and Resources

* [Forth: The Hacker's Language on HACKADAY](https://hackaday.com/2017/01/27/forth-the-hackers-language/)
* [Programming Forth by Stephen Pelc](http://www.mpeforth.com/arena/ProgramForth.pdf)
* [Forth Programming 21st Century on Facebook](https://www.facebook.com/groups/PROGRAMMINGFORTH/) - The current active and growing forum on the web for modern desktop Forth programming \(as opposed to on embedded or classic computers.\) 
* [Allegro 5.2.3 Documentation](http://liballeg.org/a5docs/5.2.3/)
* [Allegro.cc forum](https://www.allegro.cc/forums) - A very helpful and fairly active community.  And gladly, language-agnostic.
* [The DPANS94 Forth Standard](http://dl.forth.com/sitedocs/dpans94.pdf)
