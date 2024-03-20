function error = compute_geometric_error(P1, P2, image_points1, image_points2, object_points)
    % Computes geometric error between observed and projected points using P1 and P2 matrices
    projected_points1 = project_points(P1, object_points);
    projected_points2 = project_points(P2, object_points);
    
    % Determine discrepancies between observed and projected points
    diffs1 = image_points1 - projected_points1;
    diffs2 = image_points2 - projected_points2;
    
    % Sum of squared differences defines the geometric error
    error = sum(sum(diffs1.^2)) + sum(sum(diffs2.^2));
end

function projected_points = project_points(P, object_points)
    % Converts 3D object points to homogeneous coordinates and projects them using matrix P
    object_points_homogeneous = [object_points, ones(size(object_points, 1), 1)];
    
    % Projection of points and normalization to 2D
    projected_points_homogeneous = (P * object_points_homogeneous')';
    
    % Normalization to convert homogeneous coordinates back to 2D
    projected_points = bsxfun(@rdivide, projected_points_homogeneous(:, 1:2), projected_points_homogeneous(:, 3));
end
