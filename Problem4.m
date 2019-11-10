%******************************************************************************
%     University of Sharjah
%     Department of Nuclear Engineering
%     24.536 Reactor Experiments and 407.403 Advanced Nuclear Lab, Spring 2016
%     HW #7: “Reactivity Measurements Techniques” Post-lab Exercises
%     Problem #4
%     Prepared by:
%                 U00038673	Adel Ali Ansari
%                 U00034108	Ahmed Ali Hussain Aljassmi
%                 U00037021	Abdulla AjailAlktebi
%     Instructors: Professor John White & Dr. Victor Gillette 
%******************************************************************************
%
      clear all, close all,  nfig = 0;  

%%      
%   Read data from reduced file
      fname = 'Problem4.dat';
      [data,tags,exptdate,starttime] = read_datfile(fname); 
      [Be,B,Gt,lam,td,S,kappa,nu] = kinetics_data();
      
%   now lets plot some data to view reactor operation during the run
      te = data(:,1);                    % time vector for expt (secs)
      tunits = 'seconds';  titl = 'Rho';    % plot annotation
      nfig = plot_PTB(te,data,tags,exptdate,nfig,titl,tunits); 
      
%%
      xtag = 'LPwrComb';
      itag = gettagloc(xtag, tags);
      delay = 100;
      Pm = data(delay:end,itag);
      Pmnorm = Pm/Pm(1);
      t = te(delay:end) - (delay-1);
%   plot P(t) vs t
      nfig = nfig+1;   figure(nfig)
      plot(t,Pmnorm,'r-','LineWidth',2),grid on
      title('Blade\_Drop: Normalized Power profile from LPwerComb (Adel | Ahmed | Abdulla)')
      xlabel('Time (sec)'),ylabel('Normalized Power')
%
%   Measured rho using Blade Drop Method 
      range = 2:150; % skip 1st point to approx the 0+ lower limit
      INT = trapz(t(range),Pmnorm(range));
      Background = Pmnorm(end)*t(end); %Computing background
      INT = INT - Background; %Removing background from integration
      meas_rho = -td*Pmnorm(1)/INT;    %err_mrho = 100*(meas_rho - rho0)/rho0;
      fprintf('\n')
      %fprintf('      Actual subcriticality ($):     %6.3f \n',rho0)
      fprintf('      Measured subcriticality ($):   %6.3f \n',meas_rho)
      %fprintf('      Error in measured result (%%): %6.2f \n',err_mrho)
%
%   end of program

