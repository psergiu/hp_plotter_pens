// Gel pen refill (128mm long, 7mm tip)
// HP Plotter pen adapter
//  by Sergiu Partenie
// - insert refill from top down
// - cut refill height to fit in pen path of plotter
// - print with tip facing up and concentric supports 

$fn= 180;

//                    refill_diam_tube ...............> |   | <..
//    ............... refill_diam_b ...............     |   |  
//    :   ........... pen_diam                    :     |   |
//    :   :                                       :     |   |
//     ____  ........ top_cut_off_height          :     |   |
//    /   |                                       :     |   |
//    |   |                                       :     |   |
//    |   |___                                    :     |   |
//    |    __/  ..... ~ 27.7 mm to paper          :     |   |
//    |   |                                       :     |   |
//    |   |                                       :     |   |
//    |   |                                       :     |   |
//    |   |                                       :     |   |
//    |   |                                       :.> __|___|__ <..
//  +-+   /   ....... refill_height_b ............... |_______|
//  |   _/                                              |   |
//  |  /              refill_diam_a ..................> |   | <....
// ++ /    .......... refill_height_a ..................\___/   
// | /                refill_diam_tip .................> | | <.....
// -'   ............. bottom_cut_off_height              | |
//                                                       \ /
// ------------------ ( paper ) --------------------------*--

total_body_height = 43.25 ; // fixed value, Official HP pen max height
pen_diam = 11.63 ; // official=11.5, HP pens=11.6. Adjust for filament shrinkage
bottom_cut_off_height = 4; // Measured from the tip (ie. paper)
top_cut_off_height = total_body_height - 4 ; // Top part of the pen, shorten

refill_diam_tip = 2.3 ; // width of bottom (tip) pen hole. Should be a tight (but removable) fit
refill_height_a = 7 ; // distance from paper where metal tip enters plastic tube 
refill_diam_a = 3.25; // diameter of plastic tube holding metal tip
refill_height_b = 13.76 ; // (0.16mm x 86 layers) Measured from the tip (ie. paper) to bottom of refill flange
refill_diam_b = 5.65 ; // width of the refill flange
refill_diam_tube = 4 ; // width of long refill tube

diameter_spacing = 0.05 ; // increase = easier to slide the refill. If you set it to 0 it will be very hard to get the refill in.

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

module adapter_minus_refill()
{
 difference()
  {
   color ("white", 0.2) adapter_body () ;

   // top pen hole
   color ("red")
    translate([0,0,refill_height_b])
     cylinder(d=refill_diam_b+diameter_spacing*2, h=100);

   // bottom pen hole
   color ("blue")
    translate([0,0,bottom_cut_off_height-diameter_spacing])
     cylinder(d=refill_diam_tip+diameter_spacing,h=refill_height_b-bottom_cut_off_height+2*diameter_spacing);

   // bottom (tip) cut-off line
   translate ([0, 0, bottom_cut_off_height/2]) 
    cube ([20, 20, bottom_cut_off_height], center=true) ;

   // top cut-off line
   translate ([0, 0, 50/2 + top_cut_off_height]) 
    cube ([20, 20, 50], center=true) ;

   // transition for easier refill insertion - bottom
   color ("violet")
    translate([0,0,refill_height_a-0.5])
     cylinder(d1=refill_diam_tip+diameter_spacing,d2=refill_diam_a,h=0.51);
  
   // tapered hole for plastic tube
   color ("blue") 
    translate([0,0,refill_height_a])
     cylinder(d1=refill_diam_a,d2=refill_diam_a+0.1,h=refill_height_b-refill_height_a+0.1);
     
   // transition for easier refill insertion - middle  
   color ("violet")
    translate([0,0,refill_height_b-0.5])
     cylinder(d1=refill_diam_a,d2=refill_diam_a+0.5,h=0.51);

   // transition for easier refill insertion - top   
   color ("violet")
    translate([0,0,top_cut_off_height-1])
     cylinder(d1=refill_diam_b,d2=refill_diam_b+1,h=1.1);
  }
}


// adapter
difference()
 {
  union()
   {
    adapter_minus_refill() ;
    // optional parts to add
   }
  // debug section view, comment out for final print
  // cube([20,20,100]);
 }


// refill stopper
translate([50,0,0])
 difference()
  {
    union()
     {
       // bottom flange
       cylinder(d=pen_diam, h=1);
       // stopper body, tapered
       cylinder(d1=refill_diam_b,d2=refill_diam_b-diameter_spacing-0.1,h=1+top_cut_off_height-refill_height_b-1.5);
     }

    // cuts in the stopper body 
    for(i=[0:60:120])
      translate([0,0,(top_cut_off_height-refill_height_b)/2+3.5])
       rotate([0,0,i])
        cube([10,0.5,top_cut_off_height-refill_height_b],center=true);

    // hole for refill tube, tapered
    cylinder(d1=refill_diam_tube+diameter_spacing,d2=refill_diam_tube+diameter_spacing+0.1,h=top_cut_off_height-refill_height_b+1);
  }
  
 