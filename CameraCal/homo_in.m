function A = homo_in(H_in)
%returns intrinsic matrix A from i homographies
% H_in is 3x3xn homographies (with final coordinate 1)

% constraints for each H
for i = 1:size(H_in,3)
    %ith column of H be hi=[hi1 hi2 hi3]transpose
    H = H_in(:,:,i)';
    %cij = [hi1hj2, hi1hj2+hi2hj1, hi2hj2, hi3hj1+hi1hj3, hi3hj2+hi2hj3,
    %hi3hj3]transpose
    c11 = [H(1,1)*H(1,1), H(1,1)*H(1,2)+H(1,2)*H(1,1), H(1,2)*H(1,2),...
        H(1,3)*H(1,1)+H(1,1)*H(1,3), H(1,3)*H(1,2)+H(1,2)*H(1,3),...
        H(1,3)*H(1,3)]';
    c12 = [H(1,1)*H(2,1), H(1,1)*H(2,2)+H(1,2)*H(2,1), H(1,2)*H(2,2),...
        H(1,3)*H(2,1)+H(1,1)*H(2,3), H(1,3)*H(2,2)+H(1,2)*H(2,3),...
        H(1,3)*H(2,3)]';
    c22 = [H(2,1)*H(2,1), H(2,1)*H(2,2)+H(2,2)*H(2,1), H(2,2)*H(2,2),...
        H(2,3)*H(2,1)+H(2,1)*H(2,3), H(2,3)*H(2,2)+H(2,2)*H(2,3),...
        H(2,3)*H(2,3)]';
    %[c12' ; (c11-c22)']
    C(i*2-1,:) = c12';
    C(i*2,:) = (c11 - c22)';
end

%svd to find b (Cb = 0)
%Cb=0 so single val decomp for V component
[U,S,V] = svd(C);
b = V(:,6); %V is x6 matrix

% form B
% b = [B11, B12, B22, B13, B23, B33]'
% B = [B11,B12,B13; B12,B22,B23; B13,B23,B33]
B = [b(1), b(2), b(4); b(2), b(3), b(5); b(4), b(5), b(6)];

% intrinsic from B - rearange the hellish matrix in eq5 Zhang
v_0 = (B(1,2)*B(1,3)-B(1,1)*B(2,3))/(B(1,1)*B(2,2)-B(1,2)*B(1,2));
l = B(3,3)-(B(1,3)*B(1,3)+v_0*(B(1,2)*B(1,3)-B(1,1)*B(2,3)))/B(1,1);
a = sqrt(l/B(1,1));
b=sqrt(l*B(1,1)/B(1,1)*B(2,2)-B(1,2)*B(1,2));
g = -B(1,2)*a*a*b/l;
u_0 = (g*v_0/a)-(B(1,3)*a*a/l);

%arange A
A = [a,g,u_0;0,b,v_0;0,0,1];
