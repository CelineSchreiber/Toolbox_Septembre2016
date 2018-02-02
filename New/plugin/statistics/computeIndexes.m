function Index=computeIndexes(Session,Trial,Normatives)

%% -------------------------------------------------------------------------
% NI DROITE %
% Attention: calcul sur 16 paramètres pour les enfants et 15 pour les
% adultes
%--------------------------------------------------------------------------
Index=[];
if isfield(Trial,'Rkinematics') 

    if isfield(Trial.Rkinematics,'Pobli')

        if ~isempty(Trial.Rkinematics.Pobli)%strcmp(Session.Gait.gaittrial,'yes')

            TO=round(Normatives.Gaitparameters.right_stance_phase.data);
            S1=Normatives.Gaitparameters.right_stance_phase.data;
            S2=Normatives.Gaitparameters.mean_velocity_adim.data;               % Walking Speed/leg_length_R?;
            S3=Normatives.Gaitparameters.cadence.data;                          % cadence en HZ
            S4=mean(Normatives.Rkinematics.Ptilt.data(:,1:2:end));              % Mean Pelvic Tilt
            S5=max(Normatives.Rkinematics.Ptilt.data(:,1:2:end))-min(Normatives.Rkinematics.Ptilt.data(:,1:2:end)); % Range of Pelvic Tilt
            S6=mean(Normatives.Rkinematics.Prota.data(:,1:2:end));              % Mean Pelvic Rotation
            S7=min(Normatives.Rkinematics.FE4.data(:,1:2:end));                 % Minimum Hip Flexion
            S8=max(Normatives.Rkinematics.FE4.data(:,1:2:end))-min(Normatives.Rkinematics.FE4.data(:,1:2:end));     % Range of Hip Flexion
            S9=max(Normatives.Rkinematics.AA4.data(TO:end,1:2:end));            % Peak Abduction in swing
            S10=mean(Normatives.Rkinematics.IER4.data(1:TO,1:2:end));           % Mean hip rotation in stance
            S11=-Normatives.Rkinematics.FE3.data(1,1:2:end);                    % Knee flexion at initial contact
            [m,S12]=max(-Normatives.Rkinematics.FE3.data(:,1:2:end));  
            S13=max(-Normatives.Rkinematics.FE3.data(:,1:2:end))-min(-Normatives.Rkinematics.FE3.data(:,1:2:end));
            S14=max(Normatives.Rkinematics.FE2.data(1:TO,1:2:end));             % Peak dorsiflexion in stance
            S15=max(Normatives.Rkinematics.FE2.data(TO:end,1:2:end));           % Peak dorsiflexion in swing
            S16=mean(Normatives.Rkinematics.Frota.data(1:TO,1:2:end));           % Mean Frota progression angle in stance

            dataS = [S1',S2',S3',S4',S5',S6',S7',S8',S9',S10',S11',S13',S14',S15',S16'];
            meanS = mean(dataS,1);
            stdS = std(dataS,0,1);

            %Centrage des donnees Sujet Sains
            for i=1:size(dataS,1)
                for j=1:size(dataS,2)
                    Z(i,j) = (dataS(i,j) - meanS(j)) / stdS(j);
                end
            end

            C = corrcoef(Z);
            [u,lambda] = eig(C);
            % u = matrice des vecteurs propres (p x p)
            % lambda = matrice diagonale des valeurs propres
            lambda = sum(lambda); % transformation de lambda en vecteur ligne (1 x p)
            % tri par ordre decroissant des valeurs propres
            [lambda,indexes]=sort(lambda,2,'descend');
            u=u(:,indexes);

            % Coordonnées des individus actifs
            Psi = Z*u;

            % Distance aux axes des individus actifs
            for i=1:size(Psi,1)
                Dist_Indiv(i) = 0;
                for j = 1:15
                    Dist_Indiv(i) = Dist_Indiv(i) + (Psi(i,j)*Psi(i,j));
                end
            end

            % Coordonnées des variables actives
            Phi = repmat(sqrt(lambda),15,1).*u;

            %Données Sujet Patient
            TO=round(Trial.Gaitparameters.right_stance_phase);
            P1=Trial.Gaitparameters.right_stance_phase;
            P2=Trial.Gaitparameters.mean_velocity_adim;              % Walking Speed/leg_length_R?;
            P3=Trial.Gaitparameters.cadence;                    % cadence en HZ
            P4=mean(Trial.Rkinematics.Ptilt(:,1));              % Mean Pelvic Tilt
            P5=max(Trial.Rkinematics.Ptilt(:,1))-min(Trial.Rkinematics.Ptilt(:,1)); % Range of Pelvic Tilt
            P6=mean(Trial.Rkinematics.Prota(:,1));              % Mean Pelvic Rotation
            P7=min(Trial.Rkinematics.FE4(:,1));                 % Minimum Hip Flexion
            P8=max(Trial.Rkinematics.FE4(:,1))-min(Trial.Rkinematics.FE4(:,1));     % Range of Hip Flexion
            P9=max(Trial.Rkinematics.AA4(TO:end,1));            % Peak Abduction in swing
            P10=mean(Trial.Rkinematics.IER4(1:TO,1));            % Mean hip rotation in stance
            P11=-Trial.Rkinematics.FE3(1,1);                    % Knee flexion at initial contact
            [m,P12]=max(-Trial.Rkinematics.FE3(:,1));  
            P13=max(-Trial.Rkinematics.FE3(:,1))-min(-Trial.Rkinematics.FE3(:,1));
            P14=max(Trial.Rkinematics.FE2(1:TO,1));             % Peak dorsiflexion in stance
            P15=max(Trial.Rkinematics.FE2(TO:end,1));           % Peak dorsiflexion in swing
            P16=mean(Trial.Rkinematics.Frota(1:TO,1));           % Mean Frota progression angle in stance

            dataP = [P1',P2',P3',P4',P5',P6',P7',P8',P9',P10',P11',P13',P14',P15',P16'];
            meanP = mean(dataP,1);
            stdP = std(dataP,0,1);

            %Centrage des données Sujet Patient
            for i=1:size(dataP,1)
                for j=1:size(dataP,2)
                    Ztilda(i,j) = (dataP(i,j) - meanS(j)) / stdS(j);
                end
            end
            Psi_illus = Ztilda*u;

            for i=1:size(Psi_illus,1)
                NI.R(i) = 0;
                for j = 1:15
                    NI.R(i) = NI.R(i) + (Psi_illus(i,j)*Psi_illus(i,j));
                end
            end

            %% NI GAUCHE
            %--------------------------------------------------------------------------
            TO=round(Normatives.Gaitparameters.left_stance_phase.data);
            S1=Normatives.Gaitparameters.left_stance_phase.data;
            S2=Normatives.Gaitparameters.mean_velocity_adim.data;                    % Walking Speed/leg_length_R?;
            S3=Normatives.Gaitparameters.cadence.data;                          % cadence en HZ
            S4=mean(Normatives.Lkinematics.Ptilt.data(:,2:2:end));              % Mean Pelvic Tilt
            S5=max(Normatives.Lkinematics.Ptilt.data(:,2:2:end))-min(Normatives.Lkinematics.Ptilt.data(:,2:2:end)); % Range of Pelvic Tilt
            S6=mean(Normatives.Lkinematics.Prota.data(:,2:2:end));              % Mean Pelvic Rotation
            S7=min(Normatives.Lkinematics.FE4.data(:,2:2:end));                 % Minimum Hip Flexion
            S8=max(Normatives.Lkinematics.FE4.data(:,2:2:end))-min(Normatives.Lkinematics.FE4.data(:,2:2:end));     % Range of Hip Flexion
            S9=max(Normatives.Lkinematics.AA4.data(TO:end,2:2:end));            % Peak Abduction in swing
            S10=mean(Normatives.Lkinematics.IER4.data(1:TO,2:2:end));           % Mean hip rotation in stance
            S11=-Normatives.Lkinematics.FE3.data(1,2:2:end);                    % Knee flexion at initial contact
            [m,S12]=max(-Normatives.Lkinematics.FE3.data(:,2:2:end));  
            S13=max(-Normatives.Lkinematics.FE3.data(:,2:2:end))-min(-Normatives.Lkinematics.FE3.data(:,2:2:end));
            S14=max(Normatives.Lkinematics.FE2.data(1:TO,2:2:end));             % Peak dorsiflexion in stance
            S15=max(Normatives.Lkinematics.FE2.data(TO:end,2:2:end));           % Peak dorsiflexion in swing
            S16=mean(Normatives.Lkinematics.Frota.data(1:TO,2:2:end));           % Mean Frota progression angle in stance

            dataS = [S1',S2',S3',S4',S5',S6',S7',S8',S9',S10',S11',S13',S14',S15',S16'];
            meanS = mean(dataS,1);
            stdS = std(dataS,0,1);

            %Centrage des données Sujet Sains
            for i=1:size(dataS,1)
                for j=1:15
                    Z(i,j) = (dataS(i,j) - meanS(j)) / stdS(j);
                end
            end

            C = corrcoef(Z);
            [u,lambda] = eig(C);
            % u = matrice des vecteurs propres (p x p)
            % lambda = matrice diagonale des valeurs propres
            lambda = sum(lambda); % transformation de lambda en vecteur ligne (1 x p)
            % tri par ordre decroissant des valeurs propres
            [lambda,indexes]=sort(lambda,2,'descend');
            u=u(:,indexes);

            % Coordonnées des individus actifs
            Psi = Z*u;

            % Distance aux axes des individus actifs
            for i=1:size(Psi,1)
                Dist_Indiv(i) = 0;
                for j = 1:15
                    Dist_Indiv(i) = Dist_Indiv(i) + (Psi(i,j)*Psi(i,j));
                end
            end

            % Coordonnées des variables actives
            Phi = repmat(sqrt(lambda),15,1).*u;


            %Données Sujet Patient
            TO=round(Trial.Gaitparameters.left_stance_phase);
            P1=Trial.Gaitparameters.left_stance_phase;
            P2=Trial.Gaitparameters.mean_velocity_adim;                    % Walking Speed/leg_length_R?;
            P3=Trial.Gaitparameters.cadence;                          % cadence en HZ
            P4=mean(Trial.Lkinematics.Ptilt(:,1));              % Mean Pelvic Tilt
            P5=max(Trial.Lkinematics.Ptilt(:,1))-min(Trial.Lkinematics.Ptilt(:,1)); % Range of Pelvic Tilt
            P6=mean(Trial.Lkinematics.Prota(:,1));              % Mean Pelvic Rotation
            P7=min(Trial.Lkinematics.FE4(:,1));                 % Minimum Hip Flexion
            P8=max(Trial.Lkinematics.FE4(:,1))-min(Trial.Lkinematics.FE4(:,1));     % Range of Hip Flexion
            P9=max(Trial.Lkinematics.AA4(TO:end,1));            % Peak Abduction in swing
            P10=mean(Trial.Lkinematics.IER4(1:TO,1));           % Mean hip rotation in stance
            P11=-Trial.Lkinematics.FE3(1,1);                    % Knee flexion at initial contact
            [m,P12]=max(-Trial.Lkinematics.FE3(:,1));  
            P13=max(-Trial.Lkinematics.FE3(:,1))-min(-Trial.Lkinematics.FE3(:,1));
            P14=max(Trial.Lkinematics.FE2(1:TO,1));             % Peak dorsiflexion in stance
            P15=max(Trial.Lkinematics.FE2(TO:end,1));           % Peak dorsiflexion in swing
            P16=mean(Trial.Lkinematics.Frota(1:TO,1));           % Mean Frota progression angle in stance

            dataP = [P1',P2',P3',P4',P5',P6',P7',P8',P9',P10',P11',P13',P14',P15',P16'];
            meanP = mean(dataP,1);
            stdP = std(dataP,0,1);

            %Centrage des données Sujet Patient
            for i=1:size(dataP,1)
                for j=1:15
                    Ztilda(i,j) = (dataP(i,j) - meanS(j)) / stdS(j);
                end
            end
            Psi_illus = Ztilda*u;

            for i=1:size(Psi_illus,1)
                NI.L(i) = 0;
                for j = 1:15
                    NI.L(i) = NI.L(i) + (Psi_illus(i,j)*Psi_illus(i,j));
                end
            end
            NI.O=mean([NI.R NI.L],2);

            Index.NI=NI;

            %% ------------------------------------------------------------------------
            % GDI
            %--------------------------------------------------------------------------

            ordre=15;

            % Calcul de G pour les sujets sains 
            %-----------------------------------
            [s1,s2]=size(Normatives.Rkinematics.Ptilt.data);
            n=[];
            for i=1:s2
                n=[n;Normatives.Rkinematics.Ptilt.data(1:2:101,i)',...
                    Normatives.Rkinematics.Pobli.data(1:2:101,i)',...
                    Normatives.Rkinematics.Prota.data(1:2:101,i)',...
                    Normatives.Rkinematics.FE4.data(1:2:101,i)',...
                    Normatives.Rkinematics.AA4.data(1:2:101,i)',...
                    Normatives.Rkinematics.IER4.data(1:2:101,i)',...
                    Normatives.Rkinematics.FE3.data(1:2:101,i)',...
                    Normatives.Rkinematics.FE2.data(1:2:101,i)',...
                    Normatives.Rkinematics.Frota.data(1:2:101,i)'];
            end
            n=n';

            % Singular Value decomposition
            %------------------------------
            [U,S,V]=svd(n);
            f1_15=U(:,1:ordre); % approximation d'ordre 15

            C = (f1_15'*n)';
            Cmean = mean(C,1);
            delta = C - ones(size(C,1),1) * Cmean;

            for i=1:size(C,1)
                lnd(i,1) = log(sqrt(cumsum(delta(i,:)*delta(i,:)')));
            end

            mean_lnd = mean(lnd,1);
            std_lnd = std(lnd,0,1); 

            % Calcul de G pour les sujets patho
            %----------------------------------

            g.R=[];g.L=[];
            g.R = [Trial.Rkinematics.Ptilt(1:2:101)',...
                    Trial.Rkinematics.Pobli(1:2:101)',...
                    Trial.Rkinematics.Prota(1:2:101)',...
                    Trial.Rkinematics.FE4(1:2:101)',...
                    Trial.Rkinematics.AA4(1:2:101)',...
                    Trial.Rkinematics.IER4(1:2:101)',...
                    Trial.Rkinematics.FE3(1:2:101)',...
                    Trial.Rkinematics.FE2(1:2:101)',...
                    Trial.Rkinematics.Frota(1:2:101)'];
            g.L = [Trial.Lkinematics.Ptilt(1:2:101)',...
                    Trial.Lkinematics.Pobli(1:2:101)',...
                    Trial.Lkinematics.Prota(1:2:101)',...
                    Trial.Lkinematics.FE4(1:2:101)',...
                    Trial.Lkinematics.AA4(1:2:101)',...
                    Trial.Lkinematics.IER4(1:2:101)'....
                    Trial.Lkinematics.FE3(1:2:101)',...
                    Trial.Lkinematics.FE2(1:2:101)',...
                    Trial.Lkinematics.Frota(1:2:101)'];

            for i=1:size(g.L,1)
                Csubject = g.L(i,:) * f1_15;
                Diff = Csubject - Cmean;
                ln = log(sqrt(cumsum(Diff*Diff')));
                Z = (ln - mean_lnd) / std_lnd; 
                GDI.L(i) = 100 - 10*Z;
            end

            for i=1:size(g.R,1)
                Csubject = g.R(i,:) * f1_15;
                Diff = Csubject - Cmean;
                ln = log(sqrt(cumsum(Diff*Diff')));
                Z = (ln - mean_lnd) / std_lnd; 
                GDI.R(i) = 100 - 10*Z;
            end
            GDI.O=mean([GDI.R GDI.L],2);
            Index.GDI=GDI;

            %% ------------------------------------------------------------------------
            % GPS & GVS
            %--------------------------------------------------------------------------

            n=[Normatives.Rkinematics.Ptilt.mean;...
                Normatives.Rkinematics.Pobli.mean;...
                Normatives.Rkinematics.Prota.mean;...
                Normatives.Rkinematics.FE4.mean;...
                Normatives.Rkinematics.AA4.mean;...
                Normatives.Rkinematics.IER4.mean;...
                Normatives.Rkinematics.FE3.mean;...
                Normatives.Rkinematics.FE2.mean;...
                Normatives.Rkinematics.Frota.mean;...
                Normatives.Lkinematics.FE4.mean;...
                Normatives.Lkinematics.AA4.mean;...
                Normatives.Lkinematics.IER4.mean;...
                Normatives.Lkinematics.FE3.mean;...
                Normatives.Lkinematics.FE2.mean;...
                Normatives.Lkinematics.Frota.mean];

            g=[Trial.Rkinematics.Ptilt;...
                    Trial.Rkinematics.Pobli;...
                    Trial.Rkinematics.Prota;...
                    Trial.Rkinematics.FE4;...
                    Trial.Rkinematics.AA4;...
                    Trial.Rkinematics.IER4;...
                    Trial.Rkinematics.FE3;...
                    Trial.Rkinematics.FE2;...
                    Trial.Rkinematics.Frota;...
                    Trial.Lkinematics.FE4;...
                    Trial.Lkinematics.AA4;...
                    Trial.Lkinematics.IER4;...
                    Trial.Lkinematics.FE3;...
                    Trial.Lkinematics.FE2;...
                    Trial.Lkinematics.Frota];

            for i=1:size(g,2)                       % RMS=(somme des carrés)/longueur
                Diff = g(:,i) - n;
                for j=1:15
                    GVS.O(j,i) = RMS(Diff((1+(j-1)*101):(j*101)));
                end
                GPS.R(i)=RMS(Diff(1:(9*101)));
                GPS.L(i)=RMS([Diff(1:303);Diff(910:end)]);
                GPS.O(i)=RMS(Diff);
            end
            Index.GPS=GPS;
            Index.GVS=GVS;

        else
            Index.NI.R=[];
            Index.NI.L=[];
            Index.NI.O=[];
            Index.GDI.R=[];
            Index.GDI.L=[];
            Index.GDI.O=[];
            Index.GPS.R=[];
            Index.GPS.L=[];
            Index.GPS.O=[];
            Index.GVS.O=[];
        end
    end
end

function RMS = RMS(vector)
% RMS=(somme des carrés)/longueur
%--------------------------------
l=length(vector);
S=0;
for i=1:l
    S=S+vector(i)*vector(i);
end
RMS=sqrt(S/l);


