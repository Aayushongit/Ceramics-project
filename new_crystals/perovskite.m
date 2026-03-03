% Perovskite (ABO₃) Crystal Structure Visualization
% Structure: A at corners, B at body center, O at face centers
% Atoms/cell: 1 A + 1 B + 3 O = 5 total
% Coordination: A: 12, B: 6 (octahedral), O: 2+4
% Example: CaTiO₃, BaTiO₃, SrTiO₃

clear; clc; close all;

fprintf('\n PEROVSKITE (ABO₃) Crystal Structure\n');
fprintf(' Structure: A at corners, B at body center, O at face centers\n');
fprintf(' Atoms per unit cell: 1 A + 1 B + 3 O = 5\n');
fprintf(' Coordination: A=12, B=6 (octahedral), O=2+4\n');
fprintf(' Examples: CaTiO₃, BaTiO₃, SrTiO₃\n\n');

% Parameters
a = 1;                          % Lattice parameter
a_radius = 0.16;                % A-site atom radius (large cation, e.g., Ca, Ba)
b_radius = 0.10;                % B-site atom radius (smaller cation, e.g., Ti)
o_radius = 0.12;                % O atom radius
sphere_quality = 30;

% Colors
a_color = [0.2 0.4 0.8];        % Blue for A-site cation
b_color = [0.6 0.2 0.8];        % Purple for B-site cation
o_color = [0.9 0.3 0.3];        % Red for O anion
cell_edge_color = [0.3 0.3 0.3];
oct_color = [1.0 0.5 0.0];      % Orange for octahedron

% A-site positions (corners)
a_positions = [0 0 0; a 0 0; 0 a 0; 0 0 a; a a 0; a 0 a; 0 a a; a a a];

% B-site position (body center)
b_positions = [a/2 a/2 a/2];

% O positions (face centers)
o_positions = [a/2 a/2 0; a/2 a/2 a;    % z-faces
               a/2 0 a/2; a/2 a a/2;    % y-faces
               0 a/2 a/2; a a/2 a/2];   % x-faces

% Create figure with multi-panel layout
fig = figure('Name', 'Perovskite (ABO₃) Structure', ...
             'Position', [50, 50, 1400, 800], 'Color', [0.02 0.02 0.06]);

% Main 3D view (left panel - 60% width)
ax_main = axes('Position', [0.02 0.08 0.58 0.88]);
hold on;

% Draw A-site atoms (corners)
for i = 1:size(a_positions, 1)
    draw_sphere(a_positions(i,:), a_radius, a_color, 0.7, sphere_quality);
end

% Draw B-site atom (body center)
draw_sphere(b_positions, b_radius, b_color, 0.95, sphere_quality);

% Draw O atoms (face centers)
for i = 1:size(o_positions, 1)
    draw_sphere(o_positions(i,:), o_radius, o_color, 0.85, sphere_quality);
end

% Draw BO₆ octahedron (B surrounded by 6 O atoms)
draw_octahedron(b_positions, a/2, oct_color, 0.15);

% Draw bonds between B and O (octahedral coordination)
bond_color = [0.5 0.5 0.5];
for i = 1:size(o_positions, 1)
    draw_bond(b_positions, o_positions(i,:), bond_color, 2);
end

% Draw unit cell edges
draw_cube_edges(a, cell_edge_color, 2);

setup_3d_view('Perovskite (ABO₃) - Unit Cell');
add_legend({'A-site (Ca/Ba)', 'B-site (Ti)', 'O²⁻', 'BO₆ octahedron'}, ...
           {a_color, b_color, o_color, oct_color});

% Stacking diagram (top-right)
ax_stack = axes('Position', [0.64 0.55 0.34 0.40]);
draw_structure_exploded(ax_stack);

% Info panel (middle-right)
ax_info = axes('Position', [0.64 0.32 0.34 0.20]);
draw_info_panel(ax_info);

% B-site coordination (bottom-right)
ax_coord = axes('Position', [0.64 0.05 0.16 0.24]);
draw_b_coordination(ax_coord, b_color, o_color);

% Tolerance factor diagram (bottom-right-right)
ax_tol = axes('Position', [0.82 0.05 0.16 0.24]);
draw_tolerance_factor(ax_tol);

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

function draw_octahedron(center, half_diag, color, alpha)
    c = center;
    hd = half_diag;
    % Vertices of octahedron
    verts = [c(1)+hd c(2) c(3);      % +x
             c(1)-hd c(2) c(3);      % -x
             c(1) c(2)+hd c(3);      % +y
             c(1) c(2)-hd c(3);      % -y
             c(1) c(2) c(3)+hd;      % +z
             c(1) c(2) c(3)-hd];     % -z

    % Faces of octahedron (triangular)
    faces = [1 3 5; 1 5 4; 1 4 6; 1 6 3;
             2 3 5; 2 5 4; 2 4 6; 2 6 3];

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

function draw_structure_exploded(ax)
    axes(ax); hold on;

    % Draw exploded view of perovskite components
    [X, Y, Z] = sphere(20);

    % A-site at corners (show one corner representative)
    surf(X*0.15 - 0.8, Y*0.15 + 0.5, Z*0.15 + 0.5, ...
         'FaceColor', [0.2 0.4 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.8);
    text(-0.8, 0.5, 1.0, 'A-site', 'Color', 'w', 'FontSize', 9, 'HorizontalAlignment', 'center');
    text(-0.8, 0.5, 0.0, '(corners)', 'Color', [0.7 0.7 0.7], 'FontSize', 8, 'HorizontalAlignment', 'center');

    % B-site at body center
    surf(X*0.12 + 0.0, Y*0.12 + 0.5, Z*0.12 + 0.5, ...
         'FaceColor', [0.6 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.8);
    text(0.0, 0.5, 1.0, 'B-site', 'Color', 'w', 'FontSize', 9, 'HorizontalAlignment', 'center');
    text(0.0, 0.5, 0.0, '(center)', 'Color', [0.7 0.7 0.7], 'FontSize', 8, 'HorizontalAlignment', 'center');

    % O at face centers (show 6)
    o_pos_demo = [0.8 0.5 0.5];
    for i = 1:6
        angle = (i-1) * pi/3;
        ox = 0.8 + 0.15*cos(angle);
        oy = 0.5 + 0.15*sin(angle);
        oz = 0.5;
        surf(X*0.08 + ox, Y*0.08 + oy, Z*0.08 + oz, ...
             'FaceColor', [0.9 0.3 0.3], 'EdgeColor', 'none', 'FaceAlpha', 0.8);
    end
    text(0.8, 0.5, 1.0, 'O atoms', 'Color', 'w', 'FontSize', 9, 'HorizontalAlignment', 'center');
    text(0.8, 0.5, 0.0, '(faces)', 'Color', [0.7 0.7 0.7], 'FontSize', 8, 'HorizontalAlignment', 'center');

    % Arrows showing assembly
    quiver3(-0.5, 0.5, 0.5, 0.2, 0, 0, 'Color', 'w', 'LineWidth', 2, 'MaxHeadSize', 0.5);
    quiver3(0.3, 0.5, 0.5, 0.2, 0, 0, 'Color', 'w', 'LineWidth', 2, 'MaxHeadSize', 0.5);

    axis equal; axis off;
    view(0, 0);
    camlight('headlight');
    lighting gouraud;
    title('Structure Components', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'w');
    set(gca, 'Color', [0.1 0.1 0.15]);
end

function draw_info_panel(ax)
    axes(ax); hold on;
    axis off;

    info_text = {
        'Crystal System: Cubic (Pm3m)'
        'General Formula: ABO₃'
        'Atoms/cell: 1 A + 1 B + 3 O = 5'
        'A-site: CN=12 (cuboctahedral)'
        'B-site: CN=6 (octahedral)'
        'O: CN=6 (2 B + 4 A)'
        'Examples: CaTiO₃, BaTiO₃, PbTiO₃'
    };

    for i = 1:length(info_text)
        text(0.05, 1 - i*0.13, info_text{i}, 'FontSize', 10, 'Color', 'w', ...
             'Units', 'normalized');
    end

    title('Structure Information', 'FontSize', 11, 'FontWeight', 'bold', 'Color', 'w');
    set(gca, 'Color', [0.1 0.1 0.15]);
end

function draw_b_coordination(ax, b_color, o_color)
    axes(ax); hold on;

    % Draw B-site with octahedral O coordination
    [X, Y, Z] = sphere(20);

    % Central B
    surf(X*0.15, Y*0.15, Z*0.15, 'FaceColor', b_color, 'EdgeColor', 'none', ...
         'FaceAlpha', 0.9, 'FaceLighting', 'gouraud');

    % 6 O atoms (octahedral)
    oct_pos = [0.5 0 0; -0.5 0 0; 0 0.5 0; 0 -0.5 0; 0 0 0.5; 0 0 -0.5];
    for i = 1:6
        surf(X*0.10 + oct_pos(i,1), Y*0.10 + oct_pos(i,2), Z*0.10 + oct_pos(i,3), ...
             'FaceColor', o_color, 'EdgeColor', 'none', ...
             'FaceAlpha', 0.8, 'FaceLighting', 'gouraud');
        plot3([0 oct_pos(i,1)], [0 oct_pos(i,2)], [0 oct_pos(i,3)], ...
              'Color', [0.6 0.6 0.6], 'LineWidth', 1.5);
    end

    % Draw octahedron wireframe
    edges = [1 3; 1 4; 1 5; 1 6; 2 3; 2 4; 2 5; 2 6; 3 5; 3 6; 4 5; 4 6];
    for i = 1:size(edges, 1)
        p1 = oct_pos(edges(i,1), :);
        p2 = oct_pos(edges(i,2), :);
        plot3([p1(1) p2(1)], [p1(2) p2(2)], [p1(3) p2(3)], '--', ...
              'Color', [1.0 0.5 0.0], 'LineWidth', 1);
    end

    axis equal; axis off;
    view(135, 25);
    camlight('headlight');
    lighting gouraud;
    title('BO₆ Octahedron', 'FontSize', 10, 'FontWeight', 'bold', 'Color', 'w');
    set(gca, 'Color', [0.1 0.1 0.15]);
end

function draw_tolerance_factor(ax)
    axes(ax); hold on;

    % Tolerance factor diagram
    % t = (r_A + r_O) / (sqrt(2) * (r_B + r_O))

    t_values = [0.8, 0.9, 1.0, 1.05];
    structures = {'Orth.', 'Dist.', 'Cubic', 'Hex.'};
    colors = [0.8 0.3 0.3; 0.8 0.6 0.3; 0.3 0.8 0.3; 0.3 0.6 0.8];

    for i = 1:4
        bar(i, t_values(i), 'FaceColor', colors(i,:), 'EdgeColor', 'w');
    end

    % Add ideal line
    plot([0.5 4.5], [1 1], 'w--', 'LineWidth', 1.5);
    text(4.6, 1, 't=1', 'Color', 'w', 'FontSize', 8);

    xlim([0.3 5]);
    ylim([0.7 1.15]);
    set(gca, 'XTick', 1:4, 'XTickLabel', structures, 'FontSize', 8);
    set(gca, 'Color', [0.1 0.1 0.15], 'XColor', 'w', 'YColor', 'w');
    ylabel('t factor', 'Color', 'w', 'FontSize', 9);
    title('Tolerance Factor', 'FontSize', 10, 'FontWeight', 'bold', 'Color', 'w');
    grid on;
    set(gca, 'GridColor', [0.4 0.4 0.4]);
end
