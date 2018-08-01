# Ramen - the Really Accessible Multimedia ENgine

Ramen is a game engine written in standard Forth, based on the [AllegroForthKit](https://github.com/RogerLevy/AllegroForthKit) framework.

With Ramen you can rapidly create 2D, hardware-accelerated games on desktop OS's supported by standard Forth systems - Windows, Linux, Mac.  

Ramen is originally being developed on SwiftForth for Windows and Linux.

With Ramen and Forth, compilation of your game (and the engine itself) is near-instantaneous, like a scripting language, but runtime is  almost as fast as C.  Like interpretive languages, it's also interactive.  Update your code from within a running instance of your game, test functions, try out ideas, or change variables.  Like Assembly language, Forth also doesn't hold your hand when it comes to type-checking, but unlike Assembly you can test your functions deeply and thoroughly before putting them all together.

Ramen is a "breakaway" engine.  It functions as a game engine but also as a framework; there is a standard configuration, but most of its parts are optional and mix-and-match.  You could even replace whole parts with your own.  I've strived to make the parts easy-to-understand and decoupled.

## Features

- [Tiled](https://www.mapeditor.org/) map support (partial)
- Sprite animation
- Display list
- Fast rectangle collision detection
- Roundrobin multitasking
- Graphics
- Publish
- Z-sorted rendering
- Basic sound support
- Data structures: 2D arrays, stacks, node trees
- Fixed-point numbers
- 2D vectors

## See Ramen in Action

Want to watch some videos?  Here's footage of examples from Ramen's predecessor.  They're being updated to work on Ramen.

https://www.youtube.com/playlist?list=PLO8m1cHe8erpbejS5yZVJAsQNI4Lmpo_Y

Also check out [The Lady](https://store.steampowered.com/app/341060/The_Lady/
), a commercial game I wrote in Forth to prove it can be done.  Large chunks of this game's engine live on in Ramen.


## Getting Started

1. Download or clone [AllegroForthKit](https://github.com/RogerLevy/AllegroForthKit) into your project folder. See the README for supported platforms and installation instructions.
1. Download or clone Ramen into your project folder (as a subfolder `ramen/`). `git clone https://github.com/RogerLevy/ramen.git` 
1. Documentation is available at [Github Pages](http://rogerlevy.github.com/ramen).
1. Start your Forth system and check out the included examples in the ex/ folder.  (E.g. `sf include ramen/ex/exdepth` on SwiftForth.)
1. There is also some stuff in the test/ directory.

I recommend having a one-project-per-instance workflow.  Clone it for each project rather than housing multiple projects under a single installation so you won't have to deal with conflicts as much, and you can make deep modifications in your own branch.

## Help

- [Documentation](http://rogerlevy.github.com/ramen) is hosted by Github Pages.

- I'm available to help one-on-one [on Facebook](https://www.facebook.com/inkajoo).  

- The [Forth 21st Century Programming Facebook](https://www.facebook.com/groups/PROGRAMMINGFORTH/) group is a good place to ask questions or report problems, as is [ForthHub on Github](https://github.com/ForthHub/discussion/issues).

## Future

- [ ] Scaling, rotation, tint, and h/v flip for game objects
- [ ] Isometric tilemap and object collision detection
- [ ] Shader support
- [ ] GUI framework
