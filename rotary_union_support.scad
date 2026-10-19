// Custom support for overhangs when printing union support at 45 degree angle
module rotary_union_45_degree_support(
    inner_diameter, outer_diameter, length,
    flange_radius, flange_length, flange_width, flange_clearance,
    support_diameter,
) {
    barrel_thickness = (outer_diameter-inner_diameter)/2;
    outer_flange_radius = flange_radius + flange_clearance;
    
    joint_length = 
        flange_clearance + 
        flange_radius +
        flange_length +
        flange_radius +
        flange_clearance +
        flange_radius +
        flange_length +
        flange_radius +
        flange_clearance;
        
    joint_width = 
        flange_clearance +
        flange_radius +
        flange_width +
        flange_radius +
        flange_clearance;
        
    assert(length > joint_length, "Barrel must be sufficiently long to house rotary union");
    assert(barrel_thickness > joint_width, "Barrel must be sufficiently thick to house rotary union");
    
    padding_length = length - joint_length;
    padding_width = barrel_thickness - joint_width;

    flange_long_width = padding_width/2 + flange_clearance + flange_radius  + flange_width;

    // support must be placed in between two circular parts, the inner and outer radial surface
    // r_midpoint = r + clearance/2
    // the x and y component of this as an offset is given as
    // offset^2 + offset^2 = r_midpoint^2
    // offset = r_midpoint/sqrt(2)
    support_midpoint_radius = flange_radius + flange_clearance/2;
    support_midpoint_offset = support_midpoint_radius/sqrt(2);

    support_length = flange_clearance + flange_radius;
    support_center_bottom = [
        flange_long_width + support_midpoint_offset,
        0,
        padding_length/2 + outer_flange_radius - support_midpoint_offset,
    ];
    support_center_top = [
        padding_width/2 + outer_flange_radius - support_midpoint_offset,
        0,
        length - padding_length/2 - outer_flange_radius + support_midpoint_offset,
    ];

    translate([inner_diameter/2, 0, 0])
    union() {
        translate(support_center_bottom) {
            rotate([0, -45, 0]) {
                cylinder(support_length, d=support_diameter, center=true);
            };
        };

        translate(support_center_top) {
            rotate([0, -45, 0]) {
                cylinder(support_length, d=support_diameter, center=true);
            };
        };
    };
}