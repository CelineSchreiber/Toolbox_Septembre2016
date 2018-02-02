% Create the figure
mFigure = figure()
 
% Create a uicontrol of type "text"
mTextBox = uicontrol('style','text')
set(mTextBox,'String',datestr(now,1))

figure;
annotation('textbox', [0 0 .2 .5], 'FitHeightToText', 'ON', 'Fontsize', 24, ...
           'String', datestr(now,1));
 
system(['toolbox\ffmpeg.exe -i gait06_Oqus_11_13634.avi -i logoRHZ.png -filter_complex overlay=0:0 -qscale 6 test2.ogv'])