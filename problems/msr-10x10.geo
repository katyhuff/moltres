graph_sqc_rad = 2.54; // MSRE (cm) unless otherwise noted
fuel_sqc_rad = 3.048;
pitch = 2 * fuel_sqc_rad;
// num_cells = 23;
num_cells = 2;
// height = 162.56;
height = 60;
lc = 2.5;

Point(1) = {-graph_sqc_rad, -graph_sqc_rad, 0, lc};
Point(2) = {graph_sqc_rad, -graph_sqc_rad, 0, lc};
Point(3) = {graph_sqc_rad, graph_sqc_rad, 0, lc};
Point(4) = {-graph_sqc_rad, graph_sqc_rad, 0, lc};
Line(1) = {4, 1};
Line(2) = {1, 2};
Line(3) = {3, 2};
Line(4) = {3, 4};
Point(5) = {-fuel_sqc_rad, -fuel_sqc_rad, 0, lc};
Point(6) = {-fuel_sqc_rad, fuel_sqc_rad, 0, lc};
Point(7) = {fuel_sqc_rad, fuel_sqc_rad, 0, lc};
Point(8) = {fuel_sqc_rad, -fuel_sqc_rad, 0, lc};
Line(5) = {6, 7};
Line(6) = {7, 8};
Line(7) = {8, 5};
Line(8) = {5, 6};
Line Loop(9) = {5, 6, 7, 8};
Line Loop(10) = {4, 1, 2, -3};
Plane Surface(11) = {9, 10};
Plane Surface(12) = {10};
fuel_surfaces[] = {11};
moder_surfaces[] = {12};
For xindex In {1:num_cells-1}
new_f_surface = Translate {xindex*pitch, 0, 0} {
  Duplicata { Surface{11}; }
};
fuel_surfaces += new_f_surface;
new_m_surface = Translate {xindex*pitch, 0, 0} {
  Duplicata { Surface{12}; }
};
moder_surfaces += new_m_surface;
EndFor
For yindex In {1:num_cells-1}
new_f_surface = Translate {0, yindex*pitch, 0} {
  Duplicata { Surface{11}; }
};
fuel_surfaces += new_f_surface;
new_m_surface = Translate {0, yindex*pitch, 0} {
  Duplicata { Surface{12}; }
};
moder_surfaces += new_m_surface;
EndFor
For xindex In {1:num_cells-1}
For yindex In {1:num_cells-1}
new_f_surface = Translate {xindex*pitch, yindex*pitch, 0} {
  Duplicata { Surface{11}; }
};
fuel_surfaces += new_f_surface;
new_m_surface = Translate {xindex*pitch, yindex*pitch, 0} {
  Duplicata { Surface{12}; }
};
moder_surfaces += new_m_surface;
EndFor
EndFor
fuel_volumes[] = {};
moder_volumes[] = {};
For index In {0:num_cells*num_cells-1}
fuel_out[] = Extrude {0, 0, height} { Surface{fuel_surfaces[index]}; };
fuel_volumes += fuel_out[1];
moder_out[] = Extrude {0, 0, height} { Surface{moder_surfaces[index]}; };
moder_volumes += moder_out[1];
EndFor
Physical Volume ("fuel") = { fuel_volumes[] };
Physical Volume ("moder") = { moder_volumes[] };
tot_volumes = {};
// For i In {0 : #fuel_volumes[]-1}
// tot_volumes += fuel_volumes[i];
// Printf("Fuel volume ID is '%g'. Total volume ID is '%g'", fuel_volumes[i], tot_volumes[i]);
// EndFor
// For i In {0 : #moder_volumes[]-1}
// tot_volumes += moder_volumes[i];
// EndFor
tot_volumes[] = fuel_volumes[];
tot_volumes += moder_volumes[];
Printf("'%g'",#tot_volumes[]);
bnd[] = Boundary{ Volume{tot_volumes[]}; };
Physical Surface ("boundary") = bnd[];
// Printf("Surfaces '%g' and '%g' and '%g'", fuel_surfaces[0], fuel_surfaces[1], fuel_surfaces[2]);
// Printf("Surfaces '%g' and '%g' and '%g'", moder_surfaces[0], moder_surfaces[1], moder_surfaces[2]);
