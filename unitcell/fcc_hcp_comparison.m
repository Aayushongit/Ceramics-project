clear; clc; close all;

fprintf('\n FCC vs HCP Crystal Structure Comparison\n');
fprintf(' Both structures: CN = 12, Packing efficiency = 74%%\n');
fprintf(' FCC: a = 1, 4 atoms/cell, Oct 4/cell, Tet 8/cell\n');
fprintf(' HCP: a = 1, c = 1.633a, 2 atoms/cell, Oct 2/cell, Tet 4/cell\n');
fprintf(' Blue: Atoms, Red: Oct voids, Green: Tet voids\n\n');

atom_radius = 0.15;
oct_void_radius = 0.08;
tet_void_radius = 0.06;
sphere_quality = 30;
atom_color = [0.2 0.4 0.8];
oct_void_color = [0.9 0.2 0.2];
tet_void_color = [0.2 0.8 0.3];
cell_edge_color = [0.3 0.3 0.3];

a = 1;
corners = [0 0 0; a 0 0; 0 a 0; 0 0 a; a a 0; a 0 a; 0 a a; a a a];
face_centers = [a/2 a/2 0; a/2 a/2 a; a/2 0 a/2; a/2 a a/2; 0 a/2 a/2; a a/2 a/2];
fcc_atoms = [corners; face_centers];

oct_voids_fcc = [a/2 a/2 a/2;
                 a/2 0 0; 0 a/2 0; 0 0 a/2;
                 a/2 a 0; a/2 0 a; 0 a/2 a;
                 a a/2 0; a 0 a/2; 0 a a/2;
                 a/2 a a; a a/2 a; a a a/2];

tet_voids_fcc = [a/4 a/4 a/4; 3*a/4 3*a/4 a/4; 3*a/4 a/4 3*a/4; a/4 3*a/4 3*a/4;
                 3*a/4 a/4 a/4; a/4 3*a/4 a/4; a/4 a/4 3*a/4; 3*a/4 3*a/4 3*a/4];

a_hcp = 1;
c_hcp = a_hcp * sqrt(8/3);

hcp_A = [0, 0, 0;
         a_hcp, 0, 0;
         a_hcp/2, a_hcp*sqrt(3)/2, 0;
         -a_hcp/2, a_hcp*sqrt(3)/2, 0;
         a_hcp*3/2, a_hcp*sqrt(3)/2, 0];

hcp_B = [a_hcp/2, a_hcp*sqrt(3)/6, c_hcp/2;
         a_hcp*3/2, a_hcp*sqrt(3)/6, c_hcp/2;
         0, a_hcp*sqrt(3)*2/3, c_hcp/2;
         a_hcp, a_hcp*sqrt(3)*2/3, c_hcp/2];

hcp_A_top = hcp_A;
hcp_A_top(:,3) = c_hcp;

hcp_atoms = [hcp_A; hcp_B; hcp_A_top];

oct_voids_hcp = [a_hcp/2, a_hcp*sqrt(3)/6, c_hcp/4;
                 a_hcp, a_hcp*sqrt(3)*2/3, c_hcp/4;
                 a_hcp/2, a_hcp*sqrt(3)/6, 3*c_hcp/4;
                 a_hcp, a_hcp*sqrt(3)*2/3, 3*c_hcp/4;
                 0, a_hcp*sqrt(3)/3, c_hcp/4;
                 a_hcp*3/2, a_hcp*sqrt(3)/6, 3*c_hcp/4];

tet_voids_hcp = [a_hcp/2, a_hcp*sqrt(3)/6, c_hcp/8;
                 a_hcp, a_hcp*sqrt(3)*2/3, c_hcp/8;
                 0, a_hcp*sqrt(3)/3, c_hcp/8;
                 a_hcp/2, a_hcp*sqrt(3)/6, 3*c_hcp/8;
                 a_hcp, a_hcp*sqrt(3)*2/3, 3*c_hcp/8;
                 a_hcp*3/2, a_hcp*sqrt(3)/6, 3*c_hcp/8;
                 a_hcp/2, a_hcp*sqrt(3)/6, 5*c_hcp/8;
                 a_hcp, a_hcp*sqrt(3)*2/3, 5*c_hcp/8;
                 0, a_hcp*sqrt(3)/3, 5*c_hcp/8;
                 a_hcp/2, a_hcp*sqrt(3)/6, 7*c_hcp/8;
                 a_hcp, a_hcp*sqrt(3)*2/3, 7*c_hcp/8;
                 a_hcp*3/2, a_hcp*sqrt(3)/6, 7*c_hcp/8];

figure('Name', 'FCC vs HCP Comparison', 'Position', [50, 50, 1400, 600], 'Color', 'w');

subplot(1, 2, 1);
hold on;
for i = 1:size(fcc_atoms, 1)
    draw_sphere(fcc_atoms(i,:), atom_radius, atom_color, 0.6, sphere_quality);
end
for i = 1:size(oct_voids_fcc, 1)
    draw_sphere(oct_voids_fcc(i,:), oct_void_radius, oct_void_color, 0.9, sphere_quality);
end
for i = 1:size(tet_voids_fcc, 1)
    draw_sphere(tet_voids_fcc(i,:), tet_void_radius, tet_void_color, 0.9, sphere_quality);
end
draw_cube_edges(a, cell_edge_color, 2);
setup_3d_view('FCC Structure');

subplot(1, 2, 2);
hold on;
for i = 1:size(hcp_atoms, 1)
    draw_sphere(hcp_atoms(i,:), atom_radius, atom_color, 0.6, sphere_quality);
end
for i = 1:size(oct_voids_hcp, 1)
    draw_sphere(oct_voids_hcp(i,:), oct_void_radius, oct_void_color, 0.9, sphere_quality);
end
for i = 1:size(tet_voids_hcp, 1)
    draw_sphere(tet_voids_hcp(i,:), tet_void_radius, tet_void_color, 0.9, sphere_quality);
end
draw_hcp_cell(a_hcp, c_hcp, cell_edge_color, 2);
setup_3d_view('HCP Structure');

sgtitle('Comparison: FCC vs HCP Crystal Structures', 'FontSize', 16, 'FontWeight', 'bold');

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

function draw_hcp_cell(a, c, color, width)
    v1 = [a, 0, 0];
    v2 = [a/2, a*sqrt(3)/2, 0];
    base = [0 0 0; v1; v1+v2; v2];
    top = base;
    top(:,3) = c;
    for i = 1:4
        j = mod(i, 4) + 1;
        plot3([base(i,1) base(j,1)], [base(i,2) base(j,2)], [base(i,3) base(j,3)], 'Color', color, 'LineWidth', width);
    end
    for i = 1:4
        j = mod(i, 4) + 1;
        plot3([top(i,1) top(j,1)], [top(i,2) top(j,2)], [top(i,3) top(j,3)], 'Color', color, 'LineWidth', width);
    end
    for i = 1:4
        plot3([base(i,1) top(i,1)], [base(i,2) top(i,2)], [base(i,3) top(i,3)], 'Color', color, 'LineWidth', width);
    end
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
