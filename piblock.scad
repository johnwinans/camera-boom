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
include <lib/pimount.scad>


//********************************************************
// The size of the hole for the pipe(s)
pipe_diameter=24;       // 3/4" conduit


block_c_bolt_pipe_clearance=1;
block_c_bolt_inset=5;       // from clamp-bolt to the end of the block

block_inset=17;





// calculate the dimensions of the block using the above config variables

cx = pipe_diameter+block_inset;   

cbd=bolt_dim_quarter_dia;       // clamp bolt diameter
//cz=cx;                        // this is prety thick
//cz=cbd+block_c_bolt_inset*2;    // this is as thin as I'd want to go
cz=1.5*(cbd+block_c_bolt_inset*2);

cbl=cx;                         // length of the clamp bolt bore
cbnd=bolt_dim_quarter_carriage_neck_depth;

cbc=1;
rs=cbd+block_c_bolt_inset+cbc;       // relief slot width

cam_offset=5;  // how far to stick out the 'back'

cy = pipe_diameter+rs*2+cam_offset;



pi_block();


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
* A mounting bracket for a RPI 
**********************************************************************************/
module pibasePos(thick, standoff=2)
{
    rotate([90,90,0])
    translate([-piDimX/2,-piDimY/2,standoff])
    pi3_pos(standoff);
}


module pibaseNeg(thick, standoff=2)
{
    rotate([90,90,0])
    translate([-piDimX/2,-piDimY/2,standoff])
    pi3_neg(mountHoleDepth=6);
}


/**
* A mounting bracket for a RPI 
**********************************************************************************/
module pi_block()
{
    piPlateX=piDimY+2;
    piPlateY=cam_offset;
    piPlateZ=piDimX;           // do NOT expand (for clean printer bed)
    
    difference()
    {
        union()
        {
            translate([0,-cam_offset/2,0]) cube([cx,cy,cz], center=true);
            translate([0,-cy/2-cam_offset/2,piDimX/2-cz/2]) pibasePos(11);
            translate([0,-cy/2-cam_offset/2+cam_offset/2,piDimX/2-cz/2]) cube([piPlateX,piPlateY,piPlateZ], center=true);
        }
        cn();
        translate([0,-cy/2-cam_offset/2,piDimX/2-cz/2]) pibaseNeg(11);

        strain_offset=block_inset/2;
        strain_thickness=3;
        // strain relief
        translate([strain_offset,-cy/2+cam_offset/2+strain_thickness/2,0]) cube([cx+1,3, cz+1], center=true);
        
        // side bolt-holes for mounting a cover
        for (x = [ piPlateX/2, -piPlateX/2 ] )
            for (z = [ 10, piPlateZ-10 ] )
                translate([x,-cy/2, -cz/2+z]) rotate([0,90,0]) cylinder(d=bolt_dim_M25_tap, h=6*2, $fn=20, center=true);
    }

}

