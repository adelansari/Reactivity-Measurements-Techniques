%
%   read_datfile  short function file to read *.dat file writen by the umlrr_data GUI
%
%   This section of code was appearing in every analysis file -- thus, to streamline
%   things a bit, I decided to make it into a short function file.  This code simply
%   read the *.dat file and stores the information into the tags and data arrays.
%
%   Written by JRWhite, UMass-Lowell (Sept. 2015)
%

      function [data,tags,exptdate,starttime] = read_datfile(fname) 
%
      fid = fopen(fname,'rt');
      for i = 1:3,  fgetl(fid);  end               % skip first 3 lines of info
      exptdate = fscanf(fid,'%s',1);  starttime = fscanf(fid,'%s',1);  
      Nrow = fscanf(fid,'%i',1);                   % # of rows in data set (time pts)
      Ncol = fscanf(fid,'%i',1);                   % # of cols in data set (#tags+1)
      tags = cell(Ncol,1);                         % initalize array for tag names
      for i = 1:Ncol,  tags{i} = fscanf(fid,'%s',1);  end
      tags = char(tags);                           % convert to character array
      data = fscanf(fid,'%e');                     % read rest of data
      data = reshape(data,Ncol,Nrow)';             % put into matrix (Nrow x Ncol)
      fclose(fid); 
%
%   end of function