function [lat,lon,dep,T,M]=parseQCCS(filename,lat_L,lon_L,dep_L,T_L,M_L)
  % Simple routine to parse csv files from the Shell Quest CCS Reports.
  
  % Load in the EQ data.
  data = readtable(filename);
  T=datetime(data{:,2},'InputFormat','dd-MM-yyyy')+data{:,3};
  lat=data{:,4};
  lon=data{:,5};
  dep=data{:,6};
  M=data{:,7};
  
  % Filter spatially (lateral).
  if(lat_L~=-1)
      I=inpolygon(lon,lat,lon_L,lat_L);
      T=T(I);
      M=M(I);
      lat=lat(I);
      lon=lon(I);
      dep=dep(I);
  end
  
  % Filter spatially (depth).
  if(dep_L~=-1)
      I=(dep>=min(dep_L))&(dep<=max(dep_L));
      T=T(I);
      M=M(I);
      lat=lat(I);
      lon=lon(I);
      dep=dep(I);
  end
      
  % Filter temporally.
  if(T_L~=-1)
      I=(T>=min(T_L))&(T<=max(T_L));
      T=T(I);
      M=M(I);
      lat=lat(I);
      lon=lon(I);
      dep=dep(I);
  end
  
  % Filter by magnitudes.
  if(M_L~=-1)
      I=(M>=min(M_L))&(M<=max(M_L));
      T=T(I);
      M=M(I);
      lat=lat(I);
      lon=lon(I);
      dep=dep(I);
  end
  
  % Sort chronologically.
  [~,I]=sort(T);
  T=T(I);
  M=M(I);
  lat=lat(I);
  lon=lon(I);
  dep=dep(I);
  
return


