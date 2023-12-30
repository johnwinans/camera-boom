/*
    Mounting Blocks to build a camera boom.

    Copyright (C) 2021 John Winans

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

include <lib/clamp.scad>


//********************************************************
// The size of the hole for the pipe(s)
pipe_diameter=24;       // 3/4" conduit

block_c_bolt_pipe_clearance=1;
block_c_bolt_inset=6;	// from clamp-bolt to the end of the block

block_inset=18;			// space from pipe-edge to the block-edge 

pipe_gap=9;				// distance between pipes




// calculate the dimensions of the block using the above config variables

cx = pipe_diameter+block_inset;   

cbd=bolt_dim_quarter_dia;       // clamp bolt diameter
//cz=cbd+block_c_bolt_inset*2;    // this is as thin as I'd want to go
cz=cx;

cbl=cx;                         // length of the clamp bolt bore
cbnd=bolt_dim_quarter_carriage_neck_depth;

cbc=1;
rs=cbd+block_c_bolt_inset+cbc;       // relief slot width

pipe_y = pipe_diameter*2+pipe_gap+rs*2; // mimimum desirable dimension
cy = cx*2 > pipe_y ? cx*2 : pipe_y;



crossblock();


/**
* A helper for creating the negative space for the pipe clamp.
**********************************************************************************/
module cn()
{
    clamp_neg(
        clamp_bolt_length=cbl,
        clamp_bolt_dia=cbd,
        clamp_bolt_neck_depth=cbnd,
        relief_slot=rs,
        pipe_length=cz,
        pipe_diameter=pipe_diameter,
        clamp_bolt_clearance=cbc);
}


/**
* 1/2 bolt Unistrut mount for 3/4 EMT
**********************************************************************************/
module crossblock()
{
	pipe_offset=pipe_diameter/2+pipe_gap/2;

echo(cx);
echo(cy);

    difference()
    {
		cube([cx,cy,cz], center=true);
        translate([0,pipe_offset,0]) cn();
		translate([0,-cx/2,0]) cylinder(d=14, h=cz+1, center=true);
    }
}
