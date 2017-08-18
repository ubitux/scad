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

board_dim = [85, 56, 1.25];
hole_d = 2.75;

microusb_dim = [6, 8, 3];
microusb_pos = [10.6 - microusb_dim[1]/2, -1, board_dim[2]];

hdmi_dim = [11.5, 15, 6.5];
hdmi_pos = [32 - hdmi_dim[1]/2, -1, board_dim[2]];

jack_dim = [14.5, 7, 6];
jack_pos = [53.5 - jack_dim[1]/2, -2, board_dim[2]];

gpio_dim = [51, 5, 8.5];
gpio_pos = [3.5+29-gpio_dim[0]/2, board_dim[1]-gpio_dim[1]-1, board_dim[2]];

usbx2_dim = [17.25, 15, 16.5];
usbx2_pos_tab = [
    [board_dim[0]-usbx2_dim[0]+2, 29-usbx2_dim[1]/2, board_dim[2]],
    [board_dim[0]-usbx2_dim[0]+2, 47-usbx2_dim[1]/2, board_dim[2]],
];

ethernet_dim = [21, 16, 13.5];
ethernet_pos = [board_dim[0]-ethernet_dim[0]+2, 10.25-ethernet_dim[1]/2, board_dim[2]];

serialcon_dim = [2.5, 22, 5.5];
serialcon_pos_tab = [
    [1.1, 3.5+28-serialcon_dim[1]/2, board_dim[2]],
    [32+13-serialcon_dim[0]/2, .5, board_dim[2]],
];

sdslot_dim = [11.5, 12, 1.25];
sdslot_pos = [1.75, (board_dim[1]-sdslot_dim[1])/2, -sdslot_dim[2]];

sdcard_dim = [15, 11, 1];
sdcard_pos = [sdslot_pos[0]+sdslot_dim[0]-.25-sdcard_dim[0],
              (board_dim[1]-sdcard_dim[1])/2, -sdcard_dim[2]];
