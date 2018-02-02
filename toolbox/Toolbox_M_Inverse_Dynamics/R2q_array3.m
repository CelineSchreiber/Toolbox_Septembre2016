% FUNCTION
% R2q_array3.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of quaternion from rotation matrix 
%
% SYNOPSIS
% q = R2q_array3(R)
%
% INPUT
% R (i.e., rotation matrix)
%
% OUTPUT
% q (i.e., quaternion)
%
% DESCRIPTION
% Computation, for all frames (i.e., in 3rd dimension, cf. data structure
% in user guide), of the quaternion (q) from the rotation matrix (R)
%
% REFERENCES
% SW Shepperd. Quaternion from Rotation Matrix. Journal of Guidance and
% Control 1978; 1(3): 223-224.
% J Lee, SY Shin. General construction of time-domain filters for 
% orientation data. IEEE Transactions on Visualization and Computer
% Graphics 2002; 8(2): 119-128.
%__________________________________________________________________________
%
% CALLED FUNCTIONS (FROM 3D INVERSE DYNAMICS TOOLBOX) 
% Vnorm_array3.m
% qlog_array3.m
% qprod_array3.m
% qinv_array3.m
% 
% MATLAB VERSION
% Matlab R2007b
%__________________________________________________________________________
%
% CHANGELOG
% Created by Raphaël Dumas
% March 2010
%__________________________________________________________________________

function q = R2q_array3(R)

% Terms of rotation matrix in dimension (1*n)
R11 = permute(R(1,1,:),[2,3,1]);
R12 = permute(R(1,2,:),[2,3,1]);
R13 = permute(R(1,3,:),[2,3,1]);
R21 = permute(R(2,1,:),[2,3,1]);
R22 = permute(R(2,2,:),[2,3,1]);
R23 = permute(R(2,3,:),[2,3,1]);
R31 = permute(R(3,1,:),[2,3,1]);
R32 = permute(R(3,2,:),[2,3,1]);
R33 = permute(R(3,3,:),[2,3,1]);

% Choice of maximum value of qi^2 
% Trace and diagonal terms in dimension (1*n)
M = [(R11 + R22 + R33); R11; R22; R33];
% Maximal value
[Mmax,imax] = max(M); % imax = 1,2,3 or 4
% Terms associated with maximal value in dimension (1*n)
quaternionmax = sqrt(1 + 2*Mmax - (R11 + R22 + R33));

% 4 Cases
% Frame where maximal value is q0^2
ind1 = find (imax == 1);
quaternion(1,ind1) = quaternionmax(1,ind1);
quaternion(2,ind1) = (R32(1,ind1) - R23(1,ind1))./quaternionmax(1,ind1); 
quaternion(3,ind1) = (R13(1,ind1) - R31(1,ind1))./quaternionmax(1,ind1);
quaternion(4,ind1) = (R21(1,ind1) - R12(1,ind1))./quaternionmax(1,ind1);
% Frame where maximal value is q1^2
ind2 = find (imax == 2);
quaternion(1,ind2) = (R32(1,ind2) - R23(1,ind2))./quaternionmax(1,ind2);
quaternion(2,ind2) = quaternionmax(1,ind2);
quaternion(3,ind2) = (R21(1,ind2) + R12(1,ind2))./quaternionmax(1,ind2);
quaternion(4,ind2) = (R13(1,ind2) + R31(1,ind2))./quaternionmax(1,ind2);
% Frame where maximal value is q2^2
ind3 = find (imax == 3);
quaternion(1,ind3) = (R13(1,ind3) - R31(1,ind3))./quaternionmax(1,ind3);
quaternion(2,ind3) = (R21(1,ind3) + R12(1,ind3))./quaternionmax(1,ind3);
quaternion(3,ind3) = quaternionmax(1,ind3);
quaternion(4,ind3) = (R32(1,ind3) + R23(1,ind3))./quaternionmax(1,ind3);
% Frame where maximal value is q3^2
ind4 = find (imax == 4);
quaternion(1,ind4) = (R21(1,ind4) - R12(1,ind4))./quaternionmax(1,ind4);
quaternion(2,ind4) = (R13(1,ind4) + R31(1,ind4))./quaternionmax(1,ind4);
quaternion(3,ind4) = (R32(1,ind4) + R23(1,ind4))./quaternionmax(1,ind4);
quaternion(4,ind4) = quaternionmax(1,ind4);

% Quaternion in dimension (4*1*n)
q = Vnorm_array3(0.5*permute(quaternion,[1,3,2]));

% Quaternions q and -q can represent the same rotation R
for i = 2:size(q,3)
    % ||log(qi-1)-1*qi)|| > pi/2
    if norm(qlog_array3(qprod_array3(...
        qinv_array3(q(:,:,i-1)), q(:,:,i)))) > pi/2
        % Quaternion of opposite sign
        q(:,:,i) = - q(:,:,i);
    end
end
