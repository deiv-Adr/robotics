function Puma_shake()
    % Define a set of target positions (Cartesian space)
    a=0.9;
    system('Puma_Speed 30');
    pause(0.5);
    waypoints = [-110,250,-46,180,90,0;
        -110,250,-160,180,90,0;
        50,250,-160,180,90,0;
        0,250,-160,180,90,0];
    % Loop through each waypoint and move the robot incrementally
    command = sprintf('Puma_MovetoXYZOAT %.1f, %.1f, %.1f, %.1f, %.1f, %.1f', waypoints(1, :));
    system(command);
    pause(3);
    system('openGripper');
    pause (0.5);
    command = sprintf('Puma_MovetoXYZOAT %.1f, %.1f, %.1f, %.1f, %.1f, %.1f', waypoints(2, :));
    system(command);
    pause(2);
    system('Puma_Speed 100');
    pause(0.5);
    system('closeGripper');
    pause (0.5);
    command = sprintf('Puma_MovetoXYZOAT %.1f, %.1f, %.1f, %.1f, %.1f, %.1f', waypoints(3, :));
    system(command);
    pause(a);
    command = sprintf('Puma_MovetoXYZOAT %.1f, %.1f, %.1f, %.1f, %.1f, %.1f', waypoints(2, :));
    system(command);
    pause(a);
    command = sprintf('Puma_MovetoXYZOAT %.1f, %.1f, %.1f, %.1f, %.1f, %.1f', waypoints(4, :));
    system(command);
    pause(a);
    command = sprintf('Puma_MovetoXYZOAT %.1f, %.1f, %.1f, %.1f, %.1f, %.1f', waypoints(2, :));
    system(command);
    pause(a);
    system('openGripper');
    pause (0.5);
    system('Puma_Speed 30');
    pause(0.5);
    command = sprintf('Puma_MovetoXYZOAT %.1f, %.1f, %.1f, %.1f, %.1f, %.1f', waypoints(1, :));
    system(command);
    pause(2);
    
end