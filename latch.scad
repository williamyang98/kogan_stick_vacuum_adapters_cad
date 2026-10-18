include <measurements.scad>
use <male_connector.scad>
use <female_connector.scad>
use <trapezoidal_prism.scad>
use <latch_button.scad>
use <latch_button_enclosure.scad>

// Hose adapter for stick vacuum
// Measurements are in millimeters (mm)
$fn = 72; // fragment number for number of faces on axial objects


show_key = true;
show_female = true;
show_cutout = false;
show_button = true;
show_enclosure = true;
is_button_pressed = true;
button_angle = is_button_pressed ? -6 : 0;

// Key
difference() {
union() {

if (show_key) {
    male_connector(
        key_inner_length, key_notch_length, key_outer_length, 
        key_inner_diameter, key_outer_diameter, key_notch_diameter, key_wall_diameter,
        key_latch_width, key_latch_length, 
    );
};

// Latch
if (show_female) {
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
if (show_button) {
color("blue")
translate([
    latch_outer_diameter/2 + button_volume_height/2 + button_clearance,
    0,
    key_inner_length + button_length/2,
]) { // center is the button pivot point
rotate([0, button_angle, 0]) {
    latch_button(
        button_width, button_length, button_thickness,
        button_axle_inner_diameter, button_axle_outer_diameter,
        button_latch_length, button_latch_depth, button_latch_inner_diameter, button_latch_outer_diameter,
        latch_clearance=button_latch_clearance,
        hinge_length=button_hinge_length, hinge_skew=button_hinge_elevation,
    );
};
};
};

if (show_enclosure) {
color("orange")
translate([
    latch_outer_diameter/2 + button_volume_height/2 + button_clearance,
    0,
    key_inner_length + button_length/2,
]) { // center is the button pivot point
    latch_button_enclosure(
        button_width, button_length, button_thickness,
        m2_inner_diameter, button_axle_outer_diameter, m2_head_diameter, m2_head_height,
        button_clearance, button_enclosure_clearance, button_enclosure_thickness, latch_outer_diameter,
        hinge_length=button_hinge_length, hinge_skew=button_hinge_elevation,
    );
};
};

};

if (show_cutout) {
    cube([key_wall_diameter, key_wall_diameter, key_length+key_latch_length]);
};
};