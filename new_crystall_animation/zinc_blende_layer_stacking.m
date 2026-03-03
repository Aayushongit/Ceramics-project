clear; clc; close all;

fcc = [0 0 0; 0.5 0.5 0; 0.5 0 0.5; 0 0.5 0.5];
tet_filled = [0.25 0.25 0.25; 0.75 0.75 0.25; 0.75 0.25 0.75; 0.25 0.75 0.75];
tet_empty = [0.75 0.25 0.25; 0.25 0.75 0.25; 0.25 0.25 0.75; 0.75 0.75 0.75];
oct_all = [0.5 0.5 0.5; 0.5 0 0; 0 0.5 0; 0 0 0.5];

cfg = struct;
cfg.name = 'Zinc Blende (ZnS) layer stacking';
cfg.window_title = 'Zinc Blende Layer Stacking Animation';
cfg.stacking_line = 'FCC anion layers with half of tetrahedral sites occupied';
cfg.info_lines = {
    'Formula: ZnS'
    'Cubic system: F-43m'
    'Atoms per cell: 4 Zn + 4 S'
    'Coordination: Zn = 4, S = 4'
    'Layer build: S layers + Zn in half tet sites'
};
cfg.a = 1;
cfg.grid = [3 3 2];
cfg.drop_height = 0.8;
cfg.layer_steps = 5;
cfg.void_steps = 3;
cfg.layer_pause = 0.04;
cfg.atom_quality = 14;
cfg.void_quality = 10;

cfg.species(1) = struct('name', 'S anion layer', 'basis', fcc, 'color', [0.94 0.72 0.24], 'radius', 0.14, 'alpha', 0.90);
cfg.species(2) = struct('name', 'Zn cation layer', 'basis', tet_filled, 'color', [0.25 0.48 0.92], 'radius', 0.10, 'alpha', 0.92);

cfg.voids(1) = struct('name', 'Tetra void filled', 'basis', tet_filled, 'color', [0.20 0.82 0.35], 'radius', 0.050, 'alpha', 0.32);
cfg.voids(2) = struct('name', 'Tetra void empty', 'basis', tet_empty, 'color', [0.55 0.55 0.55], 'radius', 0.046, 'alpha', 0.26);
cfg.voids(3) = struct('name', 'Octa void empty', 'basis', oct_all, 'color', [1.00 0.55 0.10], 'radius', 0.052, 'alpha', 0.22);

run_layer_stacking_animation_local(cfg);


function run_layer_stacking_animation_local(cfg)
if ~isfield(cfg, 'a')
    cfg.a = 1;
end
if ~isfield(cfg, 'grid')
    cfg.grid = [3 3 2];
end
if ~isfield(cfg, 'atom_quality')
    cfg.atom_quality = 16;
end
if ~isfield(cfg, 'void_quality')
    cfg.void_quality = 12;
end
if ~isfield(cfg, 'layer_steps')
    cfg.layer_steps = 5;
end
if ~isfield(cfg, 'void_steps')
    cfg.void_steps = 3;
end
if ~isfield(cfg, 'layer_pause')
    cfg.layer_pause = 0.04;
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
             'Units', 'pixels', ...
             'Position', [120 80 1050 650], ...
             'Color', [0.02 0.02 0.06], ...
             'NumberTitle', 'off');

ax_main = axes('Parent', fig, 'Position', [0.03 0.08 0.66 0.88]);
ax_stack = axes('Parent', fig, 'Position', [0.72 0.56 0.26 0.40]);
ax_info = axes('Parent', fig, 'Position', [0.72 0.08 0.26 0.44]);

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
margin = max(span) * 0.16 + 0.48 * cfg.a;

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
view(ax_main, 45, 25);
camlight(ax_main, 'headlight');
camlight(ax_main, 'right');
lighting(ax_main, 'gouraud');
material(ax_main, 'shiny');

legend_handles = cell(n_species + n_voids, 1);
legend_labels = cell(n_species + n_voids, 1);
li = 0;
for i = 1:n_species
    li = li + 1;
    legend_handles{li} = plot3(ax_main, NaN, NaN, NaN, 'o', ...
        'MarkerFaceColor', cfg.species(i).color, ...
        'MarkerEdgeColor', 'w', 'MarkerSize', 8);
    legend_labels{li} = cfg.species(i).name;
end
for i = 1:n_voids
    li = li + 1;
    legend_handles{li} = plot3(ax_main, NaN, NaN, NaN, '^', ...
        'MarkerFaceColor', cfg.voids(i).color, ...
        'MarkerEdgeColor', 'w', 'MarkerSize', 7);
    legend_labels{li} = cfg.voids(i).name;
end
lgd = legend(ax_main, [legend_handles{:}], legend_labels, 'Location', 'northeast');
set(lgd, 'TextColor', 'w', 'Color', [0.12 0.12 0.18], 'EdgeColor', [0.30 0.30 0.40], 'FontSize', 8, 'AutoUpdate', 'off');

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

layer_labels = infer_layer_labels(layer_values, atom_pos, cfg.species, tol);
palette = [0.20 0.52 0.95; 1.00 0.35 0.35; 0.30 0.86 0.45; 0.95 0.65 0.20];
update_stacking_panel(ax_stack, layer_labels, 0, palette);

void_totals = zeros(n_voids, 1);
for v = 1:n_voids
    void_totals(v) = size(void_pos{v}, 1);
end
void_visible = zeros(n_voids, 1);

status_handle = init_info_panel(ax_info, cfg, void_totals);
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
    update_stacking_panel(ax_stack, layer_labels, L, palette);

    title(ax_main, sprintf('%s | Placing %s (%d/%d)', cfg.name, layer_labels{L}, L, num_layers), 'Color', 'w', 'FontSize', 14, 'FontWeight', 'bold');

    layer_atom_count = 0;
    for s = 1:n_species
        idx = abs(atom_pos{s}(:,3) - z_now) <= tol;
        if any(idx)
            pts = atom_pos{s}(idx, :);
            animate_layer_drop(ax_main, fig, pts, cfg.species(s).radius, cfg.species(s).color, cfg.species(s).alpha, cfg.drop_height, cfg.layer_steps, cfg.atom_quality);
            layer_atom_count = layer_atom_count + size(pts, 1);
            shown_atoms = shown_atoms + size(pts, 1);
        end
    end

    new_void_count = 0;
    for v = 1:n_voids
        idx_new = find(~shown_void{v} & void_pos{v}(:,3) <= z_now + tol);
        if ~isempty(idx_new)
            p = void_pos{v}(idx_new, :);
            animate_void_appearance(ax_main, fig, p, cfg.voids(v).radius, cfg.voids(v).color, cfg.voids(v).alpha, cfg.void_steps, cfg.void_quality);
            shown_void{v}(idx_new) = true;
            new_void_count = new_void_count + numel(idx_new);
        end
        void_visible(v) = sum(shown_void{v});
    end

    void_parts = cell(1, n_voids);
    for v = 1:n_voids
        void_parts{v} = sprintf('%s %d/%d', cfg.voids(v).name, void_visible(v), void_totals(v));
    end
    set(status_handle, 'String', sprintf('Layer %d/%d  |  Layer atoms %d\nVisible atoms %d\nNew void markers %d\n%s', L, num_layers, layer_atom_count, shown_atoms, new_void_count, strjoin(void_parts, ' | ')));

    drawnow;
    pause(cfg.layer_pause);
end

title(ax_main, sprintf('%s | Layer stacking complete', cfg.name), 'Color', [0.9 0.95 1.0], 'FontSize', 14, 'FontWeight', 'bold');
rotate_camera(ax_main, fig, 0.65);
rotate3d(ax_main, 'on');

end

function layer_labels = infer_layer_labels(layer_values, atom_pos, species, tol)
num_layers = numel(layer_values);
layer_labels = cell(num_layers, 1);
for L = 1:num_layers
    z = layer_values(L);
    counts = zeros(numel(species), 1);
    for s = 1:numel(species)
        counts(s) = sum(abs(atom_pos{s}(:,3) - z) <= tol);
    end
    [~, k] = max(counts);
    layer_labels{L} = sprintf('L%d: %s', L, species(k).name);
end
end

function update_stacking_panel(ax, labels, current_layer, palette)
axes(ax);
cla(ax);
hold(ax, 'on');
set(ax, 'Color', [0.07 0.07 0.12]);
axis(ax, 'off');
xlim(ax, [0 1]);
ylim(ax, [0 1]);

n = numel(labels);
for i = 1:n
    y = 1 - i / (n + 1);
    c = palette(mod(i-1, size(palette, 1)) + 1, :);
    shift = 0.04 * mod(i-1, 3);
    xs = [0.30 0.45 0.60] + shift - 0.03;
    for j = 1:numel(xs)
        th = linspace(0, 2*pi, 32);
        r = 0.035;
        if i == current_layer
            edge = [1 1 1];
            lw = 1.8;
            fa = 1.0;
        else
            edge = c * 0.6;
            lw = 1.0;
            fa = 0.75;
        end
        fill(ax, xs(j) + r*cos(th), y + r*sin(th), c, 'EdgeColor', edge, 'LineWidth', lw, 'FaceAlpha', fa);
    end
    tc = [0.90 0.90 0.90];
    if i == current_layer
        tc = [1.00 0.82 0.35];
    end
    text(ax, 0.06, y, labels{i}, 'Color', tc, 'FontSize', 9, 'FontWeight', 'bold');
end

if current_layer == 0
    title(ax, 'Layer stacking map', 'Color', 'w', 'FontSize', 11, 'FontWeight', 'bold');
else
    title(ax, sprintf('Layer stacking map  |  Active: %d', current_layer), 'Color', 'w', 'FontSize', 11, 'FontWeight', 'bold');
end
end

function status_handle = init_info_panel(ax, cfg, void_totals)
axes(ax);
cla(ax);
hold(ax, 'on');
axis(ax, 'off');
set(ax, 'Color', [0.07 0.07 0.12]);

text(0.04, 0.98, cfg.name, 'Units', 'normalized', 'Color', 'w', 'FontSize', 12, 'FontWeight', 'bold');
text(0.04, 0.90, cfg.stacking_line, 'Units', 'normalized', 'Color', [0.80 0.85 0.95], 'FontSize', 9);

y = 0.84;
n_show = min(4, numel(cfg.info_lines));
for i = 1:n_show
    text(0.04, y, cfg.info_lines{i}, 'Units', 'normalized', 'Color', [0.92 0.92 0.92], 'FontSize', 9);
    y = y - 0.055;
end

text(0.04, 0.44, 'Void targets per view', 'Units', 'normalized', 'Color', [0.90 0.95 1.00], 'FontSize', 10, 'FontWeight', 'bold');
y2 = 0.38;
for v = 1:numel(cfg.voids)
    text(0.04, y2, sprintf('%s: %d', cfg.voids(v).name, void_totals(v)), 'Units', 'normalized', 'Color', [0.90 0.92 0.95], 'FontSize', 9);
    y2 = y2 - 0.05;
end

status_handle = text(0.04, 0.02, '', 'Units', 'normalized', 'Color', [0.84 0.96 0.84], 'FontSize', 9);
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

function animate_layer_drop(ax, fig, points, radius, color, alpha, drop_height, nsteps, quality)
for i = 1:size(points, 1)
    if ~ishandle(fig)
        return;
    end
    start_pos = points(i,:) + [0 0 drop_height];
    end_pos = points(i,:);
    h = [];
    for s = 1:nsteps
        if ~ishandle(fig)
            return;
        end
        if ~isempty(h) && ishandle(h)
            delete(h);
        end
        t = s / nsteps;
        t = 1 - (1 - t)^2;
        pos = start_pos + t * (end_pos - start_pos);
        h = draw_single_sphere(ax, pos, radius, color, alpha, quality);
        drawnow;
        pause(0.002);
    end
end
end

function animate_void_appearance(ax, fig, points, radius, color, alpha, nsteps, quality)
scales = linspace(0.40, 1.00, nsteps);
for k = 1:numel(scales)
    if ~ishandle(fig)
        return;
    end
    rr = radius * scales(k);
    aa = min(0.98, alpha * (0.65 + 0.35 * scales(k)));
    h = draw_spheres(ax, points, rr, color, aa, quality);
    drawnow;
    pause(0.003);
    if k < numel(scales)
        delete([h{:}]);
    end
end
end

function rotate_camera(ax, fig, duration)
steps = 38;
for i = 1:steps
    if ~ishandle(fig)
        return;
    end
    view(ax, 45 + i * 6, 25 + 6 * sin(i * pi / steps));
    drawnow;
    pause(duration / steps);
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

function h = draw_single_sphere(ax, pos, radius, color, alpha, quality)
[X, Y, Z] = sphere(quality);
h = surf(ax, X * radius + pos(1), ...
            Y * radius + pos(2), ...
            Z * radius + pos(3), ...
            'FaceColor', color, ...
            'EdgeColor', 'none', ...
            'FaceAlpha', alpha, ...
            'FaceLighting', 'gouraud', ...
            'AmbientStrength', 0.5, ...
            'DiffuseStrength', 0.8, ...
            'SpecularStrength', 0.8, ...
            'SpecularExponent', 20);
end
