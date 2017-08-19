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
use <../electronics.scad>
use <../case.scad>
use <../utils.scad>

$fn = 30;

_delta = 0.005;

_c_gray  = [.4, .4, .4];
_c_gold  = [.8, .5, .0];
_c_metal = [.7, .7, .7];
_c_black = [.3, .3, .3];
_c_green_pcb = [.0, .5, .25];
_c_yellow = [.7, .7, .3];

_hole_pad = 3.5;
_holes_pos = [for (y = [_hole_pad, _hole_pad + 49],
                   x = [_hole_pad, _hole_pad + 58]) [x, y]];

module _plate_2d() {
    l = board_dim[0];
    w = board_dim[1];
    corner_radius = 3;
    translate([corner_radius, corner_radius]) {
        minkowski() {
            square([l-corner_radius*2, w-corner_radius*2]);
            circle(r=corner_radius);
        }
    }
}

module _plate() {
    h = board_dim[2];
    ring_d = 6.2;
    color(_c_green_pcb) {
        linear_extrude(height=h) {
            difference() {
                _plate_2d();
                hole_positions(_holes_pos)
                    circle(d=ring_d);
            }
        }
    }
    color(_c_yellow) {
        linear_extrude(height=board_dim[2]) {
            hole_positions(_holes_pos) {
                difference() {
                    circle(d=ring_d);
                    circle(d=hole_d);
                }
            }
        }
    }
}

_comp_info = [
    [microusb_dim,  "S", microusb_pos,          false, [-1, 0, 0]],
    [hdmi_dim,      "S", hdmi_pos,              false, [-1, 0, 0]],
    [jack_dim,      "S", jack_pos,              false, [-1, 0, 0]],
    [gpio_dim,      "W", gpio_pos,              false, [ 0, 0, 1]],
    [usbx2_dim,     "E", usbx2_pos_tab[0],      false, [-1, 0, 0]],
    [usbx2_dim,     "E", usbx2_pos_tab[1],      false, [-1, 0, 0]],
    [ethernet_dim,  "E", ethernet_pos,          false, [-1, 0, 0]],
    [serialcon_dim, "E", serialcon_pos_tab[0],  false, [ 0, 0, 1]],
    [serialcon_dim, "W", serialcon_pos_tab[1],  false, [ 0, 0, 1]],
    [sdslot_dim,    "W", sdslot_pos,            true,  [ 0, 0, 0]],
    [sdcard_dim,    "W", sdcard_pos,            true,  [-1, 0, 0]],
];

module raspberry_pi_3() {
    _plate();
    set_components(_comp_info) {
        microusb(dim=microusb_dim);
        hdmi(dim=hdmi_dim);
        jack(dim=jack_dim);
        pin_header_pitch254(dim=gpio_dim, n=20, m=2);
        usbx2(dim=usbx2_dim);
        usbx2(dim=usbx2_dim);
        ethernet(dim=ethernet_dim, swap_led=true);
        serialcon(dim=serialcon_dim);
        serialcon(dim=serialcon_dim);
        sdslot(dim=sdslot_dim);
        sdcard(dim=sdcard_dim);
    }
}

module raspberry_pi_3_case(part) {
    case(part,
         comp_info=_comp_info,
         min_z=3, max_z=9, board_h=board_dim[2],
         holes_pos=_holes_pos, holes_d=hole_d)
        _plate_2d();
}

*demo_board(board_dim)
    raspberry_pi_3();

demo_case(board_dim) {
    raspberry_pi_3_case("bottom");
    raspberry_pi_3();
    raspberry_pi_3_case("top");
}
