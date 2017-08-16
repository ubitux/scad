This repository contains various personal OpenSCAD creations.

Most of the interesting stuff lies in the [printables](printables) directory.

Building
========

In order to get the `.stl` files of a given project, enter any directory in
[printables](printables/) and type `make`. Specifying jobs to `make` with `-jX`
is supported and recommended.

All the things
==============

**Note**: I'm in the process of making and upstreaming all kind of other things
so there currently isn't much to see.

BeagleBone Black case
---------------------

A 3D printable case for the BeagleBone Black ARM board. It exposes every
device/pin/slot/button interface available.

### Demo

![Case demo](img/bbb-case/bbb-case.gif)

### Parts

This case is made of 2 main parts (top and bottom) and 3 small buttons pushers:

![Case bottom](img/bbb-case/bbb-case-bottom.png)
![Case top](img/bbb-case/bbb-case-top.png)
![Case button pusher](img/bbb-case/bbb-case-btnpusher.png)

### In real life

Here is one of the use case of this box in real life:

![In real life](img/bbb-case/real-life.jpg)

This a simple Wifi hotspot using a wireless USB dongle.

The button pushers are ugly due to manual melting of filament on top of them to
prevent them for jumping around while opening and closing the box (and then I
tried to cover it up with a red marker).

### Configuration

Some configuration you may want to adjust in [bbb-case.scad](printables/bbb-case/bbb-case.scad):

- `has_carrier` controls the presence of the rectangular carrier for fixing it
  to a wall.
- `carrier_screw_head_*` controls the size of the hole for your screw in case
  the carrier is set.
- `case_thickness` could be reasonably changed if needed in order to control
  the overall thickness of the walls.
- `breath_padding` corresponds to the space padding between parts that are not
  supposed to be in contact.
- `contact_padding` is the space padding between parts that are supposed to be
  in contact. It should be set to `0` in theory, but in practice, cheap 3D
  printers tend to drool quite a bit.
