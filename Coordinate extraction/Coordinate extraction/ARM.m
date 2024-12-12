file_path='';
bool=check_file_content(file_path);
bool=0;
n=0;
while bool
    load("Calib_Results_stereo.mat");
    load("Calib_Results_left.mat");
    % Set the minimum area threshold to filter small objects
    min_area_l = 8000;  % Adjust this based on your requirement
    min_area_r= 9000;
    Puma_ready;
    T_hat = [ 0    -T(3)   T(2);
              T(3)   0    -T(1);
             -T(2)   T(1)   0 ];
    F = inv(KK_right') * T_hat * R * inv(KK_left);
    
    reachableObjects = []; % Initialize a matrix for reachable objects
    while true
        if n==30
            break;
        end
        captureImages();
        
        % Re-run object detection
        objet_l = uvdetectl('imgleft.jpg');
        objet_r = uvdetectr('imgright.jpg');
        if isempty(objet_l) || isempty(objet_r)
            break
        end
        % Filter objects based on area (ignore objects above threshold)
        valid_objects_left = objet_l(objet_l(:,4) <= min_area_l, :);
        valid_objects_right = objet_r(objet_r(:,4) <= min_area_r, :);
        % If no valid objects are detected, shake the box
        if isempty(valid_objects_left) || isempty(valid_objects_right)
            fprintf('No valid objects detected. Shaking the box.\n');
            Puma_shake();
            Puma_ready();
            n=n+1;
            continue; % Skip the rest of the loop and retry
        end
        %[valid_objects_left, valid_objects_right] = matchPointsEpipolar(F, valid_objects_left, valid_objects_right);
        
        centroid_l = valid_objects_left(:, 1:2);
        centroid_r = valid_objects_right(:, 1:2);
        % Apply the epipolar constraint to match points between left and right images
        XYZ=[];
        for i = 1:size(centroid_r, 1)
            XYZ = [XYZ;(reconstruct3D(centroid_l(i,1), centroid_l(i,2), centroid_r(i,1), centroid_r(i,2), KK_left, KK_right, R, T, Rc_1, Tc_left_1))'];
        end
        XYnotValid = [XYZ(:,1:2) zeros(size(XYZ, 1), 1) valid_objects_right(:,3)];
        XYthetaValid = [rearrange_points(XYnotValid)];
        
        if isempty(XYthetaValid)
            fprintf('No valid (reachable) objects found. Shaking the box again.\n');
            Puma_shake();
            Puma_ready();
            n=n+1;
            continue;
        end
        
        % If valid objects are found and reachable, proceed with grabbing
        for i = 1:size(XYthetaValid, 1)
            % Grab the object and perform other actions
            Puma_grab(XYthetaValid(i, :));
            Puma_ready();
            Puma_deliver();
            Puma_ready();
        end
    end
    bool=0;
    fprintf('No more objects detected rsync 1 to roomba');
    filePath = '/home/pgyboolArm.txt';
    % Open the file for writing ('w' mode creates a new file or overwrites if it exists)
    fileID = fopen(filePath, 'w');
    % Check if the file was successfully opened
    if fileID == -1
        error('Failed to open the file for writing.');
    end
    % Write the number 1 to the file
    fprintf(fileID, '%d', 0);
    
    % Close the file
    fclose(fileID);
    
    disp('Number 0 written to file successfully.');
    pause(2);
end