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