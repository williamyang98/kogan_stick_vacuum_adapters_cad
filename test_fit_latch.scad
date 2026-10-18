// test file to check if parts fit correctly with sufficient tolerances
include <measurements.scad>
use <male_connector.scad>
use <female_connector.scad>
use <latch_button.scad>
use <latch_button_enclosure.scad>

// Hose adapter for stick vacuum
// Measurements are in millimeters (mm)
$fn = 72; // fragment number for number of faces on axial objects


show_key = true;
show_female = true;
show_cutout = true;
show_button = true;
show_enclosure = true;
is_button_pressed = false;
button_angle = is_button_pressed ? -6 : 0;

// Key
difference() {
union() {

if (show_key) {
    male_connector(
        male_inner_length, male_neck_length, male_outer_length, 
        male_inner_diameter, male_outer_diameter, male_neck_diameter, male_wall_diameter,
        male_notch_width, male_notch_length, 
        chamfer=connector_chamfer_width,
    );
};

// Latch
if (show_female) {
color("red")
female_connector(
    female_inner_length, female_hole_length, female_outer_length,
    female_inner_diameter, female_outer_diameter,
    female_notch_width, female_notch_length,
    female_hole_width,
    chamfer=connector_chamfer_width,
);
};


// Button
if (show_button) {
color("blue")
translate([
    female_outer_diameter/2 + button_total_height/2 + button_to_female_clearance,
    0,
    male_inner_length + button_length/2,
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
    female_outer_diameter/2 + button_total_height/2 + button_to_female_clearance,
    0,
    male_inner_length + button_length/2,
]) { // center is the button pivot point
    latch_button_enclosure(
        button_width, button_length, button_thickness,
        m2_inner_diameter, button_axle_outer_diameter, m2_head_diameter, m2_head_height,
        button_to_female_clearance, button_enclosure_clearance,
        button_enclosure_wall_thickness, button_enclosure_floor_thickness,
        female_outer_diameter,
        hinge_length=button_hinge_length, hinge_skew=button_hinge_elevation,
    );
};
};

};

if (show_cutout) {
    cube([male_wall_diameter, male_wall_diameter, (male_length+male_notch_length)*10]);
};
};