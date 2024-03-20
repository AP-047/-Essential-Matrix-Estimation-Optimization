function P = DLT(normalized_image_points, normalized_object_points)
    % Implements the Direct Linear Transform (DLT) to compute the projective matrix P
    % from normalized image points and object points.

    A = []; % Initialize the design matrix for DLT.
    for i = 1:size(normalized_image_points, 1)
        X = normalized_object_points(i, :); % 3D object point
        x = normalized_image_points(i, 1); % x coordinate in image
        y = normalized_image_points(i, 2); % y coordinate in image
        w = normalized_image_points(i, 3); % Homogeneous coordinate
        % Construct rows of matrix A based on homography equations
        A = [A;
             zeros(1, 4), -w*X, y*X;
             w*X, zeros(1, 4), -x*X;
             -y*X, x*X, zeros(1, 4)];
    end

    % Solve for P using Singular Value Decomposition (SVD) of A.
    [~, ~, V] = svd(A);
    P = reshape(V(:,end), 4, 3)'; % Reshape the last column of V to form P.
end
