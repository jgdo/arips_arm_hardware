$fs = 0.3;

module arm_base(servo_length = 40.4, 
                servo_width = 20.4, 
                length_to_rot_center = 30.2,
                hole_lengh = 48,
                hole_width = 10,
                hole_d = 2,
                hole_h = 15,
                screw_holder_size_width = 8,
                side_thickness = 3,
                servo_lower_height = 28,
                bottom_thickness = 0,
                cable_hole_w = 6,
                cable_hole_h = 10,
                cable_hole_z_offset = 0,
                cable_shaft_depth=2,
                base_width = 50,
                base_length = 54,
                base_thick = 5,
                ower_axis_d = 5,
                roational_inner_r = 18,
                base_holder_width = 15,
                space_hight = 56,
                servo_mount_top_height = 18,
                base_hole_d = 3.1,
                base_hole_center_dist = 20
                ) {
    rot_c_offeset_x = screw_holder_size_width + length_to_rot_center;
    rot_c_offeset_y = side_thickness + servo_width / 2;
    base_offset_neg = -space_hight + servo_mount_top_height + servo_lower_height + bottom_thickness;
    echo("base_offset_neg ", base_offset_neg);       
    intersection() {
        union() {
            cylinder(h = servo_lower_height + bottom_thickness, r =             roational_inner_r); 
            translate([-servo_length, -side_thickness-servo_width/2], 0)
                cube([servo_length, servo_width + 2*side_thickness, servo_lower_height + bottom_thickness]);
            translate([0, 0, base_offset_neg-base_thick/2]) {
                difference() {
                    cube([base_length, base_width, base_thick], center = true);
                    cylinder(h = base_thick, d = ower_axis_d+0.2, center = true); // TODO bearing
                    
                    translate([base_hole_center_dist, base_hole_center_dist, 0])
                        cylinder(h = base_thick, d = base_hole_d, center = true);
                    translate([-base_hole_center_dist, base_hole_center_dist, 0])
                        cylinder(h = base_thick, d = base_hole_d, center = true);
                    translate([base_hole_center_dist, -base_hole_center_dist, 0])
                        cylinder(h = base_thick, d = base_hole_d, center = true);
                    translate([-base_hole_center_dist, -base_hole_center_dist, 0])
                        cylinder(h = base_thick, d = base_hole_d, center = true);
                }
                translate([-length_to_rot_center-screw_holder_size_width, -base_width/2, -base_thick/2])
                    cube([base_holder_width, base_width, base_thick - base_offset_neg + servo_lower_height], center = false);
            }
        }
        
        translate([-rot_c_offeset_x, -rot_c_offeset_y, 0]) {
            // servo holder box
            difference() {
                union() {
                    // outer box
                    cube([servo_length + 2*screw_holder_size_width, servo_width + 2*side_thickness, servo_lower_height + bottom_thickness]);
                    translate([rot_c_offeset_x, rot_c_offeset_y, 0])
                        translate([0, 0, base_offset_neg-base_thick/2]) {
                            difference() {
                                cube([base_length, base_width, base_thick], center = true);
                                cylinder(h = base_thick, d = ower_axis_d+0.2, center = true); // TODO bearing
                            }
                            translate([-length_to_rot_center-screw_holder_size_width, -base_width/2, -base_thick/2]) {
                                cube([base_holder_width, base_width, base_thick - base_offset_neg + servo_lower_height], center = false);
                            }
                        }
                }
                // inner servo space
                translate([screw_holder_size_width, side_thickness, bottom_thickness])
                    cube([servo_length, servo_width, servo_lower_height]);
                
                hole_x_offset = screw_holder_size_width - (hole_lengh-servo_length)/2;
                hole_y_offset = side_thickness + (servo_width - hole_width)/2;
                hole_z_offset = bottom_thickness + servo_lower_height - hole_h;
                
                // 4 holes
                translate([hole_x_offset, hole_y_offset, hole_z_offset])
                    cylinder(d = hole_d, h = hole_h);
                
                translate([hole_x_offset + hole_lengh, hole_y_offset, hole_z_offset])
                    cylinder(d = hole_d, h = hole_h);
                
                translate([hole_x_offset, hole_y_offset + hole_width, hole_z_offset])
                    cylinder(d = hole_d, h = hole_h);
                
                translate([hole_x_offset + hole_lengh, hole_y_offset + hole_width, hole_z_offset])
                    cylinder(d = hole_d, h = hole_h);
                
                // cable opening
                translate([0, side_thickness + (servo_width - cable_hole_w)/2, cable_hole_z_offset + bottom_thickness])
                    cube([screw_holder_size_width, cable_hole_w, cable_hole_h]);
                // cable shaft
                translate([screw_holder_size_width-cable_shaft_depth, side_thickness + (servo_width - cable_hole_w)/2, bottom_thickness])
                    cube([cable_shaft_depth, cable_hole_w, servo_lower_height]);
            }
            
            rot_c_offeset_x = screw_holder_size_width + length_to_rot_center;
            rot_c_offeset_y = side_thickness + servo_width / 2;
        }
    }
}

arm_base();