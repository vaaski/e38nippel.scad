include <BOSL2/std.scad>

render_part = "combined";// [combined, plate, screw]

/* [plate parameters] */

plate_diameter = 20;
plate_thickness = 2;
plate_rounding = 0.5;

plate_inner_diameter = 3.8;
plate_inner_length = 12.75;
plate_inner_circle_diameter = 5;

/* [screw head parameters] */

screw_head_diameter = 19;
screw_head_thickness = 3.6;
screw_head_slot_depth = 1.8;
screw_head_slot_width = 1.8;
screw_head_rounding = 1;

/* [screw shaft parameters] */

screw_shaft_diameter = 5;
screw_shaft_lower_length = 7.3;
screw_shaft_ledge_height = 1.5;
screw_shaft_ledge_diameter = 5.6;
screw_shaft_upper_length = 12;

screw_top_length = 12;
screw_top_diameter_x = 2.9;
screw_top_diameter_y = 3.9;

// things below this won't show up in the customizer
module __Customizer_Limit__() {
}

// set quality, 64 for testing, 128 for rendering
$fn = $preview ? 64 : 128;

tolerance_tight = 0.125;
tolerance_normal = 0.25;

module plate() {
  zmove(plate_thickness / 2)
    difference() {
      linear_extrude(plate_thickness, center = true)
        difference() {
          // base plate
          circle(d = plate_diameter);

          // center hole for the shaft
          circle(d = plate_inner_circle_diameter);

          // elongated circle cutout
          hull()
            xflip_copy()
              xmove(plate_inner_length / 2)
                xmove(-plate_inner_diameter / 2)
                  circle(d = plate_inner_diameter);
        }

      mirror_copy([0, 0, 1])
        zmove(plate_thickness / 2)
          rounding_cylinder_mask(d = plate_diameter, rounding = plate_rounding);
    }
}

module screwhead() {
  diff() {
    // main head
    cyl(d = screw_head_diameter, h = screw_head_thickness, anchor = BOTTOM) {
      attach(TOP)
        rounding_cylinder_mask(d = screw_head_diameter, rounding = screw_head_rounding);

        // slot
      tag("remove")
        attach(TOP, overlap = -0.001)
          cube([screw_head_diameter, screw_head_slot_width, screw_head_slot_depth], anchor = TOP + CENTER);
    }
  }
}

module screw_shaft() {
  diameter = screw_shaft_diameter - tolerance_tight;
  // lower shaft
  cyl(h = screw_shaft_lower_length, d = diameter, anchor = BOTTOM) {
    attach(TOP)
      // shaft ledge
      cyl(h = screw_shaft_ledge_height, d1 = screw_shaft_ledge_diameter, d2 = diameter, anchor = BOTTOM) {
        diff()
          // upper shaft
          cyl(h = screw_shaft_upper_length, d = diameter, anchor = BOTTOM) {
            attach(TOP)
              // wide key part thing
              xcyl(h = screw_top_length, d = screw_top_diameter_x, anchor = TOP, rounding = screw_top_diameter_x / 2);

              // rounding along Y-axis
            yflip_copy()
              attach(TOP)
                rounding_edge_mask(l = screw_top_length, r = diameter / 2, orient = RIGHT, anchor = BACK);
          }
      }
  }
}

module screw() {
  union() {
    screw_shaft();

    zrot(90)
      xrot(180)
        screwhead();
  }
}


if (render_part == "combined") {
  screw();

  zmove(3)
    color("#333")
      plate();
} else if (render_part == "plate") {
  plate();
} else if (render_part == "screw") {
  screw();
}