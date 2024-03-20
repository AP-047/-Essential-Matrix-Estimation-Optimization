function projected_points = project_points(P, object_points)
    % First, we convert the object points to homogeneous coordinates by adding a row of ones.
    object_points_homogeneous = [object_points, ones(size(object_points, 1), 1)];
    
    % Next, we multiply the object points in homogeneous coordinates with the projective matrix P
    % to obtain the image points in homogeneous coordinates.
    projected_points_homogeneous = (P * object_points_homogeneous')';
    
    % Finally, we convert the projected points back to 2D by dividing by the last homogeneous coordinate.
    projected_points = projected_points_homogeneous(:, 1:2) ./ projected_points_homogeneous(:, 3);
end
