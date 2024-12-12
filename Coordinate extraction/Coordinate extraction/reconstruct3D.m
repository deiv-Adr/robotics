function XYZ_world = reconstruct3D(u_L, v_L, u_R, v_R, K_L, K_R, R, T,R_left,T_left)
    % Reconstruct 3D point from corresponding image points using stereo
    % calib results

    % Construct the projection matrices for both cameras
    Q_L = [K_L zeros(3,1)] * [R_left T_left;0 0 0 1]; % Left camera projection matrix
    Q_R = [K_R zeros(3,1)] * [R T; 0 0 0 1]*[R_left T_left;0 0 0 1];   % Right camera projection matrix

    % Convert image points to homogeneous coordinates
    uv_L = [u_L; v_L; 1]; % Left image point in homogeneous coordinates
    uv_R = [u_R; v_R; 1]; % Right image point in homogeneous coordinates

    A=[Q_R(1,1:3)-uv_R(1)*Q_R(3,1:3);Q_R(2,1:3)-uv_R(2)*Q_R(3,1:3); Q_L(1,1:3)-uv_L(1)*Q_L(3,1:3);Q_L(2,1:3)-uv_L(2)*Q_L(3,1:3)];
    b=[(uv_R(1)*Q_R(3,4))-Q_R(1,4);(uv_R(2)*Q_R(3,4))-Q_R(2,4);(uv_L(1)*Q_L(3,4))-Q_L(1,4);(uv_L(2)*Q_L(3,4))-Q_L(2,4)];
    XYZ_world=pinv(A)*b;
end