%function [A, R, t] = CameraCal(RWcoord, ImPoints, PlaneID)
function A = CameraCal(RWcoord, ImPoints, PlaneID)
% A = intrinsic matrix
% [R, t] = extrinsic paramaters, rotation and transformation
% 4 sets of corresponding points needed from four different images
% RWcoord = coordinates of real world points
% ImPoints = coordinates of points in image
% PlaneID = numbe of the plane that defines coordinates

% num of image planes
s = size(RWcoord);
num_planes = s(2);

% estimate homographies
for i = 1:num_planes
    im_xy = ImPoints{i}; %split image points to x and y coords
    im_xi = im_xy(:,1);
    im_vi = im_xy(:,2);
    world_XY = RWcoord{i};  %split world points to x and y coords
    world_Xi = world_XY(:,1);
    world_Yi = world_XY(:,2);
    h = homo(im_xi, im_vi, world_Xi, world_Yi); %estimate homography
    H(:, :, i) = [h(1:3)', h(4:6)', [h(7:8)';1]]; % rearange to H matrix
end

% intrinsic paramaters
H_in = H; %copy H
A = homo_in(H_in); % calc A 