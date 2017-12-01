$fn = 160;

use <MCAD/involute_gears.scad>


function calcSizeOffset(a) = (len(a) == undef? [a, -a/2] : (a[1] > 0?[a[1], a[0]] : [-a[1], a[0] + a[1]]));


module cube2(x, y, z) {    
    sox = calcSizeOffset(x);
    soy = calcSizeOffset(y);
    soz = calcSizeOffset(z);
    
    size = [sox[0], soy[0], soz[0]];
    off = [sox[1], soy[1], soz[1]];
    
    //echo(size);
    //echo(off);
    
    translate(off) cube(size, center=false);
}


module cylinder2(d, h) {    
    if(h > 0)
        cylinder(d = d, h = h);
    else
        translate([0,0,h-0.0005]) cylinder(d=d, h = -h+0.001);
}

inner_link2_width = 35;
link2_thick = 5.1;

joint3_outer_bore_d = 10; // joint hole diameter in link2
joint3_axis_inner_length = 6;
joint3_poti_hight = 10;
joint3_poti_holder_width = 14;
joint3_outer_axis_length = 2;
joint3_outer_axis_hold_square_w = 6;

joint4_bore_d = 6;
joint4_inner_axis_d = 12;


belt_width = 6.5;
pulley_hat_thick = 2;

bore_slip = 0.1; // bore slip in one direction

link3_length = 12;
link3_axis_d = 10;
link3_axis_len = 6;
link3_axis_holder_cube_w = 4;
link3_axis_holder_cube_h = 2;
link3_axis_holder_bore_d = 1;
link3_axis_holder_bore_len = 8;
link3_axis_holder_outer_d = link3_axis_d+3;
link3_poti_axis_thick = 2;
link3_poti_axis_r = 1.85;
link3_poti_axis_len = 9;

link4_height = link3_axis_len;

//joint5_axis_d = 8;
//joint5_axis_length

module my_bevel_gear_pair (
	gear1_teeth = 41,
	gear2_teeth = 7,
	axis_angle = 90,
	outside_circular_pitch=1000,
	bore_diameter = 4,
	slip = 0,
	gear_thickness = 3,
	face_width = 3)
{
	outside_pitch_radius1 = gear1_teeth * outside_circular_pitch / 360;
	outside_pitch_radius2 = gear2_teeth * outside_circular_pitch / 360;
	pitch_apex1=outside_pitch_radius2 * sin (axis_angle) + 
		(outside_pitch_radius2 * cos (axis_angle) + outside_pitch_radius1) / tan (axis_angle);
	cone_distance = sqrt (pow (pitch_apex1, 2) + pow (outside_pitch_radius1, 2));
	pitch_apex2 = sqrt (pow (cone_distance, 2) - pow (outside_pitch_radius2, 2));
	echo ("cone_distance", cone_distance);
	pitch_angle1 = asin (outside_pitch_radius1 / cone_distance);
	pitch_angle2 = asin (outside_pitch_radius2 / cone_distance);
	echo ("pitch_angle1, pitch_angle2", pitch_angle1, pitch_angle2);
	echo ("pitch_angle1 + pitch_angle2", pitch_angle1 + pitch_angle2);

	rotate([-90,0,90])
	// translate ([0,0,pitch_apex1])
	{
		// rotate([-90,0,0])
		*translate([0,0,-pitch_apex1])
		bevel_gear (
			number_of_teeth=gear1_teeth,
			cone_distance=cone_distance-slip,
			pressure_angle=30,
		bore_diameter=link3_axis_d+bore_slip,
			outside_circular_pitch=outside_circular_pitch-slip,
		gear_thickness = gear_thickness,
		face_width = face_width);
	
		*rotate([0,-(pitch_angle1+pitch_angle2),0])
		translate([0,0,-pitch_apex2])
		bevel_gear (
			number_of_teeth=gear2_teeth,
			cone_distance=cone_distance-slip,
			pressure_angle=30,
			outside_circular_pitch=outside_circular_pitch-slip,
		  bore_diameter=bore_diameter,
		gear_thickness = gear_thickness,
		face_width = face_width);
		
		rotate([0,(pitch_angle1+pitch_angle2),0])
		translate([0,0,-pitch_apex2])
		bevel_gear (
			number_of_teeth=gear2_teeth,
			cone_distance=cone_distance-slip,
			pressure_angle=30,
			outside_circular_pitch=outside_circular_pitch-slip,
		  bore_diameter=bore_diameter,
		gear_thickness = gear_thickness,
		face_width = face_width);
	}
}




//#translate([-40, 0, 0])
//cube([50, inner_link2_width, 10], center = true);

module link3() {
	
	difference() {
		union() {
				rotate([90,0,0]) {
					cylinder(d=joint4_bore_d - bore_slip, h = inner_link2_width + (link2_thick)*2, center = true); 
				cylinder(d=joint4_inner_axis_d, h = inner_link2_width - joint3_axis_inner_length*2-bore_slip*2, center = true); 
			}
			rotate([0,90,0]) {
				translate([0,0,-3]) {
						cylinder(d=18,h = link3_length+3);
				}
				
				translate([0,0,link3_length]) {
						cylinder(d=link3_axis_d-bore_slip,h = link3_axis_len);
				} 
			}
			
			
		}
		
		rotate([0,90,0]) {
				translate([0,0,link3_length+link3_axis_len]) {
						cube2(link3_axis_holder_cube_w-bore_slip,link3_axis_holder_cube_w-bore_slip,[0,-link3_axis_holder_cube_h]);
				} 
				
				translate([0,0,link3_length+link3_axis_len-link3_axis_holder_cube_h]) {
						cylinder2(d = link3_axis_holder_bore_d, h = -link3_axis_holder_bore_len);
				}
			}
		
		rotate([0,100,0]) 
			cube([joint3_poti_holder_width*2, joint3_poti_hight, joint3_poti_holder_width],center=true);
			
		rotate([0,-100,0]) 
			cube([joint3_poti_holder_width*2, joint3_poti_hight, joint3_poti_holder_width],center=true);
			
			cube2([link3_poti_axis_r, -joint4_inner_axis_d], [joint3_poti_hight/2, link3_poti_axis_len], link3_poti_axis_thick);
	}
}

module joint_3_gear() {
	my_bevel_gear_pair(gear1_teeth = 23, gear2_teeth = 23, outside_circular_pitch=210, 
										gear_thickness = 3, bore_diameter  = joint4_bore_d+bore_slip, slip = 1);
	
	rotate([90,0,0]) {
		translate([0,0,inner_link2_width/2 - joint3_axis_inner_length + bore_slip])
	difference() {
			cylinder(d=joint3_outer_bore_d - bore_slip, 
				h = joint3_axis_inner_length + link2_thick + joint3_outer_axis_length);
			cylinder(d=joint3_axis_inner_length + bore_slip, 
				h = joint3_axis_inner_length + link2_thick+bore_slip);
		}
	}
	
	outer_axis_holder_offset = -inner_link2_width/2 - link2_thick - joint3_outer_axis_length;
	outer_axis_square_len = belt_width + pulley_hat_thick - joint3_outer_axis_length;
	
	translate([0, outer_axis_holder_offset -outer_axis_square_len/2,0])
		cube([joint3_outer_axis_hold_square_w, outer_axis_square_len, joint3_outer_axis_hold_square_w], center = true);
}

link3();

*my_bevel_gear_pair(gear1_teeth = 23, gear2_teeth = 23, outside_circular_pitch=210, 
										gear_thickness = 3, bore_diameter  = joint4_bore_d+bore_slip);

// joint_3_gear();
