use <hose_connector.scad>
use <male_connector.scad>
use <rotary_union.scad>
use <rotary_union_support.scad>
use <fin_support.scad>
include <measurements.scad>

$fn = 72*2; // fragment number for number of faces on axial objects
show_cross_section = false;
total_height = male_length + rotary_union_length + hose_length;

// Rotary union for male connector to hose connector
rotary_union_inner_diameter = hose_inner_diameter;
rotary_union_outer_diameter = hose_outer_diameter;

difference() {
rotate([0, 0, 180])
union() {

// Male connector
color("green")
difference() {
    male_connector(
        male_inner_length, male_neck_length, male_outer_length, 
        hose_inner_diameter, male_outer_diameter, male_neck_diameter, male_wall_diameter,
        male_notch_width, male_notch_length, 
        edge_chamfer=connector_edge_chamfer_width,
    );
    cylinder(male_inner_length/2, d1=male_inner_diameter, d2=hose_inner_diameter); // match with screw and taper
};

// Rotary union
color("yellow")
translate([0, 0, male_length]) {
    rotate([0, 180, 0])
    translate([0, 0, -rotary_union_length])
    rotary_union(
        rotary_union_inner_diameter, rotary_union_outer_diameter, rotary_union_length,
        rotary_union_flange_radius, rotary_union_flange_length, rotary_union_flange_width,
        rotary_union_flange_clearance,
        flange_chamfer=rotary_union_flange_chamfer,
    );
};

// Rotary union supports
// NOTE: Must be rotated to 45 with the button facing upwards
color("blue")
translate([0, 0, male_length]) {
    for (angle = rotary_union_support_angles) {
        rotate([0, 180, 0])
        translate([0, 0, -rotary_union_length])
        rotate([0, 0, angle])
        rotary_union_45_degree_support(
            rotary_union_inner_diameter, rotary_union_outer_diameter, rotary_union_length,
            rotary_union_flange_radius, rotary_union_flange_length, rotary_union_flange_width,
            rotary_union_flange_clearance,
            rotary_union_support_diameter,
        );
    };
};

// Manual fin support base for rotary union and female connector which auto support from slicer can connect to
// Makes sure that the first layer of the floating part of the rotary union has support underneath it
color("blue")
let (
    midpoint = male_length + rotary_union_length/2,
    flange_offset = rotary_union_flange_radius*2+rotary_union_flange_length+rotary_union_flange_clearance,
    embed_offset = 0.05,
)
// multiple fins to support very dangly underside that auto support refuses to connect to
for (angle = [0, -5, 5]) rotate([0, 0, angle])
translate([
    -rotary_union_outer_diameter/2 + embed_offset,
    0,
    midpoint-flange_offset,
]) {
    rotate([180, 45, 180])
    fin_support(
        female_connector_to_rotary_union_fin_support_length,
        female_connector_to_rotary_union_fin_support_height,
        female_connector_to_rotary_union_fin_support_thickness,
        female_connector_to_rotary_union_fin_support_base,
        female_connector_to_rotary_union_fin_support_angle,
    );
};

// Manual cylindrical supports to connect both halves of the rotary union
color("blue")
let (
    total_angles = 16,
    delta_theta = 360/total_angles,
    support_diameter = female_connector_to_rotary_union_fin_support_thickness,
)
for (support_index = [0:total_angles])
let (angle = support_index*delta_theta)
rotate([0, 0, angle])
translate([
    rotary_union_outer_diameter/2 - support_diameter/2,
    0,
    male_length,
])
cylinder(rotary_union_length, d=support_diameter);


// Screw
color("pink")
translate([0, 0, male_length+rotary_union_length]) {
    hose_connector(
        hose_length,
        hose_inner_diameter, hose_outer_diameter,
        hose_thread_thickness, hose_thread_pitch, hose_thread_depth,
        thread_taper=-hose_thread_taper,
        turn=0.35,
        edge_chamfer=connector_edge_chamfer_width,
    );
};

// Fin support for hose to prevent vibrating off during early print
color("orange")
translate([-hose_outer_diameter/2, 0, male_length+rotary_union_length+hose_length*0.5])
rotate([180, 45, 180]) {
    fin_support(
        connector_base_fin_support_length,
        connector_base_fin_support_height,
        connector_base_fin_support_thickness,
        connector_base_fin_support_base,
        connector_base_fin_support_angle,
    );
};

};

if (show_cross_section)
cube([hose_outer_diameter, hose_outer_diameter, total_height], center=false);

};