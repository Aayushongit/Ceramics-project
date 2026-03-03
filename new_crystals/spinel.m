% Spinel (AB₂O₄) Crystal Structure Visualization
% Structure: FCC of O²⁻, A²⁺ in 1/8 tetrahedral, B³⁺ in 1/2 octahedral voids
% Atoms/cell (primitive): 8 A + 16 B + 32 O = 56 total (conventional)
% Coordination: A: 4 (tetrahedral), B: 6 (octahedral)
% Example: MgAl₂O₄

clear; clc; close all;

fprintf('\n SPINEL (AB₂O₄) Crystal Structure\n');
fprintf(' Structure: FCC O²⁻ with A in 1/8 tet, B in 1/2 oct voids\n');
fprintf(' Conventional cell: 8 A + 16 B + 32 O = 56 atoms\n');
fprintf(' Coordination: A=4 (tetrahedral), B=6 (octahedral)\n');
fprintf(' Example: MgAl₂O₄ (A=Mg²⁺, B=Al³⁺)\n\n');

% Parameters - showing 1/8 of conventional cell for clarity
a = 1;                          % We'll show a simplified representation
a_radius = 0.08;                % A-site (tetrahedral) - Mg
b_radius = 0.07;                % B-site (octahedral) - Al
o_radius = 0.10;                % O atom radius
sphere_quality = 25;

% Colors
a_color = [0.2 0.4 0.8];        % Blue for A-site (Mg)
b_color = [0.6 0.2 0.8];        % Purple for B-site (Al)
o_color = [0.9 0.3 0.3];        % Red for O
tet_color = [0.2 0.8 0.3];      % Green for tetrahedral voids
oct_color = [1.0 0.5 0.0];      % Orange for octahedral voids
cell_edge_color = [0.3 0.3 0.3];

% For visualization, we'll show a simplified 2x2x2 arrangement
% representing part of the spinel structure

% Oxygen positions (approximate FCC-like arrangement in spinel)
% In real spinel, O forms a slightly distorted FCC
o_base = [];
for i = 0:1
    for j = 0:1
        for k = 0:1
            % FCC-like positions
            o_base = [o_base; i*a/2 j*a/2 k*a/2];
            if i < 1 && j < 1
                o_base = [o_base; (i+0.5)*a/2 (j+0.5)*a/2 k*a/2];
            end
            if i < 1 && k < 1
                o_base = [o_base; (i+0.5)*a/2 j*a/2 (k+0.5)*a/2];
            end
            if j < 1 && k < 1
                o_base = [o_base; i*a/2 (j+0.5)*a/2 (k+0.5)*a/2];
            end
        end
    end
end
o_positions = unique(o_base, 'rows');

% A-site positions (tetrahedral - 1/8 of tetrahedral voids occupied)
% In spinel, A-sites are at positions like (1/8, 1/8, 1/8)
a_positions = [a/8 a/8 a/8;
               3*a/8 3*a/8 a/8;
               3*a/8 a/8 3*a/8;
               a/8 3*a/8 3*a/8];

% B-site positions (octahedral - 1/2 of octahedral voids occupied)
% In spinel, B-sites form a pattern at edge/face-related positions
b_positions = [a/4 0 a/4;
               0 a/4 a/4;
               a/4 a/4 0;
               a/4 a/2 a/4;
               a/2 a/4 a/4;
               a/4 a/4 a/2;
               3*a/8 3*a/8 3*a/8;
               a/8 a/8 3*a/8];

% Create figure with multi-panel layout
fig = figure('Name', 'Spinel (AB₂O₄) Structure', ...
             'Position', [50, 50, 1400, 800], 'Color', [0.02 0.02 0.06]);

% Main 3D view (left panel - 60% width)
ax_main = axes('Position', [0.02 0.08 0.58 0.88]);
hold on;

% Draw O atoms
for i = 1:size(o_positions, 1)
    draw_sphere(o_positions(i,:), o_radius, o_color, 0.6, sphere_quality);
end

% Draw A-site atoms (tetrahedral sites)
for i = 1:size(a_positions, 1)
    draw_sphere(a_positions(i,:), a_radius, a_color, 0.95, sphere_quality);
    % Draw tetrahedral coordination indicator
    draw_tetrahedron(a_positions(i,:), a/8, tet_color, 0.15);
end

% Draw B-site atoms (octahedral sites)
for i = 1:size(b_positions, 1)
    draw_sphere(b_positions(i,:), b_radius, b_color, 0.95, sphere_quality);
end

% Draw octahedral coordination around one B-site
if ~isempty(b_positions)
    draw_octahedron(b_positions(1,:), a/8, oct_color, 0.15);
end

% Draw unit cell edges (showing partial cell)
draw_cube_edges(a/2, cell_edge_color, 2);

setup_3d_view('Spinel (MgAl₂O₄) - Partial Unit Cell');
add_legend({'A-site (Mg²⁺)', 'B-site (Al³⁺)', 'O²⁻', 'Tet. site', 'Oct. site'}, ...
           {a_color, b_color, o_color, tet_color, oct_color});

% Structure schematic (top-right)
ax_struct = axes('Position', [0.64 0.55 0.34 0.40]);
draw_structure_schematic(ax_struct);

% Info panel (middle-right)
ax_info = axes('Position', [0.64 0.32 0.34 0.20]);
draw_info_panel(ax_info);

% Void occupation diagram (bottom-right)
ax_void = axes('Position', [0.64 0.05 0.16 0.24]);
draw_void_occupation(ax_void);

% Normal vs Inverse spinel (bottom-right-right)
ax_type = axes('Position', [0.82 0.05 0.16 0.24]);
draw_spinel_types(ax_type);

fprintf(' Use mouse to rotate main view. Close window to exit.\n');
fprintf(' Note: Showing simplified representation of complex spinel structure.\n');

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

function draw_tetrahedron(center, size, color, alpha)
    c = center;
    s = size;
    % Tetrahedron vertices
    verts = [c(1)+s c(2)+s c(3)+s;
             c(1)+s c(2)-s c(3)-s;
             c(1)-s c(2)+s c(3)-s;
             c(1)-s c(2)-s c(3)+s];

    faces = [1 2 3; 1 2 4; 1 3 4; 2 3 4];
    patch('Vertices', verts, 'Faces', faces, 'FaceColor', color, ...
          'FaceAlpha', alpha, 'EdgeColor', color, 'LineWidth', 0.5);
end

function draw_octahedron(center, half_diag, color, alpha)
    c = center;
    hd = half_diag;
    verts = [c(1)+hd c(2) c(3);
             c(1)-hd c(2) c(3);
             c(1) c(2)+hd c(3);
             c(1) c(2)-hd c(3);
             c(1) c(2) c(3)+hd;
             c(1) c(2) c(3)-hd];

    faces = [1 3 5; 1 5 4; 1 4 6; 1 6 3;
             2 3 5; 2 5 4; 2 4 6; 2 6 3];

    patch('Vertices', verts, 'Faces', faces, 'FaceColor', color, ...
          'FaceAlpha', alpha, 'EdgeColor', color, 'LineWidth', 0.5);
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
        h(i) = plot3(NaN, NaN, NaN, 'o', 'MarkerSize', 10, ...
                     'MarkerFaceColor', colors{i}, 'MarkerEdgeColor', 'w');
    end
    leg = legend(h, labels, 'Location', 'northeast', 'FontSize', 9);
    set(leg, 'TextColor', 'w', 'Color', [0.15 0.15 0.2]);
end

function draw_structure_schematic(ax)
    axes(ax); hold on;

    % Draw schematic of spinel structure
    [X, Y, Z] = sphere(15);

    % Show FCC oxygen sublattice concept
    text(0.5, 0.9, 'Spinel Structure Overview', 'FontSize', 12, 'FontWeight', 'bold', ...
         'Color', 'w', 'HorizontalAlignment', 'center', 'Units', 'normalized');

    % Draw representative atoms
    % O atoms (FCC arrangement shown simply)
    o_demo = [0.2 0.6; 0.4 0.6; 0.3 0.45];
    for i = 1:size(o_demo, 1)
        rectangle('Position', [o_demo(i,1)-0.05 o_demo(i,2)-0.05 0.1 0.1], ...
                  'Curvature', [1 1], 'FaceColor', [0.9 0.3 0.3], 'EdgeColor', 'w');
    end
    text(0.3, 0.75, 'O²⁻ (FCC)', 'FontSize', 10, 'Color', 'w', 'HorizontalAlignment', 'center');

    % A atoms (tetrahedral)
    rectangle('Position', [0.6-0.04 0.6-0.04 0.08 0.08], ...
              'Curvature', [1 1], 'FaceColor', [0.2 0.4 0.8], 'EdgeColor', 'w');
    text(0.6, 0.75, 'A (tet)', 'FontSize', 10, 'Color', 'w', 'HorizontalAlignment', 'center');

    % B atoms (octahedral)
    rectangle('Position', [0.8-0.035 0.6-0.035 0.07 0.07], ...
              'Curvature', [1 1], 'FaceColor', [0.6 0.2 0.8], 'EdgeColor', 'w');
    text(0.8, 0.75, 'B (oct)', 'FontSize', 10, 'Color', 'w', 'HorizontalAlignment', 'center');

    % Formula and description
    text(0.5, 0.3, 'Formula: AB₂O₄', 'FontSize', 11, 'Color', 'w', ...
         'HorizontalAlignment', 'center', 'FontWeight', 'bold');
    text(0.5, 0.2, 'A in 1/8 tet. voids (8 of 64)', 'FontSize', 9, 'Color', [0.7 0.7 0.7], ...
         'HorizontalAlignment', 'center');
    text(0.5, 0.12, 'B in 1/2 oct. voids (16 of 32)', 'FontSize', 9, 'Color', [0.7 0.7 0.7], ...
         'HorizontalAlignment', 'center');

    axis off;
    xlim([0 1]);
    ylim([0 1]);
    set(gca, 'Color', [0.1 0.1 0.15]);
end

function draw_info_panel(ax)
    axes(ax); hold on;
    axis off;

    info_text = {
        'Crystal System: Cubic (Fd3m)'
        'Formula: AB₂O₄'
        'Conv. cell: 8 A + 16 B + 32 O = 56'
        'A-site: 1/8 tetrahedral (CN=4)'
        'B-site: 1/2 octahedral (CN=6)'
        'O: close-packed FCC sublattice'
        'Examples: MgAl₂O₄, Fe₃O₄, ZnFe₂O₄'
    };

    for i = 1:length(info_text)
        text(0.05, 1 - i*0.13, info_text{i}, 'FontSize', 10, 'Color', 'w', ...
             'Units', 'normalized');
    end

    title('Structure Information', 'FontSize', 11, 'FontWeight', 'bold', 'Color', 'w');
    set(gca, 'Color', [0.1 0.1 0.15]);
end

function draw_void_occupation(ax)
    axes(ax); hold on;

    % Void occupation in spinel
    void_types = {'Oct.', 'Tet.'};
    total_voids = [32, 64];      % In conventional cell
    filled_voids = [16, 8];     % B in oct, A in tet

    x = 1:2;
    bar_width = 0.7;

    % Total voids
    b1 = bar(x - 0.15, total_voids, bar_width/2, 'FaceColor', [0.3 0.3 0.3], 'EdgeColor', 'w');
    % Filled voids
    b2 = bar(x + 0.15, filled_voids, bar_width/2, 'FaceColor', [0.4 0.7 0.4], 'EdgeColor', 'w');

    xlim([0.3 2.7]);
    ylim([0 70]);
    set(gca, 'XTick', 1:2, 'XTickLabel', void_types, 'FontSize', 9);
    set(gca, 'Color', [0.1 0.1 0.15], 'XColor', 'w', 'YColor', 'w');
    ylabel('Count', 'Color', 'w', 'FontSize', 9);
    title('Void Occupation', 'FontSize', 10, 'FontWeight', 'bold', 'Color', 'w');

    % Labels
    text(1, 35, '16/32', 'Color', 'w', 'FontSize', 8, 'HorizontalAlignment', 'center');
    text(2, 12, '8/64', 'Color', 'w', 'FontSize', 8, 'HorizontalAlignment', 'center');

    grid on;
    set(gca, 'GridColor', [0.4 0.4 0.4]);
end

function draw_spinel_types(ax)
    axes(ax); hold on;

    % Compare normal vs inverse spinel
    text(0.5, 0.95, 'Spinel Types', 'FontSize', 10, 'FontWeight', 'bold', ...
         'Color', 'w', 'HorizontalAlignment', 'center', 'Units', 'normalized');

    % Normal spinel
    text(0.5, 0.78, 'Normal Spinel', 'FontSize', 9, 'FontWeight', 'bold', ...
         'Color', [0.3 0.8 0.3], 'HorizontalAlignment', 'center', 'Units', 'normalized');
    text(0.5, 0.65, 'A²⁺: tetrahedral', 'FontSize', 8, 'Color', 'w', ...
         'HorizontalAlignment', 'center', 'Units', 'normalized');
    text(0.5, 0.55, 'B³⁺: octahedral', 'FontSize', 8, 'Color', 'w', ...
         'HorizontalAlignment', 'center', 'Units', 'normalized');
    text(0.5, 0.45, 'e.g., MgAl₂O₄', 'FontSize', 8, 'Color', [0.7 0.7 0.7], ...
         'HorizontalAlignment', 'center', 'Units', 'normalized');

    % Divider
    plot([0.1 0.9], [0.38 0.38], 'w-', 'LineWidth', 1);

    % Inverse spinel
    text(0.5, 0.30, 'Inverse Spinel', 'FontSize', 9, 'FontWeight', 'bold', ...
         'Color', [0.8 0.3 0.3], 'HorizontalAlignment', 'center', 'Units', 'normalized');
    text(0.5, 0.18, 'B³⁺: tet + oct', 'FontSize', 8, 'Color', 'w', ...
         'HorizontalAlignment', 'center', 'Units', 'normalized');
    text(0.5, 0.08, 'e.g., Fe₃O₄', 'FontSize', 8, 'Color', [0.7 0.7 0.7], ...
         'HorizontalAlignment', 'center', 'Units', 'normalized');

    axis off;
    xlim([0 1]);
    ylim([0 1]);
    set(gca, 'Color', [0.1 0.1 0.15]);
end
