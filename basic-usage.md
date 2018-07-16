# Basic Usage

Download [AllegroForthKit](https://github.com/RogerLevy/AllegroForthKit/) and [RAMEN](https://github.com/RogerLevy/ramen/).  Place the kit into a folder called `/afkit` and RAMEN into a folder called `ramen/` either by cloning them or downloading them.

Copy/rename `kitconfig.f_` and `allegro.cfg_`, removing the underscores.  Edit them as needed.

RAMEN is built over top AllegroForthKit.  See the Kit's documentation [here](https://rogerlevy.github.io/AllegroForthKit).

Next create a folder for your game's source.  The convention is `src/`. 

RAMEN follows a principle of maximum freedom, but there is a standard configuration you can use out-of-the-box called **BRICK**.  The file `brick.f` loads ramen.f and the following modules:

- Numeric Range tools
- Z-sorting
- Drawing helpers
- 2D vector structs
- Fast AABB collisions (Collision Grid)
- Roundrobin multitasking
- Keyboard polling words
- Basic audio
- Sprite support

In your `src/` folder create a file called `main.f` and place this at the top:

```
    include afkit/ans/section.f     \ A useful utility for loading sections of files

[section] preamble
empty
    #2 #0 #0 include ramen/brick.f  \ Load BRICK - note the version number is passed on the stack.
    require ramen/tiled/tiled.f     \ Load Tiled support
```

The line `require ramen/tiled/tiled.f` loads the optional Tiled module.  This comes with robust tilemap support.

You can play with the engine interactively from the Forth prompt.  On SwiftForth, if you press ENTER at the prompt without entering any commands, the graphics window will get focus and the engine will start/resume.  This lets you fluidly try things out switching back and forth.

Find examples in the `ramen/ex/` folder.  


## Git

If you are cloning AF-Kit and RAMEN, and you are not using submodules, the following `.gitignore` template could be useful.  It ignores everything but what you specify, allowing your project to use libraries without including them in your repository.  

```
/*/**
/*/
!/src/
!/src/**
!/bin/
!/bin/**
!/data/
!/data/**
!.gitignore
!/design/
!/design/**

*.komodoproject
.komodotools
kitconfig.f
allegro5.cfg
```

