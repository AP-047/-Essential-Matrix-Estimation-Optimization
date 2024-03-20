function E = estimate_essential_matrix(K1, K2, image_points1, image_points2)
% Construct homogeneous coordinates for image points
homogeneous_image_points1 = [image_points1, ones(size(image_points1, 1), 1)];
homogeneous_image_points2 = [image_points2, ones(size(image_points2, 1), 1)];

% Normalize image points using the inverse of the calibration matrices
normalized_points1 = (K1 \ image_points1')';
normalized_points2 = (K2 \ image_points2')';

% Remove the homogeneous coordinate
normalized_points1 = normalized_points1(:, 1:2);
normalized_points2 = normalized_points2(:, 1:2);


    % Display the normalized points
    disp('Normalized Image Points 1:');
    disp(normalized_points1);
    disp('Normalized Image Points 2:');
    disp(normalized_points2);

    % Estimate the fundamental matrix using the normalized eight-point algorithm
    F = eight_point_algorithm(normalized_points1, normalized_points2);

    % Enforce the rank-2 constraint on F
    [U, S, V] = svd(F);
    S(3,3) = 0;
    F = U * S * V';

    % Essential matrix is then calculated from the fundamental matrix
    E = K2' * F * K1;
end

