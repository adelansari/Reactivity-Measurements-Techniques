%
%   gettagloc  short routine to find the column in the data array  
%                  for the variables of interest
%
%   When we change the history data file, the desired tags my be in a different order.
%   This means that all the codes written to read the reduced data file (*.dat) might
%   be different from data set to data set  --  and this is very cumbersome.
%
%   This routine is designed to resolve this issue by searching for the 8-character 
%   ID name (i.e. the local tag name).  I will start using this approach from now on.
%
%   Written by JRWhite, UMass-Lowell  (April 2013)
%   Modd #1: Reviewed with no changes (except for this comment,of course)  (Sept. 2015)
%   

      function itag = gettagloc(xtags,tags)
%
      [nx,ncol] = size(xtags);  itag = zeros(1,nx);
      [ntags, ncol] = size(tags);  
      for i = 1:nx
        s1 = xtags(i,:);  j = 1;
        while j > 0 && j <= ntags 
          s2 = tags(j,:);
          if strcmp(s1,s2), itag(i) = j;  j = ntags+1;  end
          j = j+1;
        end
        if j == ntags+1, disp('*** Could not find string  -- check tag name ***'); end
      end
%
%   end of function