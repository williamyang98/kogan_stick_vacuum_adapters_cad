module bevelled_ring(
    length,
    inner_diameter,
    outer_diameter,
    flip=false,
) {
    if (!flip) {
        rotate_extrude() {
            polygon([
                [inner_diameter/2, 0],
                [outer_diameter/2, 0],
                [outer_diameter/2, length],
            ]);
        };
    } else {
        rotate_extrude() {
            polygon([
                [outer_diameter/2, 0],
                [outer_diameter/2, length],
                [inner_diameter/2, length],
            ]);
        };
    }
}

module barrel(
    length,
    inner_diameter,
    outer_diameter,
) {
    difference() {
        cylinder(length, d=outer_diameter);
        cylinder(length, d=inner_diameter);
    };
}