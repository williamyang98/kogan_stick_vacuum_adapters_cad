use <revolute_joint.scad>
include <measurements.scad>

$fn = 72;

difference() {
    revolute_joint(
        revolute_inner_diameter, revolute_outer_diameter, revolute_length,
        revolute_flange_radius, revolute_flange_length, revolute_flange_width, revolute_flange_clearance,
        flange_chamfer=revolute_flange_chamfer,
    );
    cube([revolute_outer_diameter, revolute_outer_diameter, revolute_length]);
}