clear; clc; close all;

fprintf('\n FCC Unit Cell - Tetrahedral Voids\n');
fprintf(' Lattice: a = 1, Atoms/cell: 4, CN: 12, Packing: 74%%\n');
fprintf(' Tetrahedral voids: 8/cell, r/R = 0.225\n');
fprintf(' Blue: Atoms, Green: Tetrahedral voids\n\n');

atom_radius = 0.15;
tet_void_radius = 0.06;
sphere_quality = 30;
atom_color = [0.2 0.4 0.8];
tet_void_color = [0.2 0.8 0.3];
cell_edge_color = [0.3 0.3 0.3];

a = 1;
corners = [0 0 0; a 0 0; 0 a 0; 0 0 a; a a 0; a 0 a; 0 a a; a a a];
face_centers = [a/2 a/2 0; a/2 a/2 a; a/2 0 a/2; a/2 a a/2; 0 a/2 a/2; a a/2 a/2];
fcc_atoms = [corners; face_centers];

tet_voids_fcc = [a/4 a/4 a/4; 3*a/4 3*a/4 a/4; 3*a/4 a/4 3*a/4; a/4 3*a/4 3*a/4;
                 3*a/4 a/4 a/4; a/4 3*a/4 a/4; a/4 a/4 3*a/4; 3*a/4 3*a/4 3*a/4];

figure('Name', 'FCC - Tetrahedral Voids', 'Position', [100, 100, 700, 600], 'Color', 'w');
hold on;

for i = 1:size(fcc_atoms, 1)
    draw_sphere(fcc_atoms(i,:), atom_radius, atom_color, 1.0, sphere_quality);
end

for i = 1:size(tet_voids_fcc, 1)
    draw_sphere(tet_voids_fcc(i,:), tet_void_radius, tet_void_color, 0.9, sphere_quality);
end

draw_tetrahedron_fcc([a/4 a/4 a/4], a, [0.5 1 0.5], 0.3);
draw_cube_edges(a, cell_edge_color, 2);
setup_3d_view('FCC Unit Cell - Tetrahedral Voids');
add_legend({'Atoms', 'Tetrahedral Voids'}, {atom_color, tet_void_color});

fprintf(' Use mouse to rotate. Close window to exit.\n');

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

function draw_tetrahedron_fcc(void_center, a, color, alpha)
    vertices = [0 0 0; a/2 a/2 0; a/2 0 a/2; 0 a/2 a/2];
    faces = [1 2 3; 1 2 4; 1 3 4; 2 3 4];
    patch('Vertices', vertices, 'Faces', faces, 'FaceColor', color, 'FaceAlpha', alpha, ...
          'EdgeColor', [0 0.5 0], 'LineWidth', 1.5);
end

function setup_3d_view(title_str)
    title(title_str, 'FontSize', 14, 'FontWeight', 'bold');
    xlabel('X', 'FontSize', 12);
    ylabel('Y', 'FontSize', 12);
    zlabel('Z', 'FontSize', 12);
    axis equal; grid on; box on;
    view(135, 25);
    camlight('headlight');
    camlight('right');
    lighting gouraud;
    material shiny;
    rotate3d on;
    set(gca, 'Color', [0.98 0.98 0.98]);
end

function add_legend(labels, colors)
    h = zeros(length(labels), 1);
    for i = 1:length(labels)
        h(i) = plot3(NaN, NaN, NaN, 'o', 'MarkerSize', 10, ...
                     'MarkerFaceColor', colors{i}, 'MarkerEdgeColor', 'k');
    end
    legend(h, labels, 'Location', 'northeast', 'FontSize', 10);
end
