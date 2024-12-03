include <BOSL2/std.scad>

/* [plate settings] */

plate_diameter = 20;
plate_thickness = 2;

plate_inner_diameter = 3.8;
plate_inner_length = 12.75;
plate_inner_circle_diameter = 5;

// things below this won't show up in the customizer
module __Customizer_Limit__() {
}

// set quality, 64 for testing, 128 for rendering
$fn = $preview ? 64 : 128;

tolerance_tight = 0.125;
tolerance_normal = 0.25;

module plate() {
  difference() {

    linear_extrude(plate_thickness, center = true)
      difference() {
        // base plate
        circle(d = plate_diameter);

        // center hole for the shaft
        circle(d = plate_inner_circle_diameter);

        // elongated circle cutout
        hull()
          mirror_copy([1, 0, 0])
            xmove(plate_inner_length / 2)
              xmove(-plate_inner_diameter / 2)
                circle(d = plate_inner_diameter);
      }

    mirror_copy([0, 0, 1])
      zmove(plate_thickness / 2)
        rounding_cylinder_mask(d = plate_diameter, rounding = 0.5);
  }
}

plate();
