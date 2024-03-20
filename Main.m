% Opening the file to read calibration points
fh = fopen('calib_points.dat', 'r');
% Reading the data including image points and object points
A = fscanf(fh, '%f%f%f%f%f%f%f', [7 inf]);
% Closing the file after reading
fclose(fh);

% Extracting image points and object points from the read data
x1 = A(1:2, :); % Image points (x1, y1) in the first image
x2 = A(3:4, :); % Image points (x2, y2) in the second image
object_points = A(5:7, :); % Corresponding object points (X, Y, Z)

% Transposing the points to get them into the correct shape
image_points1 = x1'; % Transpose to create a two-column matrix for image points in the first image
image_points2 = x2'; % Transpose to create a two-column matrix for image points in the second image
object_points = object_points'; % Transpose to create a three-column matrix for object points

% Displaying the dimensions of image and object points
disp('Image and Object Points:');
disp(['Image Points 1: ', num2str(size(image_points1))]); % Dimensions of image points in the first image
disp(['Image Points 2: ', num2str(size(image_points2))]); % Dimensions of image points in the second image
disp(['Object Points: ', num2str(size(object_points))]);  % Dimensions of object points

% Normalizing the image and object points
[normalized_image_points1, normalized_object_points, T_image, T_object] = normalize_points(image_points1, object_points);
[normalized_image_points2, ~, ~, ~] = normalize_points(image_points2, object_points);

% Displaying the normalized points
disp('Normalized Image and Object Points:');
disp(['Normalized Image Points 1:']);
disp(normalized_image_points1);
disp(['Normalized Image Points 2:']);
disp(normalized_image_points2);
disp(['Normalized Object Points:']);
disp(normalized_object_points);

% Computing the projective matrices using Direct Linear Transformation (DLT)
P1 = DLT(normalized_image_points1, normalized_object_points);
P2 = DLT(normalized_image_points2, normalized_object_points);

% Displaying the computed projective matrices
disp('Projective Matrices (P1 and P2) computed using DLT:');
disp(['P1: ', num2str(size(P1))]);
disp(['P2: ', num2str(size(P2))]);

% Decomposing the projective matrices to obtain the calibration matrices
K1 = decompose_projection_matrix(P1);
K2 = decompose_projection_matrix(P2);

% Displaying the obtained calibration matrices
disp('Calibration Matrices (K1 and K2) obtained by decomposing projective matrices:');
disp(['K1: ', num2str(size(K1))]);
disp(['K2: ', num2str(size(K2))]);

% Estimating the essential matrix E
E = estimate_essential_matrix(K1, K2, normalized_image_points1, normalized_image_points2);

% Displaying the estimated essential matrix
disp('Essential Matrix (E) estimated:');
disp(['E: ', num2str(size(E))]);


% Resolving the fourfold ambiguity to obtain the rotation matrix (R) and translation vector (t)
[R, t] = resolve_fourfold_ambiguity(E, K1, K2, normalized_image_points1, normalized_image_points2);

disp('Resolving Fourfold Ambiguity:');
disp(['Rotation Matrix (R): ', num2str(size(R))]);
disp(['Translation Vector (t): ', num2str(size(t))]);

% Computing the fundamental matrix (F) from the essential matrix (E)
F = K2' \ E / K1;

disp('Computing Fundamental Matrix:');
disp(['Fundamental Matrix (F): ', num2str(size(F))]);

% Checking the determinant of the fundamental matrix (F)
assert(det(F) < 1e-6, 'Potential issue: Determinant of F is not close to zero.');

disp('Checking Fundamental Matrix Determinant: Determinant of F is close to zero.');

% Computing and visualizing epipolar lines for both images
% Computing epipolar lines for both sets of points
lines1 = (F * normalized_image_points1')'; % Compute lines for the first image
lines2 = (F' * normalized_image_points2')'; % Compute lines for the second image (transpose of F)

% Displaying computed epipolar lines
disp('Computed Epipolar Lines:');
disp('Epipolar Lines for View 1:');
disp(lines1);
disp('Epipolar Lines for View 2:');
disp(lines2);

% Visualizing epipolar lines for the first image
figure;
hold on;
title('Epipolar Lines for Image 1');
plot(normalized_image_points1(:, 1), normalized_image_points1(:, 2), 'bo', 'MarkerSize', 8, 'LineWidth', 2); % Plot image points

% Drawing epipolar lines
xlim = get(gca, 'XLim');
ylim = get(gca, 'YLim');
for i = 1:size(lines1, 1)
    hline(lines1(i, :), xlim, ylim, 'vertical'); % Draw epipolar lines using the provided function
end

xlabel('X-coordinate');
ylabel('Y-coordinate');
grid on;
legend('Image Points', 'Epipolar Lines');
hold off;

% Visualizing epipolar lines for the second image
figure;
hold on;
title('Epipolar Lines for Image 2');
plot(normalized_image_points2(:, 1), normalized_image_points2(:, 2), 'bo', 'MarkerSize', 8, 'LineWidth', 2); % Plot image points

% Drawing epipolar lines
xlim = get(gca, 'XLim');
ylim = get(gca, 'YLim');
for i = 1:size(lines2, 1)
    hline(lines2(i, :), xlim, ylim, 'vertical'); % Draw epipolar lines using the provided function
end

xlabel('X-coordinate');
ylabel('Y-coordinate');
grid on;
legend('Image Points', 'Epipolar Lines');
hold off;

% ======== %
% Task 2

% Computing Initial Geometric Error
initial_geometric_error = compute_geometric_error(P1, P2, image_points1, image_points2, object_points);
disp(['Initial Geometric Error: ', num2str(initial_geometric_error)]);

% Optimization
% Flattening the initial P1 and P2 matrices into a vector for optimization
P_vec_initial = [P1(:); P2(:)];

% Setting options for lsqnonlin
options = optimoptions('lsqnonlin', ...
                       'Algorithm', 'levenberg-marquardt', ...
                       'Display', 'iter', ...
                       'MaxIterations', 100, ...
                       'TolFun', 1e-6, ...
                       'TolX', 1e-6);

% Defining the error function for the optimization
error_function = @(P_vec) reprojection_error(P_vec, image_points1, image_points2, object_points, K1, K2);

% Running the non-linear optimization
[P_vec_optimized, resnorm, residual, exitflag, output, lambda, jacobian] = lsqnonlin(error_function, P_vec_initial, [], [], options);

% Reshaping the optimized vector back into P1 and P2 matrices
P1_optimized = reshape(P_vec_optimized(1:numel(P1)), size(P1));
P2_optimized = reshape(P_vec_optimized(numel(P1)+1:end), size(P2));

% Recomputing the geometric error with the optimized matrices
optimized_geometric_error = compute_geometric_error(P1_optimized, P2_optimized, image_points1, image_points2, object_points);
disp(['Optimized Geometric Error: ', num2str(optimized_geometric_error)]);
