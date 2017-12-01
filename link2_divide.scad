$fn = 40;

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

//######### big servo
servo_lower_height = 28; // mounting plate to bottom
servo_top_height = 18; // mounting plate to top
servo_total_height = servo_lower_height + servo_top_height;
servo_lower_height_to_mid = servo_lower_height - servo_total_height/2;

servo_width = 20.4;
servo_length = 41.4;
servo_rot_center_offet = 10; // from center to rotation axis
servo_length_rot_center = servo_length/2 + servo_rot_center_offet; // from outer side to rot center
servo_length_center_short = servo_length - servo_length_rot_center;

servo_screw_side_dist = 4; // from servo wall to screw hole
servo_screw_dist_between = 10; // distance between two screw holes
servo_screw_plate_length = 2*servo_screw_side_dist;
servo_total_length = servo_screw_plate_length*2 + servo_length;
server_screw_hole_d = 2;

//######### small servo
servo_lower_height2 = 20; // mounting plate to bottom
servo_top_height2 = 14; // mounting plate to top
servo_total_height2 = servo_lower_height2 + servo_top_height2;
servo_big_height2 = 24;
servo_lower_height_to_mid2 = servo_lower_height2 - servo_total_height2/2;

servo_width2 = 12.6;
servo_length2 = 24;
servo_rot_center_offet2 = 6.2; // from center to rotation axis
servo_length_rot_center2 = servo_length2/2 + servo_rot_center_offet2; // from outer side to rot center
servo_length_center_short2 = servo_length2 - servo_length_rot_center2;

servo_screw_side_dist2 = 2.5; // from servo wall to screw hole
servo_screw_plate_length2 = 2*servo_screw_side_dist2;
servo_total_length2 = servo_screw_plate_length2*2 + servo_length2;
server_screw_hole_d2 = 1.5;
servo_mount_thick2 = 2; // mounting plate thickness
servo_top_base_height2 = 9;
// ###################


holding_hole_d = 3.1;

link_0_holding_hole_dist = 20;
link_0_servo_center_offset = 3;
joint_1_axis_d = 6;
link_1_outer_width = 56;
link_1_outer_axis_distance = 1;
gear_1_axis_distance = 30;
joint_1_gear_teeth_1 = 13;
joint_1_gear_teeth_2 = 29;
link_1_connector_thickness = 16;

link_2_outer_width = 46;
link_1_length = 140;
link_2_length = 180;
link_1_servo_offset = 65;
joint_2_axis_d = 6;
link_2_outer_axis_distance = 0.5;
axis_2_block_d = 15;

link_1_connector_1_len = 25;
link_1_connector_1_thick = 6;
link_1_connector_1_offset = 40; 

link_1_connector_2_offset = 140; 
link_1_connector_2_len = 8;

link_2_servo_1_offset = 90;
link_2_servo_2_offset = 120;
joint_3_outer_axis_d = 10;

m3_nut_flats = 5.7;	// normal M3 hex nut exact width = 5.5


thickness1 = 5;
thickness2 = 2.5;

module main_holes() {
	translate([link_2_outer_width/2,8,8])
rotate([0,-90,0])
cylinder2(d=2, h=15);
	
		translate([link_2_outer_width/2,-8,8])
rotate([0,-90,0])
cylinder2(d=2, h=15);
	
		translate([link_2_outer_width/2,8,-8])
rotate([0,-90,0])
cylinder2(d=2, h=15);
	
		translate([link_2_outer_width/2,-8,-8])
rotate([0,-90,0])
cylinder2(d=2, h=15);
}

module holes_1() {
	translate([link_2_outer_width/2,link_1_connector_1_offset+link_1_connector_1_len*1/3,servo_width-link_1_connector_1_thick/2])
rotate([0,-90,0])
cylinder2(d=2, h=15);
	translate([link_2_outer_width/2,link_1_connector_1_offset+link_1_connector_1_len*2/3,servo_width-link_1_connector_1_thick/2])
rotate([0,-90,0])
cylinder2(d=2, h=15);
}

module holes_2() {
	
	translate([link_2_outer_width/2,link_1_connector_2_offset+link_1_connector_2_len/2, servo_width*1/4])
rotate([0,-90,0])
cylinder2(d=2, h=15);
	
translate([link_2_outer_width/2,link_1_connector_2_offset+link_1_connector_2_len/2, servo_width*3/4])
rotate([0,-90,0])
cylinder2(d=2, h=15);
}

difference() {
	import("link_2_whole.stl", convexity=3);
	
	main_holes();
	holes_1();
	holes_2();
	
	// for small
*	difference() {
cube2([-link_2_outer_width/2, link_2_outer_width-link_2_outer_axis_distance - thickness1], [-50, 300], 100);
		
		cube2([link_2_outer_width/2-link_2_outer_axis_distance - thickness2-10, 100], [66, 40], 100);
	}
*#cube2([-link_2_outer_width/2-20, link_2_outer_width-link_2_outer_axis_distance - thickness2+20], [-30, 60], 100);
	
	// for big
	cube2([link_2_outer_width/2-link_2_outer_axis_distance - thickness2-0.01, 100], [-50, 300], 100);
	#cube2([link_2_outer_width/2-link_2_outer_axis_distance - thickness1-0.01, 100], [35, 300], 100);
	cube2([link_2_outer_width/2-link_2_outer_axis_distance - thickness2-10, 100], [66, 60], 100);
}
