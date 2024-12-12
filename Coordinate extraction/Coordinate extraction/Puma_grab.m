function Puma_grab(P)
    system('Puma_Speed 30');
    pause(0.5);
    a=P(1,3);
    if a<=0
        angle=-a+90;
    else
        angle=-a-90;
    end
    XY=P(1,1:2);
    system('openGripper');
    pause(1);
    waypoints=[XY,-46,180,90,0;
        XY,-46,180,90,angle;
        XY,-182.5,180,90,angle];
    command = sprintf('Puma_MovetoXYZOAT %.1f, %.1f, %.1f, %.1f, %.1f, %.1f', waypoints(1, :));
    system(command);
    pause(4);
    command = sprintf('Puma_MovetoXYZOAT %.1f, %.1f, %.1f, %.1f, %.1f, %.1f', waypoints(2, :));
    system(command);
    pause(2);
    command = sprintf('Puma_MovetoXYZOAT %.1f, %.1f, %.1f, %.1f, %.1f, %.1f', waypoints(3, :));
    system(command);
    pause(4);
    system('closeGripper');
    pause (1);
    command = sprintf('Puma_MovetoXYZOAT %.1f, %.1f, %.1f, %.1f, %.1f, %.1f', waypoints(1, :));
    system(command);
    pause(3);

end
