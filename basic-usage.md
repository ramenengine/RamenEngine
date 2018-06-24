# Basic Usage

Download [AllegroForthKit](https://github.com/RogerLevy/AllegroForthKit/) and [RAMEN](https://github.com/RogerLevy/ramen/).  Place the kit directly into a project folder and RAMEN into a subdirectory called `ramen/`.

You should have a working knowledge of AllegroForthKit.  Read the documentation [here](https://rogerlevy.github.io/AllegroForthKit).

Copy/rename `kitconfig.f_` and `allegro.cfg_`, removing the underscores.


The default configuration of RAMEN's modules is called BRICK.  The file `brick.f` loads ramen.f and the following modules:

- Range tools
- Z-sorting
- Draw
- 2D vector structs
- Fast AABB collisions (Collision Grid)
- Roundrobin multitasking
- Keyboard polling words
- Basic audio


Next create a folder for your project source.  I'd keep it short, as you might be typing it a lot.

You can play with the engine interactively from the Forth prompt.  On SwiftForth, if you press ENTER at the prompt without entering any commands, the graphics window will get focus and the engine will start/resume running.

