clear; clc; close all;

fprintf('\n FCC vs HCP CRYSTAL COMPARISON\n');
fprintf(' Both: CN = 12, Packing = 74%%\n');
fprintf(' FCC: ABCABC stacking, 4 atoms/cell, Oct 4/cell, Tet 8/cell\n');
fprintf(' HCP: ABAB stacking, 2 atoms/cell, Oct 2/cell, Tet 4/cell, c/a = 1.633\n\n');

fig = figure('Name', 'FCC vs HCP Comparison', ...
             'Position', [30, 50, 1500, 800], ...
             'Color', [0.02 0.02 0.06], ...
             'NumberTitle', 'off');

a = 1;

ax1 = subplot(1, 2, 1);
hold on;
setup_axes_style('FCC (ABC Stacking)');

fcc_layers = generate_close_packed_layers(a, 'FCC', 3);
fcc_colors = {[0.2 0.5 1.0], [1.0 0.3 0.3], [0.3 0.9 0.4]};

for L = 1:3
    draw_layer_instant(fcc_layers{L}, fcc_colors{L}, 0.35);
    draw_bonds(fcc_layers{L}, fcc_colors{L} * 0.6, 0.5);
end

tet_fcc = find_voids_between_layers(fcc_layers{1}, fcc_layers{2}, 'tetrahedral');
oct_fcc = find_voids_between_layers(fcc_layers{2}, fcc_layers{3}, 'octahedral');
draw_voids_instant(tet_fcc, [0.9 0.2 0.9], 0.10);
draw_voids_instant(oct_fcc, [1.0 0.6 0.0], 0.13);

draw_cube_edges(a * 2, [0.4 0.4 0.4], 1.5);

text(-1.5, 0, -0.3, 'A', 'Color', fcc_colors{1}, 'FontSize', 16, 'FontWeight', 'bold');
text(-1.5, 0, 0.8, 'B', 'Color', fcc_colors{2}, 'FontSize', 16, 'FontWeight', 'bold');
text(-1.5, 0, 1.9, 'C', 'Color', fcc_colors{3}, 'FontSize', 16, 'FontWeight', 'bold');

ax2 = subplot(1, 2, 2);
hold on;
setup_axes_style('HCP (ABAB Stacking)');

hcp_layers = generate_close_packed_layers(a, 'HCP', 4);
hcp_colors = {[0.2 0.5 1.0], [1.0 0.3 0.3], [0.2 0.5 1.0], [1.0 0.3 0.3]};

for L = 1:4
    draw_layer_instant(hcp_layers{L}, hcp_colors{L}, 0.35);
    draw_bonds(hcp_layers{L}, hcp_colors{L} * 0.6, 0.5);
end

tet_hcp = find_voids_between_layers(hcp_layers{1}, hcp_layers{2}, 'tetrahedral');
oct_hcp = find_voids_between_layers(hcp_layers{2}, hcp_layers{3}, 'octahedral');
draw_voids_instant(tet_hcp, [0.9 0.2 0.9], 0.10);
draw_voids_instant(oct_hcp, [1.0 0.6 0.0], 0.13);

c = a * sqrt(8/3);
draw_hex_prism(a, c, [0.4 0.4 0.4]);

text(-1.5, 0, -0.3, 'A', 'Color', hcp_colors{1}, 'FontSize', 16, 'FontWeight', 'bold');
text(-1.5, 0, c/2 - 0.3, 'B', 'Color', hcp_colors{2}, 'FontSize', 16, 'FontWeight', 'bold');
text(-1.5, 0, c - 0.3, 'A', 'Color', hcp_colors{3}, 'FontSize', 16, 'FontWeight', 'bold');
text(-1.5, 0, 3*c/2 - 0.3, 'B', 'Color', hcp_colors{4}, 'FontSize', 16, 'FontWeight', 'bold');

annotation('textbox', [0.35 0.01 0.3 0.06], ...
           'String', 'Both: 74% packing, CN=12 | Difference: Stacking sequence', ...
           'Color', 'w', 'BackgroundColor', [0.1 0.1 0.2], ...
           'EdgeColor', [0.3 0.3 0.5], 'FontSize', 11, ...
           'HorizontalAlignment', 'center', 'FitBoxToText', 'on');

view(ax1, 45, 25);
view(ax2, 45, 25);

rotate3d on;

fprintf('  Use mouse to rotate. Press any key to close...\n');
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

function draw_layer_instant(layer, color, radius)
    for i = 1:size(layer, 1)
        draw_sphere(layer(i,:), radius, color, 0.85);
    end
end

function draw_voids_instant(voids, color, radius)
    for i = 1:min(6, size(voids, 1))
        draw_sphere(voids(i,:), radius, color, 0.8);
    end
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

function draw_hex_prism(a, c, color)
    theta = (0:60:300) * pi/180;
    x = a * 0.8 * cos(theta);
    y = a * 0.8 * sin(theta);
    for i = 1:6
        j = mod(i, 6) + 1;
        plot3([x(i) x(j)], [y(i) y(j)], [0 0], '-', 'Color', color, 'LineWidth', 1.5);
        plot3([x(i) x(j)], [y(i) y(j)], [c*2 c*2], '-', 'Color', color, 'LineWidth', 1.5);
        plot3([x(i) x(i)], [y(i) y(i)], [0 c*2], '-', 'Color', color, 'LineWidth', 1.5);
    end
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
