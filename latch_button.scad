use <trapezoidal_prism.scad>
use <extra_math.scad>

// latch button which rotates around a hinge
module latch_button(
    width, length, depth,
    axle_inner_diameter, axle_outer_diameter,
    latch_length, latch_depth, latch_inner_diameter, latch_outer_diameter,
    latch_clearance = 0.2,
    hinge_length = 0, hinge_skew = 0,
    indent_width_ratio = 0.75, indent_depth_ratio = 0.25,
    latch_flange_ratio = 0.25,
    indent_fn = $fn*2,
) {
    total_depth = depth + hinge_skew;
    locking_tab_length = (length-hinge_length)/2; // connects to hinge
    press_tab_length = length/2 - width/2; // connects to thickened hinge

    indent_width = indent_width_ratio*width;
    indent_depth = indent_depth_ratio*depth;
    indent_radius = calculate_sphere_radius_from_indent(indent_width, indent_depth); 

    latch_overflow = calculate_surface_overflow_onto_cylinder(latch_inner_diameter/2, width);
    latch_total_depth = latch_depth + latch_overflow;
    latch_flange_length = latch_flange_ratio*latch_length;

    hinge_angle =
        (hinge_length == 0) ? 0 :
        (hinge_skew == 0) ? 0 :
        atan2(hinge_skew, hinge_length);
    
    difference() {
        union() {
            // create hinged button
            difference() {
                union() {
                    // hinge body
                    trapezoidal_prism(width, depth, hinge_length, hinge_skew);
                    // locking tab that goes into hole
                    translate([-total_depth/2 + depth/2, 0, -length/2 + locking_tab_length/2]) {
                        cube([depth, width, locking_tab_length], center=true);
                    };
                    // press tab straight part that connects to rounded push section
                    translate([total_depth/2 - depth/2, 0, press_tab_length/2]) {
                        cube([depth, width, press_tab_length], center=true);
                    };
                    // press tab rounded circle to release locking tab
                    translate([total_depth/2 - depth, 0, length/2 - width/2]) {
                        // half cylinder push tab section
                        rotate([0, 90, 0])
                        intersection() {
                            cylinder(depth, d=width);
                            translate([-width/4, 0, depth/2]) {
                                cube([width/2, width, depth], center=true);
                            };
                        };
                        
                    };
                    // thin hinge axle on the bottom that has to have clearance with female connector
                    rotate([90, 0, 0]) cylinder(width, d=axle_outer_diameter, center=true);
                    // thicken hinge axle on the top which is inline with the press button
                    difference() {
                        union() {
                            // thickened axle
                            rotate([90, 0, 0]) cylinder(width, d=total_depth, center=true);
                            // make it perpendicular with lock tab
                            translate([-total_depth/4, 0, -total_depth/4]) {
                                cube([total_depth/2, width, total_depth/2], center=true);
                            };
                        };
                        rotate([0, 90+hinge_angle, 0]) { // chop off half of the cylinder beneath hinge
                            translate([0, 0, -total_depth]) {
                                cube([total_depth*2, width, total_depth*2], center=true);
                           };
                        };
                    };
                };
                // hinge axle bore hole
                rotate([90,0,0]) cylinder(width, d=axle_inner_diameter, center=true);
                // indent for press tab
                translate([total_depth/2 + indent_radius - indent_depth, 0, length/2 - width/2])
                sphere(r=indent_radius, $fn=indent_fn);
            };
            // create latch
            translate([-total_depth/2, 0, -length/2]) {
                difference() {
                    translate([-latch_total_depth, -width/2, 0]) {
                        cube([latch_total_depth, width, latch_length], center=false);
                    };
                    // create locking unidirectional taper for male connector
                    translate([-latch_depth-latch_inner_diameter/2, 0, 0]) {
                        cylinder(latch_length, d=latch_inner_diameter);
                        // flange is the flat bit that touches male connector
                        translate([0, 0, latch_flange_length]) {
                            cylinder(latch_length-latch_flange_length, d1=latch_inner_diameter, d2=latch_outer_diameter);
                        };
                    };
                };
            };
        };
        // shave off some of the latch for clearance reasons
        translate([total_depth/2-total_depth-latch_total_depth, -width/2, -length/2]) {
            cube([total_depth+latch_total_depth, width, latch_clearance], center=false);
        };
    };
}