// Hose adapters for Kogan stick vacuum
//// Measurements are in millimeters (mm)

//// Customisable
// Dimensional adjustments
hose_thread_total_turns = 6;
female_outer_diameter_reinforcement = 1;
button_enclosure_screw_support_thickness = 1.5;
connector_chamfer_width = 0.5; // prevent connector edges from being sharp
// Clearances and tolerances
female_notch_length_clearance = 0.25;
female_notch_width_clearance = 0.5;
female_inner_diameter_clearance = 0.5;
female_hole_width_clearance = 1;
female_hole_length_clearance = 1;
button_to_female_clearance = 0.5;
button_latch_clearance = 0.25;
button_enclosure_clearance = 0.5; // perimeter around button

//// Measurements
// M.2 thread
m2_inner_diameter = 2;
m2_head_diameter = 4;
m2_head_height = 1.5;
// Male connector
male_outer_length = 20;
male_neck_length = 7;
male_inner_length = 10;
male_outer_diameter = 34;
male_neck_diameter = 31;
male_wall_diameter = 38.5;
male_inner_diameter = 29;
male_notch_width = 3;
male_notch_length = 4;
// Hose
hose_thread_thickness = 2.5;
hose_thread_pitch = 4.5;
hose_thread_depth = 3-1; // 3mm thickness for entire hose, 1mm for membrane connecting threads
// hose_outer_diameter = 33;
hose_outer_diameter = male_wall_diameter; // make it extra thicc
hose_inner_diameter = 26;
// Female connector
female_hole_length = 6;
// Button on female connection for latch
button_length = 32;
button_width = 15;
button_thickness = 3;
button_hinge_length = 8;
button_hinge_elevation = 5;
button_axle_inner_diameter = m2_inner_diameter + 0.25; // m.2 nut
button_axle_outer_diameter = 5.25;


//// Derived parameters
// Male connector
male_length = male_outer_length + male_neck_length + male_inner_length;
// Hose
hose_thread_length = hose_thread_total_turns*hose_thread_pitch;
hose_length = hose_thread_length +  hose_thread_thickness;
// Female connector
female_notch_length = male_notch_length + female_notch_length_clearance;
female_notch_width = male_notch_width + female_notch_width_clearance;
female_inner_diameter = male_outer_diameter + female_inner_diameter_clearance;
female_outer_diameter = male_wall_diameter + female_inner_diameter_clearance + female_outer_diameter_reinforcement;
female_hole_width = button_width + female_hole_width_clearance;
female_inner_length = male_inner_length;
female_outer_length = male_outer_length + male_neck_length - female_hole_length;
female_length = female_inner_length + female_hole_length + female_outer_length;
// Button on female connection for latch
button_total_height = button_thickness + button_hinge_elevation;
button_latch_length = female_hole_length;
button_latch_depth = button_to_female_clearance + (female_outer_diameter - male_neck_diameter)/2 - button_latch_clearance;
button_latch_inner_diameter = male_neck_diameter;
button_latch_outer_diameter = female_outer_diameter;
// Enclosure
button_enclosure_depth = button_total_height + button_to_female_clearance*2;
button_enclosure_thickness = m2_head_height + button_enclosure_screw_support_thickness;