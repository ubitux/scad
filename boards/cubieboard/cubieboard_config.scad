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

board_dim = [100, 60, 1.25];

hole_d = 3;

jack_dim = [12+2, 6.5, 5];
jack_pos_tab = [
    [board_dim[0]-jack_dim[0]+2, 39, board_dim[2]],
    [board_dim[0]-jack_dim[0]+2, 39, -jack_dim[2]],
];

otg_dim = [9, 7, 4];
otg_pos = [board_dim[0]-otg_dim[0]+1, 26.5, board_dim[2]];

fel_dim = [3.5, 7, 3.5];
fel_pos = [board_dim[0]-fel_dim[0], 26.5, -fel_dim[2]];

ethernet_dim = [21, 16, 13.5];
ethernet_pos = [board_dim[0]-ethernet_dim[0]+4, 8, board_dim[2]];

gpio_dim = [50, 6, 6];
gpio_pos_tab = [[44,                          .5, -gpio_dim[2]],
                [44, board_dim[1]-gpio_dim[1]-.5, -gpio_dim[2]]];

sata_data_dim = [17, 6.5, 9];
sata_data_pos = [27, board_dim[1]-sata_data_dim[1], board_dim[2]];

sata_5v_dim = [7.5, 6, 7.5];
sata_5v_pos = [18, 47, board_dim[2]];

usbx2_dim = [17.5, 14.5, 16];
usbx2_pos = [29, -.5, board_dim[2]];

power_dim = [12, 7.5, 6];
power_pos = [0, 50.5, board_dim[2]];

powerbtn_dim = [3.5, 7, 3.5];
powerbtn_pos = [-.5, 37, board_dim[2]];

ir_dim = [5, 3.5, 7];
ir_pos = [13.5, 57, board_dim[2]];

serial_dim = [10.25, 2.5, 8.5];
serial_pos = [44.5, 17, board_dim[2]];

hdmi_dim = [11.25, 15, 6];
hdmi_pos = [-.5, 20, board_dim[2]];

sdslot_dim = [15, 14.75, 2];
sdslot_pos = [4, 1.75, board_dim[2]];

sdcard_dim = [11, 15, 1];
sdcard_pos = [5, -.5, 2];

cpu_dim = [19, 19, 1.25];
cpu_pos = [47.5, 28, board_dim[2]];

cpurad_dim = [cpu_dim[0], cpu_dim[1], 5];
cpurad_pos = [cpu_pos[0], cpu_pos[1], cpu_pos[2]+cpu_dim[2]];
