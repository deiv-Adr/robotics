function Puma_ready()
        % Define a set of target positions (Cartesian space)
    waypoints = [-90, -135.882, 5.334,180.002,49.457,0];
    system('Puma_Speed 30');
    pause(0.5);
    % Loop through each waypoint and move the robot incrementally
    for i = 1:size(waypoints, 1)
        command = sprintf('Puma_MovetoJoints %.1f, %.1f, %.1f, %.1f, %.1f, %.1f', waypoints(i, :));
        system(command);
        pause(6);
    end
end
