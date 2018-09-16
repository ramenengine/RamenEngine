# Ramen - the Readily Available Multimedia ENgine

Ramen is a game engine written in standard Forth.

## Features

- Built with Allegro 5, using [AllegroForthKit](https://github.com/RogerLevy/AllegroForthKit).
- [Tiled](https://www.mapeditor.org/) map support (partial)
- Sprite animation
- Multiple display list support
- Interactive commandline console
- ColorForth-inspired, minimalist code emphasizing flat data design.
- Fast rectangle collision detection
- Roundrobin multitasking
- Graphics primitives such as line, rectangle, ellipse, blit, text, etc.
- Publish facility
- Z-sorted rendering
- Basic sound support
- Data structure extensions - 2D arrays, stacks, node trees

## See Ramen in Action

Want to watch some videos?  Here's footage of examples from Ramen's predecessor.  They're being updated to work on Ramen.

https://www.youtube.com/playlist?list=PLO8m1cHe8erpbejS5yZVJAsQNI4Lmpo_Y

Also check out [The Lady](https://store.steampowered.com/app/341060/The_Lady/
), a commercial game I wrote in Forth to prove it can be done.  Large chunks of this game's engine live on in Ramen.


## Getting Started

1. You'll need [SwiftForth](https://www.forth.com/swiftforth/), likely you'll want to grab the free eval version.  Full featured except no .EXE export on Windows.  After installing add the bin folder to your path.
1. Download or clone [ramenExamples](https://github.com/RogerLevy/ramenExamples)
1. Copy and rename `afkit/kitconfig.f_` and `afkit/allegro5.cfg_` to the project root, removing the underscores.  Edit them if needed.
1. Optionally get [Komodo Edit](https://www.activestate.com/komodo-ide/downloads/edit) and loading the project file - just hit F5 and the IDE should start.
1. Otherwise load up SwiftForth, navigate to the project directory with `cd` and `include session.f` - the IDE should start.  
1. You can `ld` any of these: `depth` `flies` `rectland` `island` `stickerknight`
1. Hit Tab to toggle between IDE and the running demo.  Only `rectland` has any controls.

## Help

- Submit [Issues](https://github.com/RogerLevy/ramen/issues)

- [Documentation](http://rogerlevy.github.com/ramen) is hosted by Github Pages. (incomplete)

- The [Forth 21st Century Programming Facebook](https://www.facebook.com/groups/PROGRAMMINGFORTH/) group is a good place to ask questions or report problems, as is [ForthHub on Github](https://github.com/ForthHub/discussion/issues).

