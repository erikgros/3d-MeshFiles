//// x-axis-symmetric microchannel flow ////
/*
 * Because of the symmetry in y-and z-direction,
 * we only need one quarter of the domain (x, y, z s.t. y > 0, z < 0).
 * 1 Taylor bubble.
*/
D = 1.0;  // channel diameter

b1 = 0.02;  // bubble fine
b2 = 0.025;  // bubble coarse

/* defining bubble shape: */

r = 0.45*D; //0.3*D; // bubble radius
body = 0.417042*D; //1.88834*D;

// bubble left-end coordinates:
xc = 0.0; yc = 0.0; zc = 0.0;

/*  defining:
 *              5           2
 *              o --------- o
 *            /              `,
 *          6 o o 4       1 o  o 3
 *
 *    in the z=zc plane and then rotating...
 */

Point(1) = {xc+r+body, yc, zc, b1};   // center
Point(2) = {xc+r+body, yc+r, zc, b1}; // top
Point(3) = {xc+r+body+r, yc, zc, b2}; // ext
Point(4) = {xc+r, yc, zc, b1};        // center
Point(5) = {xc+r, yc+r, zc, b1};      // top
Point(6) = {xc, yc, zc, b2};          // ext

Ellipse(1) = {3, 1, 1, 2};
Ellipse(2) = {5, 4, 4, 6};
l1 = newl; Line(l1) = {5, 2};
l2 = newl; Line(l2) = {6, 3};

Extrude {{1, 0, 0}, {xc, yc, zc}, -Pi/2} { Line{ 1, 2, l1}; } // rotation
Physical Surface(Sprintf("bubble%g",1)) = {10, 14, 7};

// closing bubble:
ll1 = newll; Line Loop(ll1) = {1, -l1, 2, l2};
s1 = news; Plane Surface(s1) = {ll1};
ll2 = newll; Line Loop(ll2) = {8, -11, 5, l2};
s2 = news; Plane Surface(s2) = {ll2};

/* defining rest of the geometry: */

length1 = 2.5*D; // distance from bubble left-end to inlet
length2 = 1.5*D; // distance from bubble right-end to outlet

// creating left region:
leftP = newp;
Point(leftP) = {xc, 0.0, -D/2.0, b1};
Point(leftP+1) = {xc, D/2.0, 0.0, b1};

leftL = newl;
Ellipse(leftL) = {leftP, 6, 6, leftP+1};
Line(leftL+1) = {leftP+1, 6};
Line(leftL+2) = {6, leftP};

Extrude {-length1, 0, 0} {
  Line{leftL, leftL+1, leftL+2};
}
leftLL = newll; Line Loop(leftLL) = {22, 26, 30};
leftS = news; Plane Surface(leftS) = {leftLL};

// creating right region:
rightP = newp;
Point(rightP) = {xc+r+body+r, 0.0, -D/2.0, b1};
Point(rightP+1) = {xc+r+body+r, D/2.0, 0.0, b1};

rightL = newl;
Ellipse(rightL) = {rightP, 3, 3, rightP+1};
Line(rightL+1) = {rightP+1, 3};
Line(rightL+2) = {3, rightP};

Extrude {length2, 0, 0} {
  Line{rightL, rightL+1, rightL+2};
}
rightLL = newll; Line Loop(rightLL) = {39, 43, 47};
rightS = news; Plane Surface(rightS) = {rightLL};

// creating central region:
centL = newl;
Line(centL) = {leftP, rightP};
Line(centL+1) = {leftP+1, rightP+1};

centLL = newll;
Line Loop(centLL) = {centL+1, -rightL, -centL, leftL};
Line Loop(centLL+1) = {-(rightL+1), -(centL+1), leftL+1, -2, l1, -1};
Line Loop(centLL+2) = {leftL+2, centL, -(rightL+2), 5, -11, 8};
centS = news;
Ruled Surface(centS) = {centLL};
Plane Surface(centS+1) = {centLL+1};
Plane Surface(centS+2) = {centLL+2};

Physical Surface('wallNoSlipPressure') = {-25, 42, centS};
Physical Surface('wallNormalV') = {s2, 33, 50, centS+2};
Physical Surface('wallNormalW') = {s1, -29, 46, centS+1};
Physical Surface('wallInflowUParabolic') = {-leftS, rightS};

/* mesh refinement: */
Characteristic Length {14, 15, 17, 20, 21, 23} = 0.1;
// left region axial:
//Transfinite Line {23, 24, 28} = 70 Using Progression 1.2;
// right region axial:
//Transfinite Line {40, 41, 45} = 49 Using Progression 1.2;
// circumferential at in- and outlet:
Transfinite Line {22, 26, 30, 39, 43, 47} = 5 Using Progression 1;
// circumferential at ends of central region:
//Transfinite Line {19, 20, 21, 36, 37, 38} = 17 Using Progression 1;

