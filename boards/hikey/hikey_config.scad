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

board_dim = [85.25, 54, 1.25];

hole_d = 2.5;
min_board_z = 2;

sdslot_dim = [14, 15.5, 1.25];
sdslot_pos = [1.25, 0, board_dim[2]];

sdcard_dim = [11, 15, 1];
sdcard_pos = [sdslot_pos[0]+.25, -2, board_dim[2]];

hdmi_dim = [15, 9.25, 6];
hdmi_pos = [17.5, -2, board_dim[2]];

microusb_dim = [8, 6, 3];
microusb_pos = [38, -1, board_dim[2]];

usb_dim = [14, 14.5, 7];
usb_pos_tab = [
    [69, 0, board_dim[2]],
    [49, 0, board_dim[2]],
];

extio_dim = [30, 6, 4];
extio_pos = [18, 12, board_dim[2]];

uart0_dim = [4, 4, 5];
uart0_pos = [1, 36, board_dim[2]];

cfgpins_dim = [6, 4, 5];
cfgpins_pos = [1, 40.5, board_dim[2]];

gpio_dim = [40.5, 4, 4.5];
gpio_pos = [9.5, 48, board_dim[2]];

powerbtn_dim = [4, 3, 2];
powerbtn_pos = [52.5, board_dim[1]-powerbtn_dim[1]-1, board_dim[2]];

power_dim = [9, 13, 6];
power_pos = [board_dim[0]-power_dim[0]-8.75,
             board_dim[1]-power_dim[1], board_dim[2]];

capacitor_dim = [6, 6, 5];
capacitor_pos = [60, 46, board_dim[2]];
