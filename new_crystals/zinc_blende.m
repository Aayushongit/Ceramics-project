clear; clc; close all;

fprintf('\n ZINC BLENDE (ZnS) Crystal Structure\n');
fprintf(' Structure: FCC S²⁻ with Zn²⁺ in half of tetrahedral voids\n');
fprintf(' Atoms per unit cell: 4 S + 4 Zn = 8\n');
fprintf(' Coordination: Zn=4 (tetrahedral), S=4 (tetrahedral)\n');
fprintf(' Stacking: ABCABC with alternating tetrahedral site occupation\n\n');

a = 1;
s_radius = 0.14;
zn_radius = 0.10;
sphere_quality = 30;

s_color = [0.9 0.7 0.2];
zn_color = [0.2 0.4 0.8];
tet_void_color = [0.2 0.8 0.3];
oct_void_color = [1.0 0.5 0.0];
cell_edge_color = [0.3 0.3 0.3];

s_corners = [0 0 0; a 0 0; 0 a 0; 0 0 a; a a 0; a 0 a; 0 a a; a a a];
s_faces = [a/2 a/2 0; a/2 a/2 a; a/2 0 a/2; a/2 a a/2; 0 a/2 a/2; a a/2 a/2];
s_positions = [s_corners; s_faces];

zn_positions = [a/4 a/4 a/4;
                3*a/4 3*a/4 a/4;
                3*a/4 a/4 3*a/4;
                a/4 3*a/4 3*a/4];

empty_tet_voids = [3*a/4 a/4 a/4;
                   a/4 3*a/4 a/4;
                   a/4 a/4 3*a/4;
                   3*a/4 3*a/4 3*a/4];

oct_void_positions = [a/2 a/2 a/2];

fig = figure('Name', 'Zinc Blende (ZnS) Structure', ...
             'Position', [50, 50, 1400, 800], 'Color', [0.02 0.02 0.06]);

ax_main = axes('Position', [0.02 0.08 0.58 0.88]);
hold on;

all_oct_voids = [a/2 a/2 a/2;
                 a/2 0 0; 0 a/2 0; 0 0 a/2;
                 a a/2 0; a 0 a/2; 0 a a/2;
                 a/2 a 0; 0 a/2 a; a/2 0 a;
                 a a/2 a; a/2 a a; a a a/2];

for i = 1:size(all_oct_voids, 1)
    draw_octahedron_void(all_oct_voids(i,:), a/5, oct_void_color, 0.08);
end

for i = 1:size(zn_positions, 1)
    draw_tetrahedron_void(zn_positions(i,:), a/7, tet_void_color, 0.2);
end

for i = 1:size(empty_tet_voids, 1)
    draw_tetrahedron_void(empty_tet_voids(i,:), a/7, [0.5 0.5 0.5], 0.12);
end

for i = 1:size(s_positions, 1)
    draw_sphere(s_positions(i,:), s_radius, s_color, 0.85, sphere_quality);
end

for i = 1:size(zn_positions, 1)
    draw_sphere(zn_positions(i,:), zn_radius, zn_color, 0.9, sphere_quality);
end

draw_cube_edges(a, cell_edge_color, 2);

bond_color = [0.5 0.5 0.5];
for i = 1:size(zn_positions, 1)
    zn_pos = zn_positions(i,:);
    for j = 1:size(s_positions, 1)
        d = norm(zn_pos - s_positions(j,:));
        if d < a*sqrt(3)/4 + 0.05 && d > 0.01
            draw_bond(zn_pos, s_positions(j,:), bond_color, 1.5);
        end
    end
end

setup_3d_view('Zinc Blende (ZnS) - Unit Cell');
add_legend({'S²⁻ (anion)', 'Zn²⁺ (cation)', 'Tet. void (filled)', 'Oct. void (empty)'}, ...
           {s_color, zn_color, tet_void_color, oct_void_color});

ax_stack = axes('Position', [0.64 0.55 0.34 0.40]);
draw_stacking_diagram(ax_stack);

ax_info = axes('Position', [0.64 0.32 0.34 0.20]);
draw_info_panel(ax_info);

ax_coord = axes('Position', [0.64 0.05 0.16 0.24]);
draw_tetrahedral_coordination(ax_coord, zn_color, s_color);

ax_void = axes('Position', [0.82 0.05 0.16 0.24]);
draw_void_occupation(ax_void);

fprintf(' Use mouse to rotate main view. Close window to exit.\n');

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

function draw_tetrahedron_void(center, size, color, alpha)
    c = center;
    s = size;
    verts = [c(1)+s c(2)+s c(3)+s;
             c(1)+s c(2)-s c(3)-s;
             c(1)-s c(2)+s c(3)-s;
             c(1)-s c(2)-s c(3)+s];
    faces = [1 2 3; 1 2 4; 1 3 4; 2 3 4];
    patch('Vertices', verts, 'Faces', faces, 'FaceColor', color, ...
          'FaceAlpha', alpha, 'EdgeColor', color, 'LineWidth', 1);
end

function draw_octahedron_void(center, half_diag, color, alpha)
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
          'FaceAlpha', alpha, 'EdgeColor', color, 'LineWidth', 1.5);
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

    layer_colors = [0.9 0.3 0.3; 0.3 0.9 0.3; 0.3 0.3 0.9];
    layer_labels = {'A', 'B', 'C', 'A', 'B', 'C'};

    for i = 1:6
        y = 7 - i;
        color_idx = mod(i-1, 3) + 1;
        fill([0 4 4 0], [y y y+0.7 y+0.7], layer_colors(color_idx,:), ...
             'EdgeColor', 'w', 'FaceAlpha', 0.7);
        text(-0.5, y+0.35, layer_labels{i}, 'FontSize', 14, 'FontWeight', 'bold', ...
             'Color', 'w', 'HorizontalAlignment', 'center');
        if mod(i, 2) == 1
            text(2, y+0.35, 'S²⁻ layer', 'FontSize', 10, 'Color', 'w', ...
                 'HorizontalAlignment', 'center');
        else
            text(2, y+0.35, 'Zn²⁺ (tet)', 'FontSize', 10, 'Color', 'w', ...
                 'HorizontalAlignment', 'center');
        end
    end

    text(2, 0.3, 'Only half of tet. voids filled', 'FontSize', 9, 'Color', [0.8 0.8 0.3], ...
         'HorizontalAlignment', 'center', 'FontStyle', 'italic');

    axis off;
    xlim([-1 5]);
    ylim([0 7.5]);
    title('Layer Stacking (ABCABC)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'w');
    set(gca, 'Color', [0.1 0.1 0.15]);
end

function draw_info_panel(ax)
    axes(ax); hold on;
    axis off;

    info_text = {
        'Crystal System: Cubic (F-43m)'
        'Lattice: FCC of S²⁻'
        'Void Occupation: Half tetrahedral'
        'Atoms/cell: 4 Zn + 4 S = 8'
        'Coordination: Zn=4, S=4 (both tet.)'
        'r(Zn²⁺)/r(S²⁻) = 0.40'
        'Examples: ZnS, GaAs, InP, diamond'
    };

    for i = 1:length(info_text)
        text(0.05, 1 - i*0.13, info_text{i}, 'FontSize', 10, 'Color', 'w', ...
             'Units', 'normalized');
    end

    title('Structure Information', 'FontSize', 11, 'FontWeight', 'bold', 'Color', 'w');
    set(gca, 'Color', [0.1 0.1 0.15]);
end

function draw_tetrahedral_coordination(ax, cation_color, anion_color)
    axes(ax); hold on;

    [X, Y, Z] = sphere(20);
    surf(X*0.15, Y*0.15, Z*0.15, 'FaceColor', cation_color, 'EdgeColor', 'none', ...
         'FaceAlpha', 0.9, 'FaceLighting', 'gouraud');

    tet_pos = [1 1 1; 1 -1 -1; -1 1 -1; -1 -1 1] * 0.35;
    for i = 1:4
        surf(X*0.12 + tet_pos(i,1), Y*0.12 + tet_pos(i,2), Z*0.12 + tet_pos(i,3), ...
             'FaceColor', anion_color, 'EdgeColor', 'none', ...
             'FaceAlpha', 0.8, 'FaceLighting', 'gouraud');
        plot3([0 tet_pos(i,1)], [0 tet_pos(i,2)], [0 tet_pos(i,3)], ...
              'Color', [0.6 0.6 0.6], 'LineWidth', 1.5);
    end

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
    title('Tetrahedral CN=4', 'FontSize', 10, 'FontWeight', 'bold', 'Color', 'w');
    set(gca, 'Color', [0.1 0.1 0.15]);
end

function draw_void_occupation(ax)
    axes(ax); hold on;

    void_types = {'Oct.', 'Tet.'};
    total_voids = [4, 8];
    filled_voids = [0, 4];

    bar_width = 0.35;
    x = 1:2;

    bar(x, total_voids, bar_width*2, 'FaceColor', [0.3 0.3 0.3], 'EdgeColor', 'w');
    bar(x, filled_voids, bar_width*2, 'FaceColor', [0.2 0.7 0.3], 'EdgeColor', 'w');

    xlim([0.3 2.7]);
    ylim([0 10]);
    set(gca, 'XTick', 1:2, 'XTickLabel', void_types, 'FontSize', 9);
    set(gca, 'Color', [0.1 0.1 0.15], 'XColor', 'w', 'YColor', 'w');
    ylabel('Voids/cell', 'Color', 'w', 'FontSize', 9);
    title('Void Occupation', 'FontSize', 10, 'FontWeight', 'bold', 'Color', 'w');

    text(1, 4.5, '0/4', 'Color', 'w', 'FontSize', 9, 'HorizontalAlignment', 'center');
    text(2, 5, '4/8', 'Color', 'w', 'FontSize', 9, 'HorizontalAlignment', 'center');

    grid on;
    set(gca, 'GridColor', [0.4 0.4 0.4]);
end
