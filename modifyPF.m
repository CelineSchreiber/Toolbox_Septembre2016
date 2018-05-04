function [Grf2, Gait] = modifyPF(Grf,Gait);

for i=1:2
    if Gait.s(i)>0
        Grf2(i)=Grf(Gait.s(i));
        Gait.s(i)=i;
    else
        Grf2(i)=Grf(i);
    end
end
