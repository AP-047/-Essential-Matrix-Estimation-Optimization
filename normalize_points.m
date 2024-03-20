function [normalized_image_points, normalized_object_points, T_image, T_object] = normalize_points(image_points, object_points)
    % First, we calculate the centroids of the image points and object points.
    centroid_image = mean(image_points);
    centroid_object = mean(object_points);

    % Next, we define translation matrices to move the centroids of both sets of points to the origin.
    T_image = eye(3);
    T_image(1:2, 3) = -centroid_image(1:2);

    T_object = eye(4); % Adjusted for homogeneous coordinates
    T_object(1:3, 4) = -centroid_object;

    % Now, we apply the translation to both sets of points.
    translated_image_points = (T_image * [image_points, ones(size(image_points, 1), 1)]')';
    translated_object_points = (T_object * [object_points, ones(size(object_points, 1), 1)]')';

    % After translation, we calculate the average distances from the origin for both sets of points.
    avg_dist_image = mean(sqrt(sum(translated_image_points(:,1:2).^2, 2)));
    avg_dist_object = mean(sqrt(sum(translated_object_points(:,1:3).^2, 2)));

    % We determine scaling factors to normalize the distances to a certain value.
    scale_image = sqrt(2) / avg_dist_image;
    scale_object = sqrt(3) / avg_dist_object;

    % Next, we construct scaling matrices using the scaling factors.
    S_image = diag([scale_image, scale_image, 1]);
    S_object = diag([scale_object, scale_object, scale_object, 1]); % Adjusted for homogeneous coordinates

    % Finally, we apply scaling to both sets of points to normalize them.
    normalized_image_points = (S_image * translated_image_points')';
    normalized_object_points = (S_object * translated_object_points')';
end
