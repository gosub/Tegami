SRCS=$(wildcard images/image_*.hs)

PNGS=$(subst images,pngs,$(SRCS:.hs=.png))

all: $(PNGS)

FULLRESO?=1600
RESO?=800


pngs/%.png: %.ppm
	convert $< -resize $(RESO)x$(RESO) $@

%.ppm: images/%.hs
	ghc -O3 -o bins/$(notdir $(basename $@)) $<
	./bins/$(notdir $(basename $<)) $(FULLRESO) $(FULLRESO)

clean: clean_artifacts
	rm bins/*
	rm pngs/*

clean_artifacts:
	rm images/*.hi
	rm images/*.o
	rm Tegami/*.hi
	rm Tegami/*.o

