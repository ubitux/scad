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

include <cubieboard_config.scad>

$fn = 30;

_delta = 0.005;

_c_gray  = [.4, .4, .4];
_c_gold  = [.8, .5, .0];
_c_metal = [.7, .7, .7];
_c_black = [.3, .3, .3];
_c_black_redish = [.35, .3, .3];

module _plate() {
    ring_size = 1.5;
    color(_c_gray) {
        linear_extrude(height=board_dim[2]) {
            difference() {
                square([board_dim[0], board_dim[1]]);
                hole_positions()
                    circle(d=hole_d + ring_size, $fn=8);
            }
        }
    }
    color(_c_gold) {
        linear_extrude(height=board_dim[2]) {
            hole_positions() {
                difference() {
                    circle(d=hole_d + ring_size, $fn=8);
                    circle(d=hole_d);
                }
            }
        }
    }
}

module _jack() {
    l = jack_dim[0];
    w = jack_dim[1];
    h = jack_dim[2];

    lcyl = 2;
    tcyl = 1;
    l0 = l - lcyl;

    color(_c_black) {
        difference() {
            union() {
                cube([l0, w, h]);
                translate([l0, w/2, h/2])
                    rotate([0, 90, 0])
                        cylinder(d=h, h=lcyl);
            }
            translate([-_delta/2, w/2, h/2])
                rotate([0, 90, 0])
                    cylinder(d=h-tcyl, h=l+_delta);
        }
    }
}

module _otg() {
    l = otg_dim[0];
    w = otg_dim[1];
    h = otg_dim[2];
    lowest = h - 3.5;
    otg_polygon_pos = [[0, h], [w, h], [w, h-1.5], [w-.5, h-2],
                       [w-.5, lowest], [.5, lowest], [.5, h-2],
                       [0, h-1.5]];
    color(_c_metal) {
        cube([l-7, w, h]);
        translate([l-7, 0, 0]) {
            rotate([90, 0, 90]) {
                linear_extrude(height=7) {
                    difference() {
                        polygon(otg_polygon_pos);
                        offset(r=-.5)
                            polygon(otg_polygon_pos);
                    }
                }
            }
        }
    }
    color(_c_black)
        translate([2, 1.5, 2])
            cube([6, w-3, 1]);
}

module _fel() {
    l = fel_dim[0];
    w = fel_dim[1];
    h = fel_dim[2];

    btn_dim = [1, 3, 1.5];
    bl = btn_dim[0];
    bw = btn_dim[1];
    bh = btn_dim[2];

    color("white")
        cube([l-bl, w, h]);
    color(_c_black)
        translate([l-bl, (w-bw)/2, (h-bh)/2])
            cube(btn_dim);
}

module _powerbtn() {
    l = powerbtn_dim[0];
    w = powerbtn_dim[1];
    h = powerbtn_dim[2];

    btn_dim = [1, 3, 1.5];
    bl = btn_dim[0];
    bw = btn_dim[1];
    bh = btn_dim[2];

    color("white")
        translate([bl, 0, 0])
            cube([l-bl, w, h]);
    color(_c_black)
        translate([0, (w-bw)/2, (h-bh)/2])
            cube(btn_dim);
}

module _ethernet() {
    l = ethernet_dim[0];
    w = ethernet_dim[1];
    h = ethernet_dim[2];

    difference() {
        color(_c_metal)
            cube(ethernet_dim);
        translate([5+_delta, 2, 0.5])
            color(_c_black)
                cube([l-5, w-4, h-3]);
    }

    color(_c_black)
        for (y = [2, w-4])
            translate([1, y, 0.5])
                cube([l-1, 2, 3]);

    color([.3, .9, .3])
        translate([l-1+_delta, 1.5-_delta, .5])
            cube([1, 2.5, 2]);

    color([.9, .9, .3])
        translate([l-1+_delta, w-4+_delta, .5])
            cube([1, 2.5, 2]);
}

module _gpio(n=24, m=2) {
    xpad = gpio_dim[0] / (n + 1);
    ypad = gpio_dim[1] / (2 + 1);

    color(_c_metal)
        linear_extrude(height=gpio_dim[2])
            for (y = [1:m])
                for (i = [1:n])
                    translate([i * xpad, y * ypad])
                        square(.5, center=true);

    base_height = gpio_dim[2] / 4;
    color(_c_black)
        translate([0, 0, gpio_dim[2]-base_height])
            linear_extrude(height=base_height)
                for (i = [1:n])
                    hull()
                        for (y = [1:m])
                            translate([i * xpad, y * ypad])
                                circle(d=2, $fn=6, center=true);
}

module _serial(n=4) {
    xpad = serial_dim[0] / (1 + 1);
    ypad = serial_dim[1] / (n + 1);

    color(_c_metal)
        linear_extrude(height=serial_dim[2])
            for (i = [1:n])
                translate([xpad, i * ypad])
                    square(.5, center=true);

    base_height = serial_dim[2] / 4;
    color(_c_black)
        linear_extrude(height=base_height)
            for (i = [1:n])
                translate([xpad, i * ypad])
                    circle(d=serial_dim[0], $fn=6, center=true);
}

module _sata_data() {
    color(_c_black) {
        difference() {
            cube(sata_data_dim);
            translate([1, 1, 2+_delta])
                cube([sata_data_dim[0]-2, sata_data_dim[1]-2, sata_data_dim[2]-2]);
        }
        translate([3, (sata_data_dim[1]-1)/2])
            cube([sata_data_dim[0]-3*2, 1, sata_data_dim[2]]);
        translate([sata_data_dim[0]-4, (sata_data_dim[1]-1)/2+1])
            cube([1, 1, sata_data_dim[2]]);

    }
}

module _sata_5v() {
    color("white") {
        difference() {
            cube(sata_5v_dim);
            translate([1, 1, sata_5v_dim[2] - 6 + _delta])
                cube([sata_5v_dim[0]-2, sata_5v_dim[1]-2, 6]);
            translate([-_delta/2, 1, sata_5v_dim[2]-3])
                cube([sata_5v_dim[0]+_delta, 1, 3+_delta]);
            translate([2, -_delta/2, sata_5v_dim[2]-4])
                cube([sata_5v_dim[0]-4, 1+_delta, 4+_delta]);
        }
    }
    color(_c_metal)
        linear_extrude(height=sata_5v_dim[2]-1)
            for (i = [1:2])
                translate([i*sata_5v_dim[0]/3, sata_5v_dim[1]/3])
                    square(.5);
}

module _usbx2() {
    pin_l = usb_pin_sqrt_len;
    l = usbx2_dim[0] - pin_l;
    w = usbx2_dim[1] - pin_l*2;
    h = usbx2_dim[2] - pin_l*2;

    //%cube(usbx2_dim);

    // separator
    color(_c_metal)
        translate([2*t, 0, (h-4)/2 + pin_l])
            cube([l-4*t, w, 4]);

    t = 0.25;
    p = 0.75;
    z = pin_l * sqrt(2);

    translate([0, pin_l, 0]) {
        translate([0, 0, pin_l]) {
            color(_c_metal) {
                difference() {
                    cube([l, w, h]);
                    translate([t, -t, t])
                        cube([l-t*2, w-t-_delta, h-t*2]);
                }
                translate([0,   0, h-t]) rotate(a= 135, v=[1,0,0]) translate([p, 0, -t]) cube([l - 2*p, z,       t]);
                translate([0,   0,   t]) rotate(a=-135, v=[1,0,0]) translate([p, 0,  0]) cube([l - 2*p, z,       t]);
                translate([t,   0,   0]) rotate(a=-135, v=[0,0,1]) translate([0, -t, p]) cube([z,       t, h - 2*p]);
                translate([l-t, 0,   0]) rotate(a= -45, v=[0,0,1]) translate([0,  0, p]) cube([z,       t, h - 2*p]);
            }
            color(_c_black) {
                translate([1, 0, h-3.5])  cube([l-2, w-t, 2]);
                translate([1, 0, h-12.5]) cube([l-2, w-t, 2]);
            }
        }
        color(_c_metal)
            translate([0, 2*w/3, 0])
                cube([l, w/3, pin_l]);
    }
}

module _power() {
    l = power_dim[0];
    w = power_dim[1];
    h = power_dim[2];
    depth = 8; // actual depth
    power_hole_d = 4.5;
    color(_c_black) {
        difference() {
            cube(power_dim);
            translate([-_delta, 1+power_hole_d/2, h/2]) // yes it's misaligned
                rotate([0, 90, 0])
                    cylinder(d=power_hole_d, h=depth);
        }
    }
    color(_c_metal)
        translate([0, 1+power_hole_d/2, h/2])
            rotate([0, 90, 0])
                cylinder(d=1.5, h=depth);
}

module _ir() {
    l = ir_dim[0];
    w = ir_dim[1];
    h = ir_dim[2];
    color(_c_black) {
        translate([0, 0, 1])
            cube([l, w-1, h-1]);
        translate([l/2, w-1.5, 1])
            cylinder(r=1.5, h=h-3);
        translate([l/2, w-1.5, h-2])
            sphere(r=1.5);
    }
    color(_c_metal)
        linear_extrude(height=h/2)
            for (i = [0:2])
                translate([i*(l-.5-_delta)/2 + _delta/2, (w-1)/2])
                    square(.5);
}

module _hdmi() {
    l = hdmi_dim[0];
    w = hdmi_dim[1];
    h = hdmi_dim[2];
    lowest = h - 5.25;
    hdmi_polygon_pos = [[0, h], [w, h], [w, h-3.25],
                        [w-2, lowest], [2, lowest], [0, h-3.25]];
    color(_c_metal) {
        translate([7, 0, 0])
            cube([l-7, w, h]);
        rotate([90, 0, 90]) {
            linear_extrude(height=7) {
                difference() {
                    polygon(hdmi_polygon_pos);
                    offset(r=-.5)
                        polygon(hdmi_polygon_pos);
                }
            }
        }
    }
    color(_c_black)
        translate([2, 2, 3])
            cube([7, w-2*2, 1]);
}

module _sdslot() {
    color(_c_metal)
        cube(sdslot_dim);
}

module _sdcard() {
    color(_c_black)
        cube(sdcard_dim);
}

module _cpu() {
    color(_c_black)
        cube(cpu_dim);
}

module _cpurad() {
    stick_dim = [3, 1];

    color(_c_black_redish)
        difference() {
            cube(cpurad_dim);

        // horizontal
        hh = 3.5;
        nb_hcut = 6;
        hpad = (cpurad_dim[1] - (nb_hcut + 1) * stick_dim[1]) / nb_hcut;
        translate([0, 0, cpurad_dim[2]-hh])
            linear_extrude(height=hh + _delta, convexity=4)
                for (y = [0:nb_hcut-1])
                    translate([-_delta/2, (y + 1) * stick_dim[1] + y * hpad])
                        square([cpurad_dim[0]+_delta, hpad]);

        // vertical
        nb_vcut = 4;
        vpad = (cpurad_dim[0] - (nb_vcut + 1) * stick_dim[0]) / nb_vcut;
        hv = 4.5;
        translate([0, 0, cpurad_dim[2]-hv])
            linear_extrude(height=hv + _delta, convexity=4)
                for (x = [0:nb_vcut-1])
                    translate([(x + 1) * stick_dim[0] + x * vpad, -_delta/2])
                        square([vpad, cpurad_dim[1]+_delta]);
    }
}

module hole_positions() {
    hole_pad = 3.5;
    hole_x1 = board_dim[0] - hole_pad;
    hole_x2 = 23;
    hole_y1 = board_dim[1] - hole_pad;
    hole_y2 = hole_pad;

    for (y = [hole_y1, hole_y2])
        for (x = [hole_x1, hole_x2])
            translate([x, y])
                children();
}

module jack_pos() {
    for (pos = jack_pos_tab)
        translate(pos)
            children();
}

module gpio_pos() {
    for (pos = gpio_pos_tab)
        translate(pos)
            children();
}

module cubieboard() {
    _plate();

    translate(ethernet_pos)     _ethernet();
    jack_pos()                  _jack();
    translate(otg_pos)          _otg();
    translate(fel_pos)          _fel();
    gpio_pos()                  _gpio();
    translate(usbx2_pos)        _usbx2();
    translate(sata_data_pos)    _sata_data();
    translate(sata_5v_pos)      _sata_5v();
    translate(power_pos)        _power();
    translate(powerbtn_pos)     _powerbtn();
    translate(ir_pos)           _ir();
    translate(serial_pos)       _serial();
    translate(hdmi_pos)         _hdmi();
    translate(sdslot_pos)       _sdslot();
    translate(sdcard_pos)       _sdcard();
    translate(cpu_pos)          _cpu();
    translate(cpurad_pos)       _cpurad();
}

rotate([0, 0, $t*360])
    translate([-board_dim[0]/2, -board_dim[1]/2])
        cubieboard();
