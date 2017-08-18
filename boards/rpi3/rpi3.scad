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

include <rpi3_config.scad>
use <../utils.scad>

$fn = 30;

_delta = 0.005;

_c_gray  = [.4, .4, .4];
_c_gold  = [.8, .5, .0];
_c_metal = [.7, .7, .7];
_c_black = [.3, .3, .3];
_c_green_pcb = [.0, .5, .25];
_c_yellow = [.7, .7, .3];

module _plate() {
    corner_radius = 3;
    l = board_dim[0];
    w = board_dim[1];
    h = board_dim[2];
    ring_d = 6.2;
    color(_c_green_pcb) {
        linear_extrude(height=h) {
            difference() {
                translate([corner_radius, corner_radius]) {
                    minkowski() {
                        square([l-corner_radius*2, w-corner_radius*2]);
                        circle(r=corner_radius);
                    }
                }
                hole_positions()
                    circle(d=ring_d);
            }
        }
    }
    color(_c_yellow) {
        linear_extrude(height=board_dim[2]) {
            hole_positions() {
                difference() {
                    circle(d=ring_d);
                    circle(d=hole_d);
                }
            }
        }
    }
}

module _sdslot() {
    color(_c_metal)
        cube(sdslot_dim);
}

module _sdcard() {
    color(_c_black)
        cube(sdcard_dim);
}

module usbx2_pos() {
    for (pos = usbx2_pos_tab)
        translate(pos)
            children();
}

module raspberry_pi_3() {
    _plate();

    translate(microusb_pos)         microusb(microusb_dim, direction="S");
    translate(hdmi_pos)             hdmi(hdmi_dim, direction="S");
    translate(jack_pos)             jack(jack_dim, direction="S");
    translate(gpio_pos)             pin_header_pitch254(20, 2, dim=gpio_dim);
    usbx2_pos()                     usbx2(usbx2_dim, direction="E");
    translate(ethernet_pos)         ethernet(ethernet_dim, direction="E", swap_led=true);
    translate(serialcon_pos_tab[0]) serialcon(serialcon_dim, direction="E");
    translate(serialcon_pos_tab[1]) serialcon(serialcon_dim, direction="W");
    translate(sdslot_pos)           _sdslot();
    translate(sdcard_pos)           _sdcard();
}

module hole_positions() {
    hole_pad = 3.5;
    hole_x1 = hole_pad;
    hole_x2 = hole_pad + 58;
    hole_y1 = hole_pad;
    hole_y2 = hole_pad + 49;

    for (y = [hole_y1, hole_y2])
        for (x = [hole_x1, hole_x2])
            translate([x, y])
                children();
}

rotate([0, 0, $t*360])
    translate([-board_dim[0]/2, -board_dim[1]/2])
        raspberry_pi_3();
