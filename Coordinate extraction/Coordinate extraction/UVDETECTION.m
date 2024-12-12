    % Load image
    inputImg = imread('imgright.jpg');
    
    % Preprocess image
    grayImg = rgb2gray(inputImg);
    filteredImg = imgaussfilt(grayImg, 2); % Use a Gaussian filter to reduce noise
    
    % Thresholding
    binaryImg = imbinarize(filteredImg, 0.16);
    binaryImg = ~binaryImg;
    
    % Remove small objects
    cleanImg = bwareaopen(binaryImg, 600); % Adjust the area threshold as needed
    % Fill holes in the cylinders (if needed)
    cleanImg = imfill(cleanImg, 'holes');
    
    % Label connected components
    [labeledImage, numObjects] = bwlabel(cleanImg, 4);
    stats = regionprops("table", labeledImage, 'Centroid', 'Orientation','Area');
    
    % Initialize list to store centroids and orientations
    objectsData = [];
    
    % Display the original image
    imshow(binaryImg);
    hold on;  % Keep the image displayed while we overlay the plots
    
    % Loop through each object
    for k = 1:numObjects
        % Get centroid (updated for table indexing)
        centroid = stats.Centroid(k, :);  % Access the k-th row of the Centroid column
        
        % Get orientation
        orientation = stats.Orientation(k);   % Access the k-th row of the Orientation column
        
        % Get area of the object
        area = stats.Area(k);  % Access the k-th row of the Area column
        
        % Store the centroid, orientation, and area in the list
        objectsData = [objectsData; centroid, orientation, area]; % Append data to the list
        
        % Convert orientation to radians
        angleRad = orientation * (pi / 180);
        
        % Calculate the endpoint of the orientation line
        lineLength = 50; % Length of the orientation line
        xEnd = centroid(1) + lineLength * cos(angleRad);
        yEnd = centroid(2) - lineLength * sin(angleRad); % Subtract to account for image coordinates
        
        % Plot the centroid as a red star
        plot(centroid(1), centroid(2), 'r*', 'MarkerSize', 10, 'LineWidth', 2);
        
        % Plot the orientation line as a green line
        plot([centroid(1), xEnd], [centroid(2), yEnd], 'g-', 'LineWidth', 2);
    end
    
    hold off;  % Release the hold so the rest of the plots don't overlap
    
    % Display the list of objects' data (centroids and orientations)
    disp('Objects Data (Centroid, Orientation):');
    disp(objectsData);