%******************************************************************************
%     University of Sharjah
%     Department of Nuclear Engineering
%     24.536 Reactor Experiments and 407.403 Advanced Nuclear Lab, Spring 2016
%     HW #7: “Reactivity Measurements Techniques” Post-lab Exercises
%     Problem #5
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
      fname = 'Problem5.dat';
      [data,tags,exptdate,starttime] = read_datfile(fname); 
      [Be,B,Gt,lam,td,S,kappa,nu] = kinetics_data();
%
%   now lets plot some data to view reactor operation during the run
      te = data(:,1);                    % time vector for expt (secs)
      tunits = 'minutes';  titl = 'Rho';    % plot annotation
      nfig = plot_PTB(te/60,data,tags,exptdate,nfig,titl,tunits); 
      
%%      
      xtag = 'SUCRate ';
      itag = gettagloc(xtag, tags);
      delay = 1;
      Pm = data(delay:end,itag);
      Pmnorm = Pm/Pm(1);
      t = te(delay:end) - (delay-1);
%   subcritical with rho0 as the subcriticality level and delrho as the change in reactivty that initiates the transient
      fprintf('\n   Subcritical reactivity change Method for finding D_rho: \n\n')
      rho0 = input('      Enter value of rho from Phase II ($): ');
      if rho0 > 0,  rho0 = -rho0;   end  %  rho0 must be negative
      rho0a = rho0*Be;         % rho0 in Dk/k
      RHO = input('      Enter the change in rho ($): ');
      RHOa = RHO*Be;           % external change in reactivty in Dk/k
      tt =   [0 te(end)];    rhot = [RHOa RHOa];  % rho(t) for step insertion 
      Qo = S;                  % initial source strength (n/sec)
      Po = -kappa*Qo/nu/rho0a; % could be set to 1.0 since normalized later anyway...
      Co = B*Po./(lam*Gt);     % initial precursor conc
      xo = [Po Co]';           % initial condition for state vector
      Q = S;                   % constant source for t > 0
      ftx = @(t,x) pkeqns_nofdbk(t,x,rho0a,Q,Be,Gt,B,lam,kappa,nu, tt, rhot);
      [t,x] = ode15s(ftx,t,xo);
      P = x(:,1)/Po;           % normalized P(t)

%   plot Normalized Count rate vs t
      nfig = nfig+1;   figure(nfig)
      plot(t/60,Pmnorm,'r-','LineWidth',2),grid on
      title(['SubcriticalM: Normalized count profile for \rho_0 + \rho_{ext} = ', ...
             num2str(rho0+RHO),' dollars   (Adel | Ahmed | Abdulla)'])
      xlabel('Time (minutes)'),ylabel('Normalized Count Rate')
%   Measured delta rho from measured value of P_final/P_initial
      Co = 1;                           % initial power level
      Cf = mean(Pmnorm(end-50:end));    % new steady state power ratio (last 50 sec)           
      Mr = Cf/Co;                       % relative MSubcrit Multiplication Factor
      meas_delrho = rho0a*(1-Mr)/Mr;    % "measured" delta rho 
      fprintf('\n')
      fprintf('      Subcriticality level($):      %6.3f \n',rho0)
      fprintf('      Measured delrho ($):          %6.3f  \n',meas_delrho/Be)
      fprintf('\n')
%
