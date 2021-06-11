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


//pi3_example();

piX=85;
piY=56;

piDefaultStandoffHeight=5;

piDimX=85;
piDimY=56;
piDimCornerRad=3;


// 49x58 square on center
piHoleCenters=[
	[ 3.5, 3.5, 0 ],
	[ 3.5, 3.5+49, 0 ],
	[ 3.5+58, 3.5, 0 ],
	[ 3.5+58, 3.5+49, 0 ]
];


v1_hole_centers=[
	[ -24/2+2, 25/2-2, 0 ],
	[ -24/2+2, -25/2+2, 0 ],
	[ -24/2+2+12.5, 25/2-2, 0 ],
	[ -24/2+2+12.5, -25/2+2, 0 ],
];


hq_hole_centers=[
	[ -38/2+4, 38/2-4, 0 ],
	[ -38/2+4, -38/2+4, 0 ],
	[ 38/2-4, 38/2-4, 0 ],
	[ 38/2-4, -38/2+4, 0 ],
];


/**
* The material to add in order to mount a Raspberry PI3. 
* For example, things like standoffs.
******************************************************************/
module pi3_pos(standoffHeight=piDefaultStandoffHeight, reference=true)
{
    translate([0, 0, -(standoffHeight+.01)])
        for ( pos = piHoleCenters )
            translate(pos) cylinder(d=6, h=standoffHeight, $fn=20);
  
    if(reference)  
    {
        // reference PCB shape (shown but not part of the object)
        %translate([piDimCornerRad, piDimCornerRad, 0]) minkowski()
        {
            cube([piDimX-2*piDimCornerRad, piDimY-2*piDimCornerRad, 1.4-.02]);
            cylinder(r=piDimCornerRad, h=.01);
        }
    }
}


/**
******************************************************************/
module pi_camera_v1_neg(
	standoffHeight=piDefaultStandoffHeight, 
	mountHoleDepth=9, 
	threadin=true)
{
	boltd=threadin ? bolt_dim_M2_tap : bolt_dim_M2_dia;
	for (pos = v1_hole_centers)
		translate(pos) translate([0,0,standoffHeight-mountHoleDepth]) cylinder(d=boltd, h=mountHoleDepth+.01, $fn=20);
}

/**
******************************************************************/
module pi_camera_v1_pos(
    standoffHeight=piDefaultStandoffHeight)
{
	for (pos = v1_hole_centers)
		translate(pos) 
			cylinder(d=3.5, h=standoffHeight, $fn=30);
}

/**
******************************************************************/
module pi_camera_hq_neg(
	standoffHeight=piDefaultStandoffHeight, 
	mountHoleDepth=9, 
	threadin=true)
{
	boltd=threadin ? bolt_dim_M25_tap : bolt_dim_M25_dia;
	for (pos = hq_hole_centers)
		translate(pos) translate([0,0,standoffHeight-mountHoleDepth]) cylinder(d=boltd, h=mountHoleDepth+.01, $fn=20);
}

/**
******************************************************************/
module pi_camera_hq_pos(
    standoffHeight=piDefaultStandoffHeight)
{
	for (pos = hq_hole_centers)
		translate(pos) 
			translate([0,0,standoffHeight/2]) cylinder(d=5.5, h=standoffHeight, center=true, $fn=30);
}


/**
* The material to subtract to mount a Raspberry PI3.
* For example, things like the bolt holes within standoffs,
* conectors,...
*
* @param threadin True=make standoff holes to thread 2.5mm 
*   into the material itself, False=proivide space for bolt & 
*   countersink the head
******************************************************************/
module pi3_neg(standoffHeight=piDefaultStandoffHeight, mountHoleDepth=4.5, threadin=true)
{
    boltd=threadin ? bolt_dim_M25_tap : bolt_dim_M25_dia;
    
    // hollow out the standoffs
    translate([0, 0, -mountHoleDepth-.01])
        for (pos = piHoleCenters)
        {
            translate(pos) cylinder(d=boltd, h=mountHoleDepth+.02, $fn=20); // bolt
            if (!threadin)
                translate(pos) cylinder(d=5, h=7, $fn=20); // countersink
        }
        
    // The Ethernet
    translate([85, 11, 1.4+14.5/2]) cube([20, 17, 14.5], center=true);

    // The USB ports
    translate([85, 29, 1.4+16.5/2]) cube([20, 16, 16.5], center=true);
    translate([85, 47, 1.4+16.5/2]) cube([20, 16, 16.5], center=true);

	//15x6 on center
    // an access slot for the SD card
    translate([0, 28,-1]) cube([30, 15, 6], center=true);
}






// a test module to demonstrate how to use this
module pi3_example()
{
    difference()
    {
        pi3_pos();		// the mounting material
        pi3_neg();		// ...less the holes for bolts, connectors etc
    }
}
