# Objects

In any video game there will be a data structure for all the things on the screen that move and interact with the player and each other, such as enemies, NPC's, and projectiles.  These are commonly called game objects, display objects, entities, nodes, actors, etc.  In Ramen, the data structure for that is called Ramen Objects (or just "objects" for short).  In Ramen, game objects aren't just for game objects but could be used for other things such as background tasks or GUI widgets.

## About object fields

All the properties of objects, or fields and vars as they're called, are global to all objects.

When you attempt to define a field that already exists, the definition is automatically skipped.

`redef` is a flag that disables this behavior should you want to bury any existing fields with new definitions.  Say `redef on` and `redef off`.

There is a limit to the total size of objects.  The default limit is 1 kilobyte (256 vars), but this can be configured.  See `object-maxsize` in obj.f.

Object fields are different from structs.  Instead of saying `<object> <field>`, you just say `<field>`.  We call this "implicit addressing".  That is, the base address is implied.

There is a current object at all times.  This is called the object base address.  It's stored in a `value` called `me`.

You can address the properties of an object that's on the stack (without changing the current object) with the word `'s`.  For example:

```
<object> 's x 2@   \ fetch the x and y coordinates of <object>
```

## Current object (Base address) management words

word | stack | description
-|-|-
as | ( obj -- ) | set `me` to a new address
{ | ( -- ) | push the base address (can be used at the prompt).
} | ( -- ) | pop the base address
>{ | ( obj -- ) | push and set the current object
's | ( obj -- <field> field ) | address a field of an explicit object

## Standard object fields

These are the standard fields common to all Ramen objects, defined in `obj.f`.

field | size | description 
------|------|-------------
en | cell | marks the object as active (i.e. existing, in the eyes of the engine)
x | cell | x coordinate
y | cell | y coordinate
vx | cell | x velocity
vy | cell | y velocity
hidden | cell | when enabled the object will not be drawn
role | cell | the object's role
lnk | cell | _internal_
^pool | cell | _internal_
drw | cell | _internal_
beha | cell | _internal_

## Defining fields

word | stack | description
-|-|-
field | ( size -- \<name\> | define field of a given size in integer bytes.  if a field is already defined it will be reused.
var | ( -- \<name\> ) | same as `cell field`

## Defaults

`defaults` is an object you can use to define the default values of fields.  For example:

```
var r  var g  var b  \ red,green,blue, should be initialized to 1,1,1

defaults >{
    1 r !  1 g !  1 b !  \ we do that here
}
```

There is an analogous object called `basis` for initializing Roles (See below) but its usage is a little different.  Don't get them confused.

## Object Lists

Used to group and process static objects and object pools.

To create an object list, say `objlist <name>`.

There is a "default" object list, called `stage`.

## Object Pools

Pre-allocated groups of "disabled" objects.  You create objects at runtime using these.

To create an object pool, say `<objlist> <n> pool: <name>`.  For example: `stage 200 pool: sprites` would create a pool attached to the `stage` called `sprites` that can hold a maximum of 200 objects.

## Creating objects

There are two kinds of objects, dynamic and static.  Dynamic objects can be created and destroyed at runtime and static ones can't.

#### Creating Static objects

Say something like this:  `stage object: <name>`, the stage being the default object list.

The current object will be the newly created object.  You can refer to it by the name you gave it.

#### Creating Dynamic objects

Say something like this:  `stage one`, the stage being the default object list.

The current object will be the newly created object.

## Programming objects

Like AFKit's piston, objects have phases that you program.  These phases are called Act and Draw.  There is an additional optional phase, Multitasking.

Ramen has a default piston configuration that executes all of the stage's objects' phases as intended but note that as you extend the engine it will be your responsibility to process them appropriately.

All of these words operate on the current object.

`act>` programs the Act phase (like `does>`).  It is intended to be executed continually in the Step phase.

`act` executes the Act phase.

`-act`  sets the Act phase to noop.

`draw>` programs the Draw phase.

`draw` executes the Draw phase.  If `hidden` is on nothing happens.  The pen is automatically set to x,y.

`perform> ( n -- )` enables an object to process during the Multitasking phase.   You can pass a single value of any kind.  See [ramenExamples/files.f](https://github.com/RogerLevy/ramenExamples/blob/master/flies.f) for an example.

`multi ( objlist/pool -- )` Processes the multitasking phase for an object list or pool. 

## Roles

Roles are the means to have objects share static data and behavior without storing them in the objects themselves.  They are analogous to classes in OOP, but there is no inheritance.

To define a role simply say `roledef: <name>`.  If a role is already defined it will be reused.  This enables live-updating of roles at runtime when you reload your object scripts.

### Rolevars

Rolevars are static variables for roles.  They are shared among all roles.  To define a rolevar simply say:

`rolevar <name>`

Note that no role is required.  You can do this at any time.

To use a rolevar, you simply call its name, but you must make sure to set the object's `role` var beforehand or an error will be thrown.

Rolevars work with `'s` so you can say `<role> 's <whatever>`.  They do not work on objects - you must say `<object> 's role @ 's <whatever>`.

### Actions

Actions are analogous to methods in OOP.  It lets different objects respond to the same set of commands differently.

To define an action, here's the format:

```
action <name> ( stack -- diagram )
```

To execute the action simply call its name.  It will be executed on the current object, provided the `role` has been set.  You don't need to program the action - if you don't and you call one, nothing happens.  But note that if it was supposed to take some parameters these will be left on the stack.  You may want to use `basis` to initialize these actions to drop words to avoid that scenario. 

To program an action of a particular role, do this:

```
<role> :to <action>  ( stack -- diagram )  ... ;
```

It's a good idea to define your stack diagrams not only with the declaration of the action but definitions too.

### Basis

Analogous to the `defaults` objects, use this for initializing rolevars and actions.

To set rolevar and action initial values, use `basis 's <rolevar/action>` and the regular Forth store words.

### Reusing actions

You can create roles that behave like other roles.  The word `->` lets you call the action of some other role, a kind of multiple inheritance.  Simply say `<role> -> <action>`.  

[LinkGoesForth/actors/mc.f](https://github.com/RogerLevy/LinkGoesForth/blob/master/actors/mc.f) contains a great example of this, where `mc` calls the actions of `avatara`.

## Misc. words

See obj.f for stack diagrams.

`away ( obj x y -- )` convenient tool for spawning objects relative to other ones.

`eachcell ( addr n xt -- )  ( addr -- )` and `eachcell> ( addr n -- <code> )  ( addr -- )` are tools for processing cell arrays.  

`some ( objlist filterxt xt -- )  ( addr n -- )` and `some> ( objlist filterxt -- <code> )  ( addr n -- )`   are tools for creating temporary filtered arrays of objects.  the arrays are destroyed automatically.

"filterxt"'s stack effect should be ( addr -- flag ) where if flag is true the object is kept.