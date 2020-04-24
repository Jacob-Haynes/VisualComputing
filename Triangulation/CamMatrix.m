function P = CamMatrix(Ps, K1, K2, X)
x_1 = X(:,1);
x_2 = X(:,2);

% first cam is P=[I|0]
P_cam1 = [eye(3), zeros(3,1)];
P = K1*P_cam1;
x_1h = inv(K1)*x_1;
x_2h = inv(K2)*x_2;

% for each cam matrix project points in 3D and get z
X3d = zeros(4,4);
z = zeros(4,2);
for i = 1:4
    A = [P_cam1(3,:).*x_1h(1,1)-P_cam1(1,:);...
        P_cam1(3,:).*x_1h(2,1)-P_cam1(2,:);...
        Ps(3, :, i).*x_2h(1,1)-Ps(1,:,i);...
        Ps(3,:,i).*x_2h(2,1)-Ps(2,:,i)];
    %normalise
    norm_A1 = sqrt(sum(A(1,:).*A(1,:)));
    norm_A2 = sqrt(sum(A(2,:).*A(2,:)));
    A_norm = [A(1,:)/norm_A1;...
        A(2,:)/norm_A2;...
        A(3,:)/norm_A1;...
        A(4,:)/norm_A1];
    %get 3D
    [~,~,V] = svd(A_norm);
    X3d(:,i)=V(:,end);
    %check with cam 2
    xi = Ps(:,:, i)*X3d(:,i);
    tempz = xi(3);
    temp = X3d(end,i);
    d3norm = sqrt(sum(Ps(3,1:3,i).*Ps(3,1:3,i)));
    z(i,1) = (sign(det(Ps(:,1:3,i)))*tempz)/(temp*d3norm);
    %check with cam 1
    xi = P_cam1(:,:)*X3d(:,1);
    tempz = xi(3);
    temp = X3d(end,i);
    d3norm = sqrt(sum(P_cam1(3,1:3).*P_cam1(3,1:3)));
    z(i,2) = (sign(det(P_cam1(:,1:3)))*tempz)/(temp*d3norm);
end
%check for correct P
if(z(1,1)>0 && z(1,2)>0)
    P = Ps(:,:,1);
elseif(z(2,1)>0 && z(2,2)>0)
    P = Ps(:,:,2);
elseif(z(3,1)>0 && z(3,2)>0)
    P = Ps(:,:,3);
elseif(z(4,1)>0 && z(4,2)>0)
    P = Ps(:,:,4);
end
    
    