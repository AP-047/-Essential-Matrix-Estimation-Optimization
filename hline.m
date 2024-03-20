function hline(l, xlim, ylim, orientation)
    % Draws epipolar lines on a plot based on line coefficients and orientation

    % Compute the slope (m) and y-intercept (b) of the line
    m = -l(1) / l(2);
    b = -l(3) / l(2);

    % Generate x-values within specified limits for plotting
    x_range = xlim(1):0.1:xlim(2);

    % Calculate y-values for the line over the x-range
    y_values = m * x_range + b;

    % Plot the line based on its orientation relative to the axes
    if orientation == "horizontal"
        % For lines more horizontal, span across x limits directly
        line([xlim(1), xlim(2)], [y_values(1), y_values(end)], "color", "r");
    else
        % For lines more vertical, plot using calculated y-values
        line(x_range, y_values, "color", "r");
    end
end
