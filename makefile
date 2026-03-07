SRCS=$(wildcard src/image_*.hs)

PNGS=$(subst src,pngs,$(SRCS:.hs=.png))

all: $(PNGS)

RESO?=800
AA?=1

# Set NIX=1 to compile via `nix develop --command ghc`.
# Leave unset (or NIX=0) to use whatever ghc is on PATH.
NIX?=0

ifeq ($(NIX),1)
GHC=nix --extra-experimental-features 'nix-command flakes' develop --command ghc
else
GHC=ghc
endif

BUILDDIR = _build
GHC_FLAGS = -O3 -threaded -outputdir $(BUILDDIR)

TEGAMI_SRCS = $(wildcard Tegami/*.hs)
TEGAMI_STAMP = $(BUILDDIR)/tegami.stamp


# Pre-compile the Tegami library once; all image targets depend on this stamp.
$(TEGAMI_STAMP): $(TEGAMI_SRCS) | $(BUILDDIR)
	$(GHC) $(GHC_FLAGS) --make -c Tegami/Shape.hs Tegami/Render.hs
	touch $@

pngs/%.png: src/%.hs $(TEGAMI_STAMP) | bins
	$(GHC) $(GHC_FLAGS) -o bins/$(notdir $(basename $<)) $<
	./bins/$(notdir $(basename $<)) $(RESO) $(RESO) $(AA) +RTS -N
	mv $(notdir $(basename $<)).png $@

$(BUILDDIR) bins:
	mkdir -p $@

clean:
	rm -rf $(BUILDDIR)
	rm -f bins/*
	rm -f pngs/*.png

