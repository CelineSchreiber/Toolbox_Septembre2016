% =========================================================================
% REHAZENTER TOOLBOX - PLUGIN CLINICAL REPORT
% =========================================================================
% File name:    mergeConditions
% -------------------------------------------------------------------------
% Subject:      Merge loaded conditions to be compared
% -------------------------------------------------------------------------
% Inputs:       - temp (structure)
%               - a (int)
%               - b (int)
% Outputs:      - Patient (structure)
%               - Pathology (structure)
%               - Treatment (structure)
%               - Examination (structure)
%               - Session (structure)
%               - Condition (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 16/12/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 
% =========================================================================

function [Patient,Pathology,Treatment,Session,Condition] = ...
    mergeConditions(temp,a,b)

% =========================================================================
% Get how many sessions have been selected
% If no session has been selected, set the first session of the list to be 
% used for the report
% =========================================================================
if length(a) == 1
    v = 1;
else
    v = (cell2mat(get(a,'Value')) == cell2mat(get(a,'Max')));
    if sum(v) == 0
        v(1) = 1;
    end
end

% =========================================================================
% Get the selected order of the sessions
% =========================================================================
j = 0;
for i = 1:size(v)
    names = fieldnames(temp(i));
    finder = 0;
    for i = 1:length(names)
        if strcmp(names{i},'footmarkersset')
            finder = 1;
        end
    end
    if finder == 0
        temp(i).Session.footmarkersset = '';
    end
end
for i = 1:size(v)
    if v(i) == 1
        j = j+1;
        temp2(j) = temp(i);
        b2(j) = get(b(i),'Value');
    end
end

% =========================================================================
% Merge the data
% =========================================================================
for i = 1:length(b2)
    Patient(b2(i)) = temp2(i).Patient;
    Pathology(b2(i)) = temp2(i).Pathology;
    Treatment(b2(i)) = temp2(i).Treatment;
    Session(b2(i)) = temp2(i).Session;
    if isfield(temp2(i).Condition,'Norm')
        temp2(i).Condition = rmfield(temp2(i).Condition,'Norm');
    end
    Condition(b2(i)) = temp2(i).Condition;
end