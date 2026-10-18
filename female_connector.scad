use <pipes.scad>

module female_connector(
    inner_length, hole_length, outer_length,
    inner_diameter, outer_diameter,
    notch_width, notch_length,
    hole_width, hole_chamfer_slope = 0.25,
    hole_clearance = 0.25,
) {
    total_length = inner_length + hole_length + outer_length;
    wall_thickness = (outer_diameter-inner_diameter)/2;
    hole_chamfer_length = hole_chamfer_slope*wall_thickness;
    
    inner_length = inner_length - hole_clearance;
    hole_length = hole_length + hole_clearance;
    
    union() {
        difference() {
            barrel(total_length, inner_diameter, outer_diameter);
            // notch cutout for male connector
            translate([inner_diameter/2 + wall_thickness/2, 0, total_length-notch_length/2]) {
                cube([inner_diameter/2, notch_width, notch_length], center=true);
            };
            // hole for button latch
            translate([outer_diameter/2 + wall_thickness/2, 0, inner_length+hole_length/2]) {
                cube([outer_diameter/2, hole_width, hole_length], center=true);
            };
        };
    };
}
