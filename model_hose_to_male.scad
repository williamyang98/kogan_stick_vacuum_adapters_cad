use <hose_connector.scad>
use <male_connector.scad>
include <measurements.scad>

$fn = 72*2; // fragment number for number of faces on axial objects

bridge_length = 10;
adapter_length = key_length + bridge_length + screw_length;


// Key
color("blue")
difference() {
    male_connector(
        key_inner_length, key_notch_length, key_outer_length, 
        screw_inner_diameter, key_outer_diameter, key_notch_diameter, key_wall_diameter,
        key_latch_width, key_latch_length, 
    );
    cylinder(key_inner_length/2, d1=key_inner_diameter, d2=screw_inner_diameter); // match with screw and taper
};



// Bridge
color("green")
translate([0, 0, key_length]) {
    difference() {
        cylinder(bridge_length, d1=key_wall_diameter, d2=screw_outer_diameter);
        // cylinder(bridge_length, d1=key_inner_diameter, d2=screw_inner_diameter);
        cylinder(bridge_length, d=screw_inner_diameter); // make it thicker inside for strength
    };
};


// Screw
color("pink")
translate([0, 0, key_length+bridge_length]) {
    hose_connector(
        screw_length,
        screw_inner_diameter, screw_outer_diameter,
        screw_thickness, screw_pitch, screw_depth,
        turn=0.35,
    );
};