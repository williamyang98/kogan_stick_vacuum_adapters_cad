module fin_support(length, height, thickness, base, angle) {
    assert(angle >= 0, "Fin angle must be positive");
    // fin supports surface at [0,0,0]
    angled_fin_height = length*tan(angle);
    
    union() {
        // angled fin
        rotate([90, 0, 0]) {
            linear_extrude(thickness, center=true) {
                polygon([
                    [-angled_fin_height/2, -length/2],
                    [ angled_fin_height/2, -length/2],
                    [ angled_fin_height/2,  length/2],
                ]);
            };
        };
        
    
        // fin body
        translate([0, 0, -angled_fin_height/2-height/2]) {
            cube([length, thickness, height], center=true);
        };
        // fin base
        translate([0, 0, -angled_fin_height/2-height+thickness/2]) {
            cube([length, base, thickness], center=true);
        };
    };
}