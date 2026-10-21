use <rotary_union.scad>
use <rotary_union_support.scad>
include <measurements.scad>

$fn = 72;
show_rotary_union = true;
show_supports = true;

rotary_union_inner_diameter = male_inner_diameter;
rotary_union_outer_diameter = female_outer_diameter;

difference() {

union() {

if (show_rotary_union)
color("yellow")
rotary_union(
    rotary_union_inner_diameter, rotary_union_outer_diameter, rotary_union_length,
    rotary_union_flange_radius, rotary_union_flange_length, rotary_union_flange_width,
    rotary_union_flange_clearance,
    flange_chamfer=rotary_union_flange_chamfer,
);

if (show_supports)
color("blue")
for (angle = rotary_union_support_angles) {
    rotate([0, 0, angle])
    rotary_union_45_degree_support(
        rotary_union_inner_diameter, rotary_union_outer_diameter, rotary_union_length,
        rotary_union_flange_radius, rotary_union_flange_length, rotary_union_flange_width,
        rotary_union_flange_clearance,
        rotary_union_support_diameter,
    );
};


};

cube([rotary_union_outer_diameter, rotary_union_outer_diameter, rotary_union_length]);
};