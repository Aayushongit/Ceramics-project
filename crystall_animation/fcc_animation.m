clear; clc; close all;

fprintf('\n FCC CRYSTAL STRUCTURE\n');
fprintf(' Lattice Parameter: a = 1 unit\n');
fprintf(' Stacking: ABCABC, Atoms/cell: 4, CN: 12, Packing: 74%%\n');
fprintf(' Voids: Octahedral 4/cell, Tetrahedral 8/cell\n');
fprintf(' Examples: Cu, Al, Au, Ag, Ni, Pb\n\n');

fig = figure('Name', 'FCC Crystal - ABC Stacking', ...
             'Position', [50, 50, 1400, 850], ...
             'Color', [0.02 0.02 0.06], ...
             'NumberTitle', 'off');

ax_main = axes('Position', [0.02 0.08 0.65 0.88]);
ax_side = axes('Position', [0.70 0.52 0.28 0.44]);
ax_info = axes('Position', [0.70 0.04 0.28 0.44]);

set(fig, 'CurrentAxes', ax_side);
draw_stacking_diagram();
drawnow;

set(fig, 'CurrentAxes', ax_info);
draw_info_panel();
drawnow;

a = 1;
layers = generate_close_packed_layers(a, 'FCC', 4);
colors = {[0.2 0.5 1.0], [1.0 0.3 0.3], [0.3 0.9 0.4], [0.2 0.5 1.0]};
names = {'A', 'B', 'C', 'A'''};

set(fig, 'CurrentAxes', ax_main);
hold on;
setup_axes_style('FCC Crystal: ABC Stacking Sequence');

for L = 1:length(layers)
    if ~ishandle(fig), return; end
    title(sprintf('Placing Layer %s...', names{L}), 'Color', 'w', 'FontSize', 16);
    animate_layer_drop(layers{L}, colors{L}, 0.38, fig);
    draw_bonds(layers{L}, colors{L} * 0.7, 0.9);

    if L == 2
        title('Forming Tetrahedral Voids...', 'Color', [0.9 0.3 0.9], 'FontSize', 16);
        tet_voids = find_voids_between_layers(layers{1}, layers{2}, 'tetrahedral');
        animate_void_appearance(tet_voids, [0.9 0.2 0.9], 0.12, fig);
        pause(0.3);
    elseif L == 3
        title('Forming Octahedral Voids...', 'Color', [1.0 0.6 0.0], 'FontSize', 16);
        oct_voids = find_voids_between_layers(layers{2}, layers{3}, 'octahedral');
        animate_void_appearance(oct_voids, [1.0 0.6 0.0], 0.15, fig);
        draw_octahedron_wireframe(oct_voids(1,:), 0.35, [1 0.7 0.3]);
        pause(0.3);
    end
    pause(0.2);
end

draw_unit_cell_fcc(a * 2.5, [0.5 0.5 0.5]);
title('FCC Structure Complete', 'Color', 'w', 'FontSize', 16);

rotate_camera(fig, 1.5);

fprintf('  Press any key to close...\n');
pause;
close(fig);

function layers = generate_close_packed_layers(a, type, num_layers)
    layers = cell(1, num_layers);
    n = 2;
    if strcmp(type, 'FCC')
        z_spacing = a * sqrt(2/3);
        offsets = {[0, 0], [a/2, a/(2*sqrt(3))], [a, a/sqrt(3)], [0, 0]};
    else
        c = a * sqrt(8/3);
        z_spacing = c / 2;
        offsets = {[0, 0], [a/2, a/(2*sqrt(3))], [0, 0], [a/2, a/(2*sqrt(3))]};
    end
    for L = 1:num_layers
        layer = [];
        off = offsets{mod(L-1, length(offsets)) + 1};
        z = (L - 1) * z_spacing;
        for row = -n:n
            for col = -n:n
                x = col * a + mod(row, 2) * a/2 + off(1);
                y = row * a * sqrt(3)/2 + off(2);
                if sqrt(x^2 + y^2) < n * a * 0.95
                    layer = [layer; x, y, z];
                end
            end
        end
        layers{L} = layer;
    end
end

function voids = find_voids_between_layers(layer1, layer2, void_type)
    voids = [];
    z_mid = (mean(layer1(:,3)) + mean(layer2(:,3))) / 2;
    n_voids = min(6, size(layer2, 1));
    for i = 1:n_voids
        if strcmp(void_type, 'tetrahedral')
            offset = [0.15, 0.1, -0.05];
        else
            offset = [0.25, 0.15, 0];
        end
        pos = layer2(i,:) + offset;
        pos(3) = z_mid;
        voids = [voids; pos];
    end
end

function atoms = animate_layer_drop(layer, color, radius, fig)
    atoms = [];
    drop_height = 2.5;
    steps = 6;
    for i = 1:size(layer, 1)
        if ~ishandle(fig), return; end
        start_pos = layer(i,:) + [0, 0, drop_height];
        end_pos = layer(i,:);
        h = [];
        for s = 1:steps
            if ~ishandle(fig), return; end
            if ~isempty(h) && ishandle(h), delete(h); end
            t = s / steps;
            t = 1 - (1-t)^2;
            pos = start_pos + t * (end_pos - start_pos);
            h = draw_sphere(pos, radius, color, 0.95);
            drawnow;
            pause(0.008);
        end
        atoms = [atoms; h];
    end
end

function animate_void_appearance(voids, color, radius, fig)
    if isempty(voids), return; end
    max_show = min(6, size(voids, 1));
    for scale = 0.3:0.35:1.0
        if ~ishandle(fig), return; end
        for i = 1:max_show
            h(i) = draw_sphere(voids(i,:), radius * scale, color, 0.6 + 0.3*scale);
        end
        drawnow;
        pause(0.02);
        if scale < 1.0
            delete(h);
        end
    end
end

function rotate_camera(fig, duration)
    if ~ishandle(fig), return; end
    steps = 40;
    for i = 1:steps
        if ~ishandle(fig), return; end
        view(45 + i*9, 25 + 8*sin(i*pi/steps));
        drawnow;
        pause(duration/steps);
    end
end

function h = draw_sphere(center, radius, color, alpha)
    [X, Y, Z] = sphere(20);
    X = X * radius + center(1);
    Y = Y * radius + center(2);
    Z = Z * radius + center(3);
    h = surf(X, Y, Z, 'FaceColor', color, 'EdgeColor', 'none', ...
             'FaceAlpha', alpha, 'FaceLighting', 'gouraud', ...
             'AmbientStrength', 0.5, 'DiffuseStrength', 0.7, ...
             'SpecularStrength', 0.6);
end

function draw_bonds(layer, color, threshold)
    for i = 1:size(layer, 1)
        for j = i+1:size(layer, 1)
            d = norm(layer(i,:) - layer(j,:));
            if d < threshold
                plot3([layer(i,1) layer(j,1)], [layer(i,2) layer(j,2)], ...
                      [layer(i,3) layer(j,3)], '-', 'Color', [color 0.4], 'LineWidth', 1.5);
            end
        end
    end
end

function draw_cube_edges(a, color, width)
    v = [0 0 0; a 0 0; a a 0; 0 a 0; 0 0 a; a 0 a; a a a; 0 a a];
    edges = [1 2; 2 3; 3 4; 4 1; 5 6; 6 7; 7 8; 8 5; 1 5; 2 6; 3 7; 4 8];
    for i = 1:size(edges, 1)
        plot3([v(edges(i,1),1) v(edges(i,2),1)], ...
              [v(edges(i,1),2) v(edges(i,2),2)], ...
              [v(edges(i,1),3) v(edges(i,2),3)], ...
              '-', 'Color', color, 'LineWidth', width);
    end
end

function draw_octahedron_wireframe(center, sz, color)
    v = [1 0 0; -1 0 0; 0 1 0; 0 -1 0; 0 0 1; 0 0 -1] * sz + center;
    edges = [1 3; 1 4; 1 5; 1 6; 2 3; 2 4; 2 5; 2 6; 3 5; 3 6; 4 5; 4 6];
    for i = 1:size(edges, 1)
        plot3([v(edges(i,1),1) v(edges(i,2),1)], ...
              [v(edges(i,1),2) v(edges(i,2),2)], ...
              [v(edges(i,1),3) v(edges(i,2),3)], ...
              '-', 'Color', color, 'LineWidth', 2);
    end
end

function draw_unit_cell_fcc(a, color)
    draw_cube_edges(a, color, 1.5);
end

function draw_stacking_diagram()
    cla reset;
    hold on;
    set(gca, 'Color', [0.05 0.05 0.1]);
    colors = {[0.2 0.5 1], [1 0.3 0.3], [0.3 0.9 0.4], [0.2 0.5 1]};
    labels = {'A', 'B', 'C', 'A'''};
    offsets = [0, 0.3, 0.6, 0];
    for L = 1:4
        y_pos = (L - 1) * 0.22;
        for x = -1:1
            theta = linspace(0, 2*pi, 30);
            r = 0.06;
            cx = x * 0.15 + offsets(L) * 0.15;
            cy = y_pos;
            fill(cx + r*cos(theta), cy + r*sin(theta), colors{L}, ...
                 'EdgeColor', colors{L}*0.7, 'LineWidth', 1.5, 'FaceAlpha', 0.9);
        end
        text(0.42, y_pos, labels{L}, 'Color', colors{L}, 'FontSize', 12, ...
             'FontWeight', 'bold', 'HorizontalAlignment', 'left');
    end
    plot([-0.22 -0.22], [-0.1 0.8], '--', 'Color', [0.4 0.4 0.4], 'LineWidth', 1);
    plot([0.22 0.22], [-0.1 0.8], '--', 'Color', [0.4 0.4 0.4], 'LineWidth', 1);
    title('ABC Stacking', 'Color', 'w', 'FontSize', 11, 'FontWeight', 'bold');
    xlim([-0.35 0.6]);
    ylim([-0.12 0.85]);
    axis off;
end

function draw_info_panel()
    cla reset;
    hold on;
    set(gca, 'Color', [0.05 0.05 0.1]);
    xlim([0 1]);
    ylim([0 1]);
    axis off;
    text(0.5, 0.92, 'FCC Parameters', 'Color', [0.3 0.7 1], 'FontSize', 12, ...
         'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    props = {'a = 1 unit', 'Atoms: 4/cell', 'CN = 12', 'APF = 74%', '', ...
             'Voids:', 'Oct: 4/cell', 'Tet: 8/cell', '', 'r/R ratios:', ...
             'Oct: 0.414', 'Tet: 0.225'};
    y_start = 0.80;
    for i = 1:length(props)
        text(0.1, y_start - (i-1)*0.065, props{i}, 'Color', 'w', 'FontSize', 10);
    end
    rectangle('Position', [0.1 0.05 0.12 0.06], 'FaceColor', [0.2 0.5 1], 'EdgeColor', 'none', 'Curvature', 0.2);
    text(0.25, 0.08, 'Atoms', 'Color', 'w', 'FontSize', 9);
    rectangle('Position', [0.5 0.05 0.12 0.06], 'FaceColor', [1 0.6 0], 'EdgeColor', 'none', 'Curvature', 0.2);
    text(0.65, 0.08, 'Oct', 'Color', 'w', 'FontSize', 9);
    rectangle('Position', [0.78 0.05 0.12 0.06], 'FaceColor', [0.9 0.2 0.9], 'EdgeColor', 'none', 'Curvature', 0.2);
    text(0.92, 0.08, 'Tet', 'Color', 'w', 'FontSize', 9);
end

function setup_axes_style(title_str)
    ax = gca;
    ax.Color = [0.03 0.03 0.08];
    ax.XColor = [0.6 0.6 0.6];
    ax.YColor = [0.6 0.6 0.6];
    ax.ZColor = [0.6 0.6 0.6];
    ax.GridColor = [0.2 0.2 0.3];
    ax.GridAlpha = 0.5;
    title(title_str, 'Color', 'w', 'FontSize', 14, 'FontWeight', 'bold');
    axis equal;
    grid on;
    box on;
    view(45, 25);
    xlim([-2.5 2.5]);
    ylim([-2.5 2.5]);
    zlim([-0.5 4]);
    camlight('headlight');
    camlight('right');
    lighting gouraud;
    material shiny;
end
