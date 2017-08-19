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

include <bbb_config.scad>
use <../electronics.scad>
use <../case.scad>
use <../utils.scad>

$fn = 30;

_delta = 0.005;

_c_gray  = [.4, .4, .4];
_c_gold  = [.8, .5, .0];
_c_metal = [.7, .7, .7];
_c_black = [.3, .3, .3];

_holes_pos = [
    [in2mm( 575), in2mm(2025)],
    [in2mm( 575), in2mm( 125)],
    [in2mm(3175), in2mm( 250)],
    [in2mm(3175), in2mm(1900)],
];

module _plate_2d() {
    l = board_dim[0];
    w = board_dim[1];
    difference() {
        square([l, w]);
        difference() {
            union() {
                translate([        0,         0]) square(ledgesz);
                translate([        0, w-ledgesz]) square(ledgesz);
                translate([l-redgesz, w-redgesz]) square(redgesz);
                translate([l-redgesz,         0]) square(redgesz);
            }

            translate([  ledgesz,   ledgesz]) circle(ledgesz);
            translate([  ledgesz, w-ledgesz]) circle(ledgesz);
            translate([l-redgesz, w-redgesz]) circle(redgesz);
            translate([l-redgesz,   redgesz]) circle(redgesz);
        }
    }
}

module _plate() {
    color(_c_gray) {
        linear_extrude(height=board_dim[2]) {
            difference() {
                _plate_2d();
                hole_positions(_holes_pos)
                    circle(d=hole_d+1);
            }
        }
    }
    color(_c_gold) {
        linear_extrude(height=board_dim[2]) {
            hole_positions(_holes_pos) {
                difference() {
                    circle(d=hole_d+1);
                    circle(d=hole_d);
                }
            }
        }
    }
}

module _power() {
    l = power_dim[0];
    w = power_dim[1];
    h = power_dim[2];

    l1 = 3.5;
    l0 = l - l1;
    h0 = 6.5;

    color(_c_black) {
        difference() {
            union() {
                translate([l1, 0]) {
                    cube([l0, w, h0]);
                    translate([0, w/2, h0])
                        rotate([0, 90])
                            cylinder(d=w-1, h=l0);
                }
                cube([l1, w, h]);
            }
            translate([-_delta, w/2, h0])
                rotate([0, 90])
                    cylinder(d=6.5, h=l0);
        }
    }
    color(_c_metal)
        translate([0, w/2, h0])
            rotate([0, 90])
                cylinder(d=2, h=l0);
}

module _button() {
    // XXX
    button_base_dim = [4, 3, 1.5];
    button_pusher_dim = [2, 1.5, 0.5];

    base_l = button_base_dim[0];
    base_w = button_base_dim[1];
    base_h = button_base_dim[2];

    button_l = button_pusher_dim[0];
    button_w = button_pusher_dim[1];

        color(_c_metal)
            cube(button_base_dim);

        color(_c_black)
            translate([(base_l-button_l)/2, (base_w-button_w)/2, base_h])
                cube(button_pusher_dim);
}

module _miniusb() {
    color(_c_metal)
        cube(miniusb_dim);
}

module _hdmi() {
    color(_c_metal)
        cube(hdmi_dim);
}

module _sdslot() {
    color(_c_metal)
        cube(sdslot_dim);
}

module _sdcard() {
    color(_c_black)
        cube(sdcard_dim);
}

module _rt1() {
    rt1_l = rt1_dim[0];
    rt1_w = rt1_dim[1];
    rt1_h = rt1_dim[2];

    head_l = rt1_dim[0];
    head_w = rt1_dim[1];
    head_h = rt1_dim[2] / 3;

    color(_c_metal)
        for (y = [1, rt1_w-1])
            translate([rt1_l/2, y])
                cylinder(d=1, h=rt1_h-head_h);

    color(_c_gold)
        translate([0, 0, rt1_h-head_h])
            cube([head_l, head_w, head_h]);
}

_comp_info = [
    [power_dim,     "W", power_pos,             false, [-1, 0, 0]],
    [ethernet_dim,  "W", ethernet_pos,          false, [-1, 0, 0]],
    [gpio_dim,      "W", gpio_pos_tab[0],       false, [ 0, 0, 1]],
    [gpio_dim,      "W", gpio_pos_tab[1],       false, [ 0, 0, 1]],
    [usb_dim,       "E", usb_pos,               false, [-1, 0, 0]],
    [button_dim,    "W", button_pos_tab[0],     false, [ 0, 0, 0]],
    [button_dim,    "W", button_pos_tab[1],     false, [ 0, 0, 0]],
    [button_dim,    "W", button_pos_tab[2],     false, [ 0, 0, 0]],
    [rt1_dim,       "W", rt1_pos,               false, [ 0, 0, 0]],
    [pins_dim,      "W", pins_pos,              false, [ 0, 0, 1]],
    [miniusb_dim,   "W", miniusb_pos,           false, [-1, 0, 0]],
    [hdmi_dim,      "E", hdmi_pos,              false, [-1, 0, 0]],
    [sdslot_dim,    "E", sdslot_pos,            false, [ 0, 0, 0]],
    [sdcard_dim,    "E", sdcard_pos,            false, [-1, 0, 0]],
];

module beaglebone_black() {
    _plate();
    set_components(_comp_info) {
        _power();
        ethernet(dim=ethernet_dim);
        female_header_pitch254(dim=gpio_dim, n=23, m=2);
        female_header_pitch254(dim=gpio_dim, n=23, m=2);
        usb(dim=usb_dim);
        _button();
        _button();
        _button();
        _rt1();
        pin_header_pitch254(dim=pins_dim, n=6, m=1);
        _miniusb();
        _hdmi();
        sdslot(dim=sdslot_dim);
        sdcard(dim=sdcard_dim);
    }
}

module beaglebone_black_case(part) {
    case(part,
         comp_info=_comp_info,
         min_z=4, max_z=7.5, board_h=board_dim[2],
         holes_pos=_holes_pos, holes_d=hole_d)
        _plate_2d();
}

*demo_board(board_dim)
    beaglebone_black();

demo_case(board_dim) {
    beaglebone_black_case("bottom");
    beaglebone_black();
    beaglebone_black_case("top");
}
