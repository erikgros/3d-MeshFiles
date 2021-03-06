// microchannel flow using moving frame

nb = 1;
b1 = 0.03;  // bubble fine
b2 = 0.05;  // bubble coarse
wall = 0.16;

D = 1.0;
r = 0.3*D; //0.45*D; // bubble radius
body = 1.88834*D; //0.417042*D;
slug = 0.7*r;

yc = 0.0;
zc = 0.0;
For t In {0:nb-1}

 xc = (slug+body+r+r/2.0)*t - 0.06;
 i=100*t;
 j=200*t;
 // include bubble shape file:
 Include '../../bubbleShape/taylor.geo';
 Physical Surface(Sprintf("bubble%g",t+1)) = {j+40,-(j+10), -(j+30), j+20, j+36, j+16, -(j+33), -(j+13), -(j+26), j+43, j+23, -(j+46)};

EndFor

wallLength1 = 2.5*D;
wallLength2 = nb*(body+3*r/2.0)+(nb-1)*slug;
wallLength3 = 1.3*D;
pert = (0.0/100.0)*D/2.0;

k=10000;
Point(k+1) = {-wallLength1,         0.0,         0.0, wall}; // center
Point(k+2) = {-wallLength1,         0.0,  D/2.0+pert, wall}; // right
Point(k+3) = {-wallLength1,         0.0, -D/2.0-pert, wall}; // left
Point(k+4) = {-wallLength1,  D/2.0-pert,         0.0, wall}; // up
Point(k+5) = {-wallLength1, -D/2.0+pert,         0.0, wall}; // down
Ellipse(k+1) = {k+4, k+1, k+1, k+2};
Ellipse(k+2) = {k+2, k+1, k+1, k+5};
Ellipse(k+3) = {k+5, k+1, k+1, k+3};
Ellipse(k+4) = {k+3, k+1, k+1, k+4};
Line Loop(k+5) = {k+1, k+2, k+3, k+4};

Extrude {wallLength1, 0, 0} {
  Line{k+01, k+04, k+03, k+02};
}
Extrude {wallLength2, 0, 0} {
  Line{k+18, k+06, k+10, k+14};
}
Extrude {wallLength3, 0, 0} {
  Line{k+26, k+30, k+34, k+22};
}
/*
arr[]= ...{};
sizeA=#arr[];
Printf("Extrusion 1 (size = %g):",sizeA);
For ii In {1:sizeA}
 Printf("%g",arr[ii-1]);
EndFor
*/

Line Loop(k+54) = {k+38, k+50, k+46, k+42};
Plane Surface(k+55) = {k+54};
Plane Surface(k+56) = {k+05};

Physical Surface('wallInflowUParabolic') = {k+55, -(k+56)};
Physical Surface('wallNoSlipPressure') = {k+9, k+13, k+17, k+21, k+53, k+41, k+45, k+49, k+33, k+25, k+29, k+37};

/* Refinement: */

// left cylinder axial:
Transfinite Line {k+8, k+15, k+7, k+11} = 25 Using Progression 0.95;
// central cylinder axial:
Transfinite Line {k+27, k+24, k+31, k+23} = 58 Using Bump 1.9;
// right cylinder axial:
Transfinite Line {k+40, k+47, k+39, k+43} = 16 Using Progression 1.1;
// circumferential at ends of central cylinder:
Transfinite Line {k+06, k+18, k+10, k+14, k+26, k+22, k+34, k+30} = 17 Using Progression 1;
// circumferential at in- and outlet:
Transfinite Line {k+01, k+04, k+03, k+02, k+38, k+42, k+46, k+50} = 6 Using Progression 1;
