$fs = 0.3;

module four_holes(diam = 1, dist=1, h=1) {
    translate([dist, 0, 0])
        cylinder(d=diam, h=h);
    translate([-dist, 0, 0])
        cylinder(d=diam, h=h);
    translate([0, dist, 0])
        cylinder(d=diam, h=h);
    translate([0, -dist, 0])
        cylinder(d=diam, h=h);
}

module nut_holder(w=5.8, d=3, h=1.5, th=1.2) {
    difference() {
        translate([-d-th, -w/2-th,-h-th])
            cube([(d+th)*2, w+th*2, h+th]);
        
        translate([-d, -w/2,-h])
            cube([d*2+th, w, h]);
    }
}

module four_nut_holders(dist=1, w, d, h, th, d_hole) {
    translate([dist, 0, 0]) difference() {
        nut_holder(w=w, d=d, h=h, th=th);
        cylinder(d=d_hole, h=(h+th)*2, center=true);
    }
    translate([-dist, 0, 0]) difference() {
        nut_holder(w=w, d=d, h=h, th=th); 
        cylinder(d=d_hole, h=(h+th)*2, center=true);
    }
    translate([0, dist, 0]) difference() {
        nut_holder(w=w, d=d, h=h, th=th); 
        cylinder(d=d_hole, h=(h+th)*2, center=true);
    }
    translate([0, -dist, 0]) difference() {
        nut_holder(w=w, d=d, h=h, th=th); 
        cylinder(d=d_hole, h=(h+th)*2, center=true);
    }
    
}

module arm_holder(
        inner_r = 20, 
        wall_thick = 5, 
        top_thick = 5, 
        bottom_thick = 5,
        height_space = 50,
        servo_middle_hole_d=7,
        servo_hole_d = 3.1,
        servo_hole_dist = 7.25,
        servo_nut_holder_width = 5.8,
        servo_nut_holder_depth = 3.2,
        servo_nut_holder_h = 2.6,
        servo_nut_holder_thick = 1.2,
        servo_fitter_d = 22,
        servo_fitter_thick = 1,
        servo_fitter_h = 1.2,
        holding_hole_d = 3.1,
        holding_hole_dist = 20,
        lower_axis_d = 5,
        lower_axis_h = 4,
        lower_axis_holder_d = 7,
        lower_axis_holder_h = 1) {
    outer_r = inner_r + wall_thick;
            
    difference() {        
        // top plate
        cylinder(r=outer_r, h=top_thick);
        
        cylinder(d=servo_middle_hole_d, h=top_thick);
        
        four_holes(diam = servo_hole_d, 
                   dist = servo_hole_dist,
                   h = top_thick);
        
        rotate(45)
        four_holes(diam = holding_hole_d, 
                   dist = holding_hole_dist,
                   h = top_thick);
        
    }
    rotate(45)
    four_nut_holders(dist = holding_hole_dist, 
               w = servo_nut_holder_width,
               d = servo_nut_holder_depth,
               h = servo_nut_holder_h,
               th = servo_nut_holder_thick,
               d_hole = servo_hole_d);
    
    translate([0,0,-servo_fitter_h]) {
        difference() {
            cylinder(d=servo_fitter_d+servo_fitter_thick,
                     h=servo_fitter_h);
            cylinder(d=servo_fitter_d,
                     h=servo_fitter_h);
        }
    }
    
    translate([0,0,-height_space])
        difference() {
            cylinder(r=outer_r,h=height_space);
            cylinder(r=inner_r, h=height_space);
            d_cube=cos(45)*inner_r;
            remain = outer_r-d_cube;
            translate([+remain/2,0,height_space/2])
                cube([d_cube*2+remain, outer_r*2, height_space], center=true);
        }
            
    translate([0,0,-(bottom_thick + height_space)]) {
        // bottom plate
        cylinder(r=outer_r, bottom_thick);
        
        translate([0,0,-lower_axis_holder_h]) {
            cylinder(d=lower_axis_holder_d, h=lower_axis_holder_h);
            
            translate([0,0,-lower_axis_h]) {
                cylinder(d=lower_axis_d, h=lower_axis_h);
                
            }
        }
    }
}

//nut_holder();
arm_holder();
