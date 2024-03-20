function K = decompose_projection_matrix(P)
    % Extracts the rotation and intrinsic parameters from the projection matrix P.

    M = P(:, 1:3); % Extract rotation and scaling matrix.
    
    % Adjust M to ensure a positive determinant.
    if det(M) < 0
        M = -M;
    end

    % Singular Value Decomposition to separate rotation and intrinsic scales.
    [U, S, ~] = svd(M);
    
    % Construct the intrinsic parameter matrix, normalized such that K(3,3) = 1.
    K = U * S;
    K = K / K(3, 3);
end
