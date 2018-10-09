# Getting Started

Ramen is built on AllegroForthKit. For documentation go [here](https://rogerlevy.github.io/AllegroForthKit).

The easiest way to get started is to download the examples project. This serves as a great project template. You can find it here: [ramenExamples](https://github.com/RogerLevy/ramenexamples)

The long way: Create a folder to hold your project and download [AllegroForthKit](https://github.com/RogerLevy/AllegroForthKit/) and [Ramen](https://github.com/RogerLevy/ramen/). In the project folder, place the kit in a subfolder called `afkit/` and Ramen into another subfolder called `ramen/` either by cloning or download. \(If using Git clone, adding them as submodules to your project is a good idea.\)

If not already done, copy and rename `kitconfig.f_` and `allegro.cfg_`, removing the underscores. Place them in the root of your project. Edit them as needed.

Ramen is an extensible engine, meaning at its core it is very minimal, but it comes with a collection of libraries called the Standard Packet \(aka stdpack\).

Here is a snippet to put at the top of your main source file that will get you up and running.

```text
include ramen/ramen.f
#1 #5 #0 [ramen] [checkver] \ optional
include ramen/stdpack.f
```

The file `stdpack.f` loads these modules:

* [Tiled](http://mapeditor.org) support
* Z-sorting
* Drawing helpers
* 2D vector structs
* Roundrobin multitasking
* Keyboard words
* Audio
* Animated sprites
* Numeric range tools \(for centering things, simple collisions, etc\)
* Fast AABB collisions \(Collision Grids\)

Typically your game will have a main.f. When you publish using the provided build system, by default it compiles this file. \(The build system is modifiable.\)

A useful script called session.f is included in the ramen/ directory. It loads Ramen \(without stdpack\) and the included IDE. It also loads a file called tes**t**.f.

_Tip: You may want to copy session.f to your project root so that you can modify it._

`include` session.f or main.f. If you loaded session.f you'll see a colored background and a black bar with a flashing cursor. Otherwise type `ide` to start the IDE.

You can play with the engine interactively from the prompt. On SwiftForth, if the IDE is not loaded, if you press &lt;enter&gt; at the prompt without entering any commands, the graphics window will get focus and the piston will kick off \(to quit hit `<f12>`\). This lets you more fluidly try things out.

## Komodo Edit

The folder komodo-tools contains a couple convenient tools you can use to launch and publish your projects. You can import these into your Komodo projects. I have set up F5 to launch session.f.

