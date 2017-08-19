// Copyright (c) 2017 Clément Bœsch <u pkh.me>
//
// Permission to use, copy, modify, and distribute this software for any
// purpose with or without fee is hereby granted, provided that the above
// copyright notice and this permission notice appear in all copies.
//
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
// ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
// ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
// OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

include <hikey_config.scad>
use <../electronics.scad>
use <../case.scad>
use <../utils.scad>

$fn = 30;

_delta = 0.005;

_c_gray  = [.4, .4, .4];
_c_gold  = [.8, .5, .0];
_c_metal = [.7, .7, .7];
_c_black = [.3, .3, .3];

_hole_pad = 4;
_holes_pos = [for (y = [       19, board_dim[1] - _hole_pad],
                   x = [_hole_pad, board_dim[0] - _hole_pad]) [x, y]];

module _plate_2d() {
    square([board_dim[0], board_dim[1]]);
}

module _plate() {
    color(_c_gray) {
        linear_extrude(height=board_dim[2]) {
            difference() {
                _plate_2d();
                hole_positions(_holes_pos)
                    circle(d=hole_d+2.25);
            }
        }
    }
    color(_c_gold) {
        linear_extrude(height=board_dim[2]) {
            hole_positions(_holes_pos) {
                difference() {
                    circle(d=hole_d+2.25);
                    circle(d=hole_d);
                }
            }
        }
    }
}

module _extio() {
    l = extio_dim[0];
    w = extio_dim[1];
    h = extio_dim[2];

    color([.9,.85,.75]) {
        linear_extrude(height=1) {
            square([2.5, w]);
            translate([l-2.5, 0])
                square([2.5, w]);
            translate([0, (w-4)/2])
                square([l, 4]);
        }
        translate([0, 0, 1]) {
            linear_extrude(height=h-1) {
                difference() {
                    translate([1, (w-4)/2])
                        square([l-2, 4]);
                    translate([1.5, (w-4/3)/2])
                        square([l-3, 4/3]);
                }
            }
        }
    }
}

module _powerbtn() {
    l = powerbtn_dim[0];
    w = powerbtn_dim[1];
    h = powerbtn_dim[2];
    color(_c_metal)
        cube([l, w, h-.5]);
    color(_c_black)
        translate([l/2, w/2, h-.5])
            cylinder(d=w-1, h=.5);
}

module _power() {
    l = power_dim[1];
    w = power_dim[0];
    h = power_dim[2];

    translate([w, 0, 0]) // XXX
    rotate([0, 0, 90]) { // XXX
    color(_c_black) {
        difference() {
            union() {
                translate([0, w-1])     cube([l, 1, h]);
                translate([0, w-3])     cube([l, 1, h]);
                translate([1.5/2, w-9]) cube([l-1.5, 8, h]);
                translate([3/2, 0])     cube([l-3, w-9, h]);
            }
            translate([l/2, w+_delta, h/2])
                rotate([90, 0, 0])
                    cylinder(d=5, h=9);
        }
    }
    color(_c_metal)
        translate([l/2, w-.5, h/2])
            rotate([90, 0, 0])
                cylinder(d=2, h=9);
    }
}

module _capacitor() {
    l = capacitor_dim[0];
    w = capacitor_dim[1];
    h = capacitor_dim[2];
    color(_c_black)
        cube([l, w, 1.5]);
    color(_c_metal)
        translate([l/2, w/2, 1.5])
            cylinder(d=l, h=h-1.5);
}

_comp_info = [
    [sdslot_dim,    "S", sdslot_pos,        false, [ 0, 0, 0]],
    [sdcard_dim,    "S", sdcard_pos,        false, [-1, 0, 0]],
    [hdmi_dim,      "S", hdmi_pos,          false, [-1, 0, 0]],
    [microusb_dim,  "S", microusb_pos,      false, [-1, 0, 0]],
    [usb_dim,       "S", usb_pos_tab[0],    false, [-1, 0, 0]],
    [usb_dim,       "S", usb_pos_tab[1],    false, [-1, 0, 0]],
    [extio_dim,     "W", extio_pos,         false, [ 0, 0, 1]],
    [uart0_dim,     "N", uart0_pos,         false, [ 0, 0, 1]],
    [cfgpins_dim,   "N", cfgpins_pos,       false, [ 0, 0, 1]],
    [gpio_dim,      "W", gpio_pos,          false, [ 0, 0, 1]],
    [powerbtn_dim,  "W", powerbtn_pos,      false, [ 0, 0, 1]],
    [power_dim,     "N", power_pos,         false, [-1, 0, 0]],
    [capacitor_dim, "W", capacitor_pos,     false, [ 0, 0, 0]],
];

module hikey() {
    _plate();
    set_components(_comp_info) {
        sdslot(dim=sdslot_dim);
        sdcard(dim=sdcard_dim);
        hdmi(dim=hdmi_dim);
        microusb(dim=microusb_dim);
        usb(dim=usb_dim);
        usb(dim=usb_dim);
        _extio();
        pin_header_pitch200(dim=uart0_dim, n=2, m=2);
        pin_header_pitch200(dim=cfgpins_dim, n=3, m=2);
        female_header_pitch200(dim=gpio_dim, n=20, m=2);
        _powerbtn();
        _power();
        _capacitor();
    }
}

module hikey_case(part) {
    case(part,
         comp_info=_comp_info,
         min_z=3, max_z=9, board_h=board_dim[2],
         holes_pos=_holes_pos, holes_d=hole_d)
        _plate_2d();
}

*demo_board(board_dim)
    hikey();

demo_case(board_dim) {
    hikey_case("bottom");
    hikey();
    hikey_case("top");
}
