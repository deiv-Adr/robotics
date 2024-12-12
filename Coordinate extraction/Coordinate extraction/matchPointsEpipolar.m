function [validLeftPoints, validRightPoints] = matchPointsEpipolar(F, cylinderLeft, cylinderRight)
    % Initialize arrays to store valid points
    pointsLeft=cylinderLeft(:,1:2);
    pointsRight=cylinderRight(:,1:2);
    validLeftPoints = [];
    validRightPoints = [];
    
    % Tolerance for epipolar constraint (due to noise)
    tolerance = 0.1;  % A[objet_l, objet_r] = matchPointsEpipolar(F, objet_l, objet_r);djust tolerance as needed
    
    % Loop over all points
    for i = 1:size(pointsLeft, 1)
        % Convert the point from the left image to homogeneous coordinates
        x_L = [pointsLeft(i, :), 1]';  % Left image point in homogeneous coordinates
        
        % Loop over all points in the right image
        for j = 1:size(pointsRight, 1)
            % Convert the point from the right image to homogeneous coordinates
            x_R = [pointsRight(j, :), 1]';  % Right image point in homogeneous coordinates
            
            % Compute the epipolar line in the right image corresponding to x_L
            l_R = F * x_L;  % Epipolar line in the right image (3x1)
            
            % Check if the point in the right image lies on the epipolar line
            epipolar_constraint = l_R(1) * x_R(1) + l_R(2) * x_R(2) + l_R(3);  % Should be close to 0
            
            % If the point in the right image satisfies the epipolar constraint, add it to valid points
            if abs(epipolar_constraint) < tolerance
                validLeftPoints = [validLeftPoints; cylinderLeft(i, :)];  % Add the point from left image
                validRightPoints = [validRightPoints; cylinderRight(j, :)];  % Add the point from right image
                break;  % Once we find a valid match for this left point, break out of the loop
            end
        end
    end
    % Display results
    if isempty(validLeftPoints)
        disp('No valid matches found based on the epipolar constraint.');
    else
        disp(['Found ', num2str(size(validLeftPoints, 1)), ' valid matches.']);
    end
end
