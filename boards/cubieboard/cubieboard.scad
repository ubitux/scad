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
use <../utils.scad>

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

    translate(ethernet_pos)     ethernet(ethernet_dim, direction="E");
    jack_pos()                  jack(jack_dim, direction="E");
    translate(otg_pos)          _otg();
    translate(fel_pos)          _fel();
    gpio_pos()                  pin_header_pitch200(24, 2, dim=gpio_dim, flipped=true);
    translate(usbx2_pos)        usbx2(dim=usbx2_dim, direction="S");
    translate(sata_data_pos)    _sata_data();
    translate(sata_5v_pos)      _sata_5v();
    translate(power_pos)        _power();
    translate(powerbtn_pos)     _powerbtn();
    translate(ir_pos)           _ir();
    translate(serial_pos)       pin_header_pitch254(4, 1, dim=serial_dim, direction="N");
    translate(hdmi_pos)         hdmi(hdmi_dim);
    translate(sdslot_pos)       _sdslot();
    translate(sdcard_pos)       _sdcard();
    translate(cpu_pos)          _cpu();
    translate(cpurad_pos)       _cpurad();
}

rotate([0, 0, $t*360])
    translate([-board_dim[0]/2, -board_dim[1]/2])
        cubieboard();
