% Script to make Figure 4 - the links to past tectonics.
clear;

% Predefine some stuff.
McA=2.0;
McS=0.0;
McC=4.0;

% Boundary polygons and stuff.
latB=[  54.9   54.9   53.4   53.4]; % General area.
lonB=[-114.2 -112.0 -112.0 -114.2]; % General area.
lonDB=[-114.00 -112.20]; latDB=[54.6 53.65];
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

% Load in catalogue data.
%file1='../../data/Catalogues/AGS.csv';
file1='../../data/Catalogues/final/ShellQuest_Cat.csv';
file2='../../data/Catalogues/QCCS.csv';
file3='../../data/Catalogues/NRCan.csv';
%[lat_eqA,lon_eqA,dep_eqA,TeqA,MeqA]=parseAGS(file1,latB,lonB,depB,tB,mB);
[lat_eqA,lon_eqA,dep_eqA,TeqA,MeqA]=parseRYN(file1,latB,lonB,depB,tB,mB,-1,-1);
%[lat_eqC,lon_eqC,dep_eqC,TeqC,MeqC]=parseNRCan(file3,latB,lonB,depB,tB,mB);
%[lat_eqS,lon_eqS,dep_eqS,TeqS,MeqS]=parseQCCS(file2,-1,-1,-1,-1,-1);
%[lat_eqS,lon_eqS] = utm2deg(lon_eqS,lat_eqS,repmat(['12 N'],length(lat_eqS), 1));

% Basement faults.
[Sf]=parseFaults('../../data/Basement/AB_Geo.txt');




%%% Plot.
GREY=[0.85,0.85,0.85];

% Get plot aspect ratio.
Va=(max(latB)-min(latB))/(max(lonB)-min(lonB))/cosd(mean(latB));

% Make the magnitude size axis.
RsA=getMscale(MeqA)/3;
%RsS=getMscale(MeqS)/1;
%RsC=getMscale(MeqC)/1;

% Study area map.
figure(4); clf;
plot(-113.494547,53.526844,'sk','MarkerFaceColor',GREY); hold on; % Edmonton centre.
plot(lonYEG,latYEG,'-k'); % Edmonton outline.
plot(lonSLA,latSLA,'-k'); % SLA.
plot(lonPIPE,latPIPE,'-k'); % Pipeline.
plot(lonPIP1,latPIP1,'-k'); % Pipeline.
plot(lonPIP2,latPIP2,'-k'); % Pipeline.
plot(lonPIP3,latPIP3,'-k'); % Pipeline.
%plot(Tlon,Tlat,'-k');
scatter(lon_eqA,lat_eqA,RsA,'or','MarkerFaceColor',GREY);
scatter(lon_eqA(MeqA>=McA),lat_eqA(MeqA>=McA),RsA(MeqA>=McA),'ok','MarkerFaceColor','r');
%scatter(lon_eqC,lat_eqC,RsC,'om','MarkerFaceColor',GREY);
%scatter(lon_eqC(MeqC>=McC),lat_eqC(MeqC>=McC),RsC(MeqC>=McC),'ok','MarkerFaceColor','m');
%scatter(lon_eqS,lat_eqS,RsS,'om','MarkerFaceColor',GREY);
%scatter(lon_eqS(MeqS>=McS),lat_eqS(MeqS>=McS),RsS(MeqS>=McS),'ok','MarkerFaceColor','m');
for i=1:length(Sf)
    plot(Sf(i).lon,Sf(i).lat,'-k');
end
plot(lonW,latW,'dk','MarkerFaceColor','b'); 
xlabel('Longitude'); ylabel('Latitude'); zlabel('Depth (km)');
xlim([min(lonDB) max(lonDB)]); ylim([min(latDB) max(latDB)]);
pbaspect([1 Va 1]);





%%%% SUBROUNTINES.

% Get the size of rupture from event magnitude.
function [Rs]=getMscale(ML)
  %Mw=0.754*ML+0.884;% ML to Mw [Yenier, 2017; Ross et al., 2016].
  Mw=ML;
  Mo=10.^(1.5*Mw+9.1); % Mw to Mo (Nm).
  Rs=nthroot((7/16)*(Mo/3e6),3); % Mo to radius (m), assuming a stress dop of 3 MPa.
end

