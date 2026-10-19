use <rotary_union.scad>
include <measurements.scad>

$fn = 72;

difference() {
    rotary_union(
        rotary_union_inner_diameter, rotary_union_outer_diameter, rotary_union_length,
        rotary_union_flange_radius, rotary_union_flange_length, rotary_union_flange_width, rotary_union_flange_clearance,
        flange_chamfer=rotary_union_flange_chamfer,
    );
    cube([rotary_union_outer_diameter, rotary_union_outer_diameter, rotary_union_length]);
}