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