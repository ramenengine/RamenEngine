# Basic Usage

Download [AllegroForthKit](https://github.com/RogerLevy/AllegroForthKit/) and [Ramen](https://github.com/RogerLevy/ramen/).  Place the kit in a folder called `/afkit` and Ramen into a folder called `ramen/` either by cloning them or downloading them.

Copy/rename `kitconfig.f_` and `allegro.cfg_`, removing the underscores.  Edit them as needed.

Ramen is built on AllegroForthKit.  For documentation go [here](https://rogerlevy.github.io/AllegroForthKit).

Ramen has a standard configuration you can use out-of-the-box called Cutlet.  You'll need to load it if you want to use most of the main features.  The file `cutlet.f` loads the following modules.

- [Tiled](http://mapeditor.org) support
- Z-sorting
- Drawing helpers
- 2D vector structs
- Fast AABB collisions (Collision Grids)
- Roundrobin multitasking
- Keyboard words
- Audio
- Sprites
- Numeric range tools

In your root create a file called `main.f` and place this at the top:

```
#1 #0 #0                     \ version numbers for Ramen
include ramen/ramen.f
include ramen/cutlet.f
```

A useful script called session.f is included in the ramen/ directory.  It loads Ramen (without Cutlet) and the included IDE.  It also loads a file called test.f if it is present.  Copy session.f to your project root, that way you can customize it.

From SwiftForth, load session.f or main.f.  If the IDE is loaded you'll see a colored background and a black bar with a flashing cursor.

You can play with the engine interactively from the Forth prompt.  On SwiftForth, if the IDE is not loaded, if you press ENTER at the prompt without entering any commands, the graphics window will get focus and the piston will kick off (to quit hit `<f12>`).  This lets you more fluidly try things out.

A project containing several examples can be found at [https://github.com/RogerLevy/ramenExamples](https://github.com/RogerLevy/ramenExamples).

The following `.gitignore` template could be useful.  

```
bin
kitconfig.f
allegro5.cfg
*.bak
```

## Komodo Edit

The folder komodo-tools contains a couple convenient tools you can use to launch and publish your projects.
