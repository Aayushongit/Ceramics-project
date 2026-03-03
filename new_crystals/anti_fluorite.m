% Anti-Fluorite Crystal Structure Visualization
% Structure: FCC lattice of anions (O²⁻) with cations (Li⁺) in ALL tetrahedral voids
% Atoms/cell: 4 O + 8 Li = 12 total
% Coordination: O: 8 (cubic), Li: 4 (tetrahedral)
% Example: Li₂O

clear; clc; close all;

fprintf('\n ANTI-FLUORITE (Li₂O) Crystal Structure\n');
fprintf(' Structure: FCC O²⁻ with Li⁺ in all tetrahedral voids\n');
fprintf(' Atoms per unit cell: 4 O + 8 Li = 12\n');
fprintf(' Coordination: O=8 (cubic), Li=4 (tetrahedral)\n');
fprintf(' Reverse of fluorite: anion/cation positions swapped\n\n');

% Parameters
a = 1;                          % Lattice parameter
o_radius = 0.14;                % O atom radius
li_radius = 0.08;               % Li atom radius (smaller)
sphere_quality = 30;

% Colors
o_color = [0.9 0.3 0.3];        % Red for O anion
li_color = [0.2 0.4 0.8];       % Blue for Li cation
cell_edge_color = [0.3 0.3 0.3];

% O²⁻ positions (FCC lattice)
o_corners = [0 0 0; a 0 0; 0 a 0; 0 0 a; a a 0; a 0 a; 0 a a; a a a];
o_faces = [a/2 a/2 0; a/2 a/2 a; a/2 0 a/2; a/2 a a/2; 0 a/2 a/2; a a/2 a/2];
o_positions = [o_corners; o_faces];

% Li⁺ positions (ALL 8 tetrahedral voids)
li_positions = [a/4 a/4 a/4;
                3*a/4 3*a/4 a/4;
                3*a/4 a/4 3*a/4;
                a/4 3*a/4 3*a/4;
                3*a/4 a/4 a/4;
                a/4 3*a/4 a/4;
                a/4 a/4 3*a/4;
                3*a/4 3*a/4 3*a/4];

% Create figure with multi-panel layout
fig = figure('Name', 'Anti-Fluorite (Li₂O) Structure', ...
             'Position', [50, 50, 1400, 800], 'Color', [0.02 0.02 0.06]);

% Main 3D view (left panel - 60% width)
ax_main = axes('Position', [0.02 0.08 0.58 0.88]);
hold on;

% Draw O atoms (FCC positions)
for i = 1:size(o_positions, 1)
    draw_sphere(o_positions(i,:), o_radius, o_color, 0.85, sphere_quality);
end

% Draw Li atoms (in all tetrahedral voids)
for i = 1:size(li_positions, 1)
    draw_sphere(li_positions(i,:), li_radius, li_color, 0.9, sphere_quality);
end

% Draw unit cell edges
draw_cube_edges(a, cell_edge_color, 2);

% Draw bonds between Li and neighboring O
bond_color = [0.5 0.5 0.5];
for i = 1:size(li_positions, 1)
    li_pos = li_positions(i,:);
    for j = 1:size(o_positions, 1)
        d = norm(li_pos - o_positions(j,:));
        if d < a*sqrt(3)/4 + 0.05 && d > 0.01
            draw_bond(li_pos, o_positions(j,:), bond_color, 1);
        end
    end
end

% Draw cubic coordination around O (showing 8 Li neighbors)
draw_cubic_polyhedron([a/2 a/2 a/2], a/4, [0.4 0.8 0.4], 0.2);

setup_3d_view('Anti-Fluorite (Li₂O) - Unit Cell');
add_legend({'O²⁻ (anion)', 'Li⁺ (cation)'}, {o_color, li_color});

% Stacking diagram (top-right)
ax_stack = axes('Position', [0.64 0.55 0.34 0.40]);
draw_stacking_diagram(ax_stack);

% Info panel (middle-right)
ax_info = axes('Position', [0.64 0.32 0.34 0.20]);
draw_info_panel(ax_info);

% Coordination comparison (bottom-right)
ax_coord = axes('Position', [0.64 0.05 0.16 0.24]);
draw_coordination_comparison(ax_coord);

% Fluorite vs Anti-Fluorite comparison (bottom-right-right)
ax_comp = axes('Position', [0.82 0.05 0.16 0.24]);
draw_structure_comparison(ax_comp);

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

    % Draw structure layers showing O FCC with Li in tetrahedral sites
    layer_y = [6 5 4 3 2 1];
    layer_labels = {'O (A)', 'Li tet', 'O (B)', 'Li tet', 'O (C)', 'Li tet'};
    layer_colors = {[0.9 0.3 0.3], [0.2 0.4 0.8], [0.9 0.3 0.3], ...
                    [0.2 0.4 0.8], [0.9 0.3 0.3], [0.2 0.4 0.8]};

    for i = 1:6
        y = layer_y(i);
        fill([0 4 4 0], [y y y+0.7 y+0.7], layer_colors{i}, ...
             'EdgeColor', 'w', 'FaceAlpha', 0.7);
        text(2, y+0.35, layer_labels{i}, 'FontSize', 11, 'FontWeight', 'bold', ...
             'Color', 'w', 'HorizontalAlignment', 'center');
    end

    text(2, 0.3, 'Reverse of Fluorite structure', 'FontSize', 9, 'Color', [0.8 0.8 0.3], ...
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
        'Lattice: FCC of O²⁻ (anion)'
        'Void Occupation: All tetrahedral (8/8)'
        'Atoms/cell: 4 O + 8 Li = 12'
        'Coordination: O=8 (cubic), Li=4 (tet.)'
        'Formula: A₂X (Li₂O, Na₂O, K₂O)'
        'Examples: Li₂O, Na₂O, K₂O, Na₂S'
    };

    for i = 1:length(info_text)
        text(0.05, 1 - i*0.13, info_text{i}, 'FontSize', 10, 'Color', 'w', ...
             'Units', 'normalized');
    end

    title('Structure Information', 'FontSize', 11, 'FontWeight', 'bold', 'Color', 'w');
    set(gca, 'Color', [0.1 0.1 0.15]);
end

function draw_coordination_comparison(ax)
    axes(ax); hold on;

    % Draw tetrahedral coordination for Li
    [X, Y, Z] = sphere(20);

    % Central Li
    surf(X*0.12, Y*0.12, Z*0.12, 'FaceColor', [0.2 0.4 0.8], 'EdgeColor', 'none', ...
         'FaceAlpha', 0.9, 'FaceLighting', 'gouraud');

    % 4 coordinating O (tetrahedral)
    tet_pos = [1 1 1; 1 -1 -1; -1 1 -1; -1 -1 1] * 0.35;
    for i = 1:4
        surf(X*0.10 + tet_pos(i,1), Y*0.10 + tet_pos(i,2), Z*0.10 + tet_pos(i,3), ...
             'FaceColor', [0.9 0.3 0.3], 'EdgeColor', 'none', ...
             'FaceAlpha', 0.8, 'FaceLighting', 'gouraud');
        plot3([0 tet_pos(i,1)], [0 tet_pos(i,2)], [0 tet_pos(i,3)], ...
              'Color', [0.6 0.6 0.6], 'LineWidth', 1.5);
    end

    % Draw tetrahedron wireframe
    edges = [1 2; 1 3; 1 4; 2 3; 2 4; 3 4];
    for i = 1:size(edges, 1)
        p1 = tet_pos(edges(i,1), :);
        p2 = tet_pos(edges(i,2), :);
        plot3([p1(1) p2(1)], [p1(2) p2(2)], [p1(3) p2(3)], 'w--', 'LineWidth', 0.5);
    end

    axis equal; axis off;
    view(135, 25);
    camlight('headlight');
    lighting gouraud;
    title('Li: CN=4 (tet)', 'FontSize', 10, 'FontWeight', 'bold', 'Color', 'w');
    set(gca, 'Color', [0.1 0.1 0.15]);
end

function draw_structure_comparison(ax)
    axes(ax); hold on;

    % Comparison table between Fluorite and Anti-Fluorite
    y_pos = [0.85 0.65 0.45 0.25];

    % Headers
    text(0.5, 0.95, 'Structure Comparison', 'FontSize', 10, 'FontWeight', 'bold', ...
         'Color', 'w', 'HorizontalAlignment', 'center', 'Units', 'normalized');

    % Fluorite column
    text(0.25, y_pos(1), 'Fluorite', 'FontSize', 9, 'FontWeight', 'bold', ...
         'Color', [0.3 0.8 0.3], 'HorizontalAlignment', 'center', 'Units', 'normalized');
    text(0.25, y_pos(2), 'FCC: Cation', 'FontSize', 8, 'Color', 'w', ...
         'HorizontalAlignment', 'center', 'Units', 'normalized');
    text(0.25, y_pos(3), 'Tet: Anion', 'FontSize', 8, 'Color', 'w', ...
         'HorizontalAlignment', 'center', 'Units', 'normalized');
    text(0.25, y_pos(4), 'CaF₂', 'FontSize', 8, 'Color', 'w', ...
         'HorizontalAlignment', 'center', 'Units', 'normalized');

    % Anti-Fluorite column
    text(0.75, y_pos(1), 'Anti-Fl.', 'FontSize', 9, 'FontWeight', 'bold', ...
         'Color', [0.8 0.3 0.3], 'HorizontalAlignment', 'center', 'Units', 'normalized');
    text(0.75, y_pos(2), 'FCC: Anion', 'FontSize', 8, 'Color', 'w', ...
         'HorizontalAlignment', 'center', 'Units', 'normalized');
    text(0.75, y_pos(3), 'Tet: Cation', 'FontSize', 8, 'Color', 'w', ...
         'HorizontalAlignment', 'center', 'Units', 'normalized');
    text(0.75, y_pos(4), 'Li₂O', 'FontSize', 8, 'Color', 'w', ...
         'HorizontalAlignment', 'center', 'Units', 'normalized');

    % Divider line
    plot([0.5 0.5], [0.1 0.9], 'w-', 'LineWidth', 1);

    axis off;
    xlim([0 1]);
    ylim([0 1]);
    set(gca, 'Color', [0.1 0.1 0.15]);
end
