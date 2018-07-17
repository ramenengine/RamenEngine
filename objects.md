# Objects

In every game, you need some kind of data structure to represent all the objects on the screen that can move and interact with the player and each other, such as enemies and projectiles.  Commonly these are referred to as game objects, display objects, entities, nodes, or actors.

In RAMEN, we call them ramen objects, or just objects.  Ramen objects are unified, polymorphic data structures used for multiple purposes, the primary of which is as game objects.  

There are two levels to managing objects.

## Object Lists

Let's say you are making a very basic game, such as Pong, and you know how many objects are going to be on the screen.  Nothing is created or destroyed during gameplay - (at least not from the programmer's perspective.)  You'd like to just declare them and rely on them always being available.  This is what object lists provide.

...

## Pools

In most games, the prevailing approach is that game objects are created and destroyed throughout the course of gameplay.  You don't know ahead of time the exact number or kinds of objects that will be in the game world at any given moment.

For this RAMEN provides pools, which is a fast way of allocating things dynamically.  Pools are special lists containing objects that are inactive, but can be made active when you do what is called instantiating them, which is another way of saying creating them.  Pools are themselves children of normal lists such that when you create them, their objects are also part of the parent list's objects.  Pools have a maximum size of your choosing.  One good approach is to have a pool for your playfield objects and another for your heads up display elements such as health and score.  

...

## About object fields

In RAMEN, you have two main kinds of data structures: normal data structures, and objects.  When you declare fields (properties) of normal data structures, you always create a new field, and it increases the size of the given structure.  With objects, there is one data structure that applies to _all_ instances and types, the maximum size is _fixed_ (by default to 256 cells) and if you declare a field that already exists, a new one will not be created.  Thus you ought to give your object fields generic names and general meanings (and standard practice is not to prefix them with the name of the struct) and treat them more like "extensions" rather than leaves within a heirearchy of data classes as you find in traditional OOP.  This is appropriate for RAMEN because it was designed to be only semi-modular - and the fact that object definitions cannot normally be moved into any project without thought follows the same philosophy.  This is a tradeoff of more freedom for the programmer in exchange for less modularity.  But Forth's ease when writing simple code somewhat bridges the gap, and we intend to encourage and promote the writing of simple code.

All objects are polymorphic or potentially so.  We can use the same words to manage other kinds of data structures, such as background tasks and GUI objects.

Objects also support a kind of multiple inheritance.  You can easily treat an object as being of several types, not just one.  For instance if you want any game object to also be a task, you can.  (And this is exactly how the multitasking module works.)  You can add features which apply to every object of your game, such as physics, or in the case of an RPG, properties of the elements (e.g. fire, ice, wind, earth, etc).  

**TECHNICAL NOTE:** None of this is incredibly original or groundbreaking - but this implementation of game objects works well in Forth and with the intended scope of RAMEN.  Some may call it wasteful of memory, but memory on the intended platform is plentiful, and besides, frequently the game objects of other engines are substantially larger than the default 1KB, due to many factors, not least of which is the monolithic design approach that is predominant.


## Actions

