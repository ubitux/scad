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

module stack_animate(time, pad=40, axis=[0,0,1]) {
    function slope_a(x1, y1, x2, y2) = (y1 - y2) / (x1 - x2);
    function slope_b(x1, y1, x2, y2) = (x1*y2 - x2*y1) / (x1 - x2);
    function clip_time(t, mint, maxt) = min(max(t, mint), maxt);

    for (i = [0:$children-1]) {
        start_pos = (i + 1) * pad;
        end_pos = 0;
        start_time = i / $children;
        end_time = (i + 1) / $children;
        a = slope_a(start_time, start_pos, end_time, end_pos);
        b = slope_b(start_time, start_pos, end_time, end_pos);
        t = clip_time(time, start_time, end_time);
        translate(axis * (a*t + b))
            children(i);
    }
}
