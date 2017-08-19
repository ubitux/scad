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

use <../../utils/animate.scad>

use <bbb.scad>
include <bbb_config.scad>

$fn = 30;

has_carrier = true;

case_thickness  = 1.2;
breath_padding  = .7;
contact_padding = .2;

carrier_screw_head_top_d = 8;
carrier_screw_head_bot_d = 3;
carrier_screw_head_h     = 5;

board_min_z = miniusb_dim[2] + breath_padding;

extrude_extra = 15;

button_max_height = button_base_dim[2] + button_pusher_dim[2];

button_pusher_base_r = 2.4;
button_pusher_r      = 1.4;

board_z   = case_thickness + board_min_z;
buttons_z = board_z + board_dim[2] + button_max_height;
top_z     = board_z + board_dim[2] + gpio_dim[2] - case_thickness;

module extruder(dim, vt, dim_patch=[0,0,0]) {
    minkowski() {
        cube(dim + extrude_extra*vt + dim_patch);
        sphere(d=2*breath_padding);
    }
}

module extrude_interfaces_common() {
    e = extrude_extra;
    translate(ethernet_pos + [-e, 0, 0]) extruder(ethernet_dim, [1, 0, 1]);
    translate(power_pos    + [-e, 0, 0]) extruder(power_dim,    [1, 0, 1]);
}

module extrude_interfaces_bottom() {
    extrude_interfaces_common();
    e = extrude_extra;
    translate(miniusb_pos + [-e, 0, 0]) extruder(miniusb_dim, [1, 0, 0]);
    translate(usb_pos     + [ 0, 0, 0]) extruder(usb_dim,     [1, 0, 1]);
    translate(hdmi_pos    + [ 0, 0, 0]) extruder(hdmi_dim,    [1, 0, 0]);
    translate(sdcard_pos  + [ 0, 0, 0]) extruder(sdcard_dim,  [1, 0, 0]);
}

module extrude_interfaces_top() {
    extrude_interfaces_common();
    e = extrude_extra;
    bp = breath_padding;
    translate(usb_pos + [usb_dim[0]-2, 0, 0]) extruder(usb_dim, [1, 0, 1]);
    translate(usb_pos  + [0,  0, 0]) extruder(usb_dim,  [0, 0, 0], dim_patch=[0,0,-4*bp/3]);
    translate(rt1_pos  + [0, -e, 0]) extruder(rt1_dim,  [0, 1, 1]);
    translate(pins_pos + [0, -e, 0]) extruder(pins_dim, [0, 1, 1]);
    gpio_pos_0 = gpio_pos_tab[0];
    gpio_pos_1 = gpio_pos_tab[1];
    translate(gpio_pos_0) translate([0, -e, 0]) extruder(gpio_dim, + [0, 1, 1]);
    translate(gpio_pos_1) translate([0, 0,  0]) extruder(gpio_dim, + [0, 1, 1]);
}

module column(total_height, height_bottom, radius, bottom_radius_pad) {
    l1 = height_bottom;
    l = total_height;
    w0 = radius;
    w1 = w0 + bottom_radius_pad;

    rotate_extrude()
        polygon([[0, 0], [w1, 0], [w1, l1], [w0, l1], [w0, l], [0, l]]);
}

module button_pushers_pos() {
    translate([button_base_dim[0] / 2, button_base_dim[1] / 2, 0])
        button_pos()
            children();
}

module button_pusher() {
    pusher_h = top_z - board_z - board_dim[2] - button_max_height + case_thickness + 1.0;
    column(pusher_h, 2, button_pusher_r, button_pusher_base_r-button_pusher_r);
}

module button_pushers() {
    button_pushers_pos()
       button_pusher();
}

module plate_aerations() {
    area_dim = [0.45*board_dim[0], 0.5*board_dim[1]];
    nb_segments = 6;

    pad = area_dim[1] / (2*nb_segments+1);
    intersection() {
        translate([board_dim[0] / 2, board_dim[1] / 2])
            circle(d=area_dim[0]);
        translate([(board_dim[0] - area_dim[0]) / 2, (board_dim[1] - area_dim[1]) / 2]) {
            for (i = [0:nb_segments-1])
                translate([0, pad + i * pad * 2])
                    square([area_dim[0], pad]);
        }
    }
}

module board_plate() {
    difference() {
        square([board_dim[0], board_dim[1]]);
        plate_edges();
    }
}

module case_plate_2d() {
    difference() {
        offset(r=case_thickness + breath_padding)
            board_plate();
        plate_aerations();
    }
}

module case_bottom_borders() {
    bp = breath_padding;
    difference() {
        translate([0, 0, case_thickness]) {
            linear_extrude(height=top_z-case_thickness, convexity=2) {
                difference() {
                    case_plate_2d();
                    offset(r=breath_padding)
                        board_plate();
                }
            }
        }
        translate([0, 0, board_z])
            extrude_interfaces_bottom();
    }

    gpio_x = gpio_pos_tab[0][0];
    gpio_len = gpio_dim[0];
    translate([0, 0, top_z]) {
        linear_extrude(height=case_thickness) {
            intersection() {
                for (y = [board_dim[1] + bp, -bp - case_thickness])
                    translate([gpio_x, y])
                        square([gpio_len, case_thickness]);
                case_plate_2d();
            }
        }
    }
}

module carrier() {
    wsticks = 4;
    w_screw = carrier_screw_head_top_d + 4;
    pad = redgesz;
    l = w_screw + 20;

    difference() {
        linear_extrude(height=case_thickness) {
            for (y = [pad, board_dim[1]-pad])
                translate([board_dim[0], y - wsticks/2])
                    square([l, wsticks]);
            translate([board_dim[0] + l - w_screw, pad])
                square([w_screw, board_dim[1] - pad*2]);
        }
        translate([board_dim[0] + l - w_screw/2,
                  (board_dim[1]) / 2,
                  -carrier_screw_head_h+case_thickness+.25])
            cylinder(d1=carrier_screw_head_bot_d,
                    d2=carrier_screw_head_top_d,
                    h=carrier_screw_head_h);
    }
}

module case_bottom() {
    linear_extrude(height=case_thickness)
        case_plate_2d();
    if (has_carrier)
        carrier();

    case_bottom_borders();
    translate([0, 0, case_thickness])
        hole_positions()
            column(board_min_z + board_dim[2] + 1, board_min_z,
                   hole_d/2 - 0.2, 1);
}

module case_top_borders(border_height) {
    bp = breath_padding;

    translate([0, 0, -border_height]) {
        linear_extrude(height=border_height, convexity=2) {
            difference() {
                offset(r=breath_padding - contact_padding)
                    board_plate();

                offset(r=breath_padding - contact_padding - case_thickness)
                    board_plate();

                translate([gpio_pos_tab[0][0] - bp, -bp, 0])
                    square([gpio_dim[0] + 2*bp, board_dim[1] + 2*bp]);
            }
        }
    }
}

module case_top() {
    border_height = 3;
    button_pusher_hole_r = button_pusher_r + breath_padding;

    difference() {
        union() {
            linear_extrude(height=case_thickness, convexity=2) {
                difference() {
                    case_plate_2d();
                    button_pushers_pos()
                        circle(r=button_pusher_hole_r);
                }
            }
            case_top_borders(border_height);
        }

        translate([0, 0, -top_z + board_z])
            extrude_interfaces_top();
    }

    translate([0, 0, -border_height]) {
        linear_extrude(height=border_height) {
            button_pushers_pos() {
                difference() {
                    circle(r=button_pusher_hole_r + case_thickness);
                    circle(r=button_pusher_hole_r);
                }
            }
        }
    }
}

module demo() {
    rotate([0, 0, 360*$t]) {
        case_bottom();
        stack_animate(time=$t) {
            translate([0, 0, board_z])   beaglebone_black();
            translate([0, 0, buttons_z]) button_pushers();
            translate([0, 0, top_z])     case_top();
        }
    }
}

mod = "demo";

if      (mod == "bottom")     case_bottom();
else if (mod == "top")        rotate([180, 0, 0]) case_top();
else if (mod == "btnpusher")  button_pusher();
else if (mod == "demo")
    demo();
