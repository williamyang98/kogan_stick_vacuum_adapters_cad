use <pipes.scad>

module male_connector(
    inner_length, neck_length, outer_length, 
    inner_diameter, outer_diameter, neck_diameter, notch_diameter,
    notch_width, notch_length, 
    edge_chamfer = 0,
) {
    total_length = inner_length + neck_length + outer_length;
    neck_depth = (outer_diameter-neck_diameter)/2;
    notch_height = (notch_diameter-outer_diameter)/2;
    wall_thickness = (outer_diameter - inner_diameter)/2;

    union() {
        difference() {
            barrel(total_length, inner_diameter, outer_diameter);
            translate([0, 0, inner_length]) {
                barrel(neck_length-neck_depth, neck_diameter, outer_diameter);
            };
            translate([0, 0, inner_length+neck_length-neck_depth]) {
                bevelled_ring(neck_depth, neck_diameter, outer_diameter);
            };
            if (edge_chamfer > 0) {
                cylinder(edge_chamfer, d1=inner_diameter+edge_chamfer*2, d2=inner_diameter);
                bevelled_ring(edge_chamfer, outer_diameter-edge_chamfer*2, outer_diameter);
            };
        };
        // notch
        translate([outer_diameter/2 + notch_height/2 - wall_thickness/4, 0, total_length-notch_length/2]) {
            cube([notch_height + wall_thickness/2, notch_width, notch_length], center=true);
        };
    };
}