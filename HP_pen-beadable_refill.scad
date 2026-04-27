// Beadable pen refill (62mm long, 44mm tip-to-end-of-ink)
// HP Plotter pen adapter 
//  by Sergiu Partenie
// - insert refill from top down
// - cut refill height to fit in pen path of plotter
// - print with tip facing up and concentric supports
// - reccomended material: PETg or similar non-brittle

$fn= 180;

//    ..............., pen_top_diameter ...............> |   | <,,  
//    :    ........... pen_diam                          |   |
//    :    :                                             |   |
//     _____  ........ top_cut_off_height                |   |
//    ||   |                                             |   |
//    ||   |                                             |   |
//    ||   |___                                          |   |
//    ||    __/  ..... ~ 27.7 mm to paper                |   |
//    ||   |                                             |   |
//    ||   |                                             |   |
//    ||   |                                             |   |
//    ||   |                                             |   |
//     |   |                                             [   ]
//     | . /  .........wiew_hole_height                  |   |
//   +-+ _/ .......... height_where_pen_diameter_change. \___/
//   |  /                                                 | | 
//   | /  ............ tip_height                         | |   
//   //                pen_bottom_diameter..............> | | <...
//  /'   ............. bottom_cut_off_height              | |
//                                                        \ /
// ------------------- ( paper ) --------------------------*--


total_body_height = 43.25 ; // fixed value, Official HP pen max height
pen_diam = 11.63 ; // official=11.5, HP pens=11.6. Adjust for filament shrinkage
pen_top_diameter = 4.35 ; 
pen_bottom_diameter = 3.25 ; 
tip_height = 2 ; // top of cone to squeeze metal tip for perfectly centered fit
pen_tip_diameter = 0 ; // adjust to enlarge metal tip squeeze cone. Default: 0

diameter_spacing = 0.05 ; // increase = easier to slide the pen. If you set it to 0 it will be very hard to get the pen in.

height_where_pen_diameter_change = 21.7 ; // Measured from the tip (ie. paper)
bottom_cut_off_height = height_where_pen_diameter_change - (22-5) ; 
top_cut_off_height = total_body_height - 4 ; // Top part of the pen, lower to allow handling refill tube

wiew_hole_height = 13.5 ; // height of view hole (for visually checking if refill is spent)

BodyOutline = [                     // X values = (measured diameter)/2, Y as distance from
    [0.0,0.0],                      //  0 fiber pen tip
//  [2.0/2,1.4],                    //  1 ... taper (not buildable)
    [1.0/2,0.005],                  //  1 ... faked point to remove taper
    [2.0/2,0.0],[2.0/2,2.7],        //  2 ... cylinder
    [3.7/2,2.7],[3.7/2,4.45],       //  4 tip surround
    [4.8/2,5.2],                    //  5 chamfer
    [6.6/2,10.2],                   //  6 seal seat    
    [6.4/2,11.8],                   //  7 rubber seal face
    [8.9/2,11.8],                   //  8 cap seat
    [pen_diam/2,15.9],              //  9 taper to body
    [pen_diam/2,28.0],              // 10 lower body
    [13.2/2,28.0],[16.6/2,28.5],    // 11 lower flange = 0.5
    [16.6/2,29.5],[13.2/2,30.0],    // 13 flange rim = 1.0
    [pen_diam/2,30.0],              // 15 upper flange = 0.5
    [pen_diam/2,43.25],             // 16 upper body
    [0.0,43.25]                     // 17 lid over reservoir
    ];

module adapter_body() {
 render(convexity=10)
        rotate_extrude()
            polygon(points=BodyOutline);
}

module adapter_minus_pen() {
    difference() {
        color ("white", 0.2) adapter_body () ;

        color ("red") translate([0,0,height_where_pen_diameter_change])
                    cylinder(r= (pen_top_diameter+diameter_spacing)/2, 
                             h= 100);

         color ("blue") translate([0,0,bottom_cut_off_height+tip_height])
                            cylinder(r=(pen_bottom_diameter+diameter_spacing)/2, 
                                 h=height_where_pen_diameter_change);

         // conical taper to squeeze metal refill tip
         color ("violet") translate([0,0,0.5]) cylinder(r1=(pen_tip_diameter+diameter_spacing)/2,
                                   r2=(pen_bottom_diameter+diameter_spacing)/2,
                                h=bottom_cut_off_height+tip_height);

        translate ([0, 0, bottom_cut_off_height/2]) 
            cube ([20, 20, bottom_cut_off_height], center=true) ;

        translate ([0, 0, 50/2 + top_cut_off_height]) 
            cube ([20, 20, 50], center=true) ;
    }
}

// to hold refill tube in place while also allowing easy replacement
//  if refill tube is moving freely it creates incorrect draw paths 
module guide() {
 translate([pen_bottom_diameter/2,-1.8,height_where_pen_diameter_change])
    cylinder(d=1.8,h=top_cut_off_height-height_where_pen_diameter_change);
}

union(){
 difference(){
  adapter_minus_pen();
  // sideways hole for visual inspection of ink level
  rotate([90,0,0])
    translate([0,wiew_hole_height,0])
     cylinder(d=1.5, h=12, center=true);
 }
 guide();
 rotate([0,0,60]) guide();
 rotate([0,0,120]) guide();
 rotate([0,0,180]) guide();
 rotate([0,0,240]) guide();
 rotate([0,0,300]) guide();
}
