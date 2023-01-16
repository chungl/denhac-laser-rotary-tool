roller_d=22.7;
roller_gap=17;
frame_w=10;

screw_d=4;
screw_slot_w=4;

snap_undersize=4;
snap_oversize=2;
snap_relief_w=3;
snap_relief_h=frame_w/2;

t=1;

NOTHING=0;
CUT_T = t + 2*NOTHING;

$fn=100;

bracket_w=roller_gap + 2*roller_d + 2*frame_w;
bracket_h= roller_d + 2*frame_w;

module bracket() {
    difference() {
        cube([bracket_w, bracket_h, t]);
        translate([frame_w + roller_d/2, frame_w + roller_d/2, -NOTHING]) roller_cut();
        translate([frame_w + 3*roller_d/2 + roller_gap, frame_w + roller_d/2, -NOTHING]) roller_cut();
    }
}

module roller_cut() {
    union() {
        cylinder(d=roller_d, h=CUT_T);
        translate([roller_d/2, 0, 0]) screw_slot();
        rotate([0,0,180]) translate([roller_d/2, 0, 0]) screw_slot();
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
        cylinder(d=screw_d, h=CUT_T);
        translate([screw_slot_w, 0, 0]) cylinder(d=screw_d, h=CUT_T);
        translate([0,-screw_d/2, 0]) cube([screw_slot_w, screw_d, CUT_T]);
    }
}

module screw_slot() {
    oval(d=screw_d, w=screw_slot_w, t=CUT_T);
}


bracket();
