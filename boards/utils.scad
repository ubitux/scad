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

_delta = 0.005;
_c_metal = [.7, .7, .7];
_c_black = [.3, .3, .3];

module _set_flipped(dim, flipped) {
    if (flipped) {
        translate([0, dim[1], dim[2]])
            rotate([180, 0, 0])
                children();
    } else {
        children();
    }
}

module _set_direction(dim, direction) {
    if (direction == "N")
        translate([0, dim[0], 0])
            rotate([0, 0, -90])
                children();
    else if (direction == "S")
        translate([dim[1], 0, 0])
            rotate([0, 0, 90])
                children();
    else if (direction == "E")
        translate([dim[0], dim[1], 0])
            rotate([0, 0, 180])
                children();
    else if (direction == "W")
        children();
}

module _set_orient(dim, direction, flipped) {
    //%cube(dim);
    _set_direction(dim, direction)
        _set_flipped(dim, flipped)
            children();
}

module _ethernet(dim) {
    l = dim[0];
    w = dim[1];
    h = dim[2];

    difference() {
        color(_c_metal)
            cube(dim);
        translate([-_delta, 2, 0.5])
            color(_c_black)
                cube([l-5, w-4, h-3]);
    }

    color(_c_black)
        for (y = [2, w-4])
            translate([0, y, 0.5])
                cube([l-1, 2, 3]);

    color([.3, .9, .3])
        translate([-_delta, w-4+_delta, .5])
            cube([1, 2.5, 2]);

    color([.9, .9, .3])
        translate([-_delta, 1.5-_delta, .5])
            cube([1, 2.5, 2]);
}

module _usb(dim) {
    pin_l = .6;
    l = dim[0] - pin_l;
    w = dim[1] - pin_l*2;
    h = dim[2] - pin_l*2;

    t = 0.25;
    p = 0.75;
    z = pin_l * sqrt(2);

    translate([pin_l, pin_l, pin_l]) {
        color(_c_metal) {
            difference() {
                cube([l, w, h]);
                translate([-_delta, t, t])
                    cube([l-t+_delta, w-t*2, h-t*2]);
            }
            translate([0,   p, h-t]) rotate(a= 45, v=[0,1,0]) translate([-z,  0,  0]) cube([z, w - 2*p,       t]);
            translate([0,   p,   t]) rotate(a=-45, v=[0,1,0]) translate([-z,  0, -t]) cube([z, w - 2*p,       t]);
            translate([0,   t,   p]) rotate(a= 45, v=[0,0,1]) translate([-z, -t,  0]) cube([z,       t, h - 2*p]);
            translate([0, w-t,   p]) rotate(a=-45, v=[0,0,1]) translate([-z,  0,  0]) cube([z,       t, h - 2*p]);
        }
        color("white")
            translate([0, 1, h-3.5])
                cube([l-t, w-2, 2]);
    }
    color(_c_metal)
        translate([pin_l+l-l/3, pin_l])
            cube([l/3, w, pin_l]);
}

module _pins_pos(dim, n, m, pins_dist) { // centered position for the pins
    l = dim[0];
    w = dim[1];
    pl = (n - 1) * pins_dist;
    pw = (m - 1) * pins_dist;
    if (l <= pl) echo("WARN: female header length looks too small");
    if (w <= pw) echo("WARN: female header width looks too small");
    translate([(l-pl)/2, (w-pw)/2])
        for (y = [0:m-1])
            for (x = [0:n-1])
                translate([x * pins_dist, y * pins_dist])
                    children();
}

module _female_header(dim, n, m, pins_sz, pins_dist) {
    h = dim[2];
    color(_c_black) {
        difference() {
            cube(dim);
            translate([0, 0, _delta])
                linear_extrude(height=h-.25)
                    _pins_pos(dim, n, m, pins_dist)
                        square(pins_sz, center=true);
            translate([0, 0, h-.25])
                _pins_pos(dim, n, m, pins_dist)
                    rotate(45)
                        cylinder(d1=pins_sz*sqrt(2), d2=1.25+pins_sz, h=.25+_delta, $fn=4);
        }
    }
}

module _pins_slot(n, u) {
    x = u/4;
    z = u/2;
    h = u*n;
    slot_polygons = [
        [-z/2, h/2], [ z/2, h/2], [ u/2, h/2-x], [ u/2,-h/2+x],
        [ z/2,-h/2], [-z/2,-h/2], [-u/2,-h/2+x], [-u/2, h/2-x],
    ];
    polygon(slot_polygons);
}

module _pin_header(dim, n, m, pins_sz, pins_dist) {
    l = dim[0];
    w = dim[1];
    h = dim[2];
    color(_c_metal)
        linear_extrude(height=h)
            _pins_pos(dim, n, m, pins_dist)
                square(pins_sz, center=true);
    pl = (n - 1) * pins_dist;
    color(_c_black)
        linear_extrude(height=h/4)
            translate([(l-pl)/2, w/2])
                for (x = [0:n-1])
                    translate([x * pins_dist, 0])
                        _pins_slot(m, pins_dist);
}

_default_ethernet_dim = [21, 16, 13.5];
_default_usb_dim      = [14, 14.5, 8];
_default_hdmi_dim     = [11.5, 15, 6];

module _hdmi(dim) {
    l = dim[0];
    w = dim[1];
    h = dim[2];
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

module ethernet(dim=_default_ethernet_dim, direction="W", flipped=false) {
    _set_orient(dim, direction, flipped)
        _ethernet(dim);
}

module usb(dim=_default_usb_dim, direction="W", flipped=false) {
    _set_orient(dim, direction, flipped)
        _usb(dim);
}

module hdmi(dim=_default_hdmi_dim, direction="W", flipped=false) {
    _set_orient(dim, direction, flipped)
        _hdmi(dim);
}

function _dim254(dim, n, m) = [
        dim[0] ? dim[0] : n*2.54,
        dim[1] ? dim[1] : m*2.5,
        dim[2] ? dim[2] : 8.5,
];

function _dim200(dim, n, m) = [
        dim[0] ? dim[0] : n*2,
        dim[1] ? dim[1] : m*2,
        dim[2] ? dim[2] : 4.5,
];

module female_header_pitch254(n, m, dim=[0,0,0], direction="W", flipped=false) {
    dim = _dim254(dim, n, m);
    _set_orient(dim, direction, flipped)
        _female_header(dim, n, m, pins_sz=.64, pins_dist=2.54);
}

module female_header_pitch200(n, m, dim=[0,0,0], direction="W", flipped=false) {
    dim = _dim200(dim, n, m);
    _set_orient(dim, direction, flipped)
        _female_header(dim, n, m, pins_sz=.50, pins_dist=2);
}

module pin_header_pitch254(n, m, dim=[0,0,0], direction="W", flipped=false) {
    dim = _dim254(dim, n, m);
    _set_orient(dim, direction, flipped)
        _pin_header(dim, n, m, pins_sz=.64, pins_dist=2.54);
}

module pin_header_pitch200(n, m, dim=[0,0,0], direction="W", flipped=false) {
    dim = _dim200(dim, n, m);
    _set_orient(dim, direction, flipped)
        _pin_header(dim, n, m, pins_sz=.50, pins_dist=2);
}

module _test_orient(dim, flipped) {
    translate([0, 0,  0]) _set_orient(dim, "W", flipped) children();
    translate([0, 0, 20]) _set_orient(dim, "S", flipped) children();
    translate([0, 0, 40]) _set_orient(dim, "E", flipped) children();
    translate([0, 0, 60]) _set_orient(dim, "N", flipped) children();
}

_test_orient(_default_ethernet_dim, flipped=false)
    ethernet();

!pin_header_pitch200(20, 2);
