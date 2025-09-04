% -------------------------------------------------------------------------
% Author: JYOTISHMAN BHAGAWATI
% Email:  jbhagawati491@gmail.com
% GitHub: https://github.com/jbhagawati491
% Description: Interactive app to visualize the sum of squares of n IID
% Normal(mu, sigma^2) variables. Shows resulting distribution, key stats,
% and allows customization of parameters.
% -------------------------------------------------------------------------

function chi_square_enhanced_app()
    % Create main figure window
    f = figure('Name', 'Chi-Square Distribution Explorer', ...
               'NumberTitle', 'off', ...
               'Position', [100, 100, 900, 600]);

    % --- Header: Author Info ---
    uicontrol('Style', 'text', 'String', [
        'Author: JYOTISHMAN BHAGAWATI    ', ...
        'Email: jbhagawati491@gmail.com    ', ...
        'GitHub: github.com/jbhagawati491'], ...
        'FontSize', 10, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', ...
        'Position', [10 550 880 20]);

    % --- Axes for plots ---
    ax1 = axes('Parent', f, 'Position', [0.08, 0.45, 0.4, 0.4]);
    ax2 = axes('Parent', f, 'Position', [0.55, 0.45, 0.4, 0.4]);

    % Initial parameters
    n0 = 5;
    mu0 = 0;
    sigma20 = 1;

    % --- Sliders and Labels (Below plots) ---
    create_slider('Degrees of Freedom (n)', 1, 30, n0, [150, 120, 200, 20], @(n) update_all(), 'n');
    create_slider('\mu (mean)', -5, 5, mu0, [150, 80, 200, 20], @(mu) update_all(), 'mu');
    create_slider('\sigma^2 (variance)', 0.1, 10, sigma20, [150, 40, 200, 20], @(sigma2) update_all(), 'sigma2');

    % Plot handles
    normalPlot = plot(ax1, 0, 0, 'b', 'LineWidth', 2);
    chiPlot = plot(ax2, 0, 0, 'r', 'LineWidth', 2);
    title(ax1, 'Normal Distribution \mathcal{N}(\mu, \sigma^2)');
    title(ax2, 'Sum of Squares Distribution');
    xlabel(ax1, 'x'); ylabel(ax1, 'PDF'); grid(ax1, 'on');
    xlabel(ax2, 'x'); ylabel(ax2, 'PDF'); grid(ax2, 'on');

    update_all();

    % --- Update all plots ---
    function update_all()
        n = round(get(findobj('Tag','n'), 'Value'));
        mu = get(findobj('Tag','mu'), 'Value');
        sigma2 = get(findobj('Tag','sigma2'), 'Value');
        sigma = sqrt(sigma2);

        % --- Normal Distribution ---
        xN = linspace(mu - 4*sigma, mu + 4*sigma, 500);
        yN = normpdf(xN, mu, sigma);
        set(normalPlot, 'XData', xN, 'YData', yN);

        % --- Sum of squares -> Noncentral Chi-square distribution ---
        lambda = n * (mu^2 / sigma2);
        xC = linspace(0, max(50, 5*n*sigma2), 1000);
        yC = ncx2pdf(xC / sigma2, n, lambda) / sigma2;
        set(chiPlot, 'XData', xC, 'YData', yC);
    end

    % --- Slider creation helper ---
    function create_slider(label, minVal, maxVal, initVal, position, ~, tag)
    % Create text label for the parameter
    uicontrol('Style', 'text', 'String', label, ...
              'Position', position + [0 20 0 0], 'FontWeight', 'bold');

    % Create value label next to the slider
    valLabel = uicontrol('Style', 'text', ...
        'String', sprintf('%.2f', initVal), ...
        'Position', position + [220 0 60 20]);

    % Create the slider with proper callback to update all
    uicontrol('Style', 'slider', 'Min', minVal, 'Max', maxVal, ...
              'Value', initVal, 'Position', position, ...
              'SliderStep', [0.01 0.1], 'Tag', tag, ...
              'Callback', @(src,~) onSliderChange(src, valLabel));
end

function onSliderChange(sliderObj, valLabel)
    val = get(sliderObj, 'Value');
    set(valLabel, 'String', sprintf('%.2f', val));
    update_all();  % Call update_all each time a slider changes
end

end

% --- PDF function for the resulting distribution ---
function val = chi_pdf(x, n, mu, sigma2)
    lambda = n * (mu^2 / sigma2);
    val = ncx2pdf(x / sigma2, n, lambda) / sigma2;
end

% --- CDF function for the resulting distribution ---
function val = chi_cdf(x, n, mu, sigma2)
    lambda = n * (mu^2 / sigma2);
    val = ncx2cdf(x / sigma2, n, lambda);
end
