function rearranged_points = rearrange_points(XYZ)
    xmin=-271;
    xmax=-160;
    ymin=175;
    ymax=304;
     % Rearrange points based on the in_bounds logical index
    WtoR=[XYZ(:,1:3)';ones(1, size(XYZ,1))]; % [x; y; z; 1]
    TW=[0, 1, 0,-430;   % Example 4x4 transformation matrix
        -1,0, 0,440;
        0, 0, 1,-330.2;
        0, 0, 0, 1];
    XYZ_homogeneous =TW * WtoR;
    points = [XYZ_homogeneous(1:2,:)' XYZ(:,4)]; % [x; y; z]
    in_bounds = points(:, 1) >= xmin & points(:, 1) <= xmax & ...
                points(:, 2) >= ymin & points(:, 2) <= ymax;
    rearranged_points = points(in_bounds,:);
end