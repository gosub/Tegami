SRCS=$(wildcard images/image_*.hs)

PNGS=$(subst images,pngs,$(SRCS:.hs=.png))

all: $(PNGS)

RESO?=800
AA?=1


pngs/%.png: images/%.hs
	ghc -O3 -threaded -o bins/$(notdir $(basename $<)) $<
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

