// x-axis-symmetric microchannel flow (one quarter of the rotation)

nb = 1;
b1 = 0.05;  // bubble fine
b2 = 0.08;  // bubble coarse
wall = 0.2;

D = 1.0;
r = 0.45*D; //0.3*D; // bubble radius
body = 0.417042*D; //1.88834*D; //
slug = 0.7*r;

yc = 0.0;
zc = 0.0;

For t In {0:nb-1}

 xc = (slug+body+r+r/2.0)*t - 0.06;
 i=100*t;
 j=200*t;
 // include bubble shape file:
 Include '../../bubbleShape/quarterTaylor.geo';
 Physical Surface(Sprintf("bubble%g",t+1)) = {j+6, j+9, j+13};

EndFor

wallLength1 = 2.5*D;
wallLength2 = nb*(body+3*r/2.0)+(nb-1)*slug;
wallLength3 = 1.3*D;
pert = (0.0/100.0)*D/2.0;

k=10000;
Point(k+1) = {-wallLength1,         0.0,         0.0, wall};  // center
Point(k+2) = {-wallLength1,         0.0,  -D/2.0+pert, wall}; // left
Point(k+3) = {-wallLength1, D/2.0+pert,         0.0, wall};   // top

Ellipse(k+1) = {k+2, k+1, k+1, k+3};
Line(k+2) = {k+3, k+1};
Line(k+3) = {k+1, k+2};
Line Loop(k+4) = {k+1, k+2, k+3};

Extrude {wallLength1, 0, 0} {
  Line{k+1, k+3, k+2};
}
Extrude {wallLength2, 0, 0} {
  Line{k+5, k+9, k+13};
}
Extrude {wallLength3, 0, 0} {
  Line{k+17, k+21, k+25};
}

Line Loop(k+54) = {k+29, k+37, k+33};
Plane Surface(k+55) = {k+4};
Plane Surface(k+56) = {k+54};

Physical Surface('wallInflowUParabolic') = {-(k+55), k+56};
Physical Surface('wallNoSlipPressure') = {k+8, k+20, k+32};
Physical Surface('wallNormalV') = {k+12, k+24, k+36};
Physical Surface('wallNormalW') = {k+16, k+28, k+40};

/* Refinement: */

// left region axial:
Transfinite Line {k+6, k+7, k+10} = 23 Using Progression 0.93;
// central region axial:
Transfinite Line {k+18, k+19, k+22} = 30 Using Bump 1.9;
// right region axial:
Transfinite Line {k+30, k+31, k+34} = 14 Using Progression 1.2;
// circumferential at ends of central region:
Transfinite Line {k+5, k+9, k+13, k+17, k+21, k+25} = 17 Using Progression 1;
// circumferential at in- and outlet:
Transfinite Line {k+1, k+2, k+3, k+29, k+33, k+37} = 5 Using Progression 1;
