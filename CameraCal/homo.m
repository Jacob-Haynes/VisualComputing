function h = homo(im_xi, im_yi, world_Xi, world_Yi)
% condensed version of the function made in feature matching section
% returns vector of homography matrix components h
% (im_xi, im_yi) image point coordinates
% (world_Xi, world_Yi) world point coordinates

len = length(im_xi);

%generate matrix of homogenous points
P=[];
for i = 1:len
    p{i} = [world_Xi(i), world_Yi(i), 1, 0, 0, 0, -im_xi(i)*world_Xi(i), -im_xi(i)*world_Yi(i);...
        0,0,0, world_Xi(i), world_Yi(i), 1, -im_yi(i)*world_Xi(i), -im_yi(i)*world_Yi(i)];
    P=[P;p{i}];
end
% single value decomp
[~, ~, V] =svd(P);
for i=1:size(V,1)
    h(i)=V(i, end); %re-order into H in main function
end
