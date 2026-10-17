module female_connector(
    inner_length, hole_length, outer_length,
    inner_diameter, outer_diameter,
    notch_width, notch_length,
    hole_width, hole_chamfer_slope = 0.25,
) {
    total_length = inner_length + hole_length + outer_length;
    wall_thickness = (outer_diameter-inner_diameter)/2;
    hole_chamfer_length = hole_chamfer_slope*wall_thickness;
    
    union() {
        difference() {
            cylinder(total_length, d=outer_diameter);
            cylinder(total_length, d=inner_diameter); // barrel
            // notch cutout for male connector
            translate([inner_diameter/2 + wall_thickness/2, 0, total_length-notch_length/2]) {
                cube([inner_diameter/2, notch_width, notch_length], center=true);
            };
            // hole
            translate([0, 0, inner_length]) {
                // remove to create chamfer
                translate([0, 0, -hole_chamfer_length]) { 
                    intersection() {
                        // create cylindrical taper
                        difference() {
                            cylinder(hole_chamfer_length, d=outer_diameter*1.01);
                            cylinder(hole_chamfer_length, d1=outer_diameter, d2=inner_diameter);
                        };
                        // limit chamfer to hole region
                        translate([outer_diameter/2 + wall_thickness/2, 0, hole_chamfer_length/2]) {
                            cube([outer_diameter/2, hole_width, hole_chamfer_length], center=true);
                        };
                    };
                    
                };
                // remove hole
                translate([outer_diameter/2 + wall_thickness/2, 0, hole_length/2]) { // hole
                    cube([outer_diameter/2, hole_width, hole_length], center=true);
                };
            };
        };
    };
}
