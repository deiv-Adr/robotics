function objectData= uvdetectl(image_file_name)
    inputImg = imread(image_file_name);
    
    % Preprocess image
    grayImg = rgb2gray(inputImg);
    filteredImg = imgaussfilt(grayImg, 2); % Use a Gaussian filter to reduce noise
    
    % Thresholding
    binaryImg = imbinarize(filteredImg, 0.16);
    binaryImg = ~binaryImg;
    
    % Remove small objects
    cleanImg = bwareaopen(binaryImg, 600); % Adjust the area threshold depends on the quqlity of the image
    % Fill holes in the cylinders (if needed)
    cleanImg = imfill(cleanImg, 'holes');
    
    % Label connected components
    [labeledImage, numObjects] = bwlabel(cleanImg, 4);
    stats = regionprops("table", labeledImage, 'Centroid', 'Orientation','Area');
    
    % Initialize list to store centroids and orientations
    objectData =[];
    
    % Display the original image
    imshow(binaryImg);
    hold on;  % Keep the image displayed while we overlay the plots
    
    % Loop through each object
    for k = 1:numObjects
        % Get centroid (updated for table indexing)
        centroid = stats.Centroid(k, :);  % Access the k-th row of the Centroid column
        
        % Get orientation
        orientation = stats.Orientation(k);   % Access the k-th row of the Orientation column
        %Get area
        area=stats.Area(k);
        objectData = [objectData; centroid, orientation,area]; % Append data to the list
        
    end
end
