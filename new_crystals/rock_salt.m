% Rock Salt (NaCl) Crystal Structure Visualization
% Structure: FCC lattice of Cl⁻ with Na⁺ in ALL octahedral voids
% Atoms/cell: 4 Na + 4 Cl = 8 total
% Coordination: Na: 6 (octahedral), Cl: 6 (octahedral)

clear; clc; close all;

fprintf('\n ROCK SALT (NaCl) Crystal Structure\n');
fprintf(' Structure: FCC Cl⁻ with Na⁺ in all octahedral voids\n');
fprintf(' Atoms per unit cell: 4 Na + 4 Cl = 8\n');
fprintf(' Coordination: Na=6 (octahedral), Cl=6 (octahedral)\n');
fprintf(' Stacking: ABCABC of Cl with Na in octahedral sites\n\n');

% Parameters
a = 1;                          % Lattice parameter
cl_radius = 0.14;               % Cl atom radius
na_radius = 0.10;               % Na atom radius (smaller cation)
oct_void_radius = 0.04;         % Octahedral void indicator
sphere_quality = 30;

% Colors
cl_color = [0.9 0.7 0.2];       % Yellow/Gold for anion
na_color = [0.2 0.4 0.8];       % Blue for cation
oct_void_color = [1.0 0.5 0.0]; % Orange for octahedral voids
cell_edge_color = [0.3 0.3 0.3];

% Cl⁻ positions (FCC lattice)
cl_corners = [0 0 0; a 0 0; 0 a 0; 0 0 a; a a 0; a 0 a; 0 a a; a a a];
cl_faces = [a/2 a/2 0; a/2 a/2 a; a/2 0 a/2; a/2 a a/2; 0 a/2 a/2; a a/2 a/2];
cl_positions = [cl_corners; cl_faces];

% Na⁺ positions (octahedral voids of FCC)
% Body center + edge centers
na_positions = [a/2 a/2 a/2;                    % Body center
                a/2 0 0; 0 a/2 0; 0 0 a/2;      % Edge centers
                a a/2 0; a 0 a/2; 0 a a/2;
                a/2 a 0; 0 a/2 a; a/2 0 a;
                a a/2 a; a/2 a a; a a a/2];

% Create figure with multi-panel layout
fig = figure('Name', 'Rock Salt (NaCl) Structure', ...
             'Position', [50, 50, 1400, 800], 'Color', [0.02 0.02 0.06]);

% Main 3D view (left panel - 60% width)
ax_main = axes('Position', [0.02 0.08 0.58 0.88]);
hold on;

% Draw Cl atoms
for i = 1:size(cl_positions, 1)
    draw_sphere(cl_positions(i,:), cl_radius, cl_color, 0.85, sphere_quality);
end

% Draw Na atoms (in octahedral voids)
for i = 1:size(na_positions, 1)
    draw_sphere(na_positions(i,:), na_radius, na_color, 0.9, sphere_quality);
end

% Draw unit cell edges
draw_cube_edges(a, cell_edge_color, 2);

% Draw bonds between Na and neighboring Cl
bond_color = [0.5 0.5 0.5];
na_inside = na_positions(na_positions(:,1) > 0 & na_positions(:,1) < a & ...
                          na_positions(:,2) > 0 & na_positions(:,2) < a & ...
                          na_positions(:,3) > 0 & na_positions(:,3) < a, :);
for i = 1:size(na_inside, 1)
    na_pos = na_inside(i,:);
    for j = 1:size(cl_positions, 1)
        d = norm(na_pos - cl_positions(j,:));
        if d < a/2 + 0.01 && d > 0.01
            draw_bond(na_pos, cl_positions(j,:), bond_color, 1);
        end
    end
end

setup_3d_view('Rock Salt (NaCl) - Unit Cell');
add_legend({'Cl⁻ (anion)', 'Na⁺ (cation)'}, {cl_color, na_color});

% Stacking diagram (top-right)
ax_stack = axes('Position', [0.64 0.55 0.34 0.40]);
draw_stacking_diagram(ax_stack);

% Info panel (middle-right)
ax_info = axes('Position', [0.64 0.32 0.34 0.20]);
draw_info_panel(ax_info);

% Coordination polyhedron (bottom-right)
ax_coord = axes('Position', [0.64 0.05 0.16 0.24]);
draw_octahedral_coordination(ax_coord, na_color, cl_color);

% Packing diagram (bottom-right-right)
ax_pack = axes('Position', [0.82 0.05 0.16 0.24]);
draw_packing_chart(ax_pack);

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

    % Draw ABCABC stacking layers
    layer_colors = [0.9 0.3 0.3; 0.3 0.9 0.3; 0.3 0.3 0.9];
    layer_labels = {'A', 'B', 'C', 'A', 'B', 'C'};

    for i = 1:6
        y = 7 - i;
        color_idx = mod(i-1, 3) + 1;
        % Draw layer rectangle
        fill([0 4 4 0], [y y y+0.7 y+0.7], layer_colors(color_idx,:), ...
             'EdgeColor', 'w', 'FaceAlpha', 0.7);
        % Layer label
        text(-0.5, y+0.35, layer_labels{i}, 'FontSize', 14, 'FontWeight', 'bold', ...
             'Color', 'w', 'HorizontalAlignment', 'center');
        % Atom type
        if mod(i, 2) == 1
            text(2, y+0.35, 'Cl⁻ layer', 'FontSize', 10, 'Color', 'w', ...
                 'HorizontalAlignment', 'center');
        else
            text(2, y+0.35, 'Na⁺ layer', 'FontSize', 10, 'Color', 'w', ...
                 'HorizontalAlignment', 'center');
        end
    end

    axis off;
    xlim([-1 5]);
    ylim([0.5 7.5]);
    title('Layer Stacking (ABCABC)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'w');
    set(gca, 'Color', [0.1 0.1 0.15]);
end

function draw_info_panel(ax)
    axes(ax); hold on;
    axis off;

    info_text = {
        'Crystal System: Cubic (Fm3m)'
        'Lattice: FCC of Cl⁻'
        'Void Occupation: All octahedral'
        'Atoms/cell: 4 Na + 4 Cl = 8'
        'Coordination: Na=6, Cl=6'
        'r(Na⁺)/r(Cl⁻) = 0.52'
        'Examples: NaCl, KCl, MgO, CaO'
    };

    for i = 1:length(info_text)
        text(0.05, 1 - i*0.13, info_text{i}, 'FontSize', 10, 'Color', 'w', ...
             'Units', 'normalized');
    end

    title('Structure Information', 'FontSize', 11, 'FontWeight', 'bold', 'Color', 'w');
    set(gca, 'Color', [0.1 0.1 0.15]);
end

function draw_octahedral_coordination(ax, cation_color, anion_color)
    axes(ax); hold on;

    % Draw central cation
    [X, Y, Z] = sphere(20);
    surf(X*0.15, Y*0.15, Z*0.15, 'FaceColor', cation_color, 'EdgeColor', 'none', ...
         'FaceAlpha', 0.9, 'FaceLighting', 'gouraud');

    % Draw 6 coordinating anions (octahedral)
    oct_pos = [1 0 0; -1 0 0; 0 1 0; 0 -1 0; 0 0 1; 0 0 -1] * 0.5;
    for i = 1:6
        surf(X*0.12 + oct_pos(i,1), Y*0.12 + oct_pos(i,2), Z*0.12 + oct_pos(i,3), ...
             'FaceColor', anion_color, 'EdgeColor', 'none', ...
             'FaceAlpha', 0.8, 'FaceLighting', 'gouraud');
        % Draw bond
        plot3([0 oct_pos(i,1)], [0 oct_pos(i,2)], [0 oct_pos(i,3)], ...
              'Color', [0.6 0.6 0.6], 'LineWidth', 1.5);
    end

    % Draw octahedron wireframe
    verts = oct_pos;
    edges = [1 3; 1 4; 1 5; 1 6; 2 3; 2 4; 2 5; 2 6; 3 5; 3 6; 4 5; 4 6];
    for i = 1:size(edges, 1)
        p1 = verts(edges(i,1), :);
        p2 = verts(edges(i,2), :);
        plot3([p1(1) p2(1)], [p1(2) p2(2)], [p1(3) p2(3)], 'w--', 'LineWidth', 0.5);
    end

    axis equal; axis off;
    view(135, 25);
    camlight('headlight');
    lighting gouraud;
    title('Octahedral CN=6', 'FontSize', 10, 'FontWeight', 'bold', 'Color', 'w');
    set(gca, 'Color', [0.1 0.1 0.15]);
end

function draw_packing_chart(ax)
    axes(ax); hold on;

    % Packing efficiency data
    structures = {'FCC', 'NaCl', 'BCC'};
    packing = [0.74, 0.67, 0.68];
    colors = [0.3 0.6 0.9; 0.9 0.5 0.2; 0.5 0.8 0.5];

    for i = 1:3
        bar(i, packing(i), 'FaceColor', colors(i,:), 'EdgeColor', 'w');
    end

    xlim([0.3 3.7]);
    ylim([0 0.85]);
    set(gca, 'XTick', 1:3, 'XTickLabel', structures, 'FontSize', 9);
    set(gca, 'Color', [0.1 0.1 0.15], 'XColor', 'w', 'YColor', 'w');
    ylabel('APF', 'Color', 'w', 'FontSize', 9);
    title('Packing Efficiency', 'FontSize', 10, 'FontWeight', 'bold', 'Color', 'w');
    grid on;
    set(gca, 'GridColor', [0.4 0.4 0.4]);
end
