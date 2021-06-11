# camera-boom
3D printable crossblocks and related items used to build a boom using 3/4" conduit 
with mounting blocks for a Raspberry PI and cameras.

## Files:
* [lib](lib) Library of reused modules
* [collet.scad](collet.scad) - Collet For Holding A Counterweight
* [crossblock.scad](crossblock.scad) crossblock.scad - Crossblock
* [piblock.scad](piblock.scad) - PI B Mounting Block
* [v1block.scad](v1block.scad) - PI Camera V1 Mounting Block
* [hqblock.scad](hqblock.scad) - PI HQ Camera Mounting Block

## How To Build STL Files 

On a Linux/Unix system with Make and OpenSCAD installed, download this repo and type `make`
in the top-level directory.

If this is not viable for some reason and you don't have any reason to change the design,
then you can use the .stl files I placed in the [stl](stl) directory.

## Printing Notes

I used slic3r to render the gcode files with these parameters:

* Nozzle = .5mm
* Layer Height = .4mm
* Infill = 30% Honeycomb
* Overhang threshold = 10% 
* Contact Z-distance = .2mm (easily detached)
* Bed Temperature = 80C
* Nozzle Temperature = 235C

I printed using a TAZ5 with 3mm Black ESUN (cheap) filament and pried the parts
off the bed using a razor blade.


## Collet
![collet.scad](img/collet.png)

## Crossblock
![crossblock.scad](img/crossblock.png)

## HQ Camera Block
![hqblock.scad](img/hqblock.png)

## V1 Camera Block
![v1block.scad](img/v1block.png)

## PI Mounting Block
![piblock.scad](img/piblock.png)
