// Hose adapter for stick vacuum
// Measurements are in millimeters (mm)


// Key for stick vacuum
// measured parameters
key_outer_length = 20;
key_notch_length = 7;
key_inner_length = 10;
key_outer_diameter = 34;
key_notch_diameter = 31;
key_wall_diameter = 38.5;
key_inner_diameter = 29;
key_latch_width = 3;
key_latch_length = 4;
// derived parameters
key_notch_depth = (key_outer_diameter-key_notch_diameter)/2;
key_wall_height = (key_wall_diameter-key_outer_diameter)/2;
key_length = key_outer_length + key_notch_length + key_inner_length;

// Screw for hose
// measured parameters
screw_thickness = 2.5;
screw_pitch = 4.5;
// screw_outer_diameter = 33;
screw_outer_diameter = key_wall_diameter; // make it extra thicc
screw_inner_diameter = 26;
screw_depth = 3-1;
screw_total_turns = 6;
screw_thread_length = screw_total_turns*screw_pitch;
screw_length = screw_thread_length +  screw_thickness;

// M.2 thread
m2_inner_diameter = 2;
m2_head_diameter = 4;
m2_head_height = 1.5;

// Button for latch
// measured parameters
button_length = 32;
button_width = 15;
button_thickness = 3;
button_hinge_length = 8;
button_hinge_elevation = 5;
button_axle_inner_diameter = m2_inner_diameter + 0.25; // m.2 nut
button_axle_outer_diameter = 5.25;
button_clearance = 0.5;
button_latch_clearance = 0.25;

// Latch for stick vacuum
// measured parameters
latch_insertion_clearance = 0.25;
latch_insertion_depth = key_latch_length + latch_insertion_clearance;
latch_insertion_cutout_width = key_latch_width + 0.5;
latch_inner_diameter_clearance = 0.5;
latch_inner_diameter = key_outer_diameter + latch_inner_diameter_clearance;
latch_outer_diameter = key_wall_diameter + latch_inner_diameter_clearance + 1;
latch_lock_cutoff_width_clearance = 1;
latch_lock_cutoff_length_clearance = 1;
latch_lock_cutoff_width = button_width + latch_lock_cutoff_width_clearance;
latch_lock_cutoff_length = 6;
// derived parameters
latch_insertion_height = (latch_outer_diameter-latch_inner_diameter)/2;
latch_inner_length = key_inner_length;
latch_outer_length = key_outer_length + key_notch_length - latch_lock_cutoff_length;
latch_total_length = latch_inner_length + latch_lock_cutoff_length + latch_outer_length;

// derived parameters
button_volume_height = button_thickness + button_hinge_elevation;
button_lock_tab_length = (button_length - button_hinge_length)/2;
button_press_tab_length = button_length - button_hinge_length - button_lock_tab_length;
button_latch_length = latch_lock_cutoff_length;
button_latch_depth = button_clearance + (latch_outer_diameter - key_notch_diameter)/2 - button_latch_clearance;
button_latch_inner_diameter = key_notch_diameter;
button_latch_outer_diameter = latch_outer_diameter;

// measured parameters
button_enclosure_depth = button_volume_height + button_clearance*2;
button_enclosure_clearance = 0.5;
button_enclosure_thickness = m2_head_height + 1.5;