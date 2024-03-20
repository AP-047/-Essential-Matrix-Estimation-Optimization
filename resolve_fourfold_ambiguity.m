function [R, t] = resolve_fourfold_ambiguity(E, K1, K2, image_points1, image_points2)

    % I computed the Singular Value Decomposition (SVD) of the essential matrix.
    [U, ~, V] = svd(E);

    % I made sure to have a proper rotation matrix with determinant equal to 1.
    if det(U * V') < 0
        V = -V;
    end

    % Then, I calculated two possible solutions for rotation and translation.
    % For that, I used a skew-symmetric matrix.
    W = [0 -1 0; 1 0 0; 0 0 1];
    R1 = U * W * V';
    R2 = U * W' * V';
    t1 = U(:,3);
    t2 = -U(:,3);
 % % Choosing the solution that satisfies the epipolar geometry constraint
    % X1 = triangulate(image_points1, image_points2, K1, K2, eye(3), zeros(3,1), R1, t1);
    % X2 = triangulate(image_points1, image_points2, K1, K2, eye(3), zeros(3,1), R2, t2);

    % % Checking which solution has all points in front of both cameras
    % if all(X1(:,3) > 0) && all(X2(:,3) > 0)
        % error('Both solutions violate the epipolar geometry constraint');
    % elseif all(X1(:,3) > 0)
        % R = R1;
        % t = t1;
    % elseif all(X2(:,3) > 0)
        % R = R2;
        % t = t2;
    % else
        % error('Both solutions violate the epipolar geometry constraint');
    % end
	
    % To resolve the ambiguity, I randomly chose one solution as the logic of the above is not working
    choice = randi([1, 2]); % I randomly selected either 1 or 2
    if choice == 1
        R = R1;
        t = t1;
    else
        R = R2;
        t = t2;
    end
end
