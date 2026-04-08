# Renoise Scripting


## Scripting Development Book

Please read the [`Renoise Scripting Development Book`]
(https://renoise.github.io/xrnx).

This book is highly recommended for anyone who wants to get into all this 
Renoise scripting stuff. Please read it first to get an overview of what's
needed to develop tools for Renoise. It contains an introduction, some guides
and a searchable API documentation.


## API Definitions

The `Types` folder next to this documentation folder defines all available
Lua functions and classes in LuaCATS format.

LuaCATS stands for "Lua Comment And Type System", which is the system used 
by [`Sumneko's Lua Language Server`](https://luals.github.io/). You can use the 
existing type definitions in other editors such as VSCode as well.

See [`Definitions Repository`](https://github.com/renoise/definitions) for more info.


## API Overview

Here is a small overview of what the API exposes:

**renoise**<br>
Renoise API version number and some global accessors like "song", "app" are here.

**renoise.Application**<br>
Access to the main Renoise application and window, main user interface.

**renoise.Song**<br>
Access to the song and all its components (instruments, samples, tracks...)

**renoise.Document**<br>
Generic "observer pattern" document creation and access, used by the
song/app and to create persistent data (preferences, presets).

**renoise.ScriptingTool**<br>
Interact with Renoise; create menus, keybindings.

**renoise.ViewBuilder**<br>
Create custom dialogs / GUIs.

**renoise.Socket**<br>
Inter-process and network communication functions and classes.

**renoise.Osc**<br>
Tools to generate and receive OSC messages, bundles over the network.

**renoise.Midi**<br>
"Raw" MIDI device interaction (send, receive MIDI messages from any devices.)

**renoise.Sqlite**<br>
Create new, read from and write to Sqlite3 databases.


## API design

A note about the general API design:

- Whatever you do with the API, you should never be able to fatally crash
  Renoise. If you manage to do this, then please file a bug report in our forums
  so we can fix it. All errors, as stupid they might be, should always result in
  a clean error message from Lua.

- The Renoise Lua API also allows global File IO and external program execution
  (via os.execute()) which can obviously be hazardous. Please be careful with
  these, as you would with programming in general...


> Enjoy extending, customizing and automating Renoise ;)

