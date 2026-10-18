use <pipes.scad>

module female_connector(
    inner_length, hole_length, outer_length,
    inner_diameter, outer_diameter,
    notch_width, notch_length,
    hole_width,
    hole_chamfer = 0, edge_chamfer = 0,
) {
    total_length = inner_length + hole_length + outer_length;
    wall_thickness = (outer_diameter-inner_diameter)/2;
    
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
        // inner hole chamfer to allow latch to swing open easier radially
        if (hole_chamfer > 0) {
            translate([0, 0, inner_length-hole_chamfer]) {
                intersection() {
                    cylinder(hole_chamfer, d1=inner_diameter, d2=outer_diameter);
                    translate([outer_diameter/2 + wall_thickness/2, 0, hole_chamfer/2]) {
                        cube([outer_diameter/2, hole_width, hole_chamfer], center=true);
                    };
                };
            };
        };
        // edge chamfers for male connector
        if (edge_chamfer > 0) {
            translate([0, 0, total_length-edge_chamfer]) {
                cylinder(edge_chamfer, d1=inner_diameter, d2=inner_diameter+2*edge_chamfer); // inner
                bevelled_ring(edge_chamfer, outer_diameter-2*edge_chamfer, outer_diameter, flip=true); // outer
            };
        };
    };
}
