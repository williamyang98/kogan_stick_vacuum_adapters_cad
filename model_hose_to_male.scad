use <hose_connector.scad>
use <male_connector.scad>
include <measurements.scad>

$fn = 72*2; // fragment number for number of faces on axial objects
bridge_length = 10;

// Key
color("blue")
difference() {
    male_connector(
        male_inner_length, male_neck_length, male_outer_length, 
        hose_inner_diameter, male_outer_diameter, male_neck_diameter, male_wall_diameter,
        male_notch_width, male_notch_length, 
        chamfer=connector_chamfer_width,
    );
    cylinder(male_inner_length/2, d1=male_inner_diameter, d2=hose_inner_diameter); // match with screw and taper
};



// Bridge
color("green")
translate([0, 0, male_length]) {
    difference() {
        cylinder(bridge_length, d1=male_wall_diameter, d2=hose_outer_diameter);
        // cylinder(bridge_length, d1=male_inner_diameter, d2=hose_inner_diameter);
        cylinder(bridge_length, d=hose_inner_diameter); // make it thicker inside for strength
    };
};


// Screw
color("pink")
translate([0, 0, male_length+bridge_length]) {
    hose_connector(
        hose_length,
        hose_inner_diameter, hose_outer_diameter,
        hose_thread_thickness, hose_thread_pitch, hose_thread_depth,
        turn=0.35,
        chamfer=connector_chamfer_width,
    );
};