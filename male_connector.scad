module male_connector(
    inner_length, neck_length, outer_length, 
    inner_diameter, outer_diameter, neck_diameter, notch_diameter,
    notch_width, notch_length, 
) {
    total_length = inner_length + neck_length + outer_length;
    neck_depth = (outer_diameter-neck_diameter)/2;
    notch_height = (notch_diameter-outer_diameter)/2;
    wall_thickness = (outer_diameter - inner_diameter)/2;

    union() {
        difference() {
            cylinder(total_length, d=outer_diameter);
            cylinder(total_length, d=inner_diameter); // barrel
            translate([0, 0, inner_length]) { // neck
                difference() {
                    cylinder(neck_length, d=outer_diameter);
                    cylinder(neck_length, d=neck_diameter); // neck for connector
                    translate([0, 0, neck_length-neck_depth]) { // chamfer edge of neck
                        cylinder(neck_depth, d1=neck_diameter, d2=outer_diameter);
                    };
                };
            };
            
        };
        // notch
        translate([outer_diameter/2 + notch_height/2 - wall_thickness/4, 0, total_length-notch_length/2]) {
            cube([notch_height + wall_thickness/2, notch_width, notch_length], center=true);
        };
    };
}