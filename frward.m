% Define joint angles, link offsets, link lengths, and link twists in numerical values
theta_values = [deg2rad(-179.116), deg2rad(-143.553), deg2rad(-13.559), deg2rad(90.139), deg2rad(90.074), deg2rad(50.994)];
d_values = [0*25.4, 0*25.4, 79/16*25.4, 8*25.4, 0*25.4, 2.202*25.4];
a_values = [0*25.4, 8*25.4, -5/16*25.4, 0*25.4, 0*25.4, 0*25.4];
alpha_values = [-pi/2, 0, pi/2, -pi/2, pi/2, 0];

% Initialize the transformation matrix as identity matrix
T = eye(4);  % Start with identity matrix

% Loop through each joint and apply the DH transformations
for i = 1:6
    theta = theta_values(i);
    d = d_values(i);
    a = a_values(i);
    alpha = alpha_values(i);
    
    % Compute the transformation matrix for this joint
    A = [cos(theta), -sin(theta)*cos(alpha), sin(theta)*sin(alpha), a*cos(theta);
         sin(theta), cos(theta)*cos(alpha), -cos(theta)*sin(alpha), a*sin(theta);
         0, sin(alpha), cos(alpha), d;
         0, 0, 0, 1];
    
    % Multiply the transformation matrix to the total matrix
    T = T * A;
end
% Yaw (ψ) around the z-axis
yaw = atan2(T(2,1), T(1,1));

% Roll (φ) around the x-axis
roll = atan2(T(3,2), T(3,3));

% Pitch (θ) around the y-axis
pitch = atan2(-T(3,1), sqrt(T(3,2)^2 + T(3,3)^2));

% Convert radians to degrees (optional, if you want the angles in degrees)
yaw = rad2deg(yaw);
roll = rad2deg(roll);
pitch = rad2deg(pitch);
% Display the final transformation matrix (numeric)
disp('Total Transformation Matrix between the base and the end-effector (numeric):');
disp('O=',yaw,'A=',roll,'T=',pitch,'X'=T(1,4),'Y'=T(2,4),'Z'=T(3,4));
