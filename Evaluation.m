mdlName='SandLaika3d';

LaikaData3d;
simout = sim(mdlName,'SrcWorkspace','current','FastRestart','off');
   
%     vel = abs(simout.yout{1}.Values.Data);
%     xEnd = simout.yout{2}.Values.Data(end);
     ttot = simout.tout;
     contactData = simout.yout{2}.Values.Data;
     footHeight = simout.yout{1}.Values.Data;
     
 penetration = contactData(:,3);
 friction = contactData(:,2);
 normalF = abs(contactData(:,1));
 
%  figure(1)
%  plot(penetration, normalF,'k.');
%   title('Force- penetration curve');
%   xlabel('Penetration(m)');
%   ylabel('Normal Force (N)');
%   
%  figure(2)
%  subplot(3,1,1)
%   plot(ttot,penetration);
%   title('Penetration')
%   xlabel('Time(s)');
%   ylabel('Penetration (m)');
%   
% %    subplot(3,1,2)
% %   plot(ttot,(footHeight));
% %     title('height')
% %   xlabel('Time(s)');
% %   ylabel('height)');
%   subplot(3,1,2)
%   plot(ttot,friction);
%     title('Friction force')
%   xlabel('Time(s)');
%   ylabel('Friction Force (N)');
%   
%   subplot(3,1,3)
%   
%   plot(ttot,normalF);
%   title('Normal force')
%   xlabel('Time(s)');
%   ylabel('Normal Force (N)');
%   
  
  figure(1)
  subplot(2,1,1)
  plot(time, rad2deg(Rhip_motion),'ko');
  hold on
  plot(timevec,rad2deg(yhip),'r--')
    title('Hip motion')
  xlabel('Time(s)');
  ylabel('Hip trajectory (deg)');
  legend( 'Optimised points' ,' Fitted curve', 'Location', 'NorthEast', 'Interpreter', 'none' );
  
  subplot(2,1,2)
  plot(time, rad2deg(Rknee_motion),'ko');
  hold on
  plot(timevec,rad2deg(yknee),'r--')
  title('Knee motion')
  xlabel('Time(s)');
  ylabel('Knee trajectory (deg)');
    