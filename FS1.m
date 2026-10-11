% Script to make Figure S1 - the Gutenberg-Richter magnitude-frequency distribution.
clear;

% Predefine some stuff.
dM=0.2;
Mc=1.5;

% Boundary polygons and stuff.
latB=[  54.9   54.9   53.4   53.4]; % General area.
lonB=[-114.2 -112.0 -112.0 -114.2]; % General area.
lonDB=[-114.20 -112.00]; latDB=[54.9 53.4];
depB=-1;
tB=-1;
mB=[-4 8];
idB=-1;
ddB=1;
vB=10;
ccB=1.0;

% Load in catalogue data.
file1='../../data/Catalogues/final/ShellQuest_Cat.csv';
file2='../../data/Catalogues/final/ShellQuest_CatX.csv';
file3='../../data/Catalogues/QCCS.csv';
[lat_eqA,lon_eqA,dep_eqA,TeqA,MeqA,evIDa]=parseRYN( file1,latB,lonB,depB,tB,mB,-1,-1);
[lat_eqX,lon_eqX,dep_eqX,TeqX,MeqX,~,ccX,evIDx]=parseRYNx(file2,latB,lonB,depB,tB,mB,-1,-1,ccB);
[lat_eqS,lon_eqS,dep_eqS,TeqS,MeqS]=parseQCCS(file3,-1,-1,-1,-1,-1);
Meq=[MeqA;MeqX];
%Meq=MeqS;

% GR-MFD stats.
[b,b_err,a,R2,~,Mgr,Ngr,ngrb]=Bval(Meq, Mc,dM);
po=[-b,a];
Mgr_fit=[Mc, max(Meq)];
Ngr_fit=10.^polyval(po,Mgr_fit);

% Get the other distribution bin counts.
%ngra=histcounts(MeqX,[Mgr,Mgr(end)+dM/2]);
%ngrt=histcounts(Mt( I),[Mgr,Mgr(end)+dM/2]);

%%%% Plot.
GREY=[0.85,0.85,0.85];

% Plot the GR-FMD.
figure(51); clf;
semilogy(Mgr, Ngr, 'o', 'Color', 'k'); hold on;
bar(Mgr,ngrb, 'FaceColor', GREY);
%bar(Mgr,ngra, 'FaceColor', 'r');
semilogy(Mgr_fit, Ngr_fit, '-', 'Color', 'black');
xlim([min(Mgr)-dM/2 max(Mgr)+dM/2]); ylim([0.7 1.3*max(Ngr)]);
plot(Mc*[1 1],ylim,'--k');
plot(2.0*[1 1],ylim,'--k');
xlabel('Magnitude (M_L)'); ylabel('Count');
