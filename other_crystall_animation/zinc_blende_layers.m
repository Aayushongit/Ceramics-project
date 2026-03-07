clear; clc; close all;

fprintf('\n ZINC BLENDE (ZnS) Layer Stacking Simulation\n');
fprintf(' Building FCC S layers with Zn in HALF of tetrahedral voids\n\n');

a = 1;
nx = 3; ny = 3; nz = 1;

s_color = [0.92 0.72 0.20];
zn_color = [0.25 0.48 0.92];
tet_filled_color = [0.20 0.80 0.35];
tet_empty_color = [0.55 0.55 0.55];
oct_void_color = [1.00 0.55 0.10];

s_basis = [0 0 0; 0.5 0.5 0; 0.5 0 0.5; 0 0.5 0.5];
zn_basis = [0.25 0.25 0.25; 0.75 0.75 0.25; 0.75 0.25 0.75; 0.25 0.75 0.75];
empty_tet_basis = [0.75 0.25 0.25; 0.25 0.75 0.25; 0.25 0.25 0.75; 0.75 0.75 0.75];
oct_basis = [0.5 0 0; 0 0.5 0; 0 0 0.5; 0.5 0.5 0.5];

s_pos = generate_positions(s_basis, nx, ny, nz, a);
zn_pos = generate_positions(zn_basis, nx, ny, nz, a);
empty_tet_pos = generate_positions(empty_tet_basis, nx, ny, nz, a);
oct_pos = generate_positions(oct_basis, nx, ny, nz, a);

[fig, ax_main, ax_stack, ax_info] = create_layer_stacking_figure('Zinc Blende Layer Stacking');
hold on; grid on; box on; axis equal;
set(gca, 'Color', [0.06 0.06 0.12], 'XColor', 'w', 'YColor', 'w', 'ZColor', 'w', ...
         'GridColor', [0.3 0.3 0.35]);
xlabel('X', 'Color', 'w'); ylabel('Y', 'Color', 'w'); zlabel('Z', 'Color', 'w');
view(135, 25);
camlight('headlight'); camlight('right');
lighting gouraud; material shiny;

all_pos = [s_pos; zn_pos; empty_tet_pos; oct_pos];
center = (min(all_pos) + max(all_pos)) / 2;
s_pos = s_pos - center;
zn_pos = zn_pos - center;
empty_tet_pos = empty_tet_pos - center;
oct_pos = oct_pos - center;

margin = max(max(all_pos) - min(all_pos)) * 0.12;
xlim([min(s_pos(:,1))-margin max(s_pos(:,1))+margin]);
ylim([min(s_pos(:,2))-margin max(s_pos(:,2))+margin]);
zlim([min(s_pos(:,3))-margin max(s_pos(:,3))+margin+0.3]);

z_layers_s = unique(round(s_pos(:,3), 4));
z_layers_zn = unique(round(zn_pos(:,3), 4));
all_z = sort(unique([z_layers_s; z_layers_zn]));

layer_info = struct('z', {}, 'type', {}, 'label', {});
for i = 1:length(all_z)
    z = all_z(i);
    is_s = any(abs(z_layers_s - z) < 0.01);
    is_zn = any(abs(z_layers_zn - z) < 0.01);
    if is_s && is_zn
        layer_info(end+1) = struct('z', z, 'type', 'both', 'label', sprintf('S+Zn z=%.2f', z));
    elseif is_s
        layer_info(end+1) = struct('z', z, 'type', 's', 'label', sprintf('S layer z=%.2f', z));
    else
        layer_info(end+1) = struct('z', z, 'type', 'zn', 'label', sprintf('Zn layer z=%.2f', z));
    end
end

draw_info_panel(ax_info, length(s_pos), length(zn_pos), length(empty_tet_pos), length(oct_pos));

h_legend = [];
h_legend(1) = plot3(ax_main, NaN, NaN, NaN, 'o', 'MarkerFaceColor', s_color, 'MarkerEdgeColor', 'w', 'MarkerSize', 10);
h_legend(2) = plot3(ax_main, NaN, NaN, NaN, 'o', 'MarkerFaceColor', zn_color, 'MarkerEdgeColor', 'w', 'MarkerSize', 8);
h_legend(3) = plot3(ax_main, NaN, NaN, NaN, '^', 'MarkerFaceColor', tet_filled_color, 'MarkerEdgeColor', 'w', 'MarkerSize', 8);
h_legend(4) = plot3(ax_main, NaN, NaN, NaN, 's', 'MarkerFaceColor', tet_empty_color, 'MarkerEdgeColor', 'w', 'MarkerSize', 7);
h_legend(5) = plot3(ax_main, NaN, NaN, NaN, 'd', 'MarkerFaceColor', oct_void_color, 'MarkerEdgeColor', 'w', 'MarkerSize', 7);
lgd = legend(ax_main, h_legend, {'S^{2-} (anion)', 'Zn^{2+} (in tet void)', 'Tet void (filled)', 'Tet void (empty)', 'Oct void (empty)'}, ...
             'Location', 'northeast', 'FontSize', 9);
set(lgd, 'TextColor', 'w', 'Color', [0.12 0.12 0.18], 'EdgeColor', [0.3 0.3 0.4], 'AutoUpdate', 'off');

empty_tet_shown = false(size(empty_tet_pos, 1), 1);
oct_shown = false(size(oct_pos, 1), 1);
drop_height = 0.4;
nsteps = 2;

for L = 1:length(layer_info)
    if ~ishandle(fig), return; end

    z_now = layer_info(L).z;
    ltype = layer_info(L).type;

    draw_stacking_panel(ax_stack, layer_info, L);

    title(ax_main, sprintf('Zinc Blende | Building %s (Layer %d/%d)', layer_info(L).label, L, length(layer_info)), ...
          'Color', 'w', 'FontSize', 13, 'FontWeight', 'bold');

    if strcmp(ltype, 's') || strcmp(ltype, 'both')
        idx = abs(s_pos(:,3) - z_now) < 0.01;
        pts = s_pos(idx, :);
        for i = 1:size(pts, 1)
            if ~ishandle(fig), return; end
            animate_atom_drop(ax_main, pts(i,:), 0.12, s_color, 0.88, drop_height, nsteps);
        end
    end

    if strcmp(ltype, 'zn') || strcmp(ltype, 'both')
        idx = abs(zn_pos(:,3) - z_now) < 0.01;
        pts = zn_pos(idx, :);
        for i = 1:size(pts, 1)
            if ~ishandle(fig), return; end
            animate_atom_drop(ax_main, pts(i,:), 0.08, zn_color, 0.92, drop_height, nsteps);
            draw_tetrahedron_marker(ax_main, pts(i,:), a/8, tet_filled_color, 0.28);
        end
    end

    new_empty_idx = find(~empty_tet_shown & empty_tet_pos(:,3) <= z_now + 0.1);
    for i = 1:length(new_empty_idx)
        if ~ishandle(fig), return; end
        idx = new_empty_idx(i);
        draw_tetrahedron_marker(ax_main, empty_tet_pos(idx,:), a/9, tet_empty_color, 0.15);
        empty_tet_shown(idx) = true;
    end

    new_oct_idx = find(~oct_shown & oct_pos(:,3) <= z_now + 0.1);
    for i = 1:length(new_oct_idx)
        if ~ishandle(fig), return; end
        idx = new_oct_idx(i);
        draw_octahedron_marker(ax_main, oct_pos(idx,:), a/6, oct_void_color, 0.12);
        oct_shown(idx) = true;
    end

    drawnow;
    pause(0.02);
end

title(ax_main, 'Zinc Blende (ZnS) - Layer Stacking Complete', 'Color', [0.9 0.95 1.0], 'FontSize', 14, 'FontWeight', 'bold');

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
    colors_map = struct('s', [0.92 0.72 0.20], 'zn', [0.25 0.48 0.92], 'both', [0.6 0.5 0.7]);

    for i = 1:n
        y = 1 - i/(n+1);
        c = colors_map.(layer_info(i).type);

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

function draw_info_panel(ax, n_s, n_zn, n_empty_tet, n_oct)
    axes(ax); cla; hold on;
    axis off; set(ax, 'Color', [0.07 0.07 0.12]);

    info = {
        'ZINC BLENDE (ZnS) Structure'
        ''
        'Crystal System: Cubic (F-43m)'
        'Lattice: FCC of S^{2-} anions'
        sprintf('Total S atoms: %d', n_s)
        sprintf('Total Zn atoms: %d', n_zn)
        'Zn occupies HALF tet voids'
        sprintf('Tet voids (empty): %d', n_empty_tet)
        sprintf('Oct voids (empty): %d', n_oct)
        ''
        'Coordination Numbers:'
        '  Zn: 4 (tetrahedral)'
        '  S: 4 (tetrahedral)'
        ''
        'Stacking: ABCABC (FCC)'
        'Alternating tet site occupation'
    };

    y = 0.95;
    for i = 1:length(info)
        if i == 1
            text(0.02, y, info{i}, 'Units', 'normalized', 'Color', [0.9 0.95 1.0], 'FontSize', 12, 'FontWeight', 'bold');
        else
            text(0.02, y, info{i}, 'Units', 'normalized', 'Color', [0.85 0.85 0.9], 'FontSize', 9);
        end
        y = y - 0.058;
    end
end

function [fig, ax_main, ax_stack, ax_info] = create_layer_stacking_figure(fig_name)
    monitor = get_active_monitor();
    fig = figure('Name', fig_name, ...
                 'Units', 'pixels', 'Position', get_figure_position(monitor), ...
                 'Color', [0.02 0.02 0.06], 'NumberTitle', 'off', 'Resize', 'on');
    ax_main = axes('Parent', fig, 'Units', 'pixels');
    ax_stack = axes('Parent', fig, 'Units', 'pixels');
    ax_info = axes('Parent', fig, 'Units', 'pixels');
    setappdata(fig, 'layer_axes', [ax_main ax_stack ax_info]);
    set(fig, 'SizeChangedFcn', @resize_layer_stacking_figure);
    resize_layer_stacking_figure(fig, []);
    axes(ax_main);
end

function resize_layer_stacking_figure(fig, ~)
    if ~ishandle(fig)
        return;
    end

    axes_handles = getappdata(fig, 'layer_axes');
    if numel(axes_handles) ~= 3 || any(~ishandle(axes_handles))
        return;
    end

    pos = get(fig, 'Position');
    w = max(pos(3), 320);
    h = max(pos(4), 240);
    pad = max(14, round(min(w, h) * 0.02));
    gap = max(10, round(min(w, h) * 0.015));
    inner_w = max(w - 2 * pad, 120);
    inner_h = max(h - 2 * pad, 120);

    if w < 900 || w / h < 1.15
        panel_h_max = max(floor((inner_h - gap) * 0.38), 90);
        panel_h = min(max(round(inner_h * 0.24), 110), panel_h_max);
        main_h = inner_h - panel_h - gap;
        left_w = floor((inner_w - gap) / 2);
        right_w = inner_w - left_w - gap;

        set(axes_handles(1), 'Position', [pad pad + panel_h + gap inner_w main_h]);
        set(axes_handles(2), 'Position', [pad pad left_w panel_h]);
        set(axes_handles(3), 'Position', [pad + left_w + gap pad right_w panel_h]);
    else
        side_w_max = max(floor((inner_w - gap) * 0.38), 180);
        side_w = min(max(round(inner_w * 0.31), 280), side_w_max);
        main_w = inner_w - side_w - gap;
        lower_h = floor((inner_h - gap) / 2);
        upper_h = inner_h - lower_h - gap;
        side_x = pad + main_w + gap;

        set(axes_handles(1), 'Position', [pad pad main_w inner_h]);
        set(axes_handles(2), 'Position', [side_x pad + lower_h + gap side_w upper_h]);
        set(axes_handles(3), 'Position', [side_x pad side_w lower_h]);
    end
end

function monitor = get_active_monitor()
    monitors = get(0, 'MonitorPositions');
    if isempty(monitors)
        monitor = get(0, 'ScreenSize');
        return;
    end

    pointer = get(0, 'PointerLocation');
    idx = find(pointer(1) >= monitors(:, 1) & ...
               pointer(1) <= monitors(:, 1) + monitors(:, 3) & ...
               pointer(2) >= monitors(:, 2) & ...
               pointer(2) <= monitors(:, 2) + monitors(:, 4), 1, 'first');

    if isempty(idx)
        idx = 1;
    end
    monitor = monitors(idx, :);
end

function pos = get_figure_position(monitor)
    margin_x = max(20, round(monitor(3) * 0.04));
    margin_y = max(30, round(monitor(4) * 0.07));
    usable_w = max(monitor(3) - 2 * margin_x, 420);
    usable_h = max(monitor(4) - 2 * margin_y, 320);
    w = min(round(monitor(3) * 0.88), usable_w);
    h = min(round(monitor(4) * 0.84), usable_h);
    x = monitor(1) + round((monitor(3) - w) / 2);
    y = monitor(2) + round((monitor(4) - h) / 2);
    pos = [x y w h];
end
