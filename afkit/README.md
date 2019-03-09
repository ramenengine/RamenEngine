# README

AllegroForthKit \(aka AFKit\) is a framework for making games \(and other apps\) in standard Forth using [Allegro 5](www.liballeg.org).

[Documentation on GitBook](https://rogerlevy.gitbook.io/afkit/v/docs/)

## Overview

The main point of this framework is to bring up a hardware-accelerated graphics window.

The portable low-level gaming library Allegro 5 powers it.  [http://liballeg.org/](http://liballeg.org/)

[Forth Foundation Library](http://soton.mpeforth.com/flag/ffl/index.html) is included for capabilities often required when working with modern libaries and file formats- features such as XML, Base64, MD5 etc. XML DOM access and Base64 are automatically loaded.

AFKit is not a comprehensive game development library; it is a cleaned-up version of [Bubble](http://github.com/rogerlevy/bubble/) with fixed-point, Komodo-specific, and game-development-framework files removed and provisions for portability added. For a more complete game development package check out [Ramen](http://github.com/rogerlevy/ramen/).

## Cross-platform Support

### Currently officially supported platforms:

* sfwin32 - [SwiftForth](https://www.forth.com/download/) \(Win32\)
* sflinux32 - [SwiftForth](https://www.forth.com/download/) \(Linux\)

### Details

/kitconfig.f specifies compile-time parameters, and loads the appropriate platform config file. That files defines the PLATFORM string, which follows this format: `<systemcode><oscode><archbits>` For example: sfwin32 = SwiftForth, Windows, 32-bit

The platform config file creates other compile-time constants and loading platform-specific files such as FFL and Allegro. These files are the appropriate place to put "adapter" definitions or include other optional libraries.

## Getting Started

If you downloaded a release, put it in your project folder.

Make copies of kitconfig.f _and allegro5.cfg_, removing the underscores.

Set platform to the appropriate string. See the Cross-platform Support section.

On Linux, you will need to install Allegro and the addons. As of this writing 5.2 is the latest version.

```text
sudo apt-get install liballegro5.2:i386 \
liballegro-acodec5.2:i386 \
liballegro-audio5.2:i386 \
liballegro-dialog5.2:i386 \
liballegro-image5.2:i386 \
liballegro-physfs5.2:i386 \
liballegro-ttf5.2:i386 \
liballegro-video5.2:i386
```

### SwiftForth

[SwiftForth](https://www.forth.com/download/) is available from [FORTH Inc](http://www.forth.com). The trial is fully functional apart from lacking source code.

From the SwiftForth prompt, change the current path to the root of your project \(if needed\) and "0 0 0 INCLUDE afkit/afkit.f" or "include afkit/main.f" and type `go` for a simple demonstration.

## Audio

When allegro-audio is defined, audio-allegro.f will be loaded, which reserves 32 samples for playing samples with play\_sample, and a default mixer and voice.

## The Piston \(main loop\) - afkit/piston.f

This is a standard main loop with many features.

To enter the main loop type GO or just press enter without entering anything. A default program defined in display.f will run. Stop the loop by pressing F12.

The piston has 3 phases. The event handling phase, the step phase, and the display phase. 3 words are used to tell the loop what to do during these phases. These words have a syntax similar to DOES&gt;.

* SHOW&gt; sets the display.
* STEP&gt; sets the logic.
* PUMP&gt; sets the event handler.

## Links and Resources

* [Forth: The Hacker's Language on HACKADAY](https://hackaday.com/2017/01/27/forth-the-hackers-language/)
* [Programming Forth by Stephen Pelc](http://www.mpeforth.com/arena/ProgramForth.pdf)
* [Forth Programming 21st Century on Facebook](https://www.facebook.com/groups/PROGRAMMINGFORTH/) - The current active and growing forum on the web for modern desktop Forth programming \(as opposed to on embedded or classic computers.\) 
* [Allegro 5.2.3 Documentation](http://liballeg.org/a5docs/5.2.3/)
* [Allegro.cc forum](https://www.allegro.cc/forums) - A very helpful and fairly active community.  And gladly, language-agnostic.
* [The DPANS94 Forth Standard](http://dl.forth.com/sitedocs/dpans94.pdf)

