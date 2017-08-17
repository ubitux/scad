# Copyright (c) 2017 Clément Bœsch <u pkh.me>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

OPENSCAD ?= openscad --colorscheme="Tomorrow Night" --imgsize=1920,1280 $(OPENSCAD_EXTRA_SETTINGS)
DSCALE   ?= scale=iw/4:ih/4:flags=lanczos
FFMPEG   ?= ffmpeg -v warning
STEPS    ?= 200
FPS      ?= 30
PALETTE  ?= palette.png
GIF_FINAL_DELAY ?= 300

ANIM_PREFIX := anim-$(NAME)-
ANIM_IMG_PATTERN := $(ANIM_PREFIX)%03d.png
ANIM_PICS := $(addsuffix .png,$(addprefix $(ANIM_PREFIX),$(shell seq -w $(STEPS))))

PIECES_PICS := $(addsuffix .png,$(addprefix $(NAME)-,$(PIECES)))
PIECES_STL  := $(addsuffix .stl,$(addprefix $(NAME)-,$(PIECES)))
PIECES_LPICS := $(addsuffix .png,$(addprefix large-$(NAME)-,$(PIECES)))

ALL_TARGETS = $(NAME).gif $(PIECES_STL) $(PIECES_PICS)

stl: $(PIECES_STL)

all: $(ALL_TARGETS)

pics: $(PIECES_PICS)

deploy_pics: $(PIECES_PICS) $(NAME).gif
	cp $^ ../../img/$(NAME)

$(PALETTE): $(ANIM_PICS)
	$(FFMPEG) -i $(ANIM_IMG_PATTERN) -vf $(DSCALE),palettegen -y $@

$(NAME).gif: $(ANIM_PICS) $(PALETTE)
	$(FFMPEG) -framerate $(FPS) -i $(ANIM_IMG_PATTERN) -i $(PALETTE) -lavfi "$(DSCALE)[x];[x][1:v]paletteuse" -y -frames:v $(STEPS) -loop 0 -final_delay $(GIF_FINAL_DELAY) $@

$(ANIM_PREFIX)%.png: NUM = $(shell echo $* | sed 's/^0*//')
$(ANIM_PREFIX)%.png: $(NAME).scad
	$(OPENSCAD) $< -D'$$t=$(NUM)/$(STEPS)' -o $@

large-$(NAME)-%.png $(NAME)-%.stl: $(NAME).scad
	$(OPENSCAD) $< -D'mod="$*"' -o $@
$(NAME)-%.png: large-$(NAME)-%.png
	$(FFMPEG) -i $< -vf $(DSCALE) -y $@

clean:
	$(RM) $(ANIM_PICS)
	$(RM) $(PALETTE)
	$(RM) $(ALL_TARGETS)
	$(RM) $(PIECES_LPICS)

.PHONY: all stl pics clean deploy_pics
