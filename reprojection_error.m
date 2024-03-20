function residuals = reprojection_error(P_vec, image_points1, image_points2, object_points, K1, K2)
    % First, we reshape the vector P_vec into two 3x4 matrices, P1 and P2,
    % representing the projective matrices of the two cameras.
    num_elements_P = 3 * 4; % Here, we compute the number of elements in each P matrix.
    P1 = reshape(P_vec(1:num_elements_P), 3, 4);
    P2 = reshape(P_vec(num_elements_P+1:end), 3, 4);
    
    % Next, we project the 3D object points into 2D image points for both cameras
    % using the projective matrices P1 and P2.
    projected_points1 = project_points(P1, object_points);
    projected_points2 = project_points(P2, object_points);
    
    % Now, we compute the residuals by finding the differences between the observed
    % image points and the projected image points for both cameras.
    residuals1 = image_points1 - projected_points1;
    residuals2 = image_points2 - projected_points2;
    
    % Finally, we flatten the residuals into a single column vector for convenient handling.
    residuals = [residuals1(:); residuals2(:)];
end
