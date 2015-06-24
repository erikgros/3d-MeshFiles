/* x-axis-symmetric pipe */
wall = 0.15;

D = 1.0; // channel diameter
wallLength = 4.0; // channel length

// defining upper wall in z=0 plane:
Point(1) = {-wallLength/2.0, D/2.0, 0.0, wall}; // left
Point(2) = { wallLength/2.0, D/2.0, 0.0, wall}; // right
l = newl; Line(l) = {1, 2};

// rotating around x-axis:
Extrude {{1, 0, 0}, {0.0, 0.0, 0.0}, Pi/2} { Line{  l  }; }
Extrude {{1, 0, 0}, {0.0, 0.0, 0.0}, Pi/2} { Line{ l+1 }; }
Extrude {{1, 0, 0}, {0.0, 0.0, 0.0}, Pi/2} { Line{ l+5 }; }
Extrude {{1, 0, 0}, {0.0, 0.0, 0.0}, Pi/2} { Line{ l+9 }; }

Physical Surface('wallNoSlip') = { -5, -9, -13, -17 };

// in and outlet:
ll = newll; Line Loop(ll) = { 3, 7, 11, 15 };
s = news; Plane Surface(s) = {ll};
Line Loop(ll+1) = { 4, 8, 12, 16 };
Plane Surface(s+1) = { -(ll+1) };

Physical Surface('wallInflowU') = { s };
Physical Surface('wallOutflow') = { s+1 };

