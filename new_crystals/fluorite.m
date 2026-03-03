% Fluorite (CaF₂) Crystal Structure Visualization
% Structure: FCC lattice of Ca²⁺ with F⁻ in ALL tetrahedral voids
% Atoms/cell: 4 Ca + 8 F = 12 total
% Coordination: Ca: 8 (cubic), F: 4 (tetrahedral)

clear; clc; close all;

fprintf('\n FLUORITE (CaF₂) Crystal Structure\n');
fprintf(' Structure: FCC Ca²⁺ with F⁻ in all tetrahedral voids\n');
fprintf(' Atoms per unit cell: 4 Ca + 8 F = 12\n');
fprintf(' Coordination: Ca=8 (cubic), F=4 (tetrahedral)\n');
fprintf(' Special: All 8 tetrahedral voids are occupied\n\n');

% Parameters
a = 1;                          % Lattice parameter
ca_radius = 0.14;               % Ca atom radius
f_radius = 0.09;                % F atom radius (smaller)
sphere_quality = 30;

% Colors
ca_color = [0.2 0.4 0.8];       % Blue for Ca cation
f_color = [0.9 0.3 0.3];        % Red for F anion
tet_void_color = [0.2 0.8 0.3]; % Green for reference
cell_edge_color = [0.3 0.3 0.3];

% Ca²⁺ positions (FCC lattice)
ca_corners = [0 0 0; a 0 0; 0 a 0; 0 0 a; a a 0; a 0 a; 0 a a; a a a];
ca_faces = [a/2 a/2 0; a/2 a/2 a; a/2 0 a/2; a/2 a a/2; 0 a/2 a/2; a a/2 a/2];
ca_positions = [ca_corners; ca_faces];

% F⁻ positions (ALL 8 tetrahedral voids)
f_positions = [a/4 a/4 a/4;
               3*a/4 3*a/4 a/4;
               3*a/4 a/4 3*a/4;
               a/4 3*a/4 3*a/4;
               3*a/4 a/4 a/4;
               a/4 3*a/4 a/4;
               a/4 a/4 3*a/4;
               3*a/4 3*a/4 3*a/4];

% Create figure with multi-panel layout
fig = figure('Name', 'Fluorite (CaF₂) Structure', ...
             'Position', [50, 50, 1400, 800], 'Color', [0.02 0.02 0.06]);

% Main 3D view (left panel - 60% width)
ax_main = axes('Position', [0.02 0.08 0.58 0.88]);
hold on;

% Draw Ca atoms
for i = 1:size(ca_positions, 1)
    draw_sphere(ca_positions(i,:), ca_radius, ca_color, 0.85, sphere_quality);
end

% Draw F atoms (in all tetrahedral voids)
for i = 1:size(f_positions, 1)
    draw_sphere(f_positions(i,:), f_radius, f_color, 0.9, sphere_quality);
end

% Draw unit cell edges
draw_cube_edges(a, cell_edge_color, 2);

% Draw bonds between F and neighboring Ca
bond_color = [0.5 0.5 0.5];
for i = 1:size(f_positions, 1)
    f_pos = f_positions(i,:);
    for j = 1:size(ca_positions, 1)
        d = norm(f_pos - ca_positions(j,:));
        if d < a*sqrt(3)/4 + 0.05 && d > 0.01
            draw_bond(f_pos, ca_positions(j,:), bond_color, 1);
        end
    end
end

% Draw cubic coordination around Ca at body center position (illustrative)
% Show the 8 F atoms surrounding a Ca (simple cube)
draw_cubic_polyhedron([a/2 a/2 a/2], a/4, [0.4 0.8 0.4], 0.3);

setup_3d_view('Fluorite (CaF₂) - Unit Cell');
add_legend({'Ca²⁺ (cation)', 'F⁻ (anion)'}, {ca_color, f_color});

% Stacking diagram (top-right)
ax_stack = axes('Position', [0.64 0.55 0.34 0.40]);
draw_stacking_diagram(ax_stack);

% Info panel (middle-right)
ax_info = axes('Position', [0.64 0.32 0.34 0.20]);
draw_info_panel(ax_info);

% Coordination polyhedron (bottom-right)
ax_coord = axes('Position', [0.64 0.05 0.16 0.24]);
draw_cubic_coordination(ax_coord, ca_color, f_color);

% Void occupation diagram (bottom-right-right)
ax_void = axes('Position', [0.82 0.05 0.16 0.24]);
draw_void_occupation(ax_void);

fprintf(' Use mouse to rotate main view. Close window to exit.\n');

% === Helper Functions ===

function draw_sphere(center, radius, color, alpha, n)
    [X, Y, Z] = sphere(n);
    X = X * radius + center(1);
    Y = Y * radius + center(2);
    Z = Z * radius + center(3);
    surf(X, Y, Z, 'FaceColor', color, 'EdgeColor', 'none', ...
         'FaceAlpha', alpha, 'FaceLighting', 'gouraud', ...
         'AmbientStrength', 0.5, 'DiffuseStrength', 0.8, ...
         'SpecularStrength', 0.9, 'SpecularExponent', 25);
end

function draw_cube_edges(a, color, width)
    vertices = [0 0 0; a 0 0; a a 0; 0 a 0; 0 0 a; a 0 a; a a a; 0 a a];
    edges = [1 2; 2 3; 3 4; 4 1; 5 6; 6 7; 7 8; 8 5; 1 5; 2 6; 3 7; 4 8];
    for i = 1:size(edges, 1)
        p1 = vertices(edges(i,1), :);
        p2 = vertices(edges(i,2), :);
        plot3([p1(1) p2(1)], [p1(2) p2(2)], [p1(3) p2(3)], 'Color', color, 'LineWidth', width);
    end
end

function draw_cubic_polyhedron(center, half_side, color, alpha)
    % Draw a small cube wireframe centered at 'center'
    hs = half_side;
    c = center;
    verts = [c(1)-hs c(2)-hs c(3)-hs;
             c(1)+hs c(2)-hs c(3)-hs;
             c(1)+hs c(2)+hs c(3)-hs;
             c(1)-hs c(2)+hs c(3)-hs;
             c(1)-hs c(2)-hs c(3)+hs;
             c(1)+hs c(2)-hs c(3)+hs;
             c(1)+hs c(2)+hs c(3)+hs;
             c(1)-hs c(2)+hs c(3)+hs];

    faces = [1 2 3 4; 5 6 7 8; 1 2 6 5; 2 3 7 6; 3 4 8 7; 4 1 5 8];
    patch('Vertices', verts, 'Faces', faces, 'FaceColor', color, ...
          'FaceAlpha', alpha, 'EdgeColor', color, 'LineWidth', 1);
end

function draw_bond(p1, p2, color, width)
    plot3([p1(1) p2(1)], [p1(2) p2(2)], [p1(3) p2(3)], 'Color', color, 'LineWidth', width);
end

function setup_3d_view(title_str)
    title(title_str, 'FontSize', 14, 'FontWeight', 'bold', 'Color', 'w');
    xlabel('X', 'FontSize', 12, 'Color', 'w');
    ylabel('Y', 'FontSize', 12, 'Color', 'w');
    zlabel('Z', 'FontSize', 12, 'Color', 'w');
    axis equal; grid on; box on;
    view(135, 25);
    camlight('headlight');
    camlight('right');
    lighting gouraud;
    material shiny;
    rotate3d on;
    set(gca, 'Color', [0.1 0.1 0.15], 'XColor', 'w', 'YColor', 'w', 'ZColor', 'w', ...
             'GridColor', [0.4 0.4 0.4]);
end

function add_legend(labels, colors)
    h = zeros(length(labels), 1);
    for i = 1:length(labels)
        h(i) = plot3(NaN, NaN, NaN, 'o', 'MarkerSize', 12, ...
                     'MarkerFaceColor', colors{i}, 'MarkerEdgeColor', 'w');
    end
    leg = legend(h, labels, 'Location', 'northeast', 'FontSize', 10);
    set(leg, 'TextColor', 'w', 'Color', [0.15 0.15 0.2]);
end

function draw_stacking_diagram(ax)
    axes(ax); hold on;

    % Draw structure layers showing Ca FCC with F in tetrahedral sites
    layer_y = [6 5 4 3 2 1];
    layer_labels = {'Ca (A)', 'F tet', 'Ca (B)', 'F tet', 'Ca (C)', 'F tet'};
    layer_colors = {[0.2 0.4 0.8], [0.9 0.3 0.3], [0.2 0.4 0.8], ...
                    [0.9 0.3 0.3], [0.2 0.4 0.8], [0.9 0.3 0.3]};

    for i = 1:6
        y = layer_y(i);
        % Draw layer rectangle
        fill([0 4 4 0], [y y y+0.7 y+0.7], layer_colors{i}, ...
             'EdgeColor', 'w', 'FaceAlpha', 0.7);
        % Layer label
        text(2, y+0.35, layer_labels{i}, 'FontSize', 11, 'FontWeight', 'bold', ...
             'Color', 'w', 'HorizontalAlignment', 'center');
    end

    % Add note
    text(2, 0.3, 'All 8 tetrahedral voids filled', 'FontSize', 9, 'Color', [0.8 0.8 0.3], ...
         'HorizontalAlignment', 'center', 'FontStyle', 'italic');

    axis off;
    xlim([-1 5]);
    ylim([0 7.5]);
    title('Structure Layers', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'w');
    set(gca, 'Color', [0.1 0.1 0.15]);
end

function draw_info_panel(ax)
    axes(ax); hold on;
    axis off;

    info_text = {
        'Crystal System: Cubic (Fm3m)'
        'Lattice: FCC of Ca²⁺'
        'Void Occupation: All tetrahedral (8/8)'
        'Atoms/cell: 4 Ca + 8 F = 12'
        'Coordination: Ca=8 (cubic), F=4 (tet.)'
        'r(Ca²⁺)/r(F⁻) = 0.73'
        'Examples: CaF₂, BaF₂, SrF₂, UO₂'
    };

    for i = 1:length(info_text)
        text(0.05, 1 - i*0.13, info_text{i}, 'FontSize', 10, 'Color', 'w', ...
             'Units', 'normalized');
    end

    title('Structure Information', 'FontSize', 11, 'FontWeight', 'bold', 'Color', 'w');
    set(gca, 'Color', [0.1 0.1 0.15]);
end

function draw_cubic_coordination(ax, cation_color, anion_color)
    axes(ax); hold on;

    % Draw central cation (Ca)
    [X, Y, Z] = sphere(20);
    surf(X*0.18, Y*0.18, Z*0.18, 'FaceColor', cation_color, 'EdgeColor', 'none', ...
         'FaceAlpha', 0.9, 'FaceLighting', 'gouraud');

    % Draw 8 coordinating anions (cubic coordination)
    cubic_pos = [1 1 1; 1 1 -1; 1 -1 1; 1 -1 -1;
                 -1 1 1; -1 1 -1; -1 -1 1; -1 -1 -1] * 0.35;
    for i = 1:8
        surf(X*0.10 + cubic_pos(i,1), Y*0.10 + cubic_pos(i,2), Z*0.10 + cubic_pos(i,3), ...
             'FaceColor', anion_color, 'EdgeColor', 'none', ...
             'FaceAlpha', 0.8, 'FaceLighting', 'gouraud');
        % Draw bond
        plot3([0 cubic_pos(i,1)], [0 cubic_pos(i,2)], [0 cubic_pos(i,3)], ...
              'Color', [0.6 0.6 0.6], 'LineWidth', 1);
    end

    % Draw cube wireframe
    edges = [1 2; 1 3; 1 5; 2 4; 2 6; 3 4; 3 7; 4 8; 5 6; 5 7; 6 8; 7 8];
    for i = 1:size(edges, 1)
        p1 = cubic_pos(edges(i,1), :);
        p2 = cubic_pos(edges(i,2), :);
        plot3([p1(1) p2(1)], [p1(2) p2(2)], [p1(3) p2(3)], 'w--', 'LineWidth', 0.5);
    end

    axis equal; axis off;
    view(135, 25);
    camlight('headlight');
    lighting gouraud;
    title('Cubic CN=8', 'FontSize', 10, 'FontWeight', 'bold', 'Color', 'w');
    set(gca, 'Color', [0.1 0.1 0.15]);
end

function draw_void_occupation(ax)
    axes(ax); hold on;

    % Void occupation data for fluorite
    void_types = {'Oct.', 'Tet.'};
    total_voids = [4, 8];
    filled_voids = [0, 8];

    bar_width = 0.35;
    x = 1:2;

    % Total voids (background)
    bar(x, total_voids, bar_width*2, 'FaceColor', [0.3 0.3 0.3], 'EdgeColor', 'w');
    % Filled voids (overlay)
    bar(x, filled_voids, bar_width*2, 'FaceColor', [0.9 0.3 0.3], 'EdgeColor', 'w');

    xlim([0.3 2.7]);
    ylim([0 10]);
    set(gca, 'XTick', 1:2, 'XTickLabel', void_types, 'FontSize', 9);
    set(gca, 'Color', [0.1 0.1 0.15], 'XColor', 'w', 'YColor', 'w');
    ylabel('Voids/cell', 'Color', 'w', 'FontSize', 9);
    title('Void Occupation', 'FontSize', 10, 'FontWeight', 'bold', 'Color', 'w');

    % Add labels
    text(1, 4.5, '0/4', 'Color', 'w', 'FontSize', 9, 'HorizontalAlignment', 'center');
    text(2, 8.5, '8/8', 'Color', 'w', 'FontSize', 9, 'HorizontalAlignment', 'center');

    grid on;
    set(gca, 'GridColor', [0.4 0.4 0.4]);
end
