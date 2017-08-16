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

delta = 0.005;

hexago_r = 20;
hexago_thick = hexago_r / 2;

function _height(level=1) = hexago_thick * (level + 1);

module hexago_pos(p=[0,0,0]) {
    r0 =               hexago_r;
    r1 = sqrt(3) / 2 * hexago_r;
    tx =               hexago_thick;
    ty = sqrt(3) / 2 * hexago_thick;
    x_translate = (r0 + tx) * 3/2;
    y_translate = (r1 + ty) * 2;
    odd_y_offset = r1 + ty;

    x = p[0] * x_translate;
    y = p[1] * y_translate + (p[0] % 2 ? odd_y_offset : 0);
    z = _height(p[2]);

    translate([x, y, z])
        children();
}

module _hexago() {
    border = hexago_r / 10;
    hull() {
        cylinder(r=hexago_r, h=hexago_thick-border, $fn=6);
        cylinder(r=hexago_r-border, h=hexago_thick, $fn=6);
    }
}

module hexago_block(n=1, m=1, level=1) {
    height = _height(level);
    for (x = [0:n-1]) {
        for (y = [0:m-1]) {
            hexago_pos([x, y]) {
                difference() {
                    union() {
                        translate([0, 0, height]) // male part
                            _hexago();
                        difference() { // female part
                            cylinder(r=hexago_r+hexago_thick, h=height, $fn=6);
                            translate([0, 0, -delta])
                                _hexago();
                        }
                    }
                    cylinder(r=hexago_r-hexago_r/5, h=height + hexago_thick + delta, $fn=6);
                }
            }
        }
    }
}

module _demo() {
    color("orange") hexago_block(6, 4);
    stack_animate(time=$t, pad=200) {
        hexago_pos([5, 1, 1])                hexago_block();
        hexago_pos([0, 0, 1]) color("green") hexago_block(3, 2, level=3);
        hexago_pos([3, 3, 1]) color("pink")  hexago_block(1, 1, level=20);
        hexago_pos([1, 0, 5]) color("red")   hexago_block(4, 1, level=5);
    }
}

mod = "demo";

if      (mod == "8x5x1") hexago_block(8, 5, level=1);
else if (mod == "3x2x3") hexago_block(3, 2, level=3);
else if (mod == "1x1x5") hexago_block(1, 1, level=5);
else if (mod == "1x1x1") hexago_block(1, 1, level=1);
else
    _demo();
