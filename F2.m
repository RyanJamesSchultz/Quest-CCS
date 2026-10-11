% Script to make Figures 2 & S32 - the spatiotemporal event plots.
clear;

% Predefine some stuff.
McA=2.0;
McA2=1.5;
McX=0.0;
McS=0.0;
McC=2.5;
McC2=4.0;
GREY=[0.85,0.85,0.85];
sY=[1985 2014 2027];
Ts=datetime(2015,08,01,00,00,00);
Te=datetime(2026,05,01,00,00,00);

% Boundary polygons and stuff.
latB=[  54.9   54.9   53.4   53.4]; % General area.
lonB=[-114.2 -112.0 -112.0 -114.2]; % General area.
%latB=[  53.96   53.96   53.89   53.89]; % M4-2026 cluster.
%lonB=[-113.45 -113.30 -113.30 -113.45]; % M4-2026 cluster.
%latB=[  54.05   54.05   53.90   53.90]; % STZ cluster.
%lonB=[-112.80 -112.45 -112.45 -112.80]; % STZ cluster.
%lonDB=[-114.20 -112.00]; latDB=[54.9 53.4];
depB=-1;
tB=-1;
mB=[-4 8];
idB=-1;
ddB=1;
vB=10;
ccB=1.0;

% Load in catalogue data.
%file1='../../data/Catalogues/AGS.csv';
file1='../../data/Catalogues/final/ShellQuest_Cat.csv';
file2='../../data/Catalogues/final/ShellQuest_CatX.csv';
file3='../../data/Catalogues/QCCS.csv';
file4='../../data/Catalogues/NRCan.csv';
%[lat_eqA,lon_eqA,dep_eqA,TeqA,MeqA]=parseAGS(file1,latB,lonB,depB,tB,mB);
[lat_eqA,lon_eqA,dep_eqA,TeqA,MeqA,evIDa]=parseRYN( file1,latB,lonB,depB,tB,mB,-1,-1);
[lat_eqX,lon_eqX,dep_eqX,TeqX,MeqX,~,ccX,evIDx]=parseRYNx(file2,latB,lonB,depB,tB,mB,-1,-1,ccB);
[lat_eqC,lon_eqC,dep_eqC,TeqC,MeqC]=parseNRCan(file4,latB,lonB,depB,tB,mB);
[lat_eqS,lon_eqS,dep_eqS,TeqS,MeqS]=parseQCCS(file3,-1,-1,-1,-1,-1);
[lat_eqS,lon_eqS] = utm2deg(lon_eqS,lat_eqS,repmat(['12 N'],length(lat_eqS), 1));

% Load in injection data & filter to the study area.
data=readtable('../../data/Inj/QCCS.xlsx');
Tinj=datetime(data{:,1},repmat((1:12)',[10 1]),15*ones(size(data{:,1})));
v0535=data{:,3};
v0819=data{:,4};
v0711=data{:,5};
Vt=data{:,7};

% Make the distance from 08-19.
RrA=getDist(lat_eqA, lon_eqA);
RrX=getDist(lat_eqX, lon_eqX);
RrS=getDist(lat_eqS, lon_eqS);
RrC=getDist(lat_eqC, lon_eqC);

% Make the magnitude size axis.
RsA=getMscale(MeqA)*1.0;
RsX=getMscale(MeqX)*1.2;
RsS=getMscale(MeqS)*1.5;
RsC=getMscale(MeqC)*1.0;

% Dither the matched filtering distances.
RsX=abs(RsX+normrnd(0,5,size(MeqX)));

% Fit the diffusion curve.
%[Tp,Rp]=getRp([TeqA;TeqX],[RrA;RrX],0.90);
Rd=@(dT,Df) sqrt(4*pi()*Df*dT*3600*24)/1000; % m.

% Compute the diffusion curves.
Df=0.75; % m²/s.
tc=Ts:1:Te;
dT=days(tc-tc(1));
rc1=Rd(dT,0.75);
rc2=Rd(dT,1.2);
rc3=Rd(dT,0.35);
rc4=Rd(dT,3.5);

% Time to Edmonton.
re=70*1000;
dTe=((re^2)/(4*pi()*Df))/(3600*24*365.25);
dTe

% Focus areas.
latB1=[  55.0   55.0   53.0   53.0]; lonB1=[-115.0 -112.0 -112.0 -115.0];

% Make time axis.
Tsp=datetime(sY(2),01,01,00,00,00); % Study start year (2014).
[~,Tbins]=histcounts(TeqA,round(1.5*sqrt(length(TeqA))));
Tc=Tsp:1:Te;
Mc_t=McC2*ones(size(Tc)); Mc_t(Tc>=datetime(2006,01,01,00,00,00))=McC; Mc_t(Tc>=datetime(2014,07,01,00,00,00))=McA; Mc_t(Tc>=datetime(2024,10,15,00,00,00))=McA2;

% Spatiotemporal plots.
figure(2); clf;

% MvT plot.
ax2a=subplot(311);
scatter(TeqA,MeqA,RsA,'or','MarkerFaceColor',GREY); hold on;
scatter(TeqA(MeqA>=McA),MeqA(MeqA>=McA),RsA(MeqA>=McA),'ok','MarkerFaceColor','r');
scatter(TeqX,MeqX,RsX,'og','MarkerFaceColor',GREY); hold on;
scatter(TeqX(MeqX>=McX),MeqX(MeqX>=McX),RsX(MeqX>=McX),'ok','MarkerFaceColor','g');
scatter(TeqC,MeqC,RsC,'om','MarkerFaceColor',GREY); hold on;
scatter(TeqC(MeqC>=McC),MeqC(MeqC>=McC),RsC(MeqC>=McC),'ok','MarkerFaceColor','m');
scatter(TeqS,MeqS,RsS,'om','MarkerFaceColor',GREY); hold on;
scatter(TeqS(MeqS>=McS),MeqS(MeqS>=McS),RsS(MeqS>=McS),'ok','MarkerFaceColor','m');
plot(Tc,Mc_t,'--r');
xlabel('Year'); ylabel('Magnitude (M_L)');
%legend('Location','northwest');
ylim([-2 4.1]);

Tc2=Tsp:50:Te;
tt=[TeqA;TeqX;TeqS];
rr=[RrA;RrX;RrS];
w=10.^([MeqA;MeqX;MeqS]); w=w/sum(w);
%[tt,I]=sort(tt); rr=rr(I); w=w(I);
%for i=1:length(tt)
%    rr2(i)=prctile(rr(1:i),97);
%    %rr2(i)=mean(rr(1:i));
%    %wi=w(1:i); wi=wi/sum(wi);
%    %rr2(i)=sum(rr(1:i).*wi);
%end
%I=tt>=Ts;
%tt=tt(I); rr2=rr2(I); rr=rr(I);
[tt,rr,rr2]=getRest(tt,rr,w,Ts,Tc2);

% RvT plot.
ax2b=subplot(312);
scatter(TeqA,RrA,RsA,'ok','MarkerFaceColor','r'); hold on;
scatter(TeqX,RrX,RsX,'ok','MarkerFaceColor','g'); hold on;
scatter(TeqS,RrS,RsS,'ok','MarkerFaceColor','m'); hold on;
plot(tt,rr2);
plot(tc,rc1,'-k');
plot(tc,rc2,':k');
plot(tc,rc3,':k');
plot(tc,rc4,':k');
xlabel('Year'); ylabel('Distance (km)');
%legend('Location','northwest');
ylim([0 80]);

% NvT plot.
%ax2c=subplot(313);
%plot(TeqA(MeqA>=McA),(1:length(TeqA(MeqA>=McA)))/length(TeqA(MeqA>=McA)),'-r'); hold on;
%plot(TeqX(MeqX>=McX),(1:length(TeqX(MeqX>=McX)))/length(TeqX(MeqX>=McX)),'-g'); hold on;
%plot(TeqC(MeqC>=McC),(1:length(TeqC(MeqC>=McC)))/length(TeqC(MeqC>=McC)),'-m'); hold on;
%plot(TeqS(MeqS>=McS),(1:length(TeqS(MeqS>=McS)))/length(TeqS(MeqS>=McS)),'-m'); hold on;
%xlabel('Year'); ylabel('Cumulative event count');
%legend('Location','northwest');
%ylim([0 1]);

Tn=[TeqA;TeqX]; Mn=[MeqA;MeqX];
[Tn,I]=sort(Tn); Mn=Mn(I);
Tn=Tn(Mn>McA); Mn=Mn(Mn>McA); 

% VvT plot.
ax2c=subplot(313);
plot(Tinj,v0711,':c'); hold on;
plot(Tinj,v0711+v0819,'--c');
plot(Tinj,v0711+v0819+v0535,'-c');
plot(Tinj,(Vt/max(Vt))*max(v0711+v0819+v0535),'-b');
%plot(Tn,(1:length(Tn))*10,'-k');
xlabel('Year'); ylabel('Cumulative event count');
%legend('Location','northwest');
%ylim([0 1]);

% Link up.
linkaxes([ax2a ax2b ax2c],'x');
xlim([datetime(2014,01,01) datetime(2026,05,01)]);



%%%% SUBROUNTINES.

% Compute the distance to the Quest-CCS wells.
function [R]=getDist(lat,lon)
  if(isempty(lat))
      R=[];
      return;
  end
  R1=Geoid_Distance(54.113623, -112.978885, lat', lon', 'elliptical')*6371*pi()/180;
  R2=Geoid_Distance(54.113623, -112.978885, lat', lon', 'elliptical')*6371*pi()/180;
  R3=Geoid_Distance(54.113623, -112.978885, lat', lon', 'elliptical')*6371*pi()/180;
  R=min([R1;R2;R3])';
end


% Compute the percentile growing distance.
function [Tp,Rp]=getRp(T,R,p)
  [Tp,I]=sort(T); R=R(I);
  Rp=zeros(size(R));
  for i=1:length(R)
      Rp(i)=prctile(R(1:i),p);
      if(length(R(1:i))<5)
          Rp(i)=0;
      end
  end
end


% Get the size of rupture from event magnitude.
function [Rs]=getMscale(ML)
  %Mw=0.754*ML+0.884;% ML to Mw [Yenier, 2017; Ross et al., 2016].
  Mw=ML;
  Mo=10.^(1.5*Mw+9.1); % Mw to Mo (Nm).
  Rs=nthroot((7/16)*(Mo/3e6),3); % Mo to radius (m), assuming a stress dop of 3 MPa.
end


% Estimate migration from the catalogue.
function [tt,rr,rr2]=getRest(tt,rr,w,Ts,Tbin)
  [tt,I]=sort(tt); rr=rr(I); w=w(I);
  I=tt>=Ts;
  tt=tt(I); rr=rr(I);

  %for i=1:length(tt)
  %    rr2(i)=prctile(rr(1:i),97);
  %    %rr2(i)=mean(rr(1:i));
  %    %wi=w(1:i); wi=wi/sum(wi);
  %    %rr2(i)=sum(rr(1:i).*wi);
  %end
  
  [~,~,I]=histcounts(convertTo(tt,'datenum'),convertTo(Tbin,'datenum'));
  rr2=zeros(size(Tbin));
  for i=1:length(Tbin)
      Ii=find(i==I);
      if(~isempty(rr(Ii)))
          %rr2(i)=mean(rr(Ii));
          rr2(i)=prctile(rr(Ii),97);
      end
  end

  tt=Tbin;

end

