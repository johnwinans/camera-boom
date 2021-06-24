
SRC=\
	collet.scad \
	crossblock.scad \
	piblock.scad \
	hqblock.scad \
	v1block.scad \
	mountblock.scad


STL=$(SRC:.scad=.stl)

.SUFFIX: .scad .stl

%.stl : %.scad
	openscad -o $@ $<


all:: $(STL)

clean::
	rm -f *.stl

world:: clean all
