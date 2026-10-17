use <trapezoidal_prism.scad>

// latch button which rotates around a hinge
module latch_button(
    width, length, depth,
    axle_inner_diameter, axle_outer_diameter,
    latch_length, latch_depth, latch_inner_diameter, latch_outer_diameter,
    hinge_length = 0, hinge_skew = 0,
    indent_width_ratio = 0.75, indent_depth_ratio = 0.25,
    latch_flange_ratio = 0.25,
    indent_fn = $fn*2,
) {
    total_depth = depth + hinge_skew;
    tab_length = (length-hinge_length)/2;
    indent_width = indent_width_ratio*width;
    indent_depth = indent_depth_ratio*depth;
    
    // calculate radius r of sphere that will leave this indent of width w and depth d
    // R = r - d
    // r^2 = R^2 + (w/2)^2
    // r^2 = r^2 - 2rd + d^2 + (w/2)^2
    // 2rd = d^2 + w^2/4
    // r = d/2 + w^2/8d
    indent_radius = indent_depth/2 + indent_width^2/(8*indent_depth);

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
    latch_inner_radius = latch_inner_diameter/2;
    latch_overflow = latch_inner_radius - sqrt(max(latch_inner_radius^2 - (width^2)/4, 0));
    latch_total_depth = latch_depth + latch_overflow;
    latch_flange_length = latch_flange_ratio*latch_length;
    
    union() {
        // create hinged button
        difference() {
            union() {
                // lock, hinge and press tab body
                difference() {
                    union() {
                        // hinge body
                        trapezoidal_prism(width, depth, hinge_length, hinge_skew);
                        // locking tab that goes into hole
                        translate([-total_depth/2 + depth/2, 0, -length/2 + tab_length/2]) {
                            cube([depth, width, tab_length], center=true);
                        };
                        // press tab to release locking tab
                        translate([total_depth/2 - depth/2, 0, length/2 - tab_length/2]) {
                            // straight part that connects to rounded push section
                            translate([0, 0, -width/4]) {
                                cube([depth, width, tab_length-width/2], center=true);
                            };
                            translate([-depth/2, 0, tab_length/2-width/2]) {
                                // half cylinder push tab section
                                rotate([0, 90, 0])
                                intersection() {
                                    cylinder(depth, d=width);
                                    translate([-width/4, 0, depth/2]) {
                                        cube([width/2, width, depth], center=true);
                                    };
                                };
                                
                            };
                        };
                    };
                    // indent for press tab
                    translate([total_depth/2 + indent_radius - indent_depth, 0, length/2 - width/2])
                    sphere(r=indent_radius, $fn=indent_fn);
                };
                // hinge axle
                rotate([90, 0, 0]) cylinder(width, d=axle_outer_diameter, center=true);
            };
            // hinge axle bore hole
            rotate([90,0,0]) cylinder(width, d=axle_inner_diameter, center=true);
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
}