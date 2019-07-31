% 
% 
% 
% %gait information
 n=6;
 gaitPeriod = 1.2;
 time = linspace(0,gaitPeriod,n+1)';


ground_dim = [2 5 0.001];
plane_depth = 0.1;
Splane_depth = 0.1;
g=-9.81;

%Contact parameters
contact_point_radius = 0.01;
Scontact_point_radius = 0.025;

%sand param
Scontact_stiffness = 4000;
Scontact_damping = 250;
penFull = 0.035;
penExp = 1.25;

Smu_k = 2.5;
Smu_s = 3;
mu_vth = 0.1;

%stiff parram
contact_stiffness = 150000;
contact_damping = 5000;

mu_k = 0.7;
mu_s = 0.9;

plane_x = 2;
plane_y = 10;

%Leg parameters
       %lower leg
foot_contact=  [0.000, -0.25, -0.022];
foot_contact1= [0.008, -0.27, -0.01];       
foot_contact2= [-0.008, -0.27, -0.01]; 
foot_contact3= [0.008, -0.25, -0.045]; 
foot_contact4= [-0.008, -0.25, -0.045];


