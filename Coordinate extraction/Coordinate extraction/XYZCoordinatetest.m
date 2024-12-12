load("Calib_Results_stereo.mat");
load("Calib_Results_left.mat");
objet_l=uvdetectl('imgleft.jpg')
objet_r=uvdetectr('imgright.jpg')
% Epipolar constraint setup (Assuming T, R, and KK are already defined)
T_hat = [ 0    -T(3)   T(2);
          T(3)   0    -T(1);
         -T(2)   T(1)   0 ];
F = inv(KK_right') * T_hat * R * inv(KK_left);
[objet_l, objet_r] = matchPointsEpipolar(F, objet_l, objet_r);
uv_l=objet_l(1,1:2);
uv_r=objet_r(1,1:2);

XYZ = reconstruct3D(uv_l(1,1),uv_l(1,2), uv_r(1,1),uv_r(1,2), KK_left, KK_right, R, T,Rc_1,Tc_left_1);
% Display the reconstructed 3D point
disp('Reconstructed 3D Point (X, Y, Z):');
disp(XYZ);