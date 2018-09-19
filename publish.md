# Publishing

Publish.f contains the runtime code for executables. It also "normalizes" assets, this means the runtime will expect them all to be within a subdirectory of your published app's directory, called `data/`. Subdirectories are respected so you can simply copy your data folder contents or use a script.

`publish ( -- <name> )` takes care of the above. It's only available on SwiftForth and on Windows you must have a commercial copy. On Linux this isn't a requirement as far as I know.

A windows batch script make.bat is included to help with publishing. It takes one parameter, a string. The published app will be placed in `bin/<string>`. It also copies all your data and Allegro binaries.

Make.f is an adjunct Forth script called by make.bat. By default its contents are simply:

```text
include main.f
```

This defines what to load before make.bat calls `publish`.

You can copy both of these files to your project root and customize them as needed.

