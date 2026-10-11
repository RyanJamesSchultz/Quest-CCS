function [S]=parseFaults(filename)
  % Simple routine to parse csv of the basement terranes in the WCSB.
  
  % Load in the EQ data.
  data=readtable(filename);
  X=data{:,1};
  lat=data{:,3};
  lon=data{:,2};
  
  % dd.
  S=struct('lat',[],'lon',[]);
  j=1; k=1;
  
  % Loop over all the data.
  for i=1:length(X)
      if(strcmpi(X{i},'X'))
          j=j+1; k=1;
          continue;
      end
      S(j).lat(k)=lat(i);
      S(j).lon(k)=lon(i);
      k=k+1;
  end
  
return


