SRCS=$(wildcard images/image_*.hs)

PNGS=$(subst images,pngs,$(SRCS:.hs=.png))

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


pngs/%.png: images/%.hs
	$(GHC) -O3 -threaded -o bins/$(notdir $(basename $<)) $<
	./bins/$(notdir $(basename $<)) $(RESO) $(RESO) $(AA) +RTS -N
	mv $(notdir $(basename $<)).png $@

clean: clean_artifacts
	rm bins/*
	rm pngs/*.png

clean_artifacts:
	rm images/*.hi
	rm images/*.o
	rm Tegami/*.hi
	rm Tegami/*.o

