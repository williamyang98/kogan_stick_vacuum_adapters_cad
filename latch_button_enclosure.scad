use <trapezoidal_prism.scad>

// latch button which rotates around a hinge
module latch_button_enclosure(
    button_width, button_length, button_depth,
    axle_inner_diameter, axle_outer_diameter, axle_insert_diameter, axle_insert_depth,
    button_clearance, enclosure_clearance, enclosure_thickness, enclosure_outer_diameter,
    hinge_length = 0, hinge_skew = 0,
) {
    button_total_depth = button_depth + hinge_skew;
    
    width = button_width + enclosure_clearance*2 + enclosure_thickness*2;
    length = button_length + enclosure_clearance*2 + enclosure_thickness*2;
    
    inner_width = button_width + enclosure_clearance*2;
    outer_width = inner_width + enclosure_thickness*2;
    inner_length = button_length + enclosure_clearance*2;
    outer_length = inner_length + enclosure_thickness*2;
    
    outer_press_tab_length = outer_length/2 - outer_width/2;
    outer_latch_tab_length = outer_length/2;
    
    
    // determine additional depth for latch to wrap around latch_inner_radius
    // s^2 = (w/2)^2 + d^2
    // s^2 = w^2/4 + d^2
    // tan(theta) = d/(w/2) = 2d/w
    // alpha = 90-theta
    // 2*alpha + beta = 180
    // 180-2*theta + beta = 180
    // theta = beta/2
    // tan(beta/2) = (s/2)/sqrt(r^2 - s^2/4) = s/sqrt(4r^2 - s^2)
    // since tan(theta) = tan(beta/2)
    // 2d/w = s/sqrt(4r^2 - s^2)
    // 4d^2/w^2 = s^2/(4r^2 - s^2)
    // 16 r^2 d^2 - 4 s^2 d^2 = w^2 s^2
    // s^2 (w^2 + 4d^2) = 16 r^2 d^2
    // s^2 = (16 r^2 d^2)/(w^2 + 4 d^2)
    // substitute into pythag
    // 16 r^2 d^2 = (w^2/4 + d^2) * (w^2 + 4d^2)
    // 64 r^2 d^2 = (w^2 + 4d^2)^2
    // 8rd = w^2 + 4d^2
    // 4d^2 - 8rd + w^2 = 0
    // d^2 - 2rd = -w^2/4
    // d^2 - 2rd + r^2 - r^2 = -w^2/4
    // (d-r)^2 = r^2 - w^2/4
    // d = r - sqrt(r^2 - w^2/4) // take shorter distance
    enclosure_outer_radius = enclosure_outer_diameter/2;
    enclosure_overflow = enclosure_outer_radius - sqrt(max(enclosure_outer_radius^2 - (outer_width^2)/4, 0));
    depth = button_total_depth + enclosure_overflow + button_clearance;
    
    latch_tab_depth = enclosure_overflow + button_clearance + button_depth;
    hinge_axle_depth = enclosure_overflow + button_clearance + button_total_depth/2;
    
    difference() {
        union() {
            // enclosure walls
            difference() {
                // build enclosure volume
                union() {
                    // hinge axle
                    rotate([90,0,0]) cylinder(outer_width, d=button_total_depth, center=true);
                    translate([button_total_depth/2-depth, 0, 0]) {
                        // rounded button section
                        translate([0, 0, outer_length/2-outer_width/2]) {
                            // half cylinder push tab section
                            rotate([0, 90, 0])
                            intersection() {
                                cylinder(depth, d=outer_width);
                                translate([-outer_width/4, 0, depth/2]) {
                                    cube([outer_width/2, outer_width, depth], center=true);
                                };
                            };
                        };
                        // press tab border
                        translate([depth/2, 0, outer_length/2-outer_width/2-outer_press_tab_length/2]) {
                            cube([depth, outer_width, outer_press_tab_length], center=true);
                        };
                        // hinge axle border (aesthetic fix to make bolt hole joint at right angle to rest of border)
                        translate([hinge_axle_depth/2, 0, 0]) {
                            cube([hinge_axle_depth, outer_width, button_total_depth], center=true);
                        };
                        // latch tab border
                        translate([latch_tab_depth/2, 0, -outer_length/2+outer_latch_tab_length/2]) {
                            cube([latch_tab_depth, outer_width, outer_latch_tab_length], center=true);
                        };
                    };
                };
                // punch out the y-z face of enclosure
                union() {
                    translate([button_total_depth/2-depth, 0, 0]) {
                        // rounded button section
                        translate([0, 0, inner_length/2-inner_width/2]) {
                            // half cylinder push tab section
                            rotate([0, 90, 0])
                            intersection() {
                                cylinder(depth, d=inner_width);
                                translate([-inner_width/4, 0, depth/2]) {
                                    cube([inner_width/2, inner_width, depth], center=true);
                                };
                            };
                        };
                        // square body
                        translate([depth/2, 0, -inner_length/2+(inner_length-inner_width/2)/2]) {
                            cube([depth, inner_width, inner_length-inner_width/2], center=true);
                        };
                    };
                };
            };
            // enclosure floor
            intersection() {
                // enclosure perimeter where floor is value
                union() {
                    translate([button_total_depth/2-depth, 0, 0]) {
                        // rounded button section
                        translate([0, 0, outer_length/2-outer_width/2]) {
                            // half cylinder push tab section
                            rotate([0, 90, 0])
                            intersection() {
                                cylinder(depth, d=outer_width);
                                translate([-outer_width/4, 0, depth/2]) {
                                    cube([outer_width/2, outer_width, depth], center=true);
                                };
                            };
                        };
                        // square body
                        translate([depth/2, 0, -outer_length/2+(outer_length-outer_width/2)/2]) {
                            cube([depth, outer_width, outer_length-outer_width/2], center=true);
                        };
                    };
                };
                translate([-button_total_depth/2-button_clearance-enclosure_outer_diameter/2, 0, 0]) {
                    cylinder(outer_length/2, d1=enclosure_outer_diameter, d2=enclosure_outer_diameter+button_depth*2);
                };
            };
        };
        // hinge axle bore hole
        rotate([90,0,0]) cylinder(outer_width, d=axle_inner_diameter, center=true);
        // m2 nut and bolt insert holes
        rotate([90,0,0]) {
            difference() {
                cylinder(outer_width, d=axle_insert_diameter, center=true);
                cylinder(outer_width-axle_insert_depth*2, d=axle_insert_diameter, center=true);
            };
        };
        // outer diameter attachment surface accounting for clearance with button
        translate([-button_total_depth/2-button_clearance-enclosure_outer_diameter/2, 0, -outer_length/2]) {
            cylinder(outer_length, d=enclosure_outer_diameter);
        };
    };
    
}