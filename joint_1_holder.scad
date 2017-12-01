use <MCAD/involute_gears.scad>

use <pulley.scad>

pi=3.1415926535897932384626433832795;
$fn = 160;

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



//	********************************
//	** Scaling tooth for good fit **
//	********************************
/*	To improve fit of belt to pulley, set the following constant. Decrease or increase by 0.1mm at a time. We are modelling the *BELT* tooth here, not the tooth on the pulley. Increasing the number will *decrease* the pulley tooth size. Increasing the tooth width will also scale proportionately the tooth depth, to maintain the shape of the tooth, and increase how far into the pulley the tooth is indented. Can be negative */

additional_tooth_width = 0.2; //mm

//	If you need more tooth depth than this provides, adjust the following constant. However, this will cause the shape of the tooth to change.

additional_tooth_depth = 0; //mm

// calculated constants

nut_elevation = pulley_b_ht/2;
m3_nut_points = 2*((m3_nut_flats/2)/cos(30)); // This is needed for the nut trap

// The following set the pulley diameter for a given number of teeth

MXL_pulley_dia = tooth_spacing (2.032,0.254);
40DP_pulley_dia = tooth_spacing (2.07264,0.1778);
XL_pulley_dia = tooth_spacing (5.08,0.254);
H_pulley_dia = tooth_spacing (9.525,0.381);
T2_5_pulley_dia = tooth_spaceing_curvefit (0.7467,0.796,1.026);
T5_pulley_dia = tooth_spaceing_curvefit (0.6523,1.591,1.064);
T10_pulley_dia = tooth_spacing (10,0.93);
AT5_pulley_dia = tooth_spaceing_curvefit (0.6523,1.591,1.064);
HTD_3mm_pulley_dia = tooth_spacing (3,0.381);
HTD_5mm_pulley_dia = tooth_spacing (5,0.5715);
HTD_8mm_pulley_dia = tooth_spacing (8,0.6858);
GT2_2mm_pulley_dia = tooth_spacing (2,0.254);
GT2_3mm_pulley_dia = tooth_spacing (3,0.381);
GT2_5mm_pulley_dia = tooth_spacing (5,0.5715);

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

module servo() {
    color("Cyan", 0.5) {
        cube2(servo_width, [-servo_length_rot_center, servo_length], 
            [-servo_total_height, servo_lower_height]);
        cube2(
            servo_width, 
            [-servo_length_rot_center-servo_screw_plate_length, servo_total_length], 
            [-servo_top_height, 2]);
        cylinder2(d = 8, h = -servo_top_height);
    }
}

module servo2() {
    *color("Cyan", 0.5) {
        cube2(servo_width2, [-servo_length_rot_center2, servo_length2], 
            [-servo_total_height2, servo_big_height2]);
        cube2(
            servo_width2, 
            [-servo_length_rot_center2-servo_screw_plate_length2, servo_total_length2], 
            [-servo_top_height2, servo_mount_thick2]);
        cylinder2(d = 8, h = -servo_top_height2);
    }
}

module four_holes(diam = 1, dist=1, h=1) {
    translate([dist, 0, 0])
        cylinder2(d=diam, h=h);
    translate([-dist, 0, 0])
        cylinder2(d=diam, h=h);
    translate([0, dist, 0])
        cylinder2(d=diam, h=h);
    translate([0, -dist, 0])
        cylinder2(d=diam, h=h);
}

module link_1_bearing_holder(xOffSize, side_holder_thickness, side_holder_width) {
    difference() {
        cube2(xOffSize, side_holder_width, [-servo_width/2-2, gear_1_axis_distance + servo_width+2]);
        translate([xOffSize[0], 0, gear_1_axis_distance]) rotate([0,90,0]) cylinder2(d = joint_1_axis_d+0.2, h = xOffSize[1]);
    }
}

function compute_pitch(distance, teeth1, teeth2) = distance*360/(teeth1 + teeth2);

module joint_1_holder(base_plate_thickness = 5, 
        servo_mounting_thickness = 12, 
        side_holder_thickness = 5, 
        side_holder_width = 36) {            
    rotate([0, 90,0]) translate([0,0, servo_total_height/2 - link_0_servo_center_offset]) servo();
    
    difference() {
        union() {
            cube2(link_1_outer_width + link_1_outer_axis_distance*2 + side_holder_thickness*2, [-servo_length_rot_center-servo_screw_plate_length, servo_total_length], [-servo_width/2-2, -base_plate_thickness]);
            
            translate([-link_0_servo_center_offset, 0, 0])
            cube2([-servo_total_height/2, servo_total_height - 10], [-servo_length_rot_center-servo_screw_plate_length, servo_total_length], [-servo_width/2, -2]);
            
            cube2([-link_0_servo_center_offset+servo_lower_height_to_mid, -servo_mounting_thickness], [-servo_length_rot_center, -servo_screw_plate_length], [-servo_width/2-2, servo_width+2]);
            cube2([-link_0_servo_center_offset+servo_lower_height_to_mid, -servo_mounting_thickness], [servo_length_center_short, servo_screw_plate_length], [-servo_width/2-2, servo_width+2]);
         }
         
         rotate(45)
         translate([0,0,-servo_width/2])
            four_holes(holding_hole_d, link_0_holding_hole_dist, -servo_mounting_thickness);
         
         // make servo screw holes
         translate([servo_lower_height_to_mid, 
            -servo_length_rot_center - servo_screw_side_dist,
            0]) rotate([0, 90, 0]) {
            // bottom hole
            translate([servo_screw_dist_between/2,0,0]) cylinder2(d = server_screw_hole_d, h = -servo_mounting_thickness-10);
            // top hole
            translate([-servo_screw_dist_between/2,0,0]) cylinder2(d = server_screw_hole_d, h = -servo_mounting_thickness);
         }
         
         translate([servo_lower_height_to_mid, 
            servo_length_center_short + servo_screw_side_dist,
            0]) rotate([0, 90, 0]) {
            // bottom hole
            translate([servo_screw_dist_between/2,0,0]) cylinder2(d = server_screw_hole_d, h = -servo_mounting_thickness-10);
            // top hole
            translate([-servo_screw_dist_between/2,0,0]) cylinder2(d = server_screw_hole_d, h = -servo_mounting_thickness);
         }
    }
    
    // link 1 holders
    link_1_bearing_holder([link_1_outer_width/2 + link_1_outer_axis_distance, side_holder_thickness], 
            side_holder_thickness, side_holder_width);
    link_1_bearing_holder([-link_1_outer_width/2 - link_1_outer_axis_distance, -side_holder_thickness], 
            side_holder_thickness, side_holder_width);
    
    rotate([0, 90,0]) translate([0,0, servo_total_height/2 - link_0_servo_center_offset]) 
    gear(number_of_teeth=joint_1_gear_teeth_1, 
        circular_pitch = compute_pitch(gear_1_axis_distance, joint_1_gear_teeth_1, joint_1_gear_teeth_2), 
        flat=true);
}

module link_1_half_1(thickness = 5) {
    
    difference() {
        union() {
            cube2([link_1_outer_width/2-1,-thickness], [0, -50], servo_width);
            cube2([link_1_outer_width/2,-thickness], [-10, -link_1_length+10], servo_width);
            translate([link_1_outer_width/2,0,0]) rotate([0, 90, 0]) {
                translate([0,0,-1])
                    cylinder2(d=servo_width, h = -thickness);
                translate([-servo_width/2, -link_1_length,0])
                    cylinder2(d=servo_width*2, h = -thickness);
            }
            
        rotate([0, 90,0]) translate([0,0, servo_total_height/2-1]) 
        gear(number_of_teeth=joint_1_gear_teeth_2, 
            circular_pitch = compute_pitch(gear_1_axis_distance, joint_1_gear_teeth_1, joint_1_gear_teeth_2), 
            flat=false, rim_thickness= 5, hub_thickness = 5);
            
            cube2([link_1_outer_width/2, -thickness-1], 
            [-8, -39], 
            [-15, 11]);
        }
        
        translate([link_1_outer_width/2,0,0]) rotate([0, 90, 0])
            cylinder2(d=6.6, h = -thickness*2);
        
        translate([link_1_outer_width/2, -20, -servo_width/2]) rotate([0, 90, 0])
                cylinder2(d = 3, h = -thickness-1-20);
        
                translate([link_1_outer_width/2, -40, -servo_width/2]) rotate([0, 90, 0])
                    cylinder2(d = 3, h = -thickness-1-20);
        
        translate([link_1_outer_width/2, -110, -5]) rotate([0, 90, 0])
                cylinder2(d = 3, h = -thickness-1-20);
        
                translate([link_1_outer_width/2, -110, +5]) rotate([0, 90, 0])
                cylinder2(d = 3, h = -thickness-1-20);
        
        translate([link_1_outer_width/2,0,0]) rotate([0, 90, 0])
                        translate([-servo_width/2, -link_1_length,0])
                            cylinder2(d=joint_2_axis_d+0.2, h = -thickness);        
        
    }
    
    
}

module link_1_half_2(thickness = 5) {
    rotate([180, 90,180]) translate([0,-link_1_servo_offset, servo_total_height/2+-thickness]) servo();
    
            difference() {
                union() {
                    
                    cube2([-link_1_outer_width/2,thickness], [0, -link_1_length], servo_width);
                    translate([-link_1_outer_width/2,0,0]) rotate([0, 90, 0]) {
                        cylinder2(d=servo_width, h = thickness);
                        translate([-servo_width/2, -link_1_length,0])
                            cylinder2(d=servo_width*2, h = thickness);
                    }
                    
                    cube2([-link_1_outer_width/2,-thickness], [-40, -70], servo_width);
                    
                    translate([-link_1_outer_width/2,0,0]) rotate([0, 90, 0]) 
                        cylinder2(d=joint_1_axis_d+3, h = -link_1_outer_axis_distance);
                    
                    translate([-link_1_outer_width/2-link_1_outer_axis_distance,0,0]) rotate([0, 90, 0]) 
                        cylinder2(d=joint_1_axis_d+0.3, h = -thickness);
                }
                
                translate([link_1_outer_width/2,0,0]) rotate([0, 90, 0]) {
                    translate([-servo_width/2, -link_1_length,0])
                        cylinder2(d=joint_2_axis_d+0.2, h = -thickness);
                }
                
                translate([-link_1_outer_width/2,0,0]) rotate([0, 90, 0])
                        translate([-servo_width/2, -link_1_length,0])
                            cylinder2(d=joint_2_axis_d+0.2, h = thickness);
                
                cube2([-link_1_outer_width/2,thickness], [-55, -41], servo_width);
            }
            
            difference() {
                cube2([-link_1_outer_width/2+thickness, servo_lower_height-thickness], 
                        [-link_1_servo_offset + servo_rot_center_offet, servo_screw_plate_length], 
                        servo_width);
                translate([0,0,1])
                cube2([-link_1_outer_width/2+thickness, 4], 
                        [-link_1_servo_offset + servo_rot_center_offet, servo_screw_plate_length], 
                        9);
                cube2([-link_1_outer_width/2+thickness, servo_lower_height-thickness], 
                        [-link_1_servo_offset + servo_rot_center_offet, 2], 
                        5);
            }
            
            cube2([-link_1_outer_width/2+thickness, servo_lower_height-thickness], 
                    [-link_1_servo_offset - servo_length_rot_center, -servo_screw_plate_length], 
                    servo_width);
            
            difference() {
                cube2(link_1_outer_width -thickness*2, 
                        [-link_1_servo_offset - servo_length_rot_center-servo_screw_plate_length, -link_1_connector_thickness], 
                        servo_width);
                
                translate([link_1_outer_width/2, -110, -5]) rotate([0, 90, 0])
                cylinder2(d = 3, h = -thickness-1-20);
        
                translate([link_1_outer_width/2, -110, +5]) rotate([0, 90, 0])
                cylinder2(d = 3, h = -thickness-1-20);
            }
            
            difference() {
                cube2([-link_1_outer_width/2, link_1_outer_width-thickness-1], 
                        [-8, -39], 
                        [-15, 11]);
                
                translate([link_1_outer_width/2, -20, -servo_width/2]) rotate([0, 90, 0])
                cylinder2(d = 3, h = -thickness-1-20);
        
                translate([link_1_outer_width/2, -40, -servo_width/2]) rotate([0, 90, 0])
                    cylinder2(d = 3, h = -thickness-1-20);
            }
                
            
}

module link_1(thickness = 5) 
{
    union() {
        
        link_1_half_1(thickness);
        link_1_half_2(thickness);
    }
}

module link_2(thickness1 = 5, thickness2 = 2.5) 
{  
    
     difference() {
         union() {
             cube2([link_2_outer_width/2-link_2_outer_axis_distance,-thickness2], [0, servo_width*3], [0, servo_width]);
             cube2([link_2_outer_width/2-link_2_outer_axis_distance,-thickness1], [servo_width*3, link_2_length-servo_width*3], [0, servo_width]);
            translate([link_2_outer_width/2-link_2_outer_axis_distance,0,0]) rotate([0, 90, 0]) {
            cylinder2(d=servo_width*2, h = -thickness2);
            }
						
						translate([link_2_outer_width/2-link_2_outer_axis_distance,0,0]) rotate([0, 90, 0])
						translate([-servo_width/2, link_2_length,0])
							cylinder2(d=servo_width, h = -thickness1);
        }
        translate([link_2_outer_width/2-link_2_outer_axis_distance,0,0]) rotate([0, 90, 0])
        translate([-servo_width/2, link_2_length,0])
            cylinder2(d=joint_3_outer_axis_d+0.3, h = -thickness1);
				
        
       rotate([0,180,0])
       translate([link_2_outer_width/2-link_2_outer_axis_distance, link_2_servo_2_offset, 
        -servo_width/2])rotate([0,90,0])
        cylinder2(d=servo_width2, h=-thickness1);
        
       translate([link_2_outer_width/2-link_2_outer_axis_distance, link_2_servo_1_offset-1, servo_width/2])rotate([0,90,0])
					cylinder2(d=servo_width2, h=-thickness1);
				
				translate([link_2_outer_width/2-link_2_outer_axis_distance, link_2_servo_1_offset-7, servo_width/2])rotate([0,90,0])
					cylinder2(d=servo_width2/2, h=-thickness1);
    }
    
    // servo 1
    translate([link_2_outer_width/2-link_2_outer_axis_distance + (servo_top_height2-servo_top_base_height2), link_2_servo_1_offset, servo_width/2])rotate([0,90,0])
            servo2();
		
		
    translate([0,0, servo_width/2])
    difference() {
        union() {
                cube2([link_2_outer_width/2-link_2_outer_axis_distance, -servo_top_base_height2+servo_mount_thick2], 
                [link_2_servo_1_offset-servo_length_rot_center2-servo_screw_plate_length2, servo_total_length2], 
              servo_width2);
        }
        
        cube2([link_2_outer_width/2-link_2_outer_axis_distance, -servo_top_base_height2+servo_mount_thick2], 
                [link_2_servo_1_offset-servo_length_rot_center2, servo_length2], 
              servo_width2);
        
        translate([link_2_outer_width/2-link_2_outer_axis_distance, link_2_servo_1_offset-servo_length_rot_center2 - servo_screw_side_dist2, 0])
        rotate([0, 90, 0])
        cylinder2(d=server_screw_hole_d2, h = -servo_top_base_height2);
        
        translate([link_2_outer_width/2-link_2_outer_axis_distance, link_2_servo_1_offset+servo_length_center_short2 + servo_screw_side_dist2, 0])
        rotate([0, 90, 0])
        cylinder2(d=server_screw_hole_d2, h = -servo_top_base_height2);
    }
    
    // servo 2
    rotate([0,180,0])
    translate([link_2_outer_width/2-link_2_outer_axis_distance + (servo_top_height2-servo_top_base_height2), 
            link_2_servo_2_offset, 
            -servo_width/2])rotate([0,90,0])
            servo2();
    translate([0,0, servo_width/2]) rotate([0,180,0])
    difference() {
        union() {
                cube2([link_2_outer_width/2-link_2_outer_axis_distance, -servo_top_base_height2+servo_mount_thick2], 
                [link_2_servo_2_offset-servo_length_rot_center2-servo_screw_plate_length2, servo_total_length2], 
              servo_width2);
        }
        
        cube2([link_2_outer_width/2-link_2_outer_axis_distance, -servo_top_base_height2+servo_mount_thick2], 
                [link_2_servo_2_offset-servo_length_rot_center2, servo_length2], 
              servo_width2);
        
        translate([link_2_outer_width/2-link_2_outer_axis_distance, link_2_servo_1_offset-servo_length_rot_center2 - servo_screw_side_dist2, 0])
        rotate([0, 90, 0])
        cylinder2(d=server_screw_hole_d2, h = -servo_top_base_height2);
        
        translate([link_2_outer_width/2-link_2_outer_axis_distance, link_2_servo_1_offset+servo_length_center_short2 + servo_screw_side_dist2, 0])
        rotate([0, 90, 0])
        cylinder2(d=server_screw_hole_d2, h = -servo_top_base_height2);
    }
    
    difference() {
				union() {
        cube2([-link_2_outer_width/2+link_2_outer_axis_distance,thickness1], [0, link_2_length], [0, servo_width]);
					
					translate([-link_2_outer_width/2+link_2_outer_axis_distance,0,0]) rotate([0, 90, 0])
            translate([-servo_width/2, link_2_length,0])
            cylinder2(d=servo_width, h = thickness1);
				}
        translate([-link_2_outer_width/2+link_2_outer_axis_distance,0,0]) rotate([0, 90, 0])
            translate([-servo_width/2, link_2_length,0])
            cylinder2(d=joint_3_outer_axis_d+0.3, h = thickness1);
			
			 translate([-link_2_outer_width/2+link_2_outer_axis_distance, link_2_servo_2_offset-1, servo_width/2])rotate([0,90,0])
					cylinder2(d=servo_width2, h=thickness1);
				
				translate([-link_2_outer_width/2+link_2_outer_axis_distance, link_2_servo_2_offset-7, servo_width/2])rotate([0,90,0])
					cylinder2(d=servo_width2/2, h=thickness1);
    }
    translate([-link_2_outer_width/2+link_2_outer_axis_distance,0,0]) rotate([0, 90, 0]) {
        cylinder2(d=servo_width*2, h = thickness1);
    }
    
    cube2(link_2_outer_width-2*link_2_outer_axis_distance, [link_1_connector_1_offset, link_1_connector_1_len], [servo_width, -link_1_connector_1_thick]);
    
    cube2(link_2_outer_width-2*link_2_outer_axis_distance, [link_1_connector_2_offset, link_1_connector_2_len], [0, servo_width]);
    
    rotate([0, 90,0]) translate([0,0, servo_total_height/2-10]) 
    pulley ( "GT2 2mm" , GT2_2mm_pulley_dia , 0.764 , 1.494);
    
    rotate([0, 90,0])
        cylinder(h=link_2_outer_width-2*link_2_outer_axis_distance, d = axis_2_block_d, center=true);
    
    rotate([0, 90,0])
        cylinder(h=link_2_outer_width, d = joint_2_axis_d+2, center=true);
    
    rotate([0, 90,0])
        cylinder(h=link_2_outer_width+10, d = joint_2_axis_d, center=true);
}


joint_1_holder();
translate([0,0, gear_1_axis_distance]) rotate([0,0,0])
    link_1();

translate([0,-link_1_length, gear_1_axis_distance + servo_width/2]) rotate([0,0,0])
    !link_2(); 
