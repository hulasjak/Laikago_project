function penalty = TLSimulation3d(params,mdlName,scaleFactor)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

 twoLegData;
warning('off','all');
 params = scaleFactor*params;
 
  N = numel(params)/4;
     Fhip_motion   = deg2rad([params(1:N) ]');
     Fknee_motion  = deg2rad([params(N+1:2*N) ]');
    Rhip_motion   = deg2rad([params(2*N+1:3*N) ]');
     Rknee_motion  = deg2rad([params(3*N+1:4*N) ]');
%      curveData = createSmoothTrajectory( ... 
%                Fhip_motion,Fknee_motion,Rhip_motion,Rknee_motion,period);
%     initAnglesR = evalSmoothTrajectory(curveData,0);
%     initAnglesL = evalSmoothTrajectory(curveData,-period/2);
    
%     initial_q = evalSmoothTrajectory(curveData,0);
%     initial_qF= [initial_q(1); initial_q(2)];
%    initial_qR = [initial_q(3); initial_q(4)];
initial_qF = [Fknee_motion(1,1); Fhip_motion(1,1)];
initial_qR = [Rknee_motion(1,1); Rhip_motion(1,1)];

   simout = sim(mdlName,'SrcWorkspace','current','FastRestart','off');
   
      vel = abs(simout.yout{1}.Values.Data);
    xEnd = simout.yout{2}.Values.Data(end);
    tEnd = simout.tout(end);
    footDist = simout.yout{3}.Values.Data;
    
   
        footDist(footDist < 0.07) = 0;          %foot on the ground
        footDist(footDist > 0.07) = 1;          %foot in the air
        
        footSum=sum(footDist,2);
        
        footSum(footSum < 2) = 0;
        footSum(footSum >= 2) = 5;          %penalty if more legs in the air
              
         footPenalty = mean(footSum);        %sum penalty
    
     positiveReward = sign(-xEnd)*xEnd^2 * tEnd;
    %   Angular velocity and trajectory aggressiveness 
    %   (number of times the derivative flips signs) decreases reward
    %   NOTE: Set lower limits to prevent divisions by zero
    aggressiveness = 0;
    diffs = [diff(Fhip_motion) diff(Fknee_motion) diff(Rhip_motion) diff(Rknee_motion)];
    for idx = 1:numel(diffs)-1
        if (sign(diffs(idx)/diffs(idx+1))<0) && mod(idx,N) 
             aggressiveness = aggressiveness + 1;            
        end
    end
    
    wAvg = mean(vel(1,:))+1;
    vy= mean(vel(2,:))+1;
    
    negativeReward = max(wAvg,0.01)*max(aggressiveness,1)...
        *max(footPenalty,1)*max(vy,0.01) ;
    %   Negative sign needed since the optimization minimizes cost function     
    penalty = -positiveReward/negativeReward;        
    
   disp(['x rev' ,num2str(xEnd^2)]);
   disp(['trev', num2str(tEnd)]);
    disp(['wrev', num2str(wAvg)]);
   disp(['aggrerev', num2str(aggressiveness)]);
   disp(['vy', num2str(vy)]);
   disp(['contact ', num2str(footPenalty)]);
   disp(['penatly :', num2str(positiveReward)]); 
   disp(['penatly :', num2str(negativeReward)]); 
    
end

