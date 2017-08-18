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
use <../utils.scad>

$fn = 30;

_delta = 0.005;

_c_gray  = [.4, .4, .4];
_c_gold  = [.8, .5, .0];
_c_metal = [.7, .7, .7];
_c_black = [.3, .3, .3];

module _plate() {
    color(_c_gray) {
        linear_extrude(height=board_dim[2]) {
            difference() {
                square([board_dim[0], board_dim[1]]);
                hole_positions()
                    circle(d=hole_d+2.25);
            }
        }
    }
    color(_c_gold) {
        linear_extrude(height=board_dim[2]) {
            hole_positions() {
                difference() {
                    circle(d=hole_d+2.25);
                    circle(d=hole_d);
                }
            }
        }
    }
}

module hole_positions() {
    hole_pad = 4;
    hole_x1 = hole_pad;
    hole_x2 = board_dim[0] - hole_pad;
    hole_y1 = 19;
    hole_y2 = board_dim[1] - hole_pad;

    for (y = [hole_y1, hole_y2])
        for (x = [hole_x1, hole_x2])
            translate([x, y])
                children();
}

module _sdslot() {
    color(_c_metal)
        cube(sdslot_dim);
}

module _sdcard() {
    color(_c_black)
        cube(sdcard_dim);
}

module _hdmi() {
    l = hdmi_dim[0];
    w = hdmi_dim[1];
    h = hdmi_dim[2];
    lowest = h - 5.25;
    hdmi_polygon_pos = [[0, h], [l, h], [l, h-3.25],
                        [l-2, lowest], [2, lowest], [0, h-3.25]];
    translate([0, 7, 0]) {
        color(_c_metal) {
            cube([l, w-7, h]);
            rotate([90, 0, 0]) {
                linear_extrude(height=7) {
                    difference() {
                        polygon(hdmi_polygon_pos);
                        offset(r=-.5)
                            polygon(hdmi_polygon_pos);
                    }
                }
            }
        }
    }
    color(_c_black)
        translate([2, 2, 3])
            cube([l-2*2, 7, 1]);
}

module _microusb() {
    l = microusb_dim[0];
    w = microusb_dim[1];
    h = microusb_dim[2];
    microusb_polygon_pos = [[1, h], [l-1, h], [l, h-1],
                            [l-2, 0], [2, 0], [0, h-1]];
    color(_c_metal) {
        translate([0, w-1])
            cube([l, 1, h]);
        translate([0, w-1]) {
            rotate([90, 0, 0]) {
                linear_extrude(height=w-1) {
                    difference() {
                        polygon(microusb_polygon_pos);
                        offset(r=-.5)
                            polygon(microusb_polygon_pos);
                    }
                }
            }
        }
    }
    color(_c_black)
        translate([2, 0, h-1.5])
            cube([l-4, w-1, .5]);
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

module _dualpins(dim, n) {
    xpad = dim[0] / (2 + 1);
    ypad = dim[1] / (n + 1);

    color(_c_metal)
        linear_extrude(height=dim[2])
            for (y = [1:n])
                for (x = [1:2])
                    translate([x * xpad, y * ypad])
                        square(.5, center=true);

    base_height = dim[2] / 4;
    color(_c_black)
            linear_extrude(height=base_height)
                for (y = [1:n])
                    hull()
                        for (x = [1:2])
                            translate([x * xpad, y * ypad])
                                circle(d=2.5, $fn=6, center=true);
}

module _uart0() {
    _dualpins(uart0_dim, 2);
}

module _cfgpins() {
    _dualpins(cfgpins_dim, 3);
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
    l = power_dim[0];
    w = power_dim[1];
    h = power_dim[2];

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

module usb_pos() {
    for (pos = usb_pos_tab)
        translate(pos)
            children();
}

module hikey() {
    _plate();

    translate(sdslot_pos)       _sdslot();
    translate(sdcard_pos)       _sdcard();
    translate(hdmi_pos)         _hdmi();
    translate(microusb_pos)     _microusb();
    usb_pos()                   usb(usb_dim, direction="S");
    translate(extio_pos)        _extio();
    translate(uart0_pos)        _uart0();
    translate(cfgpins_pos)      _cfgpins();
    translate(gpio_pos)         female_header_pitch200(20, 2, dim=gpio_dim);
    translate(powerbtn_pos)     _powerbtn();
    translate(power_pos)        _power();
    translate(capacitor_pos)    _capacitor();
}

rotate([0, 0, $t*360])
    translate([-board_dim[0]/2, -board_dim[1]/2])
        hikey();
