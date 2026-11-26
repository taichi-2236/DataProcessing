function h = sslrobot(x, y, heading)
% ref: 
% (1) https://jp.mathworks.com/matlabcentral/answers/98665-how-do-i-plot-a-circle-with-a-given-radius-and-center
% (2) https://wpk408.hateblo.jp/entry/2019/05/17/111346
% (3) https://robocup-ssl.github.io/ssl-rules/sslrules.html#_vision_pattern
  
  % parameters between CoM and dribbler
  d_rf = 0.078;
  w_d = 0.075;
  d_ang = atan2(0.5*w_d,d_rf);
  % radius of robot
  r_r = 0.090;   % 90 mm = 9 cm = 0.09 m
  
  dth = pi/100;
  % for body
  arc_ang = d_ang:dth:2*pi-d_ang;
  bx = r_r*cos(heading + arc_ang);
  by = r_r*sin(heading + arc_ang);
  % five markers (See Sect.3.2.4 of the SSL rules)
  ang = 0:dth:2*pi;  r_m = 0.02;  r_cm = 0.025;
  % left front marker
  p_r_lfm = [ 0.035; 0.054772 ];
  p_lfm = func_R(heading)*p_r_lfm;
  lfm_x = p_lfm(1) + r_m*cos(ang);
  lfm_y = p_lfm(2) + r_m*sin(ang);
  % right front marker
  p_r_rfm = [ 0.035; -0.054772 ];
  p_rfm = func_R(heading)*p_r_rfm;
  rfm_x = p_rfm(1) + r_m*cos(ang);
  rfm_y = p_rfm(2) + r_m*sin(ang);
  % left rear marker
  p_r_lrm = [ -0.054772; 0.035 ];
  p_lrm = func_R(heading)*p_r_lrm;
  lrm_x = p_lrm(1) + r_m*cos(ang);
  lrm_y = p_lrm(2) + r_m*sin(ang);
  % right rear marker
  p_r_rrm = [ -0.054772; -0.035 ];
  p_rrm = func_R(heading)*p_r_rrm;
  rrm_x = p_rrm(1) + r_m*cos(ang);
  rrm_y = p_rrm(2) + r_m*sin(ang);
  % center (team) marker
  cm_x = r_cm*cos(ang);
  cm_y = r_cm*sin(ang);
  
  % An Yellow robot of ID 10
  h = fill(x + bx, y + by, 'k', ...
           x + lfm_x, y + lfm_y, 'm', ...
           x + rfm_x, y + rfm_y, 'm', ...
           x + lrm_x, y + lrm_y, 'g', ...
           x + rrm_x, y + rrm_y, 'g', ...
           x + cm_x, y + cm_y, 'y');
  % plot(x + bx, y + by, 'r-')
  % h = plot(x + bx, y + by, 'k', ...
  %          x + lfm_x, y + lfm_y, 'm', ...
  %          x + rfm_x, y + rfm_y, 'm', ...
  %          x + lrm_x, y + lrm_y, 'g', ...
  %          x + rrm_x, y + rrm_y, 'g', ...
  %          x + cm_x, y + cm_y, 'y');
end