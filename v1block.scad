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

block_inset=15;





// calculate the dimensions of the block using the above config variables

cx = pipe_diameter+block_inset;   

cbd=bolt_dim_quarter_dia;		// clamp bolt diameter
//cz=cx;							// make the block square 
cz=30;							// make the block just wider than the camera

cbl=cx;							// length of the clamp bolt bore
cbnd=bolt_dim_quarter_carriage_neck_depth;

cbc=1;							// gap between the clamp bolt & pipe
rs=cbd+block_c_bolt_inset+cbc;	// relief slot width

cam_offset=8;					// how far to stick out the 'back'

cy = pipe_diameter+rs*2+cam_offset;


v1block();


/**
* A helper module to create the clamp negative space using the above config values.
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
* A mounting bracket for a RPI V1.3 camera
**********************************************************************************/
module v1block()
{
	// dimensions of the camera-plate
	cpx=cx;
	cpy=cam_offset;
	cpz=cz;

	cam_depth=5;
	
    
    difference()
    {
		translate([0,-cam_offset/2,0]) cube([cx,cy,cz], center=true);
        cn();

        strain_offset=block_inset/2;
        strain_thickness=3;
        // strain relief
        translate([strain_offset,-cy/2+cam_offset/2+strain_thickness/2,0]) 
			cube([cx+1,3, cz+1], center=true);

		translate([0,-cy/2-cam_offset/2+cam_depth-.01,0]) 
		{
			rotate([90,0,0]) 
			{
				difference()
				{
					union()
					{
						translate([5,0,cam_depth/2]) cube([35,19,cam_depth], center=true);
						translate([24-5,0,cam_depth/2]) cube([24,cz+.01,cam_depth], center=true);
					}
					pi_camera_v1_pos();
				}
				pi_camera_v1_neg();
			}
		}
    }
}
