function fitresult = hipFit(time, Rhip_motion)
%CREATEFIT(TIME,RKNEE_MOTION)
%  Create a fit.
%
%  Data for 'Sand gait hip' fit:
%      X Input : time
%      Y Output: Rknee_motion
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 24-Jun-2019 14:13:03


%% Fit: 'Sand gait hip'.
[xData, yData] = prepareCurveData( time, Rhip_motion );

% Set up fittype and options.
ft = fittype( 'smoothingspline' );
opts = fitoptions( 'Method', 'SmoothingSpline' );
opts.SmoothingParam = 0.9999916440332;

% Fit model to data.
fitresult = fit( xData, yData, ft, opts );

% % Plot fit with data.
% figure( 'Name', 'Sand gait hip' );
% h = plot( fitresult, xData, yData );
% legend( h, 'Rknee_motion vs. time', 'Sand gait hip', 'Location', 'NorthEast', 'Interpreter', 'none' );
% % Label axes
% xlabel( 'time', 'Interpreter', 'none' );
% ylabel( 'Rknee_motion', 'Interpreter', 'none' );
% grid on


