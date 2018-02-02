% FUNCTION
% Inverse_Dynamics_GC.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of joint force and moment by generalized coordinates method
%
% SYNOPSIS
% [Joint,Segment] = Inverse_Dynamics_GC(Joint,Segment,f,n)
%
% INPUT
% Joint (cf. data structure in user guide)
% Segment (cf. data structure in user guide)
% f (i.e., sampling frequency)
% n (i.e., number of frames)
%
% OUTPUT
% Joint (cf. data structure in user guide)
% Segment (cf. data structure in user guide)
%
% DESCRIPTION
% Computation of joint force and moment (F, M) at proximal endpoint of 
% segment (rP) expressed in ICS, as a function of:
% *	generalized mass matrix (G)
% *	second time derivatives of generalized coordinates (Q)
% *	generalized ground reaction force and moment (through N1P1 and N1*)
%
% REFERENCES
% R Dumas, L Cheze. 3D inverse dynamics in non-orthonormal segment 
% coordinate system. Medical & Biological Engineering & Computing 2007;
% 45(3):315-22
% R Dumas, E Nicol, L Cheze. Influence of the 3D inverse dynamic method on
% the joint forces and moments during gait. Journal of Biomechanical 
% Engineering 2007;129(5):786-90.
%__________________________________________________________________________
%
% CALLED FUNCTIONS FROM (3D INVERSE DYNAMICS TOOLBOX) 
% Derive_array3.m
% Vnorm_array3.m
% Minv_array3.m
% Mprod_array3.m
% 
% MATLAB VERSION
% Matlab R2007b
%__________________________________________________________________________
%
% CHANGELOG
% Created by Raphaël Dumas
% March 2010
%
% Modified by Raphaël Dumas
% December 2010
% Projection in the null space of Jacobian matrix Z (removal of Lagrange
% multipliers)
%__________________________________________________________________________


function [Joint,Segment] = Inverse_Dynamics_GC(Joint,Segment,f,n)

% Time sampling
dt = 1/f;

% Acceleration of gravity expressed in ICS in dimension (3*1*n)
g = repmat([0;-9.81;0],[1,1,n]);

% Identity matrix in dimension (3*3*n)
E33 = repmat(eye(3),[1,1,n]);
% Zero matrix in dimension (3*1*n)
O31 = zeros(3,1,n);
% Zero matrix in dimension (3*3*n)
O33 = zeros(3,3,n);

for i = 2:4 % From i = 2 foot (or hand) to i = 4 thigh (or arm)

        % Parameters
        u = Segment(i).Q(1:3,:,:);
        rP = Segment(i).Q(4:6,:,:);
        rD = Segment(i).Q(7:9,:,:);
        w = Segment(i).Q(10:12,:,:);

        % Constant geometry
        L = mean(sqrt(sum((rP - rD).^2)),3); % Mean segment length
        v = Vnorm_array3(rP - rD); % 2d vector
        a = mean(acos(dot(v,w))); % Alpha angle
        b = mean(acos(dot(w,u))); % Beta angle
        c = mean(acos(dot(u,v))); % Gamma angle

        % Transformation from (u,rP-rD,w) to (X,Y,Z)
        Bs = [1,L*cos(c),cos(b); ...
            0,L*sin(c),(cos(a) - cos(b)*cos(c))/sin(c);...
            0,0,sqrt(1 - cos(b)^2 - ((cos(a) - cos(b)*cos(c))/sin(c))^2)];

        % Coordinates of COM in (u,rP-rD,w)
        nC = inv(Bs)*Segment(i).rCs;

        % Pseudo-inertia at proximal endpoint in (u,rP-rD,w)
        J = inv(Bs)*...
            [Segment(i).Is + ...
            Segment(i).m*((Segment(i).rCs'*Segment(i).rCs)*eye(3) - ...
            Segment(i).rCs*Segment(i).rCs')]*(inv(Bs))';  % Huygens

        % Generalized mass matrix (G)
        G(1:3,1:3,1:n) = J(1,1)*E33;
        G(1:3,4:6,1:n) = (Segment(i).m*nC(1,1) + J(1,2))*E33;
        G(1:3,7:9,1:n) = - J(1,2)*E33;
        G(1:3,10:12,1:n) = J(1,3)*E33;
        G(4:6,1:3,1:n) = (Segment(i).m*nC(1,1) + J(1,2))*E33;
        G(4:6,4:6,1:n) = (Segment(i).m + 2*Segment(i).m*nC(2,1) + J(2,2))*E33;
        G(4:6,7:9,1:n) = - (Segment(i).m*nC(2,1) + J(2,2))*E33;
        G(4:6,10:12,1:n) = (Segment(i).m*nC(3,1) + J(2,3))*E33;
        G(7:9,1:3,1:n) = - J(1,2)*E33;
        G(7:9,4:6,1:n) = - (Segment(i).m*nC(2,1) + J(2,2))*E33;
        G(7:9,7:9,1:n) = J(2,2)*E33;
        G(7:9,10:12,1:n) = - J(2,3)*E33;
        G(10:12,1:3,1:n) = J(1,3)*E33;
        G(10:12,4:6,1:n) = (Segment(i).m*nC(3,1) + J(2,3))*E33;
        G(10:12,7:9,1:n) = - J(2,3)*E33;
        G(10:12,10:12,1:n) = J(3,3)*E33;

        % Transpose of Jacobian matrix of rigid body contraints (Kt)
        Kt = [2*u,rP - rD,w,O31,O31,O31; ...
            O31,u,O31,2*(rP - rD),w,O31; ...
            O31,-u,O31,-2*(rP - rD),-w,O31; ...
            O31,O31,u,O31,rP - rD,2*w];

        % Transpose of interpolation matrix for force at proximal endpoint (NPt)
        NPt = [O33;E33;O33;O33];

        % Transpose of interpolation matrix for force at COM (NCt)
        NCt = [nC(1,1)*E33;(1 + nC(2,1))*E33;-nC(2,1)*E33;nC(3,1)*E33];

        % Matrix of lever arms for forces equivalent to moment
        % at proximal endpoint
        BM = [cross(w,u),cross(u,rP - rD),cross(-(rP - rD),w)];
        % Transpose of pseudo-interpolation matrix for moment at proximal endpoint (NMt)
        NMt = Mprod_array3([O31,rP - rD,O31; ...
            O31,O31,-w; ...
            O31,O31,w; ...
            u,O31,O31],Minv_array3(BM));

        % Force, moment and Lagrange multipliers in dimension (12*1*n)
        if ~ isfield (Segment(i),'d2Qdt2')
            d2Qidt2 = Derive_array3(Derive_array3(Segment(i).Q,dt),dt);
            display('Warning: segment acceletarion d2Qdt2 may be ');
            display('unconsistant with rigid body constraints');
        else
            d2Qidt2 = Segment(i).d2Qdt2;
        end
        
%         FML = Mprod_array3(Minv_array3([NPt,NMt,-Kt]),...
%             Mprod_array3(G,d2Qidt2) - ...
%             Mprod_array3(NCt,Segment(i).m*g) - ...
%             Mprod_array3(NPt,-Joint(i-1).F) - ...
%             Mprod_array3(NMt,-Joint(i-1).M + cross( ...
%             Segment(i-1).Q(4:6,:,:) - Segment(i).Q(4:6,:,:),-Joint(i-1).F)));
% 
%         % Extraction of joint force and moment
%         Joint(i).F = FML(1:3,1,:);
%         Joint(i).M = FML(4:6,1,:);
        
        % Projection matrix Z
        for k = 1:n % Number of frames
            [V,D] = eig(Kt(:,:,k)* [Kt(:,:,k)]');
            % Eignevectors corresponding to null eignevalues
            Z(:,:,k) = V(:,1:6);
        end
        
        FM = Mprod_array3(...
            Minv_array3([Mprod_array3(permute(Z,[2,1,3]),NPt), Mprod_array3(permute(Z,[2,1,3]),NMt)]),...
            Mprod_array3(permute(Z,[2,1,3]),...
            Mprod_array3(G,d2Qidt2) - ...
            Mprod_array3(NCt,Segment(i).m*g) - ...
            Mprod_array3(NPt, - Joint(i-1).F) - ...
            Mprod_array3(NMt, - Joint(i-1).M + cross(Segment(i-1).Q(4:6,:,:) - Segment(i).Q(4:6,:,:), - Joint(i-1).F))));
            % with transpose = permute( ,[2,1,3])
            
        % Extraction of joint force and moment
        Joint(i).F = FM(1:3,1,:);
        Joint(i).M = FM(4:6,1,:);

        % Kinematics
        Segment(i).V = Mprod_array3(permute(NCt,[2,1,3]), ...
            Derive_array3(Segment(i).Q,dt));
        Segment(i).A = Mprod_array3(permute(NCt,[2,1,3]), ...
            Derive_array3(Derive_array3(Segment(i).Q,dt),dt));

end
