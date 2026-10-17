// Hose adapter for stick vacuum
// Measurements are in millimeters (mm)
$fn = 36; // fragment number for number of faces on axial objects

// Key for stick vacuum
// measured parameters
key_outer_length = 20;
key_notch_length = 7;
key_inner_length = 10;
key_outer_diameter = 34;
key_notch_diameter = 31;
key_wall_diameter = 38.5;
key_inner_diameter = 29;
key_latch_width = 3;
key_latch_length = 4;
// derived parameters
key_notch_depth = (key_outer_diameter-key_notch_diameter)/2;
key_wall_height = (key_wall_diameter-key_outer_diameter)/2;
key_length = key_outer_length + key_notch_length + key_inner_length;

// Button for latch
// measured parameters
button_length = 32;
button_width = 15;
button_thickness = 3;
button_hinge_length = 10;
button_hinge_elevation = 2.5;
button_axle_inner_diameter = 2 + 0.25; // m.2 nut
button_axle_outer_diameter = 5.25;
button_clearance = 0.1;
// derived parameters
button_volume_height = button_thickness + button_hinge_elevation;
button_lock_tab_length = (button_length - button_hinge_length)/2;
button_press_tab_length = button_length - button_hinge_length - button_lock_tab_length;


// Latch for stick vacuum
// measured parameters
latch_insertion_clearance = 0.5;
latch_insertion_depth = key_latch_length - latch_insertion_clearance;
latch_insertion_cutout_width = key_latch_width + 0.5;
latch_inner_diameter_clearance = 0.5;
latch_inner_diameter = key_outer_diameter + latch_inner_diameter_clearance;
latch_outer_diameter = key_wall_diameter + latch_inner_diameter_clearance + 1;
latch_lock_cutoff_width_clearance = 1;
latch_lock_cutoff_length_clearance = 1;
latch_lock_cutoff_width = button_width + latch_lock_cutoff_width_clearance;
latch_lock_cutoff_length = 6;
// derived parameters
latch_insertion_height = (latch_outer_diameter-latch_inner_diameter)/2;
latch_length = key_outer_length + key_notch_length + key_inner_length - latch_insertion_clearance;


show_key = true;
show_cutout = true;
show_button = true;
is_button_pressed = false;
button_angle = is_button_pressed ? -6 : 0;

// skew along x axis
module trapezoidal_prism(width, height, length, skew) {
    // square cross section
    cross_section = [
        [-height/2, -width/2, 0], // inner-left
        [height/2, -width/2, 0], // outer-left
        [height/2, width/2, 0], // outer-right
        [-height/2, width/2, 0], // inner-right
    ];
    INNER_BOT = 0;
    OUTER_BOT = 1;
    OUTER_TOP = 2;
    INNER_TOP = 3;
    
    // move to inner radius, rotate and elevate
    function transform_vertex(dz, dx, vertex_index) = let (
        vertex = cross_section[vertex_index],
        x = vertex.x+dx,
        y = vertex.y,
        z = vertex.z+dz,
    ) [x, y, z];
    // generate vertices
    bottom_vertices = [ for (vertex_index = [0 : 3]) transform_vertex(-length/2, -skew/2, vertex_index) ];
    top_vertices = [ for (vertex_index = [0 : 3]) transform_vertex(length/2, skew/2, vertex_index) ];
    vertices = concat(bottom_vertices, top_vertices);
    
    // generate tube from vertices
    tube_faces = [
        let (a = 0, b = 4) // a,b are vertex indices for current and next cross section slices
        each [
            [a+INNER_BOT, a+OUTER_BOT, b+OUTER_BOT, b+INNER_BOT], // bottom
            [a+OUTER_BOT, a+OUTER_TOP, b+OUTER_TOP, b+OUTER_BOT], // outer
            [a+OUTER_TOP, a+INNER_TOP, b+INNER_TOP, b+OUTER_TOP], // top
            [a+INNER_TOP, a+INNER_BOT, b+INNER_BOT, b+INNER_TOP], // inner
        ]
    ];
    // seal the tube caps
    start_face = [INNER_BOT, OUTER_BOT, OUTER_TOP, INNER_TOP];
    end_face = [ for (vertex_index = [0: 3]) start_face[vertex_index] + 4 ];
    faces = concat(tube_faces, [start_face, end_face]);
    // create bound polyhedron
    convexity = 1; // only expect to see 1 face from casted ray
    polyhedron(points=vertices, faces=faces, convexity=convexity);
}

// Key
difference() {
union() {

if (show_key) {
union() {
    difference() {
        union() {
            cylinder(key_length, d=key_outer_diameter);
            translate([0, 0, key_length]) { // key wall
                cylinder(key_latch_length, d=key_wall_diameter);
            };
        };
        cylinder(key_length+key_latch_length, d=key_inner_diameter); // barrel
        translate([0, 0, key_inner_length]) { // notch
            difference() {
                cylinder(key_notch_length, d=key_outer_diameter);
                cylinder(key_notch_length, d=key_notch_diameter);
                // chamfer edge of notch
                translate([0, 0, key_notch_length-key_notch_depth]) {
                    cylinder(key_notch_depth, d1=key_notch_diameter, d2=key_outer_diameter);
                };
            };
        };
        
    };
    // key latch
    translate([key_outer_diameter/2, -key_latch_width/2, key_length-key_latch_length]) {
        cube([key_wall_height, key_latch_width, key_latch_length]);
    };
};
};

// Latch
color("red")
union() {
//    // barrel with button hole
    difference() {
        cylinder(latch_length, d=latch_outer_diameter);
        cylinder(latch_length, d=latch_inner_diameter);
        // notch cutout
        translate([latch_inner_diameter/2 + latch_insertion_height/2, 0, latch_length-latch_insertion_depth/2]) {
            cube([latch_inner_diameter/2, latch_insertion_cutout_width, latch_insertion_depth], center=true);
        };
        // latch hole
        translate([0, 0, key_inner_length]) {
            translate([0, 0, -latch_lock_cutoff_length_clearance]) { // chamfer
                intersection() {
                    difference() {
                        cylinder(latch_lock_cutoff_length_clearance, d=latch_outer_diameter*1.01);
                        cylinder(latch_lock_cutoff_length_clearance, d1=latch_outer_diameter, d2=latch_inner_diameter);
                    };
                    // limit chamber to latch hole
                    translate([latch_outer_diameter/2 + latch_insertion_height/2, 0, latch_lock_cutoff_length_clearance/2]) {
                        cube([latch_outer_diameter/2, latch_lock_cutoff_width, latch_lock_cutoff_length_clearance], center=true);
                    };
                };
                
            };
            translate([latch_inner_diameter/2 + latch_insertion_height/2, 0, latch_lock_cutoff_length/2]) { // hole
                cube([latch_inner_diameter/2, latch_lock_cutoff_width, latch_lock_cutoff_length], center=true);
            };
        };
    };
};

// Button
if (show_button) {
color("blue")
translate([
    latch_outer_diameter/2 + button_volume_height/2 + button_clearance,
    0,
    key_inner_length + button_length/2,
]) { // center is the button pivot point
rotate([0, button_angle, 0]) {
union() {
    difference() {
        union() {
            rotate([90, 0, 0]) cylinder(button_width, d=button_axle_outer_diameter, center=true);
            trapezoidal_prism(button_width, button_thickness, button_hinge_length, button_hinge_elevation);
        };
        rotate([90,0,0]) cylinder(button_width, d=button_axle_inner_diameter, center=true);
    };
    
    translate([-button_volume_height/2 + button_thickness/2, 0, -button_length/2 + button_lock_tab_length/2]) {
        cube([button_thickness, button_width, button_lock_tab_length], center=true);
    };
    translate([button_volume_height/2 - button_thickness/2, 0, button_length/2 - button_press_tab_length/2]) {
        translate([0, 0, -button_width/4]) {
            cube([button_thickness, button_width, button_lock_tab_length-button_width/2], center=true);
        };
        translate([-button_thickness/2, 0, button_press_tab_length/2-button_width/2]) {
            rotate([0, 90, 0])
            intersection() {
                cylinder(button_thickness, d=button_width);
                translate([-button_width/4, 0, button_thickness/2]) {
                    cube([button_width/2, button_width, button_thickness], center=true);
                };
            };
            
        };
    };
};
};
};
};

};

if (show_cutout) {
    cube([key_wall_diameter, key_wall_diameter, key_length+key_latch_length]);
};
};