% =========================================================================
% REHAZENTER TOOLBOX - PLUGIN CLINICAL REPORT
% =========================================================================
% File name:    generatePdf
% -------------------------------------------------------------------------
% Subject:      Generate .pdf file of the current report page
% -------------------------------------------------------------------------
% Inputs:       - f (figure)
%               - pluginFolder (char)
%               - filesFolder (char)
%               - b (int)
% Outputs:      - none
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 16/12/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: -
% =========================================================================

function generatePdf(d,f,pluginFolder,filesFolder,filename)

if get(d(4),'Value')
    cd(filesFolder);
    % Check if temp folder exist, otherwise create it
    if exist('temporaryFiles') == 7
    else
        mkdir('temporaryFiles');
    end
    cd('temporaryFiles');
    % Generate pdf
    list = dir('firstPage_*');
    if strfind(filename,'firstPage')
        if f(1) ~= 0
            print(f(1),'-dpdf',[filename,'_',num2str(length(list)+1),'_temp.pdf'],'-opengl');
        end
        if length(f) > 1
            print(f(2),'-dpdf',[filename,'_',num2str(length(list)+2),'_temp.pdf'],'-opengl');
        end
    end
    list = dir('gaitParameters_*');
    if strfind(filename,'gaitParameters')
        if f(1) ~= 0
            print(f(1),'-dpdf',[filename,'_',num2str(length(list)+1),'_temp.pdf'],'-opengl');
        end
        if length(f) > 1
            print(f(2),'-dpdf',[filename,'_',num2str(length(list)+2),'_temp.pdf'],'-opengl');
        end
    end
    list = dir('kinematics_*');
    if strfind(filename,'kinematics')
%         if f(1) ~= 0
%             print(f(1),'-dpdf','-r300','-opengl',[filename,'_',num2str(length(list)+1),'_temp.pdf']);
%         end
%         if length(f) > 1
%             print(f(2),'-dpdf','-r300','-opengl',[filename,'_',num2str(length(list)+2),'_temp.pdf']);
%         end
        if f(1) ~= 0
            print(f(1),'-dpdf',[filename,'_',num2str(length(list)+1),'_temp.pdf'],'-opengl');
        end
        if length(f) > 1
            print(f(2),'-dpdf',[filename,'_',num2str(length(list)+2),'_temp.pdf'],'-opengl');
        end
    end
    list = dir('kinetics_*');
    if strfind(filename,'kinetics')
        if f(1) ~= 0
            print(f(1),'-dpdf',[filename,'_',num2str(length(list)+1),'_temp.pdf'],'-opengl');
        end
        if length(f) > 1
            print(f(2),'-dpdf',[filename,'_',num2str(length(list)+2),'_temp.pdf'],'-opengl');
        end
    end
    list = dir('EMG_*');
    if strfind(filename,'EMG')
        if f(1) ~= 0
            for k=1:length(f)
                print(f(k),'-dpdf',[filename,'_',num2str(length(list)+k),'_temp.pdf'],'-opengl');
            end
        end
    end
    list = dir('AI_*');
    if strfind(filename,'AI')
        if f(1) ~= 0
            print(f(1),'-dpdf',[filename,'_',num2str(length(list)+1),'_temp.pdf'],'-opengl');
        end
        if length(f) > 1
            print(f(2),'-dpdf',[filename,'_',num2str(length(list)+2),'_temp.pdf'],'-opengl');
        end
    end
    list = dir('NCCF_*');
    if strfind(filename,'NCCF')
        if f(1) ~= 0
            print(f(1),'-dpdf',[filename,'_',num2str(length(list)+1),'_temp.pdf'],'-opengl');
        end
        if length(f) > 1
            print(f(2),'-dpdf',[filename,'_',num2str(length(list)+2),'_temp.pdf'],'-opengl');
        end
    end
    list = dir('indexes_*');
    if strfind(filename,'indexes')
        if f(1) ~= 0
            print(f(1),'-dpdf',[filename,'_',num2str(length(list)+1),'_temp.pdf'],'-opengl');
        end
        if length(f) > 1
            print(f(2),'-dpdf',[filename,'_',num2str(length(list)+2),'_temp.pdf'],'-opengl');
        end
    end
    cd(pluginFolder);
end