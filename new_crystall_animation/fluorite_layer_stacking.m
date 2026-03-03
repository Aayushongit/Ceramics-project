clear; clc; close all;

fcc = [0 0 0; 0.5 0.5 0; 0.5 0 0.5; 0 0.5 0.5];
tet_all = [0.25 0.25 0.25; 0.25 0.75 0.75; 0.75 0.25 0.75; 0.75 0.75 0.25; ...
           0.75 0.25 0.25; 0.25 0.75 0.25; 0.25 0.25 0.75; 0.75 0.75 0.75];
oct_all = [0.5 0.5 0.5; 0.5 0 0; 0 0.5 0; 0 0 0.5];

cfg = struct;
cfg.name = 'Fluorite (CaF2) layer stacking';
cfg.window_title = 'Fluorite Layer Stacking Animation';
cfg.stacking_line = 'FCC cation layers with all tetrahedral sites occupied';
cfg.info_lines = {
    'Formula: CaF2'
    'Cubic system: Fm3m'
    'Atoms per cell: 4 Ca + 8 F'
    'Coordination: Ca = 8, F = 4'
    'Layer build: Ca layers + F in all tet sites'
};
cfg.a = 1;
cfg.grid = [3 3 2];
cfg.drop_height = 0.8;
cfg.layer_steps = 7;
cfg.void_steps = 4;
cfg.layer_pause = 0.12;
cfg.atom_quality = 14;
cfg.void_quality = 10;

cfg.species(1) = struct('name', 'Ca cation layer', 'basis', fcc, 'color', [0.25 0.48 0.92], 'radius', 0.14, 'alpha', 0.90);
cfg.species(2) = struct('name', 'F anion layer', 'basis', tet_all, 'color', [0.92 0.32 0.32], 'radius', 0.09, 'alpha', 0.92);

cfg.voids(1) = struct('name', 'Tetra void filled', 'basis', tet_all, 'color', [0.20 0.82 0.35], 'radius', 0.048, 'alpha', 0.32);
cfg.voids(2) = struct('name', 'Octa void empty', 'basis', oct_all, 'color', [1.00 0.55 0.10], 'radius', 0.052, 'alpha', 0.24);

run_layer_stacking_animation_local(cfg);


function run_layer_stacking_animation_local(cfg)
if ~isfield(cfg, 'a')
    cfg.a = 1;
end
if ~isfield(cfg, 'grid')
    cfg.grid = [3 3 2];
end
if ~isfield(cfg, 'atom_quality')
    cfg.atom_quality = 14;
end
if ~isfield(cfg, 'void_quality')
    cfg.void_quality = 10;
end
if ~isfield(cfg, 'layer_steps')
    cfg.layer_steps = 7;
end
if ~isfield(cfg, 'void_steps')
    cfg.void_steps = 4;
end
if ~isfield(cfg, 'layer_pause')
    cfg.layer_pause = 0.12;
end
if ~isfield(cfg, 'drop_height')
    cfg.drop_height = 0.9 * cfg.a;
end
if ~isfield(cfg, 'window_title')
    cfg.window_title = cfg.name;
end
if ~isfield(cfg, 'stacking_line')
    cfg.stacking_line = '';
end
if ~isfield(cfg, 'info_lines')
    cfg.info_lines = {};
end

fig = figure('Name', cfg.window_title, ...
             'Units', 'normalized', ...
             'OuterPosition', [0.08 0.08 0.84 0.82], ...
             'Color', [0.02 0.02 0.06], ...
             'NumberTitle', 'off');

ax_main = axes('Parent', fig, 'Position', [0.05 0.10 0.68 0.84]);
ax_info = axes('Parent', fig, 'Position', [0.76 0.57 0.21 0.35]);
ax_voids = axes('Parent', fig, 'Position', [0.76 0.10 0.21 0.42]);

n_species = numel(cfg.species);
n_voids = numel(cfg.voids);

atom_pos = cell(n_species, 1);
for i = 1:n_species
    atom_pos{i} = replicate_positions(cfg.species(i).basis, cfg.grid, cfg.a);
end

void_pos = cell(n_voids, 1);
for i = 1:n_voids
    void_pos{i} = replicate_positions(cfg.voids(i).basis, cfg.grid, cfg.a);
end

all_pos = [];
for i = 1:n_species
    all_pos = [all_pos; atom_pos{i}];
end
for i = 1:n_voids
    all_pos = [all_pos; void_pos{i}];
end

mins = min(all_pos, [], 1);
maxs = max(all_pos, [], 1);
center = (mins + maxs) / 2;
for i = 1:n_species
    atom_pos{i} = atom_pos{i} - center;
end
for i = 1:n_voids
    void_pos{i} = void_pos{i} - center;
end
all_pos = all_pos - center;
mins = min(all_pos, [], 1);
maxs = max(all_pos, [], 1);
span = maxs - mins;
margin = max(span) * 0.14 + 0.45 * cfg.a;

axes(ax_main);
hold(ax_main, 'on');
grid(ax_main, 'on');
box(ax_main, 'on');
axis(ax_main, 'equal');
set(ax_main, 'Color', [0.06 0.06 0.12], ...
             'XColor', 'w', ...
             'YColor', 'w', ...
             'ZColor', 'w', ...
             'GridColor', [0.30 0.30 0.35]);
xlim(ax_main, [mins(1)-margin maxs(1)+margin]);
ylim(ax_main, [mins(2)-margin maxs(2)+margin]);
zlim(ax_main, [mins(3)-margin maxs(3)+margin]);
xlabel(ax_main, 'X', 'Color', 'w');
ylabel(ax_main, 'Y', 'Color', 'w');
zlabel(ax_main, 'Z', 'Color', 'w');
view(ax_main, 42, 24);
camlight(ax_main, 'headlight');
camlight(ax_main, 'right');
lighting(ax_main, 'gouraud');
material(ax_main, 'shiny');

plot_legend_handles = cell(n_species + n_voids, 1);
plot_legend_labels = cell(n_species + n_voids, 1);
legend_idx = 0;
for i = 1:n_species
    legend_idx = legend_idx + 1;
    plot_legend_handles{legend_idx} = plot3(ax_main, NaN, NaN, NaN, 'o', 'MarkerFaceColor', cfg.species(i).color, 'MarkerEdgeColor', 'w', 'MarkerSize', 8);
    plot_legend_labels{i} = cfg.species(i).name;
end
for i = 1:n_voids
    legend_idx = legend_idx + 1;
    plot_legend_handles{legend_idx} = plot3(ax_main, NaN, NaN, NaN, '^', 'MarkerFaceColor', cfg.voids(i).color, 'MarkerEdgeColor', 'w', 'MarkerSize', 7);
    plot_legend_labels{n_species+i} = cfg.voids(i).name;
end
lgd = legend(ax_main, [plot_legend_handles{:}], plot_legend_labels, 'Location', 'northeast');
set(lgd, 'TextColor', 'w', 'Color', [0.12 0.12 0.18], 'EdgeColor', [0.30 0.30 0.40], 'FontSize', 8);

draw_info_panel(ax_info, cfg);
status_handle = text(ax_info, 0.04, 0.02, '', 'Units', 'normalized', 'Color', [0.85 0.95 0.85], 'FontSize', 9);

tol = max(cfg.a * 1e-3, 1e-4);
layer_values = [];
for i = 1:n_species
    zvals = atom_pos{i}(:,3);
    zvals = round(zvals / tol) * tol;
    layer_values = [layer_values; zvals];
end
layer_values = unique(layer_values);
layer_values = sort(layer_values);
num_layers = numel(layer_values);

void_totals = zeros(n_voids, 1);
for v = 1:n_voids
    void_totals(v) = size(void_pos{v}, 1);
end
void_visible = zeros(n_voids, 1);

axes(ax_voids);
cla(ax_voids);
hold(ax_voids, 'on');
xv = 1:n_voids;
bar(ax_voids, xv - 0.16, void_totals, 0.30, 'FaceColor', [0.38 0.38 0.40], 'EdgeColor', 'w');
h_visible = bar(ax_voids, xv + 0.16, void_visible, 0.30, 'FaceColor', [0.20 0.75 0.35], 'EdgeColor', 'w');
set(ax_voids, 'Color', [0.08 0.08 0.13], 'XColor', 'w', 'YColor', 'w', 'GridColor', [0.30 0.30 0.35]);
grid(ax_voids, 'on');
xticks(ax_voids, xv);
xticklabels(ax_voids, {cfg.voids.name});
ylim(ax_voids, [0 max(void_totals)*1.15 + 1]);
ylabel(ax_voids, 'Count', 'Color', 'w');
title(ax_voids, 'Void visibility', 'Color', 'w', 'FontSize', 10, 'FontWeight', 'bold');

shown_void = cell(n_voids, 1);
for i = 1:n_voids
    shown_void{i} = false(size(void_pos{i}, 1), 1);
end

shown_atoms = 0;

for L = 1:num_layers
    if ~ishandle(fig)
        return;
    end

    z_now = layer_values(L);

    for s = 1:n_species
        idx = abs(atom_pos{s}(:,3) - z_now) <= tol;
        if any(idx)
            layer_points = atom_pos{s}(idx, :);
            animate_drop(ax_main, fig, layer_points, cfg.species(s).radius, cfg.species(s).color, cfg.species(s).alpha, cfg.drop_height, cfg.layer_steps, cfg.atom_quality);
            shown_atoms = shown_atoms + size(layer_points, 1);
        end
    end

    for v = 1:n_voids
        idx_new = find(~shown_void{v} & void_pos{v}(:,3) <= z_now + tol);
        if ~isempty(idx_new)
            p = void_pos{v}(idx_new, :);
            animate_void(ax_main, fig, p, cfg.voids(v).radius, cfg.voids(v).color, cfg.voids(v).alpha, cfg.void_steps, cfg.void_quality);
            shown_void{v}(idx_new) = true;
        end
        void_visible(v) = sum(shown_void{v});
    end

    set(h_visible, 'YData', void_visible);

    void_parts = cell(1, n_voids);
    for v = 1:n_voids
        void_parts{v} = sprintf('%s %d/%d', cfg.voids(v).name, void_visible(v), void_totals(v));
    end
    void_text = strjoin(void_parts, ' | ');

    title(ax_main, sprintf('%s | Layer %d/%d | z = %.2f | Visible atoms = %d', cfg.name, L, num_layers, z_now, shown_atoms), 'Color', 'w', 'FontSize', 14, 'FontWeight', 'bold');
    set(status_handle, 'String', sprintf('Layer %d/%d | Atoms %d\n%s', L, num_layers, shown_atoms, void_text));

    drawnow;
    pause(cfg.layer_pause);
end

title(ax_main, sprintf('%s | Layer stacking complete', cfg.name), 'Color', [0.9 0.95 1.0], 'FontSize', 14, 'FontWeight', 'bold');
rotate3d(ax_main, 'on');

end

function positions = replicate_positions(basis, grid, a)
positions = [];
for ix = 0:grid(1)-1
    for iy = 0:grid(2)-1
        for iz = 0:grid(3)-1
            shift = [ix iy iz];
            block = (basis + shift) * a;
            positions = [positions; block];
        end
    end
end
end

function animate_drop(ax, fig, points, radius, color, alpha, drop_height, nsteps, quality)
for k = 1:nsteps
    if ~ishandle(fig)
        return;
    end
    t = k / nsteps;
    t = 1 - (1 - t)^2;
    p = points;
    p(:,3) = points(:,3) + (1 - t) * drop_height;
    h = draw_spheres(ax, p, radius, color, alpha, quality);
    drawnow;
    if k < nsteps
        delete([h{:}]);
    end
end
end

function animate_void(ax, fig, points, radius, color, alpha, nsteps, quality)
scales = linspace(0.45, 1.0, nsteps);
for k = 1:numel(scales)
    if ~ishandle(fig)
        return;
    end
    r = radius * scales(k);
    a = min(0.98, alpha * (0.65 + 0.35 * scales(k)));
    h = draw_spheres(ax, points, r, color, a, quality);
    drawnow;
    if k < numel(scales)
        delete([h{:}]);
    end
end
end

function h = draw_spheres(ax, points, radius, color, alpha, quality)
[X, Y, Z] = sphere(quality);
h = cell(size(points, 1), 1);
for i = 1:size(points, 1)
    h{i} = surf(ax, X * radius + points(i,1), ...
                    Y * radius + points(i,2), ...
                    Z * radius + points(i,3), ...
                    'FaceColor', color, ...
                    'EdgeColor', 'none', ...
                    'FaceAlpha', alpha, ...
                    'FaceLighting', 'gouraud', ...
                    'AmbientStrength', 0.5, ...
                    'DiffuseStrength', 0.8, ...
                    'SpecularStrength', 0.8, ...
                    'SpecularExponent', 20);
end
end

function draw_info_panel(ax, cfg)
axes(ax);
cla(ax);
hold(ax, 'on');
axis(ax, 'off');
set(ax, 'Color', [0.07 0.07 0.12]);

text(0.04, 0.98, cfg.name, 'Units', 'normalized', 'Color', 'w', 'FontSize', 12, 'FontWeight', 'bold');
text(0.04, 0.90, cfg.stacking_line, 'Units', 'normalized', 'Color', [0.8 0.85 0.95], 'FontSize', 9);

y = 0.84;
n_show = min(3, numel(cfg.info_lines));
for i = 1:n_show
    text(0.04, y, cfg.info_lines{i}, 'Units', 'normalized', 'Color', [0.92 0.92 0.92], 'FontSize', 9);
    y = y - 0.055;
end

text(0.04, 0.28, 'Main legend shows atom and void colors', 'Units', 'normalized', 'Color', [0.9 0.95 1.0], 'FontSize', 9);
text(0.04, 0.20, 'Rotate: mouse drag', 'Units', 'normalized', 'Color', [0.9 0.95 1.0], 'FontSize', 9);
text(0.04, 0.13, 'Zoom: scroll', 'Units', 'normalized', 'Color', [0.9 0.95 1.0], 'FontSize', 9);
end
