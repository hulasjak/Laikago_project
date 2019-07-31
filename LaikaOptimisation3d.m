
% Choose model name
mdlName = 'SandLaika3d'; 

% Flags to speed up simulation
accelFlag = true;
parallelFlag = true;

joints= 3; %amount of independent joints

scalingFactor = 2;        % Scalling to reduce the search space

%% Different ways to create initial individual
% 1st no movement

%  numPoints = 6;              % Number of joint angle points
%  gaitPeriod = 1.2;           % Period of the gait 
%  p0 = zeros(1,numPoints*3);  % Create zero motion initial conditions

%2nd Choose a trajectory and use IK to apply it
% p0 = GenerateGait(t,time);


% Load previous results
 startFile = 'Final3Dinititial_05Jul19_1124';
  [p0,gaitPeriod,numPoints] = createInitialConditions(startFile,scalingFactor);

%% Set optimization options
opts = optimoptions('ga');
opts.Display = 'iter';
opts.MaxGenerations = 200;      %maxium number of generations
opts.PopulationSize = 50;       %Size of each generation
opts.InitialPopulationMatrix = repmat(p0,[5 1]); % Add  copies of initial gait
opts.PlotFcn = @gaplotbestf; % Add progress plot of cost function
opts.UseParallel = parallelFlag;

%% Set bounds and constraints
% Upper and lower angle bounds
upperBnd = [60 *ones(1,numPoints), ... % Hip limit
            0*ones(1,numPoints),...    % knee limit
            10*ones(1,numPoints)] /scalingFactor; % Hip rotation limit

            
lowerBnd = [-10*ones(1,numPoints), ... % Hip limit
            -120*ones(1,numPoints),... % Knee Limit
            -10*ones(1,numPoints)]/scalingFactor;  % Hip rotation limit

            

%% Run commands to set up parallel/accelerated simulation
 doSpeedupTasks;

%% Run optimization
costFcn = @(p) LaikaSimulation3d(p,mdlName,scalingFactor);
disp(['Running optimization. Population: ' num2str(opts.PopulationSize) ...
      ', Max Generations: ' num2str(opts.MaxGenerations)])
[pFinal,reward] = ga(costFcn,numPoints*3,[],[],[],[], ... 
                     lowerBnd,upperBnd,[],1:numPoints*3,opts);
disp(['Final reward function value: ' num2str(-reward)])

%% Save results to file

pScaled = scalingFactor*pFinal;
time = linspace(0,gaitPeriod,numPoints+1)';
  Rhip_motion   = deg2rad([pScaled(1:numPoints),pScaled(1)]');
     Rknee_motion  = deg2rad([pScaled(numPoints+1:2*numPoints), pScaled(numPoints+1)]');
     Rhip_rotation   = deg2rad([pScaled(2*numPoints+1:3*numPoints), pScaled(2*numPoints+1) ]');

outFileName = ['Final3Dinitial_' datestr(now,'ddmmmyy_HHMM')];
save(outFileName,'reward','gaitPeriod','time', ... 
                 'Rhip_motion','Rknee_motion','Rhip_rotation');


%% Cleanup
bdclose(mdlName);
if parallelFlag
   delete(gcp('nocreate')); 
end