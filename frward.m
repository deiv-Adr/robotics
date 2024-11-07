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

% Display the final transformation matrix (numeric)
disp('Total Transformation Matrix between the base and the end-effector (numeric):');
disp(T);
