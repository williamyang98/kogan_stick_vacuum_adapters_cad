use <pipes.scad>

module female_connector(
    inner_length, hole_length, outer_length,
    inner_diameter, outer_diameter,
    notch_width, notch_length,
    hole_width, hole_chamfer_slope = 0.25,
    hole_clearance = 0.25,
    chamfer = 0,
) {
    total_length = inner_length + hole_length + outer_length;
    wall_thickness = (outer_diameter-inner_diameter)/2;
    hole_chamfer_length = hole_chamfer_slope*wall_thickness;
    
    inner_length = inner_length - hole_clearance;
    hole_length = hole_length + hole_clearance;
    
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
        // edge chamfers for male connector
        if (chamfer > 0) {
            translate([0, 0, total_length-chamfer]) {
                cylinder(chamfer, d1=inner_diameter, d2=inner_diameter+2*chamfer); // inner
                bevelled_ring(chamfer, outer_diameter-2*chamfer, outer_diameter, flip=true); // outer
            };
        };
    };
}
