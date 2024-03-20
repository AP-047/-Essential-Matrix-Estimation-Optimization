function F = eight_point_algorithm(points1, points2)
    % Applies the eight-point algorithm to estimate the fundamental matrix F
    % from corresponding points in two images.

    A = []; % Initialize matrix A based on correspondence equations
    for i = 1:size(points1, 1)
        % Extract corresponding points
        x1 = points1(i, 1);
        y1 = points1(i, 2);
        x2 = points2(i, 1);
        y2 = points2(i, 2);
        % Populate A with equation coefficients for these points
        A(i, :) = [x1*x2, x1*y2, x1, y1*x2, y1*y2, y1, x2, y2, 1];
    end

    % Determine F using Singular Value Decomposition (SVD) and least squares
    [~, ~, V] = svd(A);
    F = reshape(V(:, end), 3, 3)'; % Reshape the solution into a 3x3 matrix

    % Adjust F to enforce the rank 2 constraint
    [U, S, V] = svd(F);
    F = U * diag([S(1,1), S(2,2), 0]) * V'; % Set smallest singular value to 0
end
