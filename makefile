SRCS=$(wildcard src/image_*.hs)

PNGS=$(subst src,pngs,$(SRCS:.hs=.png))

all: $(PNGS)

RESO?=800
AA?=2

# GHC is expected on PATH.
# With the Nix dev shell, run:  nix develop --command make [target]
GHC = ghc

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
	./bins/$(notdir $(basename $<)) $(RESO) $(RESO) $(AA) $@ +RTS -N

$(BUILDDIR) bins:
	mkdir -p $@

clean:
	rm -rf $(BUILDDIR)
	rm -f bins/*
	rm -f pngs/*.png

