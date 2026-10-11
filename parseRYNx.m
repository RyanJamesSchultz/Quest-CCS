function [lat,lon,dep,T,M,ID,CCval,evID]=parseRYNx(filename,lat_L,lon_L,dep_L,T_L,M_L,ID_list,DDflag,CC_L)
  % Simple routine to parse csv files for Shell Quest (by Ryan, final version).
  
  % Load in the EQ data.
  data = readtable(filename);
  ID=data{:,1};
  T=datetime(data{:,2},'InputFormat','yyyy-MM-dd''T''HH:mm:ss.SSSSSS''Z');
  lat=data{:,3};
  lon=data{:,4};
  dep=data{:,5};
  M=data{:,6};
  evID=data{:,7};
  CCval=data{:,8};
  
  % Filter spatially (lateral).
  if(lat_L~=-1)
      I=inpolygon(lon,lat,lon_L,lat_L);
      T=T(I);
      M=M(I);
      lat=lat(I);
      lon=lon(I);
      dep=dep(I);
      ID=ID(I);
      evID=evID(I);
      CCval=CCval(I);
  end
  
  % Filter spatially (depth).
  if(dep_L~=-1)
      I=(dep>=min(dep_L))&(dep<=max(dep_L));
      T=T(I);
      M=M(I);
      lat=lat(I);
      lon=lon(I);
      dep=dep(I);
      ID=ID(I);
      evID=evID(I);
      CCval=CCval(I);
  end
      
  % Filter temporally.
  if(T_L~=-1)
      I=(T>=min(T_L))&(T<=max(T_L));
      T=T(I);
      M=M(I);
      lat=lat(I);
      lon=lon(I);
      dep=dep(I);
      ID=ID(I);
      evID=evID(I);
      CCval=CCval(I);
  end
  
  % Filter by magnitudes.
  if(M_L~=-1)
      I=(M>=min(M_L))&(M<=max(M_L));
      T=T(I);
      M=M(I);
      lat=lat(I);
      lon=lon(I);
      dep=dep(I);
      ID=ID(I);
      evID=evID(I);
      CCval=CCval(I);
  end

  % Filter by given IDs.
  if(ID_list~=-1)
      I=ismember(ID,ID_list);
      T=T(I);
      M=M(I);
      lat=lat(I);
      lon=lon(I);
      dep=dep(I);
      ID=ID(I);
      evID=evID(I);
      CCval=CCval(I);
  end

  % Filter to just the events that have been double-difference relocated.
  if(DDflag~=-1)
      I=(evID==1);
      T=T(I);
      M=M(I);
      lat=lat(I);
      lon=lon(I);
      dep=dep(I);
      ID=ID(I);
      evID=evID(I);
      CCval=CCval(I);
  end

  % Filter to just the events that meet a CC threshold.
  if(CC_L~=-1)
      I=(abs(CCval)>=CC_L);
      T=T(I);
      M=M(I);
      lat=lat(I);
      lon=lon(I);
      dep=dep(I);
      ID=ID(I);
      evID=evID(I);
      CCval=CCval(I);
  end
  
  % Sort chronologically.
  [~,I]=sort(T);
  T=T(I);
  M=M(I);
  lat=lat(I);
  lon=lon(I);
  dep=dep(I);
  ID=ID(I);
  evID=evID(I);
  CCval=CCval(I);
  
return


