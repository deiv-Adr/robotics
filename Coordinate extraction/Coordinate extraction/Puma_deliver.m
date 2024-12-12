function Puma_deliver() 
    % Define a set of target positions (Cartesian space)
    waypoints1 = [-115,-20,180,180,90,0];
    for i = 1:size(waypoints1, 1)
        command = sprintf('Puma_MovetoJoints %.1f, %.1f, %.1f, %.1f, %.1f, %.1f', waypoints1(i, :));
        system(command);
        pause(4);
    end
    system('openGripper');
    pause (1);
end