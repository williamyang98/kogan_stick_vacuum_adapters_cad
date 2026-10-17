use <trapezoidal_prism.scad>

// latch button which rotates around a hinge
module latch_button(
    width, length, depth,
    axle_inner_diameter, axle_outer_diameter,
    hinge_length = 0, hinge_skew = 0,
    indent_width_ratio = 0.75, indent_depth_ratio = 0.25,
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
}