// Hose adapter for stick vacuum
// Measurements are in millimeters (mm)
$fn = 72*2; // fragment number for number of faces on axial objects

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

// Screw for hose
// measured parameters
screw_thickness = 2.5;
screw_pitch = 4.5;
// screw_outer_diameter = 33;
screw_outer_diameter = key_wall_diameter; // make it extra thicc
screw_inner_diameter = 26;
screw_depth = 3-1;
screw_total_turns = 6;
screw_thread_length = screw_total_turns*screw_pitch;
screw_thread_overrun = screw_thickness * 0.35; // allow for screw to be insertable by overrunning tube
screw_length = screw_thread_length +  screw_thread_overrun;

// Bridge section between key and hose
bridge_length = 10;

// Full adapter
adapter_length = key_length + bridge_length + screw_length;

// Generate helix from cross section
module helix(inner_radius, screw_depth, screw_height, pitch_height, helix_height, total_faces=$fn) {
    degrees_step = 360/total_faces;
    total_steps = ceil(total_faces*helix_height/pitch_height);
    
    // square cross section
    cross_section = [
        [0, 0, 0], // inner-bottom
        [0, screw_depth, 0], // outer-bottom
        [0, screw_depth, screw_height], // outer-top
        [0, 0, screw_height], // inner-top
    ];
    INNER_BOT = 0;
    OUTER_BOT = 1;
    OUTER_TOP = 2;
    INNER_TOP = 3;
    
    // move to inner radius, rotate and elevate
    function transform_vertex(step, vertex_index) = let (
        theta = step * degrees_step,
        vertex = cross_section[vertex_index],
        x = vertex.x,
        y = vertex.y + inner_radius,
        z = vertex.z + pitch_height*theta/360,
        cos_theta = cos(theta),
        sin_theta = sin(theta),
        rot_x = x*cos_theta - y*sin_theta,
        rot_y = x*sin_theta + y*cos_theta,
    ) [rot_x, rot_y, z];
    // generate vertices
    vertices = [
        for (step = [0 : total_steps])
        for (vertex_index = [0 : 3])
        transform_vertex(step, vertex_index)
    ];
    // generate tube from vertices
    tube_faces = [
        for (step = [0 : total_steps - 1])
        let (a = 4*step, b = 4*(step+1)) // a,b are vertex indices for current and next cross section slices
        each [
            [a+INNER_BOT, a+OUTER_BOT, b+OUTER_BOT, b+INNER_BOT], // bottom
            [a+OUTER_BOT, a+OUTER_TOP, b+OUTER_TOP, b+OUTER_BOT], // outer
            [a+OUTER_TOP, a+INNER_TOP, b+INNER_TOP, b+OUTER_TOP], // top
            [a+INNER_TOP, a+INNER_BOT, b+INNER_BOT, b+INNER_TOP], // inner
        ]
    ];
    // seal the tube caps
    start_face = [INNER_BOT, OUTER_BOT, OUTER_TOP, INNER_TOP];
    end_face = [
        for (vertex_index = [0: 3])
        start_face[vertex_index] + 4*total_steps
    ];
    faces = concat(tube_faces, [start_face, end_face]);
    // create bound polyhedron
    convexity = 1; // only expect to see 1 face from casted ray
    polyhedron(points=vertices, faces=faces, convexity=convexity);
}

// Key
union() {
    difference() {
        cylinder(key_length, d=key_outer_diameter);
        // cylinder(key_length, d=key_inner_diameter); // barrel
        union() { // thickened barrel
            cylinder(key_length, d=screw_inner_diameter);
            cylinder(key_inner_length/2, d1=key_inner_diameter, d2=screw_inner_diameter); 
        };
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


// Bridge
translate([0, 0, key_length]) {
    difference() {
        cylinder(bridge_length, d1=key_wall_diameter, d2=screw_outer_diameter);
        // cylinder(bridge_length, d1=key_inner_diameter, d2=screw_inner_diameter);
        cylinder(bridge_length, d=screw_inner_diameter); // make it thicker inside for strength
    };
};


// Screw
translate([0, 0, key_length+bridge_length]) {
    difference() {
        cylinder(screw_length, d=screw_outer_diameter);
        cylinder(screw_length, d=screw_inner_diameter);
        let (
            tolerance = screw_depth*0.1,
        ) helix(
            screw_inner_diameter/2-tolerance,
            screw_depth+tolerance,
            screw_thickness,
            screw_pitch,
            screw_thread_length,
        );
        // chamber for screw thread insertion direction
        translate([0, 0, screw_length-screw_thread_overrun]) {
            cylinder(screw_thread_overrun, d1=screw_inner_diameter, d2=screw_inner_diameter+screw_depth*2);
        };
    };
};