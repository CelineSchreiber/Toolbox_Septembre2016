% =========================================================================
% REHAZENTER TOOLBOX - PLUGIN CLINICAL REPORT
% =========================================================================
% File name:    translateNomenclature
% -------------------------------------------------------------------------
% Subject:      Translate nomenclature reference to words
% -------------------------------------------------------------------------
% Inpageuts:    - nomenclature (char)
% Outputs:      - translation (char)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 15/01/2015
% Version: 1
% -------------------------------------------------------------------------
% Updates: -
% =========================================================================

function translation = translateNomenclature(nomenclature)

% =========================================================================
% Initialisation
% =========================================================================
nomenclature = lower(nomenclature); % avoid uppercase errors
context = '';
task = '';
shoes = '';
orthosis = '';
fes = '';
exth = '';
peoh = '';

counter = 1;

% =========================================================================
% Get context condition
% =========================================================================
if nomenclature(1) == 'n'
    context = '';
    counter = 2;
elseif nomenclature(1:3) == 'pre'
    context = 'pre-bloc ';
    counter = 4;
elseif nomenclature(1:3) == 'pos'
    context = 'post-bloc ';
    counter = 4;
end

% =========================================================================
% Get task condition
% =========================================================================
if nomenclature(counter+1) == 'n'
    task = 'allure spontanée ';
    counter = counter+2;
else
    if nomenclature(counter+1:counter+2) == 'ra'
        task = 'allure rapide ';
        counter = counter+3;
    elseif nomenclature(counter+1:counter+2) == 'le'
        task = 'allure lente ';
        counter = counter+3;
    elseif nomenclature(counter+1) == 'a'
        task = ['autre (',nomenclature(counter+2),') '];
        counter = counter+3;
    end
end

% =========================================================================
% Get shoes condition
% =========================================================================
if nomenclature(counter+1) == 'n'
    shoes = '';
    counter = counter+1;
elseif nomenclature(counter+1) == 'c'
    task = ['pied chaussé (',nomenclature(counter+2),') '];
    counter = counter+2;
end

% =========================================================================
% Get orthosis condition
% =========================================================================
if nomenclature(counter+1) == 'n'
    orthosis = '';
    counter = counter+1;
else
    if nomenclature(counter+1:counter+2) == 'rl'
        orthosis = 'releveur liberte ';
        counter = counter+2;
    elseif nomenclature(counter+1:counter+2) == 'db'
        orthosis = 'dictus band ';
        counter = counter+2;
    elseif nomenclature(counter+1:counter+2) == 'ch'
        orthosis = 'chignon ';
        counter = counter+2;
    elseif nomenclature(counter+1:counter+2) == 'af'
        orthosis = 'AFO ';
        counter = counter+2;
    elseif nomenclature(counter+1:counter+2) == 'de'
        orthosis = 'derotateur ';
        counter = counter+2;
    elseif nomenclature(counter+1:counter+2) == 'cr'
        orthosis = 'corset rach. ';
        counter = counter+2;
    end
end

% =========================================================================
% Get FES condition
% =========================================================================
if nomenclature(counter+1) == 'n'
    fes = '';
    counter = counter+2;
else
    if nomenclature(counter+1:counter+3) == 'ses'
        fes = 'SEF ext. 1 canal ';
        counter = counter+4;
    elseif nomenclature(counter+1:counter+3) == 'sed'
        fes = 'SEF ext. 2 canaux ';
        counter = counter+4;
    elseif nomenclature(counter+1:counter+3) == 'sim'
        fes = 'SEF impl. ';
        counter = counter+4;
    end
end

% =========================================================================
% Get external help condition
% =========================================================================
if nomenclature(counter+1) == 'n'
    exth = '';
    counter = counter+1;
else
    if nomenclature(counter+1:counter+2) == 'cs'
        exth = 'canne simple ';
        counter = counter+2;
    elseif nomenclature(counter+1:counter+2) == 'ca'
        exth = 'canne anglaise ';
        counter = counter+2;
    elseif nomenclature(counter+1:counter+2) == 'ct'
        exth = 'canne tripode ';
        counter = counter+2;
    elseif nomenclature(counter+1:counter+2) == 'cc'
        exth = 'canne canadienne ';
        counter = counter+2;
    elseif nomenclature(counter+1:counter+2) == 'ro'
        exth = 'rollator ';
        counter = counter+2;
    end
end

% =========================================================================
% Get people help condition
% =========================================================================
if nomenclature(counter+1) == 'n'
    peoh = '';
    counter = counter+1;
elseif nomenclature(counter+1) == 'p'
    peoh = 'personne(s) tactile';
    counter = counter+1;
end

translation = [context,task,shoes,orthosis,fes,exth,peoh];