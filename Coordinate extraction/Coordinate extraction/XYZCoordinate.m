%Puma_ready();
%load("Calib_Results_stereo.mat");
%load("Calib_Results_left.mat");
T_hat = [ 0    -T(3)   T(2);
          T(3)   0    -T(1);
         -T(2)   T(1)   0 ];
F = inv(KK_right') * T_hat * R * inv(KK_left);
targetObjectCount=4;
while true
    captureImages()
    % Re-run object detection
    objet_l = uvdetectl('imgleft.jpg');
    objet_r = uvdetectr('imgright.jpg');
    
    % Update the number of objects detected
    numObjectsLeft = size(objet_l, 1);
    numObjectsRight = size(objet_r, 1);
    if numObjectsLeft == targetObjectCount && numObjectsRight == targetObjectCount
        break;
    end
    fprintf(' Still less than %d objects detected. Shaking the box.',targetObjectCount);
    %Puma_shake();
end
% Apply the epipolar constraint to match points between left and right images
[objet_l, objet_r] = matchPointsEpipolar(F, objet_l, objet_r);
for i = 1:targetObjectCount
    while true
    % Get the centroids of the current objects
    centroid_l = objet_l(:, 1:2);
    centroid_r = objet_r(:, 1:2);

    % Project the object coordinates into 3D space
    XYZ = reconstruct3D(centroid_l(:,1), centroid_l(:,2), centroid_r(:,1), centroid_r(:,2), KK_left, KK_right, R, T, Rc_1, Tc_left_1);

    % Extract the 2D coordinates from the 3D projection
    XYnotValid = [XYZ(1:2, :),objet_r(:, 3)];

    % Rearrange points and check if any points are invalid
    [XYValid, shake] = rearrange_points(XYnotValid);

    % If all points are valid and the correct number of objects are detected, break the loop
    if shake == 0 && numObjectsLeft == targetObjectCount - i && numObjectsRight == targetObjectCount - i
        break;
    end

    disp('Still less than %d objects detected. Shaking the box again.', targetObjectCount - i);
    Puma_shake();
    captureImages();
    objet_l = uvdetectl('imgleft.jpg');
    objet_r = uvdetectr('imgright.jpg');
    [objet_l, objet_r] = matchPointsEpipolar(F, objet_l, objet_r);
    numObjectsLeft = size(objet_l, 1);
    numObjectsRight = size(objet_r, 1);
    end

% Grab the object and perform other actions
Puma_grab(XYValid(1,:));
Puma_ready();
Puma_deliver();
Puma_ready();

% Capture new images after grabbing
captureImages();
objet_l = uvdetectl('imgleft.jpg');
objet_r = uvdetectr('imgright.jpg');
numObjectsLeft = size(objet_l, 1);
numObjectsRight = size(objet_r, 1);
disp(['Object ', num2str(i), ' grabbed successfully. Remaining objects: ', num2str(targetObjectCount - i)]);

end