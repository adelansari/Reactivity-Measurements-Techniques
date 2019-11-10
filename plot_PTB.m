%
%   plot_PTB   short function file to plot power (P), core temperatures (T)
%                 and the blade positions (B) from a reactor data file
%
%   This section of code was appearing in every analysis file -- thus, to streamline
%   things a bit, I decided to make it into a short function file.  I usually plot
%   these up front to make sure I have the correct data file and that I understand
%   what was really happening in the reactor during the experiment.
%
%   This code can be easily modified to plot other parameters as needed (just need
%   to know the tag names from the tilres in the *.dat file)...
%
%   Written by JRWhite, UMass-Lowell (April 2013)
%   Mod. #1: reviewed and cleaned up some comments (JRWhite, Jan. 2014)
%   Mod. #2: reviewed and cleaned up some more comments (JRWhite, Sept. 2015)
%

      function newnfig = plot_PTB(te,data,tags,exptdate,nfig,titl,tunits) 
%
%   set color and marker code for creating plots
      Ncm = 6;  scm = ['r- ';'g--';'b-.';'m: ';'c- ';'k--']; 
%   power indicators  (LogPower and LPwrComb)   
      nfig = nfig+1;  figure(nfig);
      xtag = ['LogPower';'LPwrComb'];   [ntag,dum] = size(xtag);      
      itag = gettagloc(xtag,tags);             % location for tags of interest          
      st = char(zeros(ntag,8));                % storage for labels in legend command
      jj = 0;                                  % counters for marker type       
      for j = 1:ntag
        it = itag(j);   jj = jj+1;  if jj > Ncm, jj = 1; end
        plot(te,data(:,it),scm(jj,:),'LineWidth',2); hold on 
        st(j,:) = tags(it,:);
      end 
      grid on, hold off                          
      title([titl,': Power Indicators for Experiment on ',exptdate]); 
      xlabel(['Elapsed Time (',tunits,')']),ylabel('Reactor Power (% of Full Power)')
      legend(st)
%   temperature indicators (PoolTave, PoolTin, PoolTout, CoreTout, CoreTin)   
      nfig = nfig+1;  figure(nfig);
      xtag = ['PoolTave';'PoolTin ';'PoolTout';'CoreTout';'CoreTin '];  
      [ntag,dum] = size(xtag);      
      itag = gettagloc(xtag,tags);             % location for tags of interest          
      st = char(zeros(ntag,8));                % storage for labels in legend command
      jj = 0;                                  % counters for marker type       
      for j = 1:ntag
        it = itag(j);   jj = jj+1;  if jj > Ncm, jj = 1; end
        plot(te,data(:,it),scm(jj,:),'LineWidth',2); hold on 
        st(j,:) = tags(it,:);
      end 
      grid on, hold off                          
      title([titl,': Temperature Indicators for Experiment on ',exptdate]); 
      xlabel(['Elapsed Time (',tunits,')']),ylabel('Various Temperatures (^oF)')
      legend(st,'Location','SouthEast')
%   blade position indicators  (note that tag #38 is the reg rod position)   
      nfig = nfig+1;  figure(nfig);
      xtag = ['BL#1Pos ';'BL#2Pos ';'BL#3Pos ';'BL#4Pos ';'RRodPos '];  
      [ntag,dum] = size(xtag);      
      itag = gettagloc(xtag,tags);             % location for tags of interest          
      st = char(zeros(ntag,8));                % storage for labels in legend command
      jj = 0;                                  % counters for marker type       
      for j = 1:ntag
        it = itag(j);   jj = jj+1;  if jj > Ncm, jj = 1; end
        plot(te,data(:,it),scm(jj,:),'LineWidth',2); hold on 
        st(j,:) = tags(it,:);
      end 
      grid on, hold off                          
      title([titl,': Blade Position Indicators for Experiment on ',exptdate]); 
      xlabel(['Elapsed Time (',tunits,')']),ylabel('Blade Position (inches withdrawn)')
      legend(st,'Location','East')
 %
      newnfig = nfig;
 %
 %   end of function