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

$fn = 30;

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

module set_orient(dim, direction, flipped) {
    _set_direction(dim, direction)
        _set_flipped(dim, flipped)
            children();
}

module set_components(comp_info) {
    for (i = [0:len(comp_info)-1]) {
        info = comp_info[i];
        dim       = info[0];
        direction = info[1];
        position  = info[2];
        flipped   = info[3];
        extrudes  = info[4];
        translate(position)
            set_orient(dim, direction, flipped)
                children(i);
    }
}

module demo_board(board_dim) {
    rotate([0, 0, $t*360])
        translate([-board_dim[0]/2, -board_dim[1]/2])
            children();
}

module hole_positions(holes_pos) {
    for (pos = holes_pos)
        translate(pos)
            children();
}
