% =========================================================================
% REHAZENTER TOOLBOX - PLUGIN CLINICAL REPORT
% =========================================================================
% File name:    viewPdf
% -------------------------------------------------------------------------
% Subject:      View generates .pdf file of the current report page
% -------------------------------------------------------------------------
% Inputs:       - temp (char)
%               - pluginFolder (char)
%               - filesFolder (char)
% Outputs:      - none
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 15/01/2015
% Version: 1
% -------------------------------------------------------------------------
% Updates: -
% =========================================================================

function viewPdf(temp,pluginFolder,filesFolder)

cd(filesFolder);
if ~isempty(temp) 
    winopen(temp.name)
end
cd(pluginFolder);