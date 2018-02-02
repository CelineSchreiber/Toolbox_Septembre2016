% % % =========================================================================
% % % Functional method (for knee joint)
% % % =========================================================================
% % Rstatic(3).rM = [Markers.Shank_Proximal,Markers.Shank_Anterior,Markers.Shank_Posterior];
% % Rstatic(4).rM = [Markers.Thigh_Proximal,Markers.Thigh_Anterior,Markers.Thigh_Posterior];
% % 
% % clear Markers n n1 n2 f1 f2 e;
% % ffunctional = Session.Functional(1).file;
% % Markers = btkGetMarkers(ffunctional);
% % nf = btkGetLastFrame(ffunctional)-btkGetFirstFrame(ffunctional)+1;
% % f = 100;
% % 
% % names = fieldnames(Markers);
% % for i = 1:length(names)
% %     temp1 = Markers.(names{i})(:,1);
% %     temp2 = Markers.(names{i})(:,3);
% %     temp3 = -Markers.(names{i})(:,2);
% %     Markers.(names{i})(:,1) = temp1;
% %     Markers.(names{i})(:,2) = temp2;
% %     Markers.(names{i})(:,3) = temp3;        
% %     Markers.(names{i}) = Markers.(names{i})*10^(-3);        
% %     for j = 1:nf
% %         if Markers.(names{i})(j,:) == [0 0 0]
% %             Markers.(names{i})(j,:) = nan(1,3);
% %         end
% %     end        
% %     [B,A] = butter(4,6/(f/2),'low');
% %     for j = 1:3
% %         x = 1:nf;
% %         y = Markers.(names{i});
% %         xx = 1:1:nf;
% %         temp = interp1(x,y,xx,'spline');
% %         Markers.(names{i}) = filtfilt(B,A,temp);
% %     end        
% %     Markers.(names{i}) = permute(Markers.(names{i}),[2,3,1]);
% % end
% % 
% % Rfunctional(3).rM = [Markers.Shank_Proximal,Markers.Shank_Anterior,Markers.Shank_Posterior];
% % Rfunctional(4).rM = [Markers.Thigh_Proximal,Markers.Thigh_Anterior,Markers.Thigh_Posterior];
% % 
% % for j = 3:4        
% %     Rotation = [];
% %     Translation = [];
% %     RMS = [];        
% %     for i = 1:nf
% %         [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
% %             = soder(Rstatic(j).rM',Rfunctional(j).rM(:,:,i)');
% %     end        
% %     Rfunctional(j).Q = [Mprod_array3(Rotation , ...
% %         repmat(Rstatic(j).Q(1:3,1,:),[1 1 nf])); ...
% %         Mprod_array3(Rotation,repmat(Rstatic(j).Q(4:6,1,:),[1 1 nf])) ...
% %         + Translation; ...
% %         Mprod_array3(Rotation,repmat(Rstatic(j).Q(7:9,1,:),[1 1 nf])) ...
% %         + Translation; ...
% %         Mprod_array3(Rotation,repmat(Rstatic(j).Q(10:12,1,:),[1 1 nf]))];        
% % end
% % 
% % Rfunctional(3).T = Q2Tuv_array3(Rfunctional(3).Q);
% % Rfunctional(4).T = Q2Tuv_array3(Rfunctional(4).Q);
% % 
% % AoR = SARA_array3(Rfunctional(4).T,Rfunctional(3).T);
% % CoR = SCoRE_array3(Rfunctional(4).T,Rfunctional(3).T);
% % % Rfunctional(4).Q(7:9,:,:) = CoR;
% % Rfunctional(4).Q(10:12,:,:) = AoR;
% % % Rfunctional(3).Q(4:6,:,:) = CoR;
% % % Segment = Rfunctional;
% % % Main_Segment_Visualisation;
% % 
% % for j = 3:4        
% %     Rotation = [];
% %     Translation = [];
% %     RMS = [];        
% %     for i = 1:nf
% %         [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
% %             = soder(Rfunctional(j).rM(:,:,i)',Rstatic(j).rM');
% %     end      
% %     Rstatic(j).Q = [];
% %     Rstatic(j).Q = mean([Mprod_array3(Rotation , ...
% %         Rfunctional(j).Q(1:3,1,:)); ...
% %         Mprod_array3(Rotation,Rfunctional(j).Q(4:6,1,:)) ...
% %         + Translation; ...
% %         Mprod_array3(Rotation,Rfunctional(j).Q(7:9,1,:)) ...
% %         + Translation; ...
% %         Mprod_array3(Rotation,Rfunctional(j).Q(10:12,1,:))],3);        
% % end

% % =========================================================================
% % Functional method (for ankle joint)
% % =========================================================================
% Rstatic(2).rM = [Markers.R_FCC,Markers.R_FM5,Markers.R_FM1];
% Rstatic(3).rM = [Markers.R_FAX,Markers.R_TTC,Markers.R_FAL];
% 
% clear Markers n n1 n2 f1 f2 e;
% ffunctional = Session.Functional(1).file;
% Markers = btkGetMarkers(ffunctional);
% nf = btkGetLastFrame(ffunctional)-btkGetFirstFrame(ffunctional)+1;
% f = 100;
% 
% names = fieldnames(Markers);
% for i = 1:length(names)
%     temp1 = Markers.(names{i})(:,1);
%     temp2 = Markers.(names{i})(:,3);
%     temp3 = -Markers.(names{i})(:,2);
%     Markers.(names{i})(:,1) = temp1;
%     Markers.(names{i})(:,2) = temp2;
%     Markers.(names{i})(:,3) = temp3;        
%     Markers.(names{i}) = Markers.(names{i})*10^(-3);        
%     for j = 1:nf
%         if Markers.(names{i})(j,:) == [0 0 0]
%             Markers.(names{i})(j,:) = nan(1,3);
%         end
%     end        
%     [B,A] = butter(4,6/(f/2),'low');
%     for j = 1:3
%         x = 1:nf;
%         y = Markers.(names{i});
%         xx = 1:1:nf;
%         temp = interp1(x,y,xx,'spline');
%         Markers.(names{i}) = filtfilt(B,A,temp);
%     end        
%     Markers.(names{i}) = permute(Markers.(names{i}),[2,3,1]);
% end
% 
% Rfunctional(2).rM = [Markers.R_FCC,Markers.R_FM5,Markers.R_FM1];
% Rfunctional(3).rM = [Markers.R_FAX,Markers.R_TTC,Markers.R_FAL];
% 
% for j = 2:3        
%     Rotation = [];
%     Translation = [];
%     RMS = [];        
%     for i = 1:nf
%         [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
%             = soder(Rstatic(j).rM',Rfunctional(j).rM(:,:,i)');
%     end        
%     Rfunctional(j).Q = [Mprod_array3(Rotation , ...
%         repmat(Rstatic(j).Q(1:3,1,:),[1 1 nf])); ...
%         Mprod_array3(Rotation,repmat(Rstatic(j).Q(4:6,1,:),[1 1 nf])) ...
%         + Translation; ...
%         Mprod_array3(Rotation,repmat(Rstatic(j).Q(7:9,1,:),[1 1 nf])) ...
%         + Translation; ...
%         Mprod_array3(Rotation,repmat(Rstatic(j).Q(10:12,1,:),[1 1 nf]))];        
% end
% 
% Rfunctional(2).T = Q2Tuv_array3(Rfunctional(2).Q);
% Rfunctional(3).T = Q2Tuv_array3(Rfunctional(3).Q);
% 
% AoR = SARA_array3(Rfunctional(3).T,Rfunctional(2).T);
% CoR = SCoRE_array3(Rfunctional(3).T,Rfunctional(2).T);
% Rfunctional(3).Q(7:9,:,:) = CoR;
% Rfunctional(3).Q(10:12,:,:) = -AoR;
% Rfunctional(2).Q(4:6,:,:) = CoR;
% % Segment = Rfunctional;
% % Main_Segment_Visualisation;
% 
% for j = 2:3        
%     Rotation = [];
%     Translation = [];
%     RMS = [];        
%     for i = 1:nf
%         [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
%             = soder(Rfunctional(j).rM(:,:,i)',Rstatic(j).rM');
%     end      
%     Rstatic(j).Q = [];
%     Rstatic(j).Q = mean([Mprod_array3(Rotation , ...
%         Rfunctional(j).Q(1:3,1,:)); ...
%         Mprod_array3(Rotation,Rfunctional(j).Q(4:6,1,:)) ...
%         + Translation; ...
%         Mprod_array3(Rotation,Rfunctional(j).Q(7:9,1,:)) ...
%         + Translation; ...
%         Mprod_array3(Rotation,Rfunctional(j).Q(10:12,1,:))],3);        
% end