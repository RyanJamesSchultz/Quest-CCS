% Script to make Figure S31 - the spatiotemporal migration of events.
clear;

% Predefine some stuff.
McA=2.0;
McS=0.0;
McX=1.0;

% Boundary polygons and stuff.
latB=[  54.9   54.9   53.4   53.4]; % General area.
lonB=[-114.2 -112.0 -112.0 -114.2]; % General area.
%latB=[  53.96   53.96   53.89   53.89]; % M4-2026 cluster.
%lonB=[-113.45 -113.30 -113.30 -113.45]; % M4-2026 cluster.
%latB=[  54.05   54.05   53.90   53.90]; % STZ cluster.
%lonB=[-112.80 -112.45 -112.45 -112.80]; % STZ cluster.
%latB=[  54.30   54.30   54.10   54.10]; % NE cluster.
%lonB=[-112.85 -112.35 -112.35 -112.85]; % NE cluster.
lonDB=[-114.20 -112.00]; latDB=[54.9 53.4];
depB=-1;
tB=-1;
mB=[-4 8];
idB=-1;
ddB=1;
vB=10;

% SLA area & pipelines.
data=load('../../data/Quest/SLA.txt');        lonSLA=data(:,1);  latSLA=data(:,2);
data=load('../../data/Quest/Pipeline.txt');   lonPIPE=data(:,1); latPIPE=data(:,2);
data=load('../../data/Quest/05-35_pipe.txt'); lonPIP1=data(:,1); latPIP1=data(:,2);
data=load('../../data/Quest/07-11_pipe.txt'); lonPIP2=data(:,1); latPIP2=data(:,2);
data=load('../../data/Quest/08-19_pipe.txt'); lonPIP3=data(:,1); latPIP3=data(:,2);

% Outline of Edmonton.
data=load('../../data/YEG/Municipal_Boundaries.csv');  lonYEG=data(:,1); latYEG=data(:,2);

% Quest well locations.
latW=[54.143164 54.113623 54.085031];
lonW=[-113.046104 -112.978885 -112.886708];

% Well information.
%load('../../data/Wells/Enervus/INJ_all.mat','S');    Se=S;
%load('../../data/Wells/Enervus/INJ_active.mat','S'); Sa=S;
%load('../../data/Wells/Enervus/INJ_deep.mat','S');   Sd=S;

% Load in catalogue data.
%file1='../../data/Catalogues/AGS.csv';
file1='../../data/Catalogues/final/ShellQuest_Cat.csv';
file2='../../data/Catalogues/QCCS.csv';
file3='../../Manuscript/Tables/TableS3.csv';
%[lat_eqA,lon_eqA,dep_eqA,TeqA,MeqA]=parseAGS(file1,latB,lonB,depB,tB,mB);
[lat_eqA,lon_eqA,dep_eqA,TeqA,MeqA,evIDa]=parseRYN(file1,latB,lonB,depB,tB,mB,-1,-1);
[lat_eqX,lon_eqX,dep_eqX,TeqX,MeqX]=parseRYNx(file3,latB,lonB,depB,tB,mB,-1,-1,-1);
[lat_eqS,lon_eqS,dep_eqS,TeqS,MeqS]=parseQCCS(file2,-1,-1,-1,-1,-1);
%[lat_eqS,lon_eqS] = utm2deg(lon_eqS,lat_eqS,repmat(['12 N'],length(lat_eqS), 1));

% Load in station data.
load('../../data/Stations/STN.mat','D');

% Basement faults.
%[Sf]=parseFaults('../../data/Basement/AB_Geo.txt');




%%% Plot.
GREY=[0.85,0.85,0.85];

% Get plot aspect ratio.
Va=(max(latB)-min(latB))/(max(lonB)-min(lonB))/cosd(mean(latB));

% Make the magnitude size axis.
RsA=getMscale(MeqA)/2;
RsS=getMscale(MeqS)/2;
RsX=getMscale(MeqX)/1;

% Study area map.
figure(531); clf;

for i=1:12
    Ts2=datetime(2015+i,1,1);
    Ts1=datetime(2015+i-1,1,1);
    Ia2=TeqA<Ts2; Ia1=(TeqA<Ts2)&(TeqA>Ts1);
    Ix2=TeqX<Ts2; Ix1=(TeqX<Ts2)&(TeqX>Ts1);
    Is2=TeqS<Ts2; Is1=(TeqS<Ts2)&(TeqS>Ts1);
    subplot(3,4,i);
    %plot(-113.494547,53.526844,'sk','MarkerFaceColor',GREY); hold on; % Edmonton centre.
    plot(lonYEG,latYEG,'-k'); hold on; % Edmonton outline.
    plot(lonSLA,latSLA,'-k'); % SLA.
    plot(lonPIPE,latPIPE,'-b'); % Pipeline.
    plot(lonPIP1,latPIP1,'-b'); % Pipeline.
    plot(lonPIP2,latPIP2,'-b'); % Pipeline.
    plot(lonPIP3,latPIP3,'-b'); % Pipeline.
    scatter(lon_eqA(Ia2),lat_eqA(Ia2),RsA(Ia2),'o','MarkerEdgeColor','k','MarkerFaceColor',GREY);
    scatter(lon_eqX(Ix2),lat_eqX(Ix2),RsX(Ix2),'o','MarkerEdgeColor','k','MarkerFaceColor',GREY);
    %scatter(lon_eqS(Is2),lat_eqS(Is2),RsS(Is2),'o','MarkerEdgeColor','k','MarkerFaceColor',GREY);
    scatter(lon_eqA(Ia1),lat_eqA(Ia1),RsA(Ia1),'o','MarkerEdgeColor','k','MarkerFaceColor','r');
    scatter(lon_eqX(Ix1),lat_eqX(Ix1),RsX(Ix1),'o','MarkerEdgeColor','k','MarkerFaceColor','#FF4500');
    %scatter(lon_eqS(Is1),lat_eqS(Is1),RsS(Is1),'o','MarkerEdgeColor','k','MarkerFaceColor','m');
    % Add wells.
    plot(lonW,latW,'db','MarkerFaceColor','b');
    %for i=1:length(Se)
    %    plot(Se(i).Slon,Se(i).Slat,'dk','MarkerFaceColor',GREY);
    %end
    %for i=1:length(Sa)
    %    if(strcmpi(Sa(i).type,'OIL'))
    %        plot(Sa(i).Slon,Sa(i).Slat,'dk');
    %    elseif(strcmpi(Sa(i).type,'GAS'))
    %        plot(Sa(i).Slon,Sa(i).Slat,'dg');
    %    elseif(strcmpi(Sa(i).type,'INJECTOR'))
    %        plot(Sa(i).Slon,Sa(i).Slat,'db');
    %    end
    %end
    %for i=1:length(Sd)
    %    if(strcmpi(Sd(i).type,'OIL'))
    %        plot(Sd(i).Slon,Sd(i).Slat,'dk','MarkerFaceColor','k');
    %    elseif(strcmpi(Sd(i).type,'GAS'))
    %        plot(Sd(i).Slon,Sd(i).Slat,'dg','MarkerFaceColor','g');
    %    elseif(strcmpi(Sd(i).type,'INJECTOR'))
    %        plot(Sd(i).Slon,Sd(i).Slat,'db','MarkerFaceColor','b');
    %    end
    %end
    %for i=1:length(D)
    %    plot(D(i).lon,D(i).lat,'^k','MarkerFaceColor','g');
    %end
    %for i=1:length(Sf)
    %    plot(Sf(i).lon,Sf(i).lat,'-k');
    %end
    %plot(lonW,latW,'sk','MarkerFaceColor','b');
    xlabel('Longitude'); ylabel('Latitude'); zlabel('Depth (km)');
    xlim([min(lonDB) max(lonDB)]); ylim([min(latDB) max(latDB)]);
    pbaspect([1 Va 1]);
    title(num2str(year(Ts1)));
end
% Report events above M2.
%I=find(MeqA>2.0);
%for i=1:length(I)
%    fprintf('%s, %f, %f, M_L %f\n',TeqA(I(i)), lat_eqA(I(i)), lon_eqA(I(i)), MeqA(I(i)));
%end




%%%% SUBROUNTINES.

% Get the size of rupture from event magnitude.
function [Rs]=getMscale(ML)
  %Mw=0.754*ML+0.884;% ML to Mw [Yenier, 2017; Ross et al., 2016].
  Mw=ML;
  Mo=10.^(1.5*Mw+9.1); % Mw to Mo (Nm).
  Rs=nthroot((7/16)*(Mo/3e6),3); % Mo to radius (m), assuming a stress dop of 3 MPa.
end

