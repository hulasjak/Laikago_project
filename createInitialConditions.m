function [P,T,N] = createInitialConditions(filename,scale)
% Converts data from a previously saved MAT-file to initial conditions for


    % Load previously saved file
    load(filename);
    
    % Find number of points (ignore end point)
    N = numel(Rhip_motion)-1;   
    
    % Find gait period
    T = time(N+1);
%      Rhip_rotation=zeros(1,N);
    % Convert gait to scaled version for optimization
    P = rad2deg([Rhip_motion(1:N)' ...
                 Rknee_motion(1:N)'...
                 Rhip_rotation(1:N)'])/scale;

end