/* one quarter of Taylor bubble shape */

/*
 *              5           2
 *              o --------- o 
 *            /              `,  
 *          6 o o 4       1 o  o 3
 *
 */

Point(i+1) = {xc+r+body, yc, zc, b1};   // center
Point(i+2) = {xc+r+body, yc+r, zc, b1}; // top
Point(i+3) = {xc+r+body+r, yc, zc, b2}; // ext
Point(i+4) = {xc+r, yc, zc, b1};        // center
Point(i+5) = {xc+r, yc+r, zc, b1};      // top
Point(i+6) = {xc, yc, zc, b2};          // ext

Ellipse(j+1) = {i+2, i+1, i+1, i+3};
Ellipse(j+2) = {i+6, i+4, i+4, i+5};

Line(j+3) = {i+5, i+2};

Extrude {{1, 0, 0}, {xc, yc, zc}, -Pi/2} { Line{ j+1, j+2, j+3}; }
