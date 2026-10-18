use <helix.scad>
use <pipes.scad>

module hose_connector(
    thread_length,
    inner_diameter, outer_diameter,
    thread_thickness, thread_pitch, thread_depth,
    turn = 0.3,
    edge_chamfer = 0, 
) {
    tolerance = thread_depth*0.01;
    thread_z_offset = thread_thickness*turn;
    
    difference() {
        barrel(thread_length, inner_diameter, outer_diameter);
        translate([0, 0, thread_z_offset]) {
            helix(
                inner_diameter/2-tolerance,
                thread_depth+tolerance,
                thread_thickness,
                thread_pitch,
                thread_length,
            );
        };
        // inner chamfer for thread insertion direction
        translate([0, 0, thread_length-thread_thickness]) {
            cylinder(thread_thickness, d1=inner_diameter, d2=inner_diameter+thread_depth*2);
        };
        // outer chamfer for edge connection 
        if (edge_chamfer > 0) {
            translate([0, 0, thread_length-edge_chamfer]) {
                bevelled_ring(edge_chamfer, outer_diameter-2*edge_chamfer, outer_diameter, flip=true);
            };
        };
    };
}