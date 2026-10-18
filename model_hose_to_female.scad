// test file to check if parts fit correctly with sufficient tolerances
include <measurements.scad>
use <female_connector.scad>
use <latch_button.scad>
use <latch_button_enclosure.scad>
use <hose_connector.scad>

// Hose adapter for stick vacuum
// Measurements are in millimeters (mm)
$fn = 72*2; // fragment number for number of faces on axial objects


show_adapter = true;
show_button = true;

bridge_length = 10;
adapter_length = screw_length + bridge_length + latch_total_length;

// Screw
if (show_adapter) {
    color("pink")
    rotate([0, 180, 0])
    translate([0, 0, -screw_length]) {
        hose_connector(
            screw_length,
            screw_inner_diameter, screw_outer_diameter,
            screw_thickness, screw_pitch, screw_depth,
            turn=0.35,
        );
    };
};


// Bridge
if (show_adapter) {
    color("green")
    translate([0, 0, screw_length]) {
        difference() {
            cylinder(bridge_length, d1=screw_outer_diameter, d2=latch_outer_diameter);
            cylinder(bridge_length, d1=screw_inner_diameter, d2=key_inner_diameter);
        };
    };
};


// Female connector
translate([0, 0, screw_length + bridge_length]) {
    if (show_adapter) {
        color("red")
        female_connector(
            latch_inner_length, latch_lock_cutoff_length, latch_outer_length,
            latch_inner_diameter, latch_outer_diameter,
            latch_insertion_cutout_width, latch_insertion_depth,
            latch_lock_cutoff_width,
            hole_clearance=button_clearance,
        );
    };


    // Button
    translate([
        latch_outer_diameter/2 + button_volume_height/2 + button_clearance,
        0,
        key_inner_length + button_length/2,
    ]) {
        if (show_button) {
            color("blue")
            latch_button(
                button_width, button_length, button_thickness,
                button_axle_inner_diameter, button_axle_outer_diameter,
                button_latch_length, button_latch_depth, button_latch_inner_diameter, button_latch_outer_diameter,
                latch_clearance=button_latch_clearance,
                hinge_length=button_hinge_length, hinge_skew=button_hinge_elevation,
            );
        };
        
        if (show_adapter) {
            color("orange")
            latch_button_enclosure(
                button_width, button_length, button_thickness,
                m2_inner_diameter, button_axle_outer_diameter, m2_head_diameter, m2_head_height,
                button_clearance, button_enclosure_clearance, button_enclosure_thickness, latch_outer_diameter,
                hinge_length=button_hinge_length, hinge_skew=button_hinge_elevation,
            );
        };
    };
};

