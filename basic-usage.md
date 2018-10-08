# Basic Usage

Ramen is built on AllegroForthKit. For documentation go [here](https://rogerlevy.github.io/AllegroForthKit).

The easiest way to get started is to download the examples project.  This serves as a great project template.

The long way: Create a folder to hold your project and download [AllegroForthKit](https://github.com/RogerLevy/AllegroForthKit/) and [Ramen](https://github.com/RogerLevy/ramen/). In the project folder, place the kit in a subfolder called `afkit/` and Ramen into another subfolder called `ramen/` either by cloning or download.  \(If using Git clone, adding them as submodules to your project is a good idea.\) 

If not already done, copy and rename `kitconfig.f_` and `allegro.cfg_`, removing the underscores.  Place them in the root of your project. Edit them as needed.

Ramen comes with a standard out-of-the-box configuration called the Standard Packet \(aka stdpack\). You'll need to load it if you want to use most of the major features. The file `stdpack.f` loads these modules:

* [Tiled](http://mapeditor.org) support
* Z-sorting
* Drawing helpers
* 2D vector structs
* Fast AABB collisions \(Collision Grids\)
* Roundrobin multitasking
* Keyboard words
* Audio
* Animated sprites
* Numeric range tools

In your root create a file called `main.f` and place this at the top:

```text
include ramen/ramen.f
#1 #5 #0 [ramen] [checkver] \ optional
include ramen/stdpack.f
```

A useful script called session.f is included in the ramen/ directory. It loads Ramen \(without stdpack\) and the included IDE. It also loads a file called tes**t**.f if it is present. Copy session.f to your project root, that way you can customize it.

INCLUDE session.f or main.f. If the IDE is loaded you'll see a colored background and a black bar with a flashing cursor.

You can play with the engine interactively from the Forth prompt. On SwiftForth, if the IDE is not loaded, if you press ENTER at the prompt without entering any commands, the graphics window will get focus and the piston will kick off \(to quit hit `<f12>`\). This lets you more fluidly try things out.

A project containing several examples can be found at [https://github.com/RogerLevy/ramenExamples](https://github.com/RogerLevy/ramenExamples).

The following `.gitignore` template could be useful.

```text
bin
kitconfig.f
allegro5.cfg
*.bak
```

## Komodo Edit

The folder komodo-tools contains a couple convenient tools you can use to launch and publish your projects.

