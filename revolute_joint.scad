use <pipes.scad>

module revolute_joint(
    inner_diameter, outer_diameter, length,
    flange_radius, flange_length, flange_width, flange_clearance,
    flange_chamfer = 0,
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
        
    assert(length > joint_length, "Barrel must be sufficiently long to house revolute joint");
    assert(barrel_thickness > joint_width, "Barrel must be sufficiently thick to house revolute joint");
    
    padding_length = length - joint_length;
    padding_width = barrel_thickness - joint_width;
    
    // determine size of square cutout to create chamfer on flange along barrel wall
    // l = square size, w = clearance width, c = chamfer width
    // l^2 = 2*(w/2+c)^2
    // l = sqrt(2) * (w/2 + c)
    chamfer_square_width = sqrt(2)*(flange_clearance/2 + flange_chamfer);
    module chamfer_flange_wall_edge() {
        rotate([0, 0, 45]) square(size=chamfer_square_width, center=true);
    };
    
    
    CORNER_TOP_LEFT = 0;
    CORNER_TOP_RIGHT = 1;
    CORNER_BOT_RIGHT = 2;
    CORNER_BOT_LEFT = 3;
    module flange_corner(corner) {
        shift = 
            (corner == CORNER_TOP_LEFT) ? [-outer_flange_radius,  0] :
            (corner == CORNER_TOP_RIGHT) ? [0,  0] :
            (corner == CORNER_BOT_RIGHT) ? [0, -outer_flange_radius] :
            (corner == CORNER_BOT_LEFT) ? [-outer_flange_radius, -outer_flange_radius] : undef;
        
        translate(-shift) {
            intersection() {
                difference() {
                    circle(r=outer_flange_radius);
                    circle(r=flange_radius);
                };
                translate(shift) {
                    square(size=outer_flange_radius, center=false);
                };
            };
        };
    };

    flange_long_width = padding_width/2 + flange_clearance + flange_radius  + flange_width;
    
    difference() {
        barrel(length, inner_diameter, outer_diameter);
        translate([0, 0, padding_length/2])
        rotate_extrude() {
            shift_0 = [0, 0];
            shift_1 = shift_0 + [inner_diameter/2, 0];
            translate(shift_1) square([flange_long_width, flange_clearance], center=false);
            translate(shift_1 + [0, flange_clearance/2]) chamfer_flange_wall_edge();
            shift_2 = shift_1 + [flange_long_width, 0];
            translate(shift_2) flange_corner(CORNER_BOT_RIGHT);
            shift_3 = shift_2 + [flange_radius, outer_flange_radius];
            translate(shift_3) square([flange_clearance, flange_length], center=false);
            shift_4 = shift_3 + [-flange_radius, flange_length];
            translate(shift_4) flange_corner(CORNER_TOP_RIGHT);
            shift_5 = shift_4 + [-flange_width, flange_radius];
            translate(shift_5) square([flange_width, flange_clearance], center=false);
            shift_6 = shift_5 + [-outer_flange_radius, 0];
            translate(shift_6) flange_corner(CORNER_BOT_LEFT);
            shift_7 = shift_6 + [0, outer_flange_radius];
            translate(shift_7) square([flange_clearance, flange_length], center=false);
            shift_8 = shift_7 + [0, flange_length];
            translate(shift_8) flange_corner(CORNER_TOP_LEFT);
            shift_9 = shift_8 + [outer_flange_radius, flange_radius];
            translate(shift_9) square([flange_long_width, flange_clearance], center=false);
        };
    };
}