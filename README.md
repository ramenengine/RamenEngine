# Really Accessible Multimedia ENgine

RAMEN is a 2D game engine in ANS Forth.  It is based on the [AllegroForthKit](https://github.com/RogerLevy/AllegroForthKit) cross-platform standard Forth framework.

RAMEN is a "breakaway engine."  It has the traits of a game engine but it's also a framework; it has a standard configuration, but most of its parts are optional. Like a Mr. Potatohead. I've strived to make the parts easy-to-understand and sufficiently decoupled.

I recommend having a one-project-per-instance workflow.  Clone it for each project rather than housing multiple projects under a single installation so you won't have to deal with conflicts as much, and you can make deep modifications in your own branch.

## Features

- [Tiled](https://www.mapeditor.org/) map support (partial)
- Sprite animation
- Display list 
- Fast AABB (rectangle) collision detection
- Roundrobin multitasking
- Simplified graphics wordset
- Publish facility
- Z-sorting
- Basic sound effect support and BGM streaming
- Data structures: 2D arrays, stacks, node trees
- Fixed-point literals
- 2D vector wordset

## See it in action

Want to watch some videos?  Here's footage of examples from my previous engine.  They're being brought over to RAMEN.  

https://www.youtube.com/playlist?list=PLO8m1cHe8erpbejS5yZVJAsQNI4Lmpo_Y

You can also check out The Lady, a commercial game I wrote in Forth to prove it can be done.  Large chunks of this game's engine live on in RAMEN.

https://store.steampowered.com/app/341060/The_Lady/

## Getting Started

1. Clone an [AllegroForthKit](https://github.com/RogerLevy/AllegroForthKit) instance. See the README for supported platforms and installation instructions.
1. Go into your install directory and `git clone https://github.com/RogerLevy/ramen.git` 
1. Load up your Forth system and check out the included examples in the ex/ folder.  (E.g. `sf include ramen/ex/exdepth` on SwiftForth.)
1. There is also some stuff in the test/ directory.

## Help

Documentation currently consists of explanatory comments strewn throughout the source, plus the examples and tests.  The Wiki tab will be the place for dox and the Issues tab will be the place for discussion.

I'm available to help one-on-one [on Facebook](https://www.facebook.com/inkajoo).  

## In the Pipeline

- [ ] Scaling, rotation, tint, and flip support w/ TMX files  
- [ ] Isometric collision detection
- [ ] Shaders
- [ ] GUI module
- [ ] More examples
