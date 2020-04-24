function [Points] = tri_3D(p_1, Pro1, p_2, Pro2)
%outputs point in 3d space
% takes in projection matricies Pro1 Pro2
% and nx3 corresponding points p_1, p_2 

for i=1:size(p_1,2)
    %pick a point
    point1 = p_1(:,i);
    point2 = p_2(:,i);
    
    x1 = point1(1,1).*Pro1(3,:)-Pro1(1,:);
    x2 = point1(2,1).*Pro1(3,:)-Pro1(2,:);
    y1 = point2(1,1).*Pro2(3,:)-Pro2(1,:);
    y2 = point2(2,1).*Pro2(3,:)-Pro2(1,:);
    
    xy = [x1;x2;y1;y2];
    [~,~,V] = svd(xy);
    % point is last column of V
    temp = V(:,4);
    temp = temp./repmat(temp(4,1),4,1);
    
    Points(:,i)= temp;
end

end