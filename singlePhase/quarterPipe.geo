/* one quarter of x-axis-symmetric pipe (x, y, z s.t. y > 0, z < 0) */
wall = 0.03;

D = 1.0; // channel diameter
wallLength = 4.0; // channel length

// defining inlet:
Point(1) = {-wallLength/2.0, D/2.0,    0.0, wall};
Point(2) = {-wallLength/2.0,   0.0, -D/2.0, wall};
Point(3) = {-wallLength/2.0,   0.0,    0.0, wall};
l = newl;
Line(l) = {2, 3};
Line(l+1) = {3, 1};
Ellipse(l+2) = {1, 3, 3, 2};

// extruding inlet in x-direction:
Extrude {wallLength, 0, 0} { Line{ l, l+1, l+2 };}

Physical Surface('wallNoSlip') = { -15 };

ll = newll; s = news;
// inlet:
Line Loop( ll ) = {  1, 2, 3 };
Plane Surface(s) = {ll};
// outlet:
Line Loop(ll+1) = { 12, 8, 4 };
Plane Surface(s+1) = {ll+1};

Physical Surface('wallInflowU') = { s };
Physical Surface('wallOutflow') = { s+1 };
Physical Surface('wallNormalW') = { -11 };
Physical Surface('wallNormalV') = { -7  };

