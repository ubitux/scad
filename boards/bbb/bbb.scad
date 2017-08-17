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
                    circle(d=hole_d+1);
                plate_edges();
            }
        }
    }
    color(_c_gold) {
        linear_extrude(height=board_dim[2]) {
            hole_positions() {
                difference() {
                    circle(d=hole_d+1);
                    circle(d=hole_d);
                }
            }
        }
    }
}

module _ethernet() {
    l = ethernet_dim[0];
    w = ethernet_dim[1];
    h = ethernet_dim[2];

    color(_c_metal) {
        difference() {
            cube(ethernet_dim);
            translate([-_delta, 2, 0.5])
                cube([l-5, w-4, h-3]);
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
        translate([0, w/2, h0])
            rotate([0, 90])
                cylinder(d=2, h=l0);
    }
}

module _gpio() {
    l = gpio_dim[0];
    w = gpio_dim[1];
    n = 23;
    s = l/n/2;
    color(_c_black) {
        difference() {
            cube(gpio_dim);
            for (y = [0:1]) {
                for (i = [0:n-1]) {
                    translate([s/2 + i*(l/n), s/2 + y*(w/2), _delta])
                        cube([s, s, 8.5]);
                }
            }
        }
    }
}

module _usb() {
    pin_l = usb_pin_sqrt_len;
    l = usb_dim[0] - pin_l;
    w = usb_dim[1] - pin_l*2;
    h = usb_dim[2] - pin_l*2;

    t = 0.25;
    p = 0.75;
    z = pin_l * sqrt(2);

    translate([0, pin_l, 0]) {
        translate([0, 0, pin_l]) {
            color(_c_metal) {
                difference() {
                    cube([l, w, h]);
                    translate([t, t, t])
                        cube([l-t+_delta, w-t*2, h-t*2]);
                }
                translate([l,   0, h-t]) rotate(a=-45, v=[0,1,0]) translate([0,  p,  0]) cube([z, w - 2*p,       t]);
                translate([l,   0,   t]) rotate(a= 45, v=[0,1,0]) translate([0,  p, -t]) cube([z, w - 2*p,       t]);
                translate([l,   t,   0]) rotate(a=-45, v=[0,0,1]) translate([0, -t,  p]) cube([z,       t, h - 2*p]);
                translate([l, w-t,   0]) rotate(a= 45, v=[0,0,1]) translate([0,  0,  p]) cube([z,       t, h - 2*p]);
            }
            color("white")
                translate([t, 1, h-3.5])
                    cube([l-t, w-2, 2]);
        }
        color(_c_metal)
            cube([l/3, w, pin_l]);
    }
}

module _button() {
    base_l = button_base_dim[0];
    base_w = button_base_dim[1];
    base_h = button_base_dim[2];

    button_l = button_pusher_dim[0];
    button_w = button_pusher_dim[1];

    translate([0, 0, board_dim[2]]) {
        color(_c_metal)
            cube(button_base_dim);

        color(_c_black)
            translate([(base_l-button_l)/2, (base_w-button_w)/2, base_h])
                cube(button_pusher_dim);
    }
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

module _pins() {
    foot_height = 2;
    color(_c_black)
        cube([pins_dim[0], pins_dim[1], foot_height]);

    pad = pins_dim[0] / 6;
    color(_c_metal)
        for (i = [0:5])
            translate([i * pad + pad / 2, pins_dim[1]/2, 0])
                cylinder(h=pins_dim[2], d=0.8, $fn=4);
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

module hole_positions() {
    translate([in2mm( 575), in2mm(2025)]) children();
    translate([in2mm( 575), in2mm( 125)]) children();
    translate([in2mm(3175), in2mm( 250)]) children();
    translate([in2mm(3175), in2mm(1900)]) children();
}

module plate_edges() {
    l = board_dim[0];
    w = board_dim[1];

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

module gpio_pos() {
    for (pos = gpio_pos_tab)
        translate(pos)
            children();
}

module button_pos() {
    translate([5.5, 40])     children();
    translate([5.5, 40+9.5]) children();
    translate([74, 41.5])    children();
}

module beaglebone_black() {
    _plate();

    // top
    translate(power_pos)    _power();
    translate(ethernet_pos) _ethernet();
    gpio_pos()              _gpio();
    translate(usb_pos)      _usb();
    button_pos()            _button();
    translate(rt1_pos)      _rt1();
    translate(pins_pos)     _pins();

    // bottom
    translate(miniusb_pos)  _miniusb();
    translate(hdmi_pos)     _hdmi();
    translate(sdslot_pos)   _sdslot();
    translate(sdcard_pos)   _sdcard();
}

rotate([0, 0, $t*360])
    translate([-board_dim[0]/2, -board_dim[1]/2])
        beaglebone_black();
