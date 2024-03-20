function [world_points, reprojection_errors] = triangulate(image_points1, image_points2, K1, K2, R, t)
    % Converting image points to homogeneous coordinates
    homogeneous_points1 = [image_points1, ones(size(image_points1, 1), 1)];
    homogeneous_points2 = [image_points2, ones(size(image_points2, 1), 1)];

    % Computing camera matrices
    M1 = K1 * [eye(3), zeros(3, 1)];  % Computing camera matrix for image 1
    M2 = K2 * [R, t];  % Computing camera matrix for image 2

    % Triangulating points
    world_points = zeros(size(image_points1, 1), 3);  % Matrix storing world coordinates of triangulated points
    reprojection_errors = zeros(size(image_points1, 1), 1);  % Vector storing reprojection errors
    for i = 1:size(image_points1, 1)
        % Constructing linear system for triangulation
        A = [homogeneous_points1(i,1)*M1(3,:) - M1(1,:);
             homogeneous_points1(i,2)*M1(3,:) - M1(2,:);
             homogeneous_points2(i,1)*M2(3,:) - M2(1,:);
             homogeneous_points2(i,2)*M2(3,:) - M2(2,:)];

        % Solving linear system using least squares
        [~, ~, V] = svd(A);
        X = V(:,end)';
        X = X / X(4); % Homogenizing

        % Storing triangulated point
        world_points(i, :) = X(1:3);

        % Computing reprojection error
        proj_point1 = M1 * X';  % Projecting point in image 1
        proj_point2 = M2 * X';  % Projecting point in image 2
        reprojection_errors(i) = norm(homogeneous_points1(i, 1:2)' - proj_point1(1:2)) + norm(homogeneous_points2(i, 1:2)' - proj_point2(1:2));

        % Debugging: Printing intermediate results
        disp(['Triangulating point ', num2str(i), ': ', num2str(world_points(i, :))]);
        disp(['Computing reprojection error for point ', num2str(i), ': ', num2str(reprojection_errors(i))]);
    end
end