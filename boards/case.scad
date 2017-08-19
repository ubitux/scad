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

use <../utils/animate.scad>
use <utils.scad>

$fn = 30;

_delta = 0.005;

case_thickness  = 1.2;
breath_padding  = .7;
contact_padding = .2;

top_border_height = 3;

//board_min_z = miniusb_dim[2] + breath_padding; // XXX

//button_max_height = button_base_dim[2] + button_pusher_dim[2];

button_pusher_base_r = 2.4;
button_pusher_r      = 1.4;

//board_z   = case_thickness + board_min_z;
//buttons_z = board_z + board_dim[2] + button_max_height;
//top_z     = board_z + board_dim[2] + gpio_dim[2] - case_thickness;

module column(total_height, height_bottom, radius, bottom_radius_pad) {
    l1 = height_bottom;
    l = total_height;
    w0 = radius;
    w1 = w0 + bottom_radius_pad;

    rotate_extrude()
        polygon([[0, 0], [w1, 0], [w1, l1], [w0, l1], [w0, l], [0, l]]);
}

//module button_pushers_pos() {
//    translate([button_base_dim[0] / 2, button_base_dim[1] / 2, 0])
//        button_pos()
//            children();
//}
//
//module button_pusher() {
//    pusher_h = top_z - board_z - board_dim[2] - button_max_height + case_thickness + 1.0;
//    column(pusher_h, 2, button_pusher_r, button_pusher_base_r-button_pusher_r);
//}
//
//module button_pushers() {
//    button_pushers_pos()
//       button_pusher();
//}

//module plate_aerations() {
//    area_dim = [0.45*board_dim[0], 0.5*board_dim[1]];
//    nb_segments = 6;
//
//    pad = area_dim[1] / (2*nb_segments+1);
//    intersection() {
//        translate([board_dim[0] / 2, board_dim[1] / 2])
//            circle(d=area_dim[0]);
//        translate([(board_dim[0] - area_dim[0]) / 2, (board_dim[1] - area_dim[1]) / 2]) {
//            for (i = [0:nb_segments-1])
//                translate([0, pad + i * pad * 2])
//                    square([area_dim[0], pad]);
//        }
//    }
//}

module _bounding_box(items) {
    for (item = items) {
        dim       = item[0];
        direction = item[1];
        position  = item[2];
        flipped   = item[3];
        extrudes  = item[4];
        translate(position) {
            set_orient(dim, direction, flipped) {
                extrude_extra = 50;
                dim_extrude = [
                    extrudes[0] ? extrude_extra : dim[0],
                    extrudes[1] ? extrude_extra : dim[1],
                    extrudes[2] ? extrude_extra : dim[2],
                ];
                translate([
                    extrudes[0] < 0 ? -extrude_extra+dim[0] : 0,
                    extrudes[1] < 0 ? -extrude_extra+dim[1] : 0,
                    extrudes[2] < 0 ? -extrude_extra+dim[2] : 0,
                ])

                minkowski() {
                    cube(dim_extrude);
                    sphere(d=2*breath_padding);
                }
            }
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

// ===================================================

module _case_plate_2d() {
    offset(r=case_thickness + breath_padding + _delta)
        children(0);
}

module _top_borders(border_height) {
    bp = breath_padding;

    translate([0, 0, -border_height]) {
        linear_extrude(height=border_height, convexity=2) {
            difference() {
                offset(r=breath_padding - contact_padding)
                    children(0);
                offset(r=breath_padding - contact_padding - case_thickness)
                    children(0);
            }
        }
    }
}


module _case_top(comp_info, min_z, max_z, board_h,
                 holes_pos=[], holes_d=-1) {

    translate([0, 0, board_h]) {

        //translate([0, 0, -min_z+bottom_border_h]) {
            //button_pusher_hole_r = button_pusher_r + breath_padding;

            difference() {
                translate([0, 0, max_z]) {
                    linear_extrude(height=case_thickness, convexity=2) {
                        //difference() {
                            _case_plate_2d()
                                children(0);
                        //    button_pushers_pos()
                        //        circle(r=button_pusher_hole_r);
                        //}
                    }
                    _top_borders(top_border_height)
                        children(0);
                }

                _bounding_box(comp_info);
                //translate([0, 0, -top_z + board_z])
                //    extrude_interfaces_top();
            }

            //translate([0, 0, -top_border_height]) {
            //    linear_extrude(height=top_border_height) {
            //        button_pushers_pos() {
            //            difference() {
            //                circle(r=button_pusher_hole_r + case_thickness);
            //                circle(r=button_pusher_hole_r);
            //            }
            //        }
            //    }
            //}
        //}
    }

}

module _bottom_borders(height) {
    bp = breath_padding;
    linear_extrude(height=height, convexity=2) {
        difference() {
            _case_plate_2d()
                children(0);
            offset(r=breath_padding + _delta)
                children(0);
        }
    }
}

module _bottom_plate() {
    linear_extrude(height=case_thickness)
        _case_plate_2d()
            children(0);
}

module _case_bottom(comp_info, min_z, max_z, board_h,
                    holes_pos=[], holes_d=-1) {

    board_z = case_thickness + min_z; // XXX: + breath_padding?
    //buttons_z = board_z + board_dim[2] + button_max_height;
    //top_z = board_z + board_h + gpio_dim[2] - case_thickness;



    bottom_border_h = min_z + board_h + max_z;

    difference() {
        translate([0, 0, -min_z]) {
            translate([0, 0, -case_thickness])
                _bottom_plate()
                    children(0);

            _bottom_borders(bottom_border_h)
                children(0);

        }
        _bounding_box(comp_info);
    }

    translate([0, 0, -min_z])
        for(pos = holes_pos)
            translate(pos)
                column(min_z + board_h + 1, min_z, holes_d/2 - 0.2, 1);
}

// part: "top" or "bottom"
// min_z: typically the height of the "higher" component(s) below the board
// max_z: typically the height of the higher component(s) on top of the board
//
// children(0): plate 2d
module case(part,
            comp_info, min_z, max_z, board_h,
            holes_pos=[], holes_d=2.75) {

    if (part == "bottom")
        _case_bottom(comp_info, min_z, max_z, board_h, holes_pos, holes_d)
            children(0);
    else if (part == "top")
        _case_top(comp_info, min_z, max_z, board_h, holes_pos, holes_d)
            children(0);
}

module demo_case(board_dim) {
    rotate([0, 0, $t*360])
    translate([-board_dim[0]/2, -board_dim[1]/2]) {
        children(0); // case bottom
        stack_animate(time=$t) {
            children(1); // board
            children(2); // case top
        }
    }
}
