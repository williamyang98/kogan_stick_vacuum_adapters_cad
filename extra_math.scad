// calculate radius r of sphere that will leave this indent of width w and depth d
// R = r - d
// r^2 = R^2 + (w/2)^2
// r^2 = r^2 - 2rd + d^2 + (w/2)^2
// 2rd = d^2 + w^2/4
// r = d/2 + w^2/8d
function calculate_sphere_radius_from_indent(
    width, depth
) = depth/2 + width^2/(8*depth);


// determine additional depth 'd' for flat surface of width 'w' to wrap around a cylinder of radius 'r'
// if the width 'w' is greater than the diameter of the cylinder '2r', the depth is just the radius 'r'
// s^2 = (w/2)^2 + d^2
// s^2 = w^2/4 + d^2
// tan(theta) = d/(w/2) = 2d/w
// alpha = 90-theta
// 2*alpha + beta = 180
// 180-2*theta + beta = 180
// theta = beta/2
// tan(beta/2) = (s/2)/sqrt(r^2 - s^2/4) = s/sqrt(4r^2 - s^2)
// since tan(theta) = tan(beta/2)
// 2d/w = s/sqrt(4r^2 - s^2)
// 4d^2/w^2 = s^2/(4r^2 - s^2)
// 16 r^2 d^2 - 4 s^2 d^2 = w^2 s^2
// s^2 (w^2 + 4d^2) = 16 r^2 d^2
// s^2 = (16 r^2 d^2)/(w^2 + 4 d^2)
// substitute into pythag
// 16 r^2 d^2 = (w^2/4 + d^2) * (w^2 + 4d^2)
// 64 r^2 d^2 = (w^2 + 4d^2)^2
// 8rd = w^2 + 4d^2
// 4d^2 - 8rd + w^2 = 0
// d^2 - 2rd = -w^2/4
// d^2 - 2rd + r^2 - r^2 = -w^2/4
// (d-r)^2 = r^2 - w^2/4
// d = r - sqrt(r^2 - w^2/4) // take shorter distance
function calculate_surface_overflow_onto_cylinder(
    radius, width
) = radius - sqrt(max(radius^2 - width^2/4, 0));
