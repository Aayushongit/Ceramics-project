clear; clc; close all;

fprintf('\n SPINEL (AB2O4) Layer Stacking Simulation\n');
fprintf(' Building: FCC O with A in 1/8 tet, B in 1/2 oct voids\n\n');

a = 1;
nx = 3; ny = 3; nz = 1;

o_color = [0.92 0.35 0.35];
a_color = [0.25 0.48 0.92];
b_color = [0.65 0.25 0.85];
tet_void_color = [0.20 0.80 0.35];
oct_void_color = [1.00 0.55 0.10];
empty_tet_color = [0.55 0.55 0.55];
empty_oct_color = [0.45 0.35 0.30];

o_basis = [0 0 0; 0.5 0.5 0; 0.5 0 0.5; 0 0.5 0.5];

a_basis = [0.125 0.125 0.125; 0.375 0.375 0.375];

b_basis = [0.5 0.5 0.5; 0.5 0 0];

empty_tet_basis = [0.625 0.625 0.125; 0.875 0.875 0.375;
                   0.625 0.125 0.625; 0.125 0.625 0.625];
empty_oct_basis = [0 0.5 0; 0 0 0.5];

o_pos = generate_positions(o_basis, nx, ny, nz, a);
a_pos = generate_positions(a_basis, nx, ny, nz, a);
b_pos = generate_positions(b_basis, nx, ny, nz, a);
empty_tet_pos = generate_positions(empty_tet_basis, nx, ny, nz, a);
empty_oct_pos = generate_positions(empty_oct_basis, nx, ny, nz, a);

fig = figure('Name', 'Spinel Layer Stacking', ...
             'Units', 'normalized', 'OuterPosition', [0.02 0.04 0.96 0.92], ...
             'Color', [0.02 0.02 0.06], 'NumberTitle', 'off');

ax_main = axes('Position', [0.01 0.06 0.64 0.90]);
hold on; grid on; box on; axis equal;
set(gca, 'Color', [0.06 0.06 0.12], 'XColor', 'w', 'YColor', 'w', 'ZColor', 'w', ...
         'GridColor', [0.3 0.3 0.35]);
xlabel('X', 'Color', 'w'); ylabel('Y', 'Color', 'w'); zlabel('Z', 'Color', 'w');
view(135, 25);
camlight('headlight'); camlight('right');
lighting gouraud; material shiny;

all_pos = [o_pos; a_pos; b_pos; empty_tet_pos; empty_oct_pos];
center = (min(all_pos) + max(all_pos)) / 2;
o_pos = o_pos - center;
a_pos = a_pos - center;
b_pos = b_pos - center;
empty_tet_pos = empty_tet_pos - center;
empty_oct_pos = empty_oct_pos - center;

margin = max(max(all_pos) - min(all_pos)) * 0.12;
xlim([min(o_pos(:,1))-margin max(o_pos(:,1))+margin]);
ylim([min(o_pos(:,2))-margin max(o_pos(:,2))+margin]);
zlim([min(o_pos(:,3))-margin max(o_pos(:,3))+margin+0.3]);

ax_stack = axes('Position', [0.67 0.52 0.31 0.44]);
ax_info = axes('Position', [0.67 0.04 0.31 0.44]);

z_layers_o = unique(round(o_pos(:,3), 4));
z_layers_a = unique(round(a_pos(:,3), 4));
z_layers_b = unique(round(b_pos(:,3), 4));
all_z = sort(unique([z_layers_o; z_layers_a; z_layers_b]));

layer_info = struct('z', {}, 'type', {}, 'label', {});
for i = 1:length(all_z)
    z = all_z(i);
    is_o = any(abs(z_layers_o - z) < 0.01);
    is_a = any(abs(z_layers_a - z) < 0.01);
    is_b = any(abs(z_layers_b - z) < 0.01);

    lbl = '';
    if is_o, lbl = [lbl 'O']; end
    if is_a, lbl = [lbl 'A']; end
    if is_b, lbl = [lbl 'B']; end

    if isempty(lbl), lbl = 'void'; end
    layer_info(end+1) = struct('z', z, 'type', lower(lbl), 'label', sprintf('%s z=%.2f', lbl, z));
end

draw_info_panel(ax_info, length(o_pos), length(a_pos), length(b_pos), length(empty_tet_pos), length(empty_oct_pos));

h_legend = [];
h_legend(1) = plot3(ax_main, NaN, NaN, NaN, 'o', 'MarkerFaceColor', o_color, 'MarkerEdgeColor', 'w', 'MarkerSize', 10);
h_legend(2) = plot3(ax_main, NaN, NaN, NaN, 'o', 'MarkerFaceColor', a_color, 'MarkerEdgeColor', 'w', 'MarkerSize', 8);
h_legend(3) = plot3(ax_main, NaN, NaN, NaN, 'o', 'MarkerFaceColor', b_color, 'MarkerEdgeColor', 'w', 'MarkerSize', 9);
h_legend(4) = plot3(ax_main, NaN, NaN, NaN, '^', 'MarkerFaceColor', tet_void_color, 'MarkerEdgeColor', 'w', 'MarkerSize', 8);
h_legend(5) = plot3(ax_main, NaN, NaN, NaN, 'd', 'MarkerFaceColor', oct_void_color, 'MarkerEdgeColor', 'w', 'MarkerSize', 7);
h_legend(6) = plot3(ax_main, NaN, NaN, NaN, 's', 'MarkerFaceColor', empty_tet_color, 'MarkerEdgeColor', 'w', 'MarkerSize', 6);
lgd = legend(ax_main, h_legend, {'O^{2-}', 'A^{2+} (tet)', 'B^{3+} (oct)', 'Tet (filled)', 'Oct (filled)', 'Tet (empty)'}, ...
             'Location', 'northeast', 'FontSize', 8);
set(lgd, 'TextColor', 'w', 'Color', [0.12 0.12 0.18], 'EdgeColor', [0.3 0.3 0.4], 'AutoUpdate', 'off');

empty_tet_shown = false(size(empty_tet_pos, 1), 1);
empty_oct_shown = false(size(empty_oct_pos, 1), 1);
drop_height = 0.4;
nsteps = 2;

for L = 1:length(layer_info)
    if ~ishandle(fig), return; end

    z_now = layer_info(L).z;
    ltype = layer_info(L).type;

    draw_stacking_panel(ax_stack, layer_info, L);

    title(ax_main, sprintf('Spinel | Building %s (Layer %d/%d)', layer_info(L).label, L, length(layer_info)), ...
          'Color', 'w', 'FontSize', 13, 'FontWeight', 'bold');

    if contains(ltype, 'o')
        idx = abs(o_pos(:,3) - z_now) < 0.01;
        pts = o_pos(idx, :);
        for i = 1:size(pts, 1)
            if ~ishandle(fig), return; end
            animate_atom_drop(ax_main, pts(i,:), 0.11, o_color, 0.85, drop_height, nsteps);
        end
    end

    if contains(ltype, 'a')
        idx = abs(a_pos(:,3) - z_now) < 0.01;
        pts = a_pos(idx, :);
        for i = 1:size(pts, 1)
            if ~ishandle(fig), return; end
            animate_atom_drop(ax_main, pts(i,:), 0.07, a_color, 0.92, drop_height, nsteps);
            draw_tetrahedron_marker(ax_main, pts(i,:), a/10, tet_void_color, 0.28);
        end
    end

    if contains(ltype, 'b')
        idx = abs(b_pos(:,3) - z_now) < 0.01;
        pts = b_pos(idx, :);
        for i = 1:size(pts, 1)
            if ~ishandle(fig), return; end
            animate_atom_drop(ax_main, pts(i,:), 0.08, b_color, 0.92, drop_height, nsteps);
            draw_octahedron_marker(ax_main, pts(i,:), a/6, oct_void_color, 0.22);
        end
    end

    new_empty_tet_idx = find(~empty_tet_shown & empty_tet_pos(:,3) <= z_now + 0.1);
    for i = 1:length(new_empty_tet_idx)
        if ~ishandle(fig), return; end
        idx = new_empty_tet_idx(i);
        draw_tetrahedron_marker(ax_main, empty_tet_pos(idx,:), a/12, empty_tet_color, 0.12);
        empty_tet_shown(idx) = true;
    end

    new_empty_oct_idx = find(~empty_oct_shown & empty_oct_pos(:,3) <= z_now + 0.1);
    for i = 1:length(new_empty_oct_idx)
        if ~ishandle(fig), return; end
        idx = new_empty_oct_idx(i);
        draw_octahedron_marker(ax_main, empty_oct_pos(idx,:), a/8, empty_oct_color, 0.10);
        empty_oct_shown(idx) = true;
    end

    drawnow;
    pause(0.02);
end

title(ax_main, 'Spinel (AB_2O_4) - Layer Stacking Complete', 'Color', [0.9 0.95 1.0], 'FontSize', 14, 'FontWeight', 'bold');

for angle = 135:3:495
    if ~ishandle(fig), break; end
    view(ax_main, angle, 25 + 8*sin(angle*pi/90));
    drawnow;
    pause(0.02);
end
rotate3d(ax_main, 'on');
fprintf(' Simulation complete. Use mouse to rotate.\n');

function pos = generate_positions(basis, nx, ny, nz, a)
    pos = [];
    for ix = 0:nx-1
        for iy = 0:ny-1
            for iz = 0:nz-1
                block = (basis + [ix iy iz]) * a;
                pos = [pos; block];
            end
        end
    end
end

function animate_atom_drop(ax, target, radius, color, alpha, drop_h, nsteps)
    [X, Y, Z] = sphere(16);
    h = [];
    for s = 1:nsteps
        if ~isempty(h) && ishandle(h), delete(h); end
        t = (s/nsteps)^0.5;
        pos = target + [0 0 drop_h*(1-t)];
        h = surf(ax, X*radius+pos(1), Y*radius+pos(2), Z*radius+pos(3), ...
                 'FaceColor', color, 'EdgeColor', 'none', 'FaceAlpha', alpha, ...
                 'FaceLighting', 'gouraud', 'AmbientStrength', 0.5, ...
                 'DiffuseStrength', 0.8, 'SpecularStrength', 0.8);
        drawnow;
    end
end

function draw_tetrahedron_marker(ax, center, size, color, alpha)
    c = center; s = size;
    verts = [c(1)+s c(2)+s c(3)+s; c(1)+s c(2)-s c(3)-s;
             c(1)-s c(2)+s c(3)-s; c(1)-s c(2)-s c(3)+s];
    faces = [1 2 3; 1 2 4; 1 3 4; 2 3 4];
    patch(ax, 'Vertices', verts, 'Faces', faces, 'FaceColor', color, ...
          'FaceAlpha', alpha, 'EdgeColor', color, 'LineWidth', 0.8);
end

function draw_octahedron_marker(ax, center, half_diag, color, alpha)
    c = center; hd = half_diag;
    verts = [c(1)+hd c(2) c(3); c(1)-hd c(2) c(3);
             c(1) c(2)+hd c(3); c(1) c(2)-hd c(3);
             c(1) c(2) c(3)+hd; c(1) c(2) c(3)-hd];
    faces = [1 3 5; 1 5 4; 1 4 6; 1 6 3; 2 3 5; 2 5 4; 2 4 6; 2 6 3];
    patch(ax, 'Vertices', verts, 'Faces', faces, 'FaceColor', color, ...
          'FaceAlpha', alpha, 'EdgeColor', color, 'LineWidth', 0.8);
end

function draw_stacking_panel(ax, layer_info, current)
    axes(ax); cla; hold on;
    set(ax, 'Color', [0.07 0.07 0.12]); axis off;
    xlim([0 1]); ylim([0 1]);

    n = length(layer_info);

    for i = 1:n
        y = 1 - i/(n+1);
        ltype = layer_info(i).type;

        if contains(ltype, 'o')
            c = [0.92 0.35 0.35];
        elseif contains(ltype, 'a')
            c = [0.25 0.48 0.92];
        elseif contains(ltype, 'b')
            c = [0.65 0.25 0.85];
        else
            c = [0.5 0.5 0.5];
        end

        if i == current
            edge = [1 1 1]; lw = 2; fa = 1.0;
        elseif i < current
            edge = c*0.8; lw = 1; fa = 0.9;
        else
            edge = c*0.4; lw = 0.5; fa = 0.3;
        end

        for j = 1:4
            th = linspace(0, 2*pi, 24);
            r = 0.028;
            xc = 0.35 + (j-1)*0.08;
            fill(ax, xc + r*cos(th), y + r*sin(th), c, 'EdgeColor', edge, 'LineWidth', lw, 'FaceAlpha', fa);
        end

        tc = [0.7 0.7 0.7];
        if i == current, tc = [1.0 0.85 0.35]; end
        if i < current, tc = [0.9 0.9 0.9]; end
        text(ax, 0.02, y, layer_info(i).label, 'Color', tc, 'FontSize', 8, 'FontWeight', 'bold');
    end

    title(ax, sprintf('Layer Stack (%d/%d)', current, n), 'Color', 'w', 'FontSize', 11, 'FontWeight', 'bold');
end

function draw_info_panel(ax, n_o, n_a, n_b, n_empty_tet, n_empty_oct)
    axes(ax); cla; hold on;
    axis off; set(ax, 'Color', [0.07 0.07 0.12]);

    info = {
        'SPINEL (AB_2O_4) Structure'
        ''
        'Crystal System: Cubic (Fd3m)'
        'Lattice: FCC of O^{2-} anions'
        sprintf('Total O atoms: %d', n_o)
        sprintf('A atoms (tet): %d', n_a)
        sprintf('B atoms (oct): %d', n_b)
        ''
        'Void Occupation:'
        '  A in 1/8 tetrahedral voids'
        '  B in 1/2 octahedral voids'
        sprintf('  Empty tet: %d', n_empty_tet)
        sprintf('  Empty oct: %d', n_empty_oct)
        ''
        'Coordination: A=4, B=6'
        'Example: MgAl_2O_4'
    };

    y = 0.95;
    for i = 1:length(info)
        if i == 1
            text(0.02, y, info{i}, 'Units', 'normalized', 'Color', [0.9 0.95 1.0], 'FontSize', 12, 'FontWeight', 'bold');
        else
            text(0.02, y, info{i}, 'Units', 'normalized', 'Color', [0.85 0.85 0.9], 'FontSize', 9);
        end
        y = y - 0.055;
    end
end
