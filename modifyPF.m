function [Grf2, Gait] = modifyPF(Grf,Gait,f2);

for i=1:2
    if Gait.s(i)>0
        Grf2(i)=Grf(Gait.s(i));
        Gait.s(i)=i;
    else
        Grf2(i)=Grf(i);
    end
end

% Grf2(1).P(1:round(Gait.e.RHS(1)*f2),:)  =0;
% Grf2(1).P(round(Gait.e.RTO(end)*f2):end,:)=0;
% Grf2(2).P(1:round(Gait.e.LHS(1)*f2),:)  =0;
% Grf2(2).P(round(Gait.e.LTO(end)*f2):end,:)=0;