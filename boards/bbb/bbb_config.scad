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

// There is a mix of american units and sane units in this file due to the
// dimensions provided in the specifications being incomplete and expressed in
// inches, and my inability to measure in something else than international
// units. This in2mm() function allows converting the value I got from the
// specifications.
function in2mm(v) = 2.54 * v / 100;

board_dim = [in2mm(3400), in2mm(2150), 1.75];

hole_d = in2mm(125);

ledgesz = in2mm(250);
redgesz = in2mm(500);

ethernet_dim = [21, 16, 13.5];
ethernet_pos = [-in2mm(100), in2mm(855), board_dim[2]];

power_dim = [14, 9, 11];
power_pos = [-in2mm(100), in2mm(215), board_dim[2]];

gpio_dim = [59, 5, 8.5];
gpio_pos_tab = [[18,                0.5, board_dim[2]],
                [18, board_dim[1]-5-0.5, board_dim[2]]];

usb_dim = [14, 14.5, 8];
usb_pos = [72.5, in2mm(405) - .6, board_dim[2]];

button_base_dim = [4, 3, 1.5];
button_pusher_dim = [2, 1.5, 0.5];

miniusb_dim = [7, in2mm(1880-1575), 4];
miniusb_pos = [-in2mm(25), in2mm(1575), -miniusb_dim[2]];

hdmi_dim = [7.5, in2mm(1110-850), 3];
hdmi_pos = [board_dim[0]-hdmi_dim[0]+in2mm(25), in2mm(850), -hdmi_dim[2]];

sdslot_dim = [15, in2mm(1755-1205), 2];
sdslot_pos = [board_dim[0]-sdslot_dim[0], in2mm(1205), -sdslot_dim[2]];

sdcard_dim = [15, 11, 1];
sdcard_pos = [sdslot_pos[0]+in2mm(110), sdslot_pos[1]+0.5, -sdcard_dim[2]];

rt1_dim = [3.5, 8, 10.5];
rt1_pos = [68, 6.5, board_dim[2]];

pins_dim = [15, 2.5, 8.5];
pins_pos = [41, 6, board_dim[2]];
