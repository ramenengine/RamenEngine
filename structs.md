# Data Structures

A simple data structure mechanism.  Used for structs that are passed on the stack.  (Objects don't use these words.)

To declare a struct say  `struct <name>`

`sfield ( struct bytes valtype -- <name> )  ( adr -- adr+n )`  defines a struct field.
`svar  ( struct valtype -- <name> )` is short for `struct cell 0 sfield`.

Valtype is obsolete and not used so you can set it to anything.

`sizeof`  gets the size of a struct. 

## Example:

```
struct color
    color 0 svar color.r
    color 0 svar color.g
    color 0 svar color.b
    color 0 svar color.a
```