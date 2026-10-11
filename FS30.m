% Script to make Figure Sx - the reshuffling cross-correlation test.
clear;

% Predefine some stuff.
McS=0.0; % Tested between 1.5-2.0.
GREY=[0.85,0.85,0.85];
PURP=[133,57,227]/256;
sY=2014;
N=1e4;
conf=[0.6827 0.9545 0.99];

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

% Load in catalogue data.
%file1='../../data/Catalogues/AGS.csv';
%file1='../../data/Catalogues/final/ShellQuest_Cat.csv';
file2='../../data/Catalogues/QCCS.csv';
%file3='../../data/Catalogues/NRCan.csv';
%[lat_eqA,lon_eqA,dep_eqA,TeqA,MeqA]=parseAGS(file1,latB,lonB,depB,tB,mB);
%[lat_eqA,lon_eqA,dep_eqA,TeqA,MeqA,evIDa]=parseRYN(file1,latB,lonB,depB,tB,mB,-1,-1);
%[lat_eqC,lon_eqC,dep_eqC,TeqC,MeqC]=parseNRCan(file3,latB,lonB,depB,tB,mB);
[lat_eqS,lon_eqS,dep_eqS,TeqS,MeqS]=parseQCCS(file2,-1,-1,-1,-1,-1);
%[lat_eqS,lon_eqS] = utm2deg(lon_eqS,lat_eqS,repmat(['12 N'],length(lat_eqS), 1));

% Load in injection data & filter to the study area.
data=readtable('../../data/Inj/QCCS.xlsx');
Tinj=datetime(data{:,1},repmat((1:12)',[10 1]),15*ones(size(data{:,1})));
vt=data{:,6};

% Make time axis (EQs).
dT=Tinj(2)-Tinj(1);
Neq1=histcounts(TeqS(MeqS>=McS),[Tinj-dT/2; Tinj(end)+dT/2]);
Neq2=histcounts(TeqS,         [Tinj-dT/2; Tinj(end)+dT/2]);

% Do the reshuffling cross-correlation analysis.
[Tx,CC,CC_conf]=ReshuffleCorr(Tinj, Neq1, vt, N, conf);
Tx=years(Tx)*12;

% Plot.
figure(530); clf;
subplot(121);
plot(Tinj,vt/1e1,'-b'); hold on;
bar(Tinj,Neq2, 'FaceColor', GREY);
bar(Tinj,Neq1, 'FaceColor', 'r');
xlabel('Time (year)'); ylabel('Earthquake Counts');
subplot(122);
plot(Tx,CC,'-','Color',PURP); hold on;
plot(Tx, CC_conf(:,1),'-','Color','k');
plot(Tx, CC_conf(:,2),'-','Color','k');
plot(Tx, CC_conf(:,3),'-','Color','k');
xlabel('Lag Time (months)'); ylabel('Cross-correlation Amplitude');
xlim([-100 +100]);
