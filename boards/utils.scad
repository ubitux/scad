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

module _set_orient(dim, direction="W") {
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

module ethernet(dim=[21, 16, 13.5], orient="W") {
    _set_orient(dim, orient)
        _ethernet(dim);
}
