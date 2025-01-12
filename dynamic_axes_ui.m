function dynamic_axes_ui
    % Main figure setup
    fig = figure('Name', 'Dynamic Axes UI', 'Position', [100 100 600 600]);
    
    % Panel for scrollable axes
    panel = uipanel('Parent', fig, 'Position', [0 0.1 1 0.9], 'BorderType', 'none');
    
    % Scrollable container
    scroll = uicontrol('Style', 'slider', 'Parent', fig, 'Position', [580 0 20 600], 'Value', 1, 'Callback', @scroll_callback);
    
    % Button for adding and deleting axes
    uicontrol('Style', 'pushbutton', 'String', 'Add Graph', 'Position', [10 10 100 30], 'Callback', @add_axes);
    uicontrol('Style', 'pushbutton', 'String', 'Remove Graph', 'Position', [120 10 100 30], 'Callback', @remove_axes);
    
    % Storage for axes
    axes_list = {};
    axes_height = 200;
    spacing = 20;
    
    % Add new axes
    function add_axes(~, ~)
        ax = axes('Parent', panel, 'Units', 'normalized', 'Position', [0.1, 1 - length(axes_list) * 0.3, 0.8, 0.25]);
        plot(ax, rand(1, 10)); % Example plot
        axes_list{end+1} = ax;
        adjust_scrollbar();
    end
    
    % Remove the last axes
    function remove_axes(~, ~)
        if ~isempty(axes_list)
            delete(axes_list{end});
            axes_list(end) = [];
            adjust_scrollbar();
        end
    end
    
    % Adjust scrollbar and panel height
    function adjust_scrollbar()
        total_height = length(axes_list) * (axes_height + spacing);
        panel_height = max(600, total_height);
        set(panel, 'Position', [0, 600 - panel_height, 600, panel_height]);
        max_scroll = max(1, panel_height - 600 + 1);
        set(scroll, 'Max', max_scroll, 'SliderStep', [min(1/(max_scroll), 1) 1]);
    end
    
    % Scroll callback
    function scroll_callback(src, ~)
        offset = get(src, 'Value');
        panel_pos = get(panel, 'Position');
        set(panel, 'Position', [panel_pos(1), 600 - panel_pos(4) - offset, panel_pos(3), panel_pos(4)]);
    end
end
