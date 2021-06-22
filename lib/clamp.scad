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

include <boltDim.scad>


//********************************************************
// A pipe & bolt holes for a pipe clamp.
//********************************************************
module clamp_neg(
    relief_slot,        // how far from the edge of the pipe should the relief slot go?
    pipe_length, 
    pipe_diameter,
    clamp_bolt_length,    // used to determine the length of the clamp bolt
    clamp_bolt_dia,
    clamp_bolt_neck_depth,
    clamp_bolt_clearance,
	clamp_bolt_countersink_depth=0,
	clamp_bolt_countersink_dia=0,
    rib=false, 
    stripe=true
    )
{
    clamp_bolt_offset = pipe_diameter/2+clamp_bolt_dia/2+clamp_bolt_clearance;

    cz = pipe_length+.01;
    
    // the pipe hole
    cylinder(d=pipe_diameter, h=cz+.01, center=true, $fn=60);
    
    if (rib)
    {
        // rib it
        rh=2;
        rs=4;
        for (z=[-cz/2+rh*.5+1 : rs : cz/2]) // XXX fudge start to center it
            translate([0,0,z])
                cylinder(d=pipe_diameter+1, h=rh, center=true, $fn=60);
    }
    
    if (stripe)
    {
        // stripe it
        //rh=1.5;
        rh=4;
        rt=360/10;
        for (theta=[90:rt:2690])
            rotate([0,0,theta]) cube([pipe_diameter+2, rh, cz+.01], center=true);
    }
    
    // releif notch
    translate([0,pipe_diameter/2+relief_slot/2,0]) cube([3, relief_slot+.01, cz+.01], center=true);
    
    // clamp bolt
    translate([0,clamp_bolt_offset,0])
    {
        rotate([0,90,0]) 
        cylinder(d=clamp_bolt_dia, h=clamp_bolt_length+.01, $fn=20, center=true);
    
        // square for carriage bolt head
        translate([clamp_bolt_length/2-clamp_bolt_neck_depth/2-clamp_bolt_countersink_depth,0,0])
            cube([clamp_bolt_neck_depth+.01, clamp_bolt_dia,clamp_bolt_dia], center=true);
		translate([clamp_bolt_length/2-clamp_bolt_countersink_depth+.001,0,0])
			rotate([0,90,0]) cylinder(d=clamp_bolt_countersink_dia, h=clamp_bolt_countersink_depth, $fn=30);
    }
}
