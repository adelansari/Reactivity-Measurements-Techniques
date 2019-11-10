%******************************************************************************
%     University of Sharjah
%     Department of Nuclear Engineering
%     24.536 Reactor Experiments and 407.403 Advanced Nuclear Lab, Spring 2016
%     HW #7: “Reactivity Measurements Techniques” Post-lab Exercises
%     Problem #2, positive rho
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
      fname = 'Problem2_positive.dat';
      [data,tags,exptdate,starttime] = read_datfile(fname); 
      [Be,B,Gt,lam,td,S,kappa,nu] = kinetics_data();
      
%   Plot reactor power vs elapsed time
      te = data(:,1);                    % time vector for expt (secs)
      tunits = 'minutes';  titl = 'Rho';    % plot annotation
      nfig = plot_PTB(te/60,data,tags,exptdate,nfig,titl,tunits); 
      
%   compute the total compensated reactivity vs time from the reg blade worth curve
      H =  [24.55 25.15 24.95 26.09 25.09];   % max blade traverse (inches)
      RBdate = 'January 11, 2016. Adel|Ahmed|Abdulla';
      c1 =  2.259e-06;  c2 = -1.278e-04;  c3 =  2.168e-03;    % Jan. 2016 'slow' data
      c4 =  2.450e-03;  c5 = -2.960e-01;  c6 = -2.870e-02;
      RBrho = @(z) c1*z.^4 + c2*z.^3 + c3*z.^2 + c4*z + c5 + c6*sin(2*pi*z/H(5));
      z = data(:,38);                   % reg blade position vs time (expt data)
      totrho = (RBrho(z)-RBrho(z(1)));  % total compensated reactivity (% Dk/k)

%   plot measured reactivity versus time
      nfig = nfig+1;  figure(nfig);
      rp = 0.9;  % relative power (fraction of full power) for edit purposes
      plot(te/60,totrho,'r-','LineWidth',2),grid
      title(['Reactivity Changes Versus Time, (Adel|Ahmed|Abdulla)' ...
             ' (RP = ',num2str(rp,'%5.2f'),')'])
      xlabel('Elapsed Time (minutes)'),ylabel('Reactivity Change (% \Deltak/k)');
      
%   just for discussion purposes, let's also plot the full blade worth curve
      nfig = nfig+1;  figure(nfig);
      zz = linspace(0,H(5),100);  worth = RBrho(zz)-RBrho(zz(1));
      plot(zz,worth,'r-','LineWidth',2),grid
      rr = axis;   rr(1:2) = [0 H(5)];   axis(rr)
      title(['Integral RegBlade Worth Curve (data from ',RBdate,')'])
      xlabel('distance withdrawn (inches)'),ylabel('Reactivity Worth (% \Deltak/k)')
%%
      xtag = 'LPwrComb';
      itag = gettagloc(xtag, tags);
      delay = 1;
      Pm = data(delay:end,itag);
      Pmnorm = Pm/Pm(1);
      t = te(delay:end) - (delay-1);
      
%   compute log(P), extract slope of curve after some transient time, and calc rho
      Pln = log(Pmnorm);  tskip = 120;               
      Plnfit = Pln(t > tskip);   tfit = t(t > tskip);  
      cc = polyfit(tfit,Plnfit,1);   slope = cc(1);   meas_period = 1/slope;
      meas_rho = sum(B./(1 + lam*meas_period));
      fprintf('\n Problem 2 Positive rho:   \n')
      fprintf('       Measured stable period (sec):    %7.2f  \n',meas_period)
      fprintf('       Measured rho (dollars):          %7.4f  \n',meas_rho/Be)

%   plot the linear fit along with actual log(P(t))
      nfig = nfig+1;   figure(nfig)   
      plot(t/60,Pln,'r-',tfit/60,polyval(cc,tfit),'b--','LineWidth',2), grid on
      title('Stable\_Period:  Slope Determination from Linear Fit (Positive rho)(Adel|Ahmed|Abdulla)');
      xlabel('Time (minutes)'),ylabel('Nat Log of Normalized Power')
      legend('Measured ln(P(t))','Linear Approximation','Location', 'NorthWest')      

%   end of program
