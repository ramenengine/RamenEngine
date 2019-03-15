Ramen 2.0

main distribution package for the Ramen game engine.  make commercial-quality games in Forth.

i've gone from a submodule-based system to including all dependencies in the repository.

the following repositories will be used to house the stable releases of each dependency from now on:

- [AllegroForthKit](https://github.com/RogerLevy/afkit) 
- [Ramen](https://github.com/RogerLevy/ramen)
- [Workspace](https://github.com/RogerLevy/ws)
- [Venery](https://github.com/RogerLevy/venery)
- [3d Packet](https://github.com/RogerLevy/3dpack)

## Features

* Built on Allegro 5, using [AllegroForthKit](https://github.com/RogerLevy/AllegroForthKit).
* [Tiled](https://www.mapeditor.org/) map support \(partial\)
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

## See Ramen in Action

Want to watch some videos? Here's footage of examples from Ramen's predecessor. They're being updated to work on Ramen.

[https://www.youtube.com/playlist?list=PLO8m1cHe8erpbejS5yZVJAsQNI4Lmpo\_Y](https://www.youtube.com/playlist?list=PLO8m1cHe8erpbejS5yZVJAsQNI4Lmpo_Y)

Also check out [The Lady](https://store.steampowered.com/app/341060/The_Lady/%20), a commercial game I wrote in Forth to prove it can be done. Large chunks of this game's engine live on in Ramen.

## Getting Started

1. Download [SwiftForth](https://www.forth.com/swiftforth/). 
1. After installation is complete, add SwiftForth's bin\ folder to your PATH.
1. Download or clone [ramenExamples](https://github.com/RogerLevy/ramenExamples)
1. Copy kitconfig.f to your drive's root folder and customize it if desired.
1. Start start.bat or from the commandline type "sf include loader"

Note: SwiftForth's evaluation version doesn't support creating executables, and therefore none of the make scripts will work.  Work on porting to VFX is underway.

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
