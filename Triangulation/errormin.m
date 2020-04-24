% this was a potential function for error minimisation to better estimate 
% 3d points - however i was not able to get it fully functioning.

function err = errormin(x_1, Pro1, x_2, Pro2)
Points = tri_3D(x_1, Pro1, x_2, Pro2);
% find reprojection error
p_1a = Pro1*Points;
p_1a = p_1a./repmat(p_1a(3,:),3,1);
p_2a = Pro2*Points;
p_2a = p_2a./repmat(p_2a(3,:),3,1);
err1 = sum(sum((p_1a-x_1).^2));
err2 = sum(sum((p_2a-x_2).^2));
err = sqrt((err1+err2)/size(x_1,2));