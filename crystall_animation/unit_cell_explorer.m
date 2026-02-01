clear; clc; close all;

fprintf('\n FCC UNIT CELL - INTERACTIVE EXPLORER\n');
fprintf(' Lattice Parameter: a = 3 units\n');
fprintf(' Atoms: 4/cell (shown 14: 8 corner + 6 face), CN: 12, Packing: 74%%\n');
fprintf(' Voids: Octahedral 4/cell (r/R=0.414), Tetrahedral 8/cell (r/R=0.225)\n\n');

fig = figure('Name', 'Interactive Unit Cell Explorer', ...
             'Position', [100, 100, 1200, 800], ...
             'Color', [0.02 0.02 0.06], ...
             'NumberTitle', 'off');

a = 3;

ax = axes('Position', [0.05 0.1 0.9 0.85]);
hold on;
set(ax, 'Color', [0.03 0.03 0.08]);
set(ax, 'XColor', [0.6 0.6 0.6], 'YColor', [0.6 0.6 0.6], 'ZColor', [0.6 0.6 0.6]);
set(ax, 'GridColor', [0.2 0.2 0.3], 'GridAlpha', 0.5);

title('FCC Unit Cell - Interactive View', 'Color', 'w', 'FontSize', 14, 'FontWeight', 'bold');

corners = [0 0 0; a 0 0; 0 a 0; 0 0 a; a a 0; a 0 a; 0 a a; a a a];
faces = [a/2 a/2 0; a/2 a/2 a; a/2 0 a/2; a/2 a a/2; 0 a/2 a/2; a a/2 a/2];

atom_radius = 0.4;
for i = 1:size(corners, 1)
    draw_sphere(corners(i,:), atom_radius, [0.2 0.5 1.0], 0.9);
end
for i = 1:size(faces, 1)
    draw_sphere(faces(i,:), atom_radius, [0.2 0.5 1.0], 0.9);
end

oct_voids = [a/2 a/2 a/2;
             a/2 0 0; 0 a/2 0; 0 0 a/2;
             a/2 a 0; a/2 0 a; 0 a/2 a;
             a a/2 0; a 0 a/2; 0 a a/2;
             a/2 a a; a a/2 a; a a a/2];

oct_radius = 0.22;
for i = 1:size(oct_voids, 1)
    draw_sphere(oct_voids(i,:), oct_radius, [1.0 0.6 0.0], 0.85);
end

tet_voids = [a/4 a/4 a/4; 3*a/4 3*a/4 a/4; 3*a/4 a/4 3*a/4; a/4 3*a/4 3*a/4;
             3*a/4 a/4 a/4; a/4 3*a/4 a/4; a/4 a/4 3*a/4; 3*a/4 3*a/4 3*a/4];

tet_radius = 0.16;
for i = 1:size(tet_voids, 1)
    draw_sphere(tet_voids(i,:), tet_radius, [0.9 0.2 0.9], 0.85);
end

draw_cube_edges(a, [0.6 0.6 0.6], 2.5);

axis equal;
grid on;
box on;
xlim([-0.8 a+0.8]);
ylim([-0.8 a+0.8]);
zlim([-0.8 a+0.8]);
view(45, 25);

camlight('headlight');
camlight('right');
lighting gouraud;
material shiny;

annotation('textbox', [0.02 0.02 0.22 0.12], ...
           'String', {'Legend:', 'Blue: Atoms (14)', 'Orange: Oct. voids (13)', 'Purple: Tet. voids (8)'}, ...
           'Color', 'w', 'BackgroundColor', [0.1 0.1 0.2], ...
           'EdgeColor', [0.3 0.3 0.5], 'FontSize', 10);

annotation('textbox', [0.76 0.02 0.22 0.12], ...
           'String', {'FCC Unit Cell:', 'Atoms: 4/cell', 'Oct: 4/cell', 'Tet: 8/cell'}, ...
           'Color', 'w', 'BackgroundColor', [0.1 0.1 0.2], ...
           'EdgeColor', [0.3 0.3 0.5], 'FontSize', 10);

rotate3d on;

fprintf('  Use mouse to rotate. Press any key to close...\n');
pause;
close(fig);

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
