function [norm_point, trans] = norm_2d(point)
%homo coords
indx = find(abs(point(3,:))>eps);
point(1,indx)= point(1,indx)./point(3,indx);
point(2,indx)= point(2,indx)./point(3,indx);
point(3, indx)=1;
%centroid
cent = mean(point(1:2,indx)')';
%origin move
new_point(1,indx)=point(1,indx)-cent(1);
new_point(2,indx)=point(2,indx)-cent(2);
%distance between points
dist = sqrt(new_point(1,indx).^2+new_point(2,indx).^2);
average_dist = mean(dist(:));
%scale calc
scale = sqrt(2)/average_dist;
%transformation matrix 
trans=[scale, 0, -scale*cent(1); 0, scale, -scale*cent(2); 0,0,1];
%calc norm points
norm_point = trans*point;