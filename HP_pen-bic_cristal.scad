// BIC Cristal pen refill (132mm long, 10mm tip)
// HP Plotter pen adapter
//  by Sergiu Partenie
// - insert refill from bottom up
// - cut refill height to fit in pen path of plotter (4mm above top)
// - print with tip facing up and concentric supports 
// - reccomended material: PETg or similar non-brittle

$fn= 180;

// .................. pen_bottom_diameter ............> | | <..  
// :      ........... pen_diam                          | |
// :      :                                             | |
//  ______  ........ top_cut_off_height                 | |
// ||    |                                              | |
// ||    |                                              | |
// ||    |___                                           | |
// ||     __/  ..... ~ 27.7 mm to paper                 | |
// ||    |                                              | |
// ||    |                                              | |
//  |    |                                              | |
//  ++   |           height_where_pen_diameter_change  _|_|_
//   |   |                                             |   | 
//   |   /           pen_bottom_diameter ............> |   | <..
//   | _/                                              |   | 
//   |/   .......... bottom_cut_off_height ........  __|___|__ 
//                                                    \     /   
//                                                     \___/
//                                                      | |
//                                                      \ /
// ------------------ ( paper ) --------------------------*--


total_body_height = 43.25 ; // fixed value. Official HP pen max height
pen_diam = 11.63 ; // official=11.5, HP pens=11.6. Adjust for filament shrinkage
pen_top_diameter = 3 ; // width of top pen hole
pen_bottom_diameter = 4.03 ; // width of bottom (tip) pen hole. Should be a tight (but removable) fit

diameter_spacing = 0.05 ; // increase = easier to slide the pen. If you set it to 0 it will be very hard to get the pen in.

height_where_pen_diameter_change = 20 ; // Measured from the tip (ie. paper)
bottom_cut_off_height = 9.77; // Measured from the tip (ie. paper)
top_cut_off_height = total_body_height - 4 ; // Top part of the pen, lower to allow handling refill tube 

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

  // top pen hole (a bit larger than thicknes of refill tube)
  color ("red") translate([0,0,height_where_pen_diameter_change])
   cylinder(r= (pen_top_diameter+diameter_spacing+0.5)/2, h= 100);

  // bottom pen hole (thickness of tip)
  color ("blue") translate([0,0,bottom_cut_off_height-diameter_spacing])
   cylinder(r=(pen_bottom_diameter+diameter_spacing)/2,h=height_where_pen_diameter_change-bottom_cut_off_height+2*diameter_spacing);

  // bottom (tip) cut-off line
  translate ([0, 0, bottom_cut_off_height/2]) 
   cube ([20, 20, bottom_cut_off_height], center=true) ;

  // top cut-off line
  translate ([0, 0, 50/2 + top_cut_off_height]) 
   cube ([20, 20, 50], center=true) ;
    }
}

// to hold refill tube in place while also allowing easy replacement
//  if refill tube is moving freely it creates incorrect draw paths 
module guide() {
 translate([pen_top_diameter/2,-1.8,height_where_pen_diameter_change])
    cylinder(d=1.64,h=top_cut_off_height-height_where_pen_diameter_change);
}

difference(){
 union(){
  adapter_minus_pen() ;
  guide();
  rotate([0,0,60]) guide();
  rotate([0,0,120]) guide();
  rotate([0,0,180]) guide();
  rotate([0,0,240]) guide();
  rotate([0,0,300]) guide();
 }
 
 // transition taper between top and bottom holes
 color ("violet") 
  translate([0,0,height_where_pen_diameter_change-diameter_spacing])
   cylinder(r1=(pen_bottom_diameter+diameter_spacing)/2,r2=pen_top_diameter,h=2);
}