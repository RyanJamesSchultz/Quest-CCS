% Script to make Figure 3 - the spatiotemporal pore-pressure modelling results.
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
file1='../../data/Catalogues/final/ShellQuest_Cat.csv';
[lat_eqA,lon_eqA,dep_eqA,TeqA,MeqA]=parseRYN(file1,latB,lonB,depB,tB,mB,-1,-1);

% Basement faults.
%[Sf]=parseFaults('../../data/Basement/AB_Geo.txt');

% Get the estimated pore-pressure timeseries information.
[t1s,P1s]=readTimeSeries('../../data/Poro/data/S1s/M4.csv',22087157);
[t1c,P1c]=readTimeSeries('../../data/Poro/data/S1c/M4.csv',22087157);
[t2s,P2s]=readTimeSeries('../../data/Poro/data/S2s/M4.csv',22082798.79);
[t2c,P2c]=readTimeSeries('../../data/Poro/data/S2c/M4.csv',22082798.79);

% Get the estimated pore-pressure spatial grids.
[xg_1s,yg_1s, Pg0_1s,Pg2_1s,Zg_1s]=readSpatialData('../../data/Poro/data/S1s/csv_data_S1s.xlsx','10.749 y');
[xg_1c,yg_1c, Pg0_1c,Pg2_1c,Zg_1c]=readSpatialData('../../data/Poro/data/S1c/csv_data_S1c.xlsx','24.419 y');
%[xg_2s,yg_2s, Pg0_2s,Pg2_2s,Zg_2s]=readSpatialData('../../data/Poro/data/S1s/csv_data_S2s.xlsx','10.749 y');
%[xg_2c,yg_2c, Pg0_2c,Pg2_2c,Zg_2c]=readSpatialData('../../data/Poro/data/S1c/csv_data_S2c.xlsx','24.419 y');



%%% Plot.
GREY=[0.85,0.85,0.85];

% Get map-plot aspect ratio.
Va=(max(latB)-min(latB))/(max(lonB)-min(lonB))/cosd(mean(latB));

% Make the magnitude size axis.
RsA=getMscale(MeqA)/3;

% Prep the over-pressure maps.
dP_1s=(Pg2_1s-Pg0_1s)/1e3; dP_1s(dP_1s<=0)=NaN; dP_1s=log10(dP_1s);
dP_1c=(Pg2_1c-Pg0_1c)/1e3; dP_1c(dP_1c<=0)=NaN; dP_1c=log10(dP_1c);
%%
% Study area map.
figure(3); clf;
% Map.
subplot(1,3,[1]);
contourf(xg_1s,yg_1s,dP_1s,-1:0.1:3,'LineColor','none'); hold on; 
colormap sky; clim([-1 3]);
contour(xg_1s,yg_1s,dP_1s,[0 1 2 3],'-w');
contour(xg_1c,yg_1c,dP_1c,[0 1 2 3],'-m');
plot(-113.494547,53.526844,'sk','MarkerFaceColor',GREY); % Edmonton centre.
plot(lonYEG,latYEG,'-k'); % Edmonton outline.
plot(lonSLA,latSLA,'-k'); % SLA.
plot(lonPIPE,latPIPE,'-k'); % Pipeline.
plot(lonPIP1,latPIP1,'-k'); % Pipeline.
plot(lonPIP2,latPIP2,'-k'); % Pipeline.
plot(lonPIP3,latPIP3,'-k'); % Pipeline.
scatter(lon_eqA,lat_eqA,RsA,'or','MarkerFaceColor',GREY);
scatter(lon_eqA(MeqA>=McA),lat_eqA(MeqA>=McA),RsA(MeqA>=McA),'ok','MarkerFaceColor','r');
plot(lonW,latW,'dk','MarkerFaceColor','b');
xlabel('Longitude'); ylabel('Latitude'); zlabel('Depth (km)');
xlim([min(lonDB) max(lonDB)]); ylim([min(latDB) max(latDB)]);
pbaspect([1 0.5 1]);
h=colorbar();
ylabel(h,'Overpressure (log_{10}[kPa])');
subplot(1,3,[2 3]);
semilogy(t1s,P1s); hold on;
semilogy(t1c,P1c);
semilogy(t2s,P2s);
semilogy(t2c,P2c);
semilogy([datetime(2025,06,08,10,32,52) datetime(2025,06,08,10,32,52)],ylim(),':k'); % Time 1st event in M4 cluster.
semilogy([datetime(2026,04,01,23,27,29) datetime(2026,04,01,23,27,29)],ylim(),':k'); % Time of M4
semilogy([datetime(2015,08,23) datetime(2015,08,23)],ylim(),'--k'); % Start of Quest.
semilogy([datetime(2040,01,01) datetime(2040,01,01)],ylim(),'--k'); % End of Quest.
xlabel('Time'); ylabel('Overpressure (kPa)');
xlim([datetime(2015,01,01) datetime(2100,1,1)])
ylim([1e-2 1e3]);

%figure(4); clf;
% hold on;


%%%% SUBROUNTINES.

% Get the size of rupture from event magnitude.
function [Rs]=getMscale(ML)
  %Mw=0.754*ML+0.884;% ML to Mw [Yenier, 2017; Ross et al., 2016].
  Mw=ML;
  Mo=10.^(1.5*Mw+9.1); % Mw to Mo (Nm).
  Rs=nthroot((7/16)*(Mo/3e6),3); % Mo to radius (m), assuming a stress dop of 3 MPa.
end

% Get the estimated pore-pressure timeseries data.
function [t,dP]=readTimeSeries(filename,dP1)
  data=readtable(filename);
  t=datetime(2015,08,23)+data{:,1}/(3600*24);
  dP=data{:,7};
  if(dP1~=-1)
      dP=(dP-dP(1))/1e3; % dP (kPa).
  else
      dP=(dP-dP1)/1e3; % dP (kPa). Only good for M4.
  end
end


% Get the spatial pore-pressure migration data.
function [x,y, Pg0,Pg2,Zg]=readSpatialData(filename,sheetname)
  
  % Read in the tables.
  T0 = readtable(filename,'Sheet','0.000 y');
  T2 = readtable(filename,'Sheet',sheetname);
  
  % Prep.
  x=unique(T0.X);
  y=unique(T0.Y);
  P0=zeros(length(x),length(y));
  X=P0;
  Y=P0;
  Z=P0;
  P2=P0;
  
  % Loop over all the data.
  for i=1:length(x)
      for j=1:length(y)
          I=(T0.X==x(i))&(T0.Y==y(j));
          Ts0=T0(I,:);
          Ts2=T2(I,:);
          [~,Is]=min(Ts0.Z);
          if(isempty(Is))
              P0(i,j)=NaN;
              P2(i,j)=NaN;
              Z(i,j)=NaN;
          else
              P0(i,j)=Ts0(Is,:).PRES;
              P2(i,j)=Ts2(Is,:).PRES;
              X(i,j)=Ts0(Is,:).X;
              Y(i,j)=Ts0(Is,:).Y;
              Z(i,j)=Ts0(Is,:).Z;
          end
      end
  end
  
  % Transform to the UTM NS/EW reference frame and then into lat/lon.
  sz=size(X);
  [X,Y]=Ctransform(X(:)',Y(:)');
  [Y,X] = utm2deg(X,Y,repmat(['12 N'],length(X), 1));
  X=reshape(X',sz(1),sz(2));
  Y=reshape(Y',sz(1),sz(2));
  
  % Turn data into a regular grid.
  x=min(X(:)):0.01:max(X(:));
  y=min(Y(:)):0.01:max(Y(:));
  [xg,yg]=meshgrid(x,y);
  Pg0=griddata(X,Y,P0,xg,yg);
  Pg2=griddata(X,Y,P2,xg,yg);
  Zg=griddata(X,Y,475.07-Z,xg,yg);
end

% Coordinate transform.
function [xt,yt]=Ctransform(x,y)
  theta=-46;
  xt=x+2125.0;
  yt=y+125.0;
  R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
  m=[xt;yt]'*R;
  xt=m(:,1);
  yt=m(:,2);
  xt=xt+366378.295159;
  yt=yt+6001383.644890;
end