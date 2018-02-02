% =========================================================================
% REHAZENTER TOOLBOX - PLUGIN CLINICAL REPORT
% =========================================================================
% File name:    setAxisLim
% -------------------------------------------------------------------------
% Subject:      Manage the plot axis limits
% -------------------------------------------------------------------------
% Inpageuts:    - YL (int)
%               - a (int)
%               - b (int)
% Outputs:      - YL (int)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 13/01/2015
% Version: 1
% -------------------------------------------------------------------------
% Updates: -
% =========================================================================

function YL = setAxisLim(YL,a,b)
    
% if YL(1)<0
%     YL(1) = -ceil(abs(YL(1))/10)*10;
% else
%     YL(1) = round(YL(1)/10)*10;
% end
% if YL(2)<0
%     YL(2) = -round(abs(YL(2))/10)*10;
% else
%     YL(2) = ceil(YL(2)/10)*10;
% end
if YL(1)>=a && YL(2)<=b
    YL(1) = a;
    YL(2) = b;
elseif YL(2)>b && YL(1)>=a
    if YL(1)>YL(2)-(b-a)
        YL(1) = YL(2)-(b-a);
    end
elseif YL(1)<a && YL(2)<=b
    if YL(2)<YL(1)+(b-a)
        YL(2) = YL(1)+(b-a);
    end
end