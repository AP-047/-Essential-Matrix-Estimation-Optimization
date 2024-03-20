function h = hline2(line_params, x_limits, y_limits, varargin)
    % Plot line based on its parameters and specified x-axis limits

    % Determine slope and y-intercept from line parameters
    slope = -line_params(1) / line_params(2);
    intercept = -line_params(3) / line_params(2);

    % Compute y-values at the x-axis boundaries to define the line segment
    y1 = slope * x_limits(1) + intercept;
    y2 = slope * x_limits(2) + intercept;

    % Draw the line on the plot using provided x and y coordinates
    h = plot(x_limits, [y1, y2], varargin{:});
end
