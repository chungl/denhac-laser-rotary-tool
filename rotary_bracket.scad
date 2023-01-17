roller_d=22.7;
roller_gap=18.6;

frame_w=20;

screw_d=3.2;
screw_slot_w=8;
screw_separation=31.5;
nut_hex_od=6;

snap_undersize=2;
snap_oversize=2;
snap_relief_w=3;
snap_relief_h=frame_w-7;

t=1;
text_depth=.1;

version="V0.5";

NOTHING=0.1;
CUT_T = t + 2*NOTHING;

$fn=100;

bracket_w=roller_gap + 2*roller_d + 2*frame_w;
bracket_h= roller_d + 2*frame_w;

module bracket() {
    difference() {
        cube([bracket_w, bracket_h, t]);
        translate([frame_w + 3*roller_d/2 + roller_gap, frame_w + roller_d/2, -NOTHING]) roller_cut();
        translate([bracket_w/2,0, 0]) mirror([1,0,0]) translate([roller_gap/2 + roller_d/2, frame_w + roller_d/2, -NOTHING]) roller_cut();
    }
}

module roller_cut() {
    union() {
        cylinder(d=roller_d, h=CUT_T);
        translate([roller_d/2, 0, 0]) screw_slot();
        // rotate([0,0,180]) translate([roller_d/2, 0, 0]) screw_slot();
        translate([-screw_separation/2, 0, 0]) cylinder(d=screw_d, h=CUT_T);
        snap();
    }
}

module snap() {
   union() {
        hull() {
            cylinder(d=roller_d - snap_undersize, h=CUT_T);
            translate([0, -bracket_h/2, 0]) cylinder(d=roller_d + snap_oversize, h=CUT_T);
        }
        translate([0, (roller_d - snap_undersize)/2, 0]) snap_relief();
    }
}

module snap_relief() {
    rotate([0,0,90]) oval(d=snap_relief_w, w=snap_relief_h+snap_undersize/2, t=CUT_T);
}

module oval(d, w, t) {
    union() {
        cylinder(d=d, h=t);
        translate([w, 0, 0]) cylinder(d=d, h=t);
        translate([0,-d/2, 0]) cube([w, d, t]);
    }
}

module screw_slot() {
    union() {
        oval(d=screw_d, w=screw_slot_w, t=CUT_T);
        translate([(screw_separation-roller_d)/2,0,0]) rotate([0,0,30]) cylinder(d=nut_hex_od, h=CUT_T, $fn=6);
    }
}


module laser_svg() {
    difference() {
        projection() bracket();
        translate([bracket_w/2, bracket_h-2, 0]) text("https://github.com/chungl/denhac-laser-rotary-tool", font = "Liberation Sans", valign="top", halign="center", size=2);
        translate([bracket_w/2, bracket_h-8, 0]) text(version, font = "Liberation Sans", valign="top", halign="center", size=2);
    }
}

laser_svg();
