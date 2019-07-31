function penalty = LaikaSimulation3d(params,mdlName,scaleFactor)
% Simulating the Laikago gait

 LaikaData3d;               %Load the data script
 warning('off','all');      %Disable warnings for faster sim 
 
 
 params = scaleFactor*params;   % scale parameters
 
  N = numel(params)/3;          % unpack the parameters
     Rhip_motion   = deg2rad([params(1:N),params(1)]');
     Rknee_motion  = deg2rad([params(N+1:2*N),params(N+1)]');
     Rhip_rotation = deg2rad([params(2*N+1:3*N),params(2*N+1)]');

% create smooth trajectories
timevec= linspace(0,gaitPeriod,100);
kneetraj= hipFit(time, Rknee_motion);
yknee=feval(kneetraj,timevec);
  hiptraj= hipFit(time, Rhip_motion);
yhip=feval(hiptraj,timevec);
rottraj= hipFit(time, Rhip_rotation);
yhiprot=feval(rottraj,timevec);

%initial move for the tra
initial_qR = [ yknee(1,1); yhip(1,1); yhiprot(1,1)];

   simout = sim(mdlName,'SrcWorkspace','current','FastRestart','off');
   
   ttot = simout.tout;
      vel = abs(simout.yout{1}.Values.Data);
    distEnd = simout.yout{2}.Values.Data;
    tEnd = simout.tout(end);
%     footDist = simout.yout{3}.Values.Data;
    
    Torque = simout.yout{3}.Values.Data;
    
    
    zEnd= distEnd(2,end);
    xEnd= abs(distEnd(1,end))*5;
   
%         footDist(footDist < 0.16) = 0;          %foot on the ground
%         footDist(footDist > 0.16) = 1;          %foot in the air
%         
%         footSum=sum(footDist,2);
%         
%         footSum(footSum < 3) = 0;
%         footSum(footSum >= 3) = 7;          %penalty if more legs in the air
%               
%          footPenalty = mean(footSum);        %sum penalty
    
     positiveReward = -zEnd * tEnd^2;
    %   Angular velocity and trajectory aggressiveness 
    %   (number of times the derivative flips signs) decreases reward
    %   NOTE: Set lower limits to prevent divisions by zero
    aggressiveness = 0;
    diffs = [ diff(Rhip_motion) diff(Rknee_motion) diff(Rhip_rotation)];
    for idx = 1:numel(diffs)-1
        if (sign(diffs(idx)/diffs(idx+1))<0) && mod(idx,N) 
             aggressiveness = aggressiveness + 1;            
        end
    end
    
     wx = (mean(vel(1,:))*3+1);
    wy= mean(vel(2,:))*5+1;
    vy = (mean(vel(3,:))*3+1);

    
    negativeReward = wx * wy * max(xEnd,0.1) * vy *max(aggressiveness/3,0.5);
%         * max(footPenalty,1);

    %   Negative sign needed since the optimization minimizes cost function     
    penalty = -positiveReward/negativeReward;        
%     
%% Analysis
%% 
%    disp(['Distance travelled: ' ,num2str(zEnd)]);
%    disp(['Simulation time: ', num2str(tEnd)]);
%     disp(['Angular velocity y: ', num2str(wy)]);
%     disp(['Angular velocity x: ', num2str(wx)]);
%    disp(['aggressiveness: ', num2str(aggressiveness)]);
%    disp(['Y-axis velocity: ', num2str(vy)]);
%    disp(['side dist: ', num2str(xEnd)]);
%    disp(['Foot contact penalty: ', num2str(footPenalty)]);
%      
%    disp(['Positive reward: ', num2str(positiveReward)]); 
%    disp(['Negative reward: ', num2str(negativeReward)]); 
%% 
 
 figure(1)
  subplot(3,1,1)
  plot(time, rad2deg(Rhip_motion),'ko');
  hold on
  plot(timevec,rad2deg(yhip),'r--')
    title('Hip motion')
  xlabel('Time(s)');
  ylabel('Hip trajectory (deg)');
  legend( 'Optimised points' ,' Fitted curve', 'Location', 'NorthEast', 'Interpreter', 'none' );
  
  subplot(3,1,2)
  plot(time, rad2deg(Rknee_motion),'ko');
  hold on
  plot(timevec,rad2deg(yknee),'r--')
  title('Knee motion')
  xlabel('Time(s)');
  ylabel('Knee trajectory (deg)');

  subplot(3,1,3)
  plot(time, rad2deg(Rhip_rotation),'ko');
  hold on
  plot(timevec,rad2deg(yhiprot),'r--')
  title('Hip rotation')
  xlabel('Time(s)');
  ylabel('Hip rotation trajectory (deg)');
%% 
%   
%   RRK= Torque(:,1);
%   RRH = Torque(:,2);
%   RRR = Torque(:,3);
%   
%   RLK =  Torque(:,4);
%   RLH= Torque(:,5);
%   RLR= Torque(:,6);
%   
%   FRK= Torque(:,7);
%   FRH= Torque(:,8);
%   FRR= Torque(:,9);
%   
%   FLK= Torque(:,10);
%   FLH= Torque(:,11);
%   FLR= Torque(:,12);
%   
%   figure(1)
% %   subplot(3,1,1)
%   plot(ttot, RRK,'r--');
%   hold on
%   plot(ttot, RLK,'k-');
%   plot(ttot, FRK,'b-.');
%   plot(ttot, FLK,'g-');
%     title('Knee torque')
%   xlabel('Time(s)');
%   ylabel('Torque (Nm)');
%   ylim([-120 120]);
%   xlim([4.7 6]);
%   legend( 'Right Rear', 'Rear Left', 'Front Right', 'Front Left', 'Location', 'NorthEast', 'Interpreter', 'none' );
% hold off  
% 
% figure(2)
% %   subplot(3,1,2)
% plot(ttot, RRH,'r-');
%   hold on
%   plot(ttot, RLH,'k-');
%   plot(ttot, FRH,'b-');
%   plot(ttot, FLH,'g-');
%     title('Hip torque')
%   xlabel('Time(s)');
%   ylabel('Torque (Nm)');
%   ylim([-120 120]);
%   xlim([4.7 6]);
%   hold off
%   
%   figure(3)
% %   subplot(3,1,3)
%   plot(ttot, RRR,'r--');
%   hold on
%   plot(ttot, RLR,'k-');
%   plot(ttot, FRR,'b-.');
%   plot(ttot, FLR,'g-');
%     title('Hip rotation torque')
%   xlabel('Time(s)');
%   ylabel('Torque (Nm)');
%   ylim([-120 120]);
%   xlim([4.7 6]);
%   hold off

end

