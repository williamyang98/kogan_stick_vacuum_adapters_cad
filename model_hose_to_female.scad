// test file to check if parts fit correctly with sufficient tolerances
include <measurements.scad>
use <female_connector.scad>
use <latch_button.scad>
use <latch_button_enclosure.scad>
use <hose_connector.scad>
use <rotary_union.scad>
use <rotary_union_support.scad>

// Hose adapter for stick vacuum
// Measurements are in millimeters (mm)
$fn = 72*2; // fragment number for number of faces on axial objects


show_adapter = true;
show_button = true;
bridge_length = 10;

// Hose
if (show_adapter) {
    color("pink")
    rotate([0, 180, 0])
    translate([0, 0, -hose_length]) {
        hose_connector(
            hose_length,
            hose_inner_diameter, hose_outer_diameter,
            hose_thread_thickness, hose_thread_pitch, hose_thread_depth,
            turn=0.35,
            edge_chamfer=connector_edge_chamfer_width,
        );
    };
};


// Bridge
if (show_adapter) {
    color("green")
    translate([0, 0, hose_length]) {
        difference() {
            cylinder(bridge_length, d1=hose_outer_diameter, d2=female_outer_diameter);
            cylinder(bridge_length, d1=hose_inner_diameter, d2=male_inner_diameter);
        };
    };
};

// Rotary union
if (show_adapter) {
    color("yellow")
    translate([0, 0, hose_length + bridge_length]) {
        difference() {
            rotary_union(
                male_inner_diameter, female_outer_diameter, rotary_union_length,
                rotary_union_flange_radius, rotary_union_flange_length, rotary_union_flange_width,
                rotary_union_flange_clearance,
                flange_chamfer=rotary_union_flange_chamfer,
            );
            translate([0, 0, rotary_union_length-connector_edge_chamfer_width]) {
                cylinder(
                    connector_edge_chamfer_width, 
                    d1=male_inner_diameter,
                    d2=male_inner_diameter+2*connector_edge_chamfer_width,
                );
            };
        };
        
    };
}

// Rotary union supports
// NOTE: Must be rotated to 45 with the button facing upwards
if (show_adapter) {
    color("blue")
    rotate([0, 0, 180]) // supports are on other side of button
    translate([0, 0, hose_length + bridge_length]) {
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
}


// Female connector
translate([0, 0, hose_length + bridge_length + rotary_union_length]) {
    if (show_adapter) {
        color("red")
        female_connector(
            female_inner_length, female_hole_length, female_outer_length,
            female_inner_diameter, female_outer_diameter,
            female_notch_width, female_notch_length,
            female_hole_width,
            hole_chamfer=female_hole_chamfer_length, edge_chamfer=connector_edge_chamfer_width,
        );
    };


    translate([
        female_outer_diameter/2 + button_total_height/2 + button_to_female_clearance,
        0,
        male_inner_length + button_length/2,
    ]) {
        // Button
        if (show_button) {
            color("blue")
            latch_button(
                button_width, button_length, button_thickness,
                button_axle_inner_diameter, button_axle_outer_diameter,
                button_latch_length, button_latch_depth, button_latch_inner_diameter, button_latch_outer_diameter,
                latch_clearance=button_latch_to_male_clearance,
                hinge_length=button_hinge_length, hinge_skew=button_hinge_elevation,
            );
        };

        // Button enclosure 
        if (show_adapter) {
            color("orange")
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

