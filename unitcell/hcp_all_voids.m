clear; clc; close all;

fprintf('\n HCP Unit Cell - All Interstitial Voids\n');
fprintf(' Lattice: a = 1, c = 1.633a, Atoms/cell: 2, CN: 12, Packing: 74%%\n');
fprintf(' Octahedral: 2/cell (r/R=0.414), Tetrahedral: 4/cell (r/R=0.225)\n');
fprintf(' Blue: Atoms, Red: Oct voids, Green: Tet voids\n\n');

atom_radius = 0.15;
oct_void_radius = 0.08;
tet_void_radius = 0.06;
sphere_quality = 30;
atom_color = [0.2 0.4 0.8];
oct_void_color = [0.9 0.2 0.2];
tet_void_color = [0.2 0.8 0.3];
cell_edge_color = [0.3 0.3 0.3];

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

figure('Name', 'HCP - All Voids', 'Position', [300, 100, 700, 600], 'Color', 'w');
hold on;

for i = 1:size(hcp_atoms, 1)
    draw_sphere(hcp_atoms(i,:), atom_radius, atom_color, 0.7, sphere_quality);
end

for i = 1:size(oct_voids_hcp, 1)
    draw_sphere(oct_voids_hcp(i,:), oct_void_radius, oct_void_color, 0.9, sphere_quality);
end

for i = 1:size(tet_voids_hcp, 1)
    draw_sphere(tet_voids_hcp(i,:), tet_void_radius, tet_void_color, 0.9, sphere_quality);
end

draw_hcp_cell(a_hcp, c_hcp, cell_edge_color, 2);
setup_3d_view('HCP Unit Cell - All Interstitial Voids');
add_legend({'Atoms', 'Octahedral Voids', 'Tetrahedral Voids'}, {atom_color, oct_void_color, tet_void_color});

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

function add_legend(labels, colors)
    h = zeros(length(labels), 1);
    for i = 1:length(labels)
        h(i) = plot3(NaN, NaN, NaN, 'o', 'MarkerSize', 10, ...
                     'MarkerFaceColor', colors{i}, 'MarkerEdgeColor', 'k');
    end
    legend(h, labels, 'Location', 'northeast', 'FontSize', 10);
end
