function run_layer_stacking_animation(cfg)
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
             'OuterPosition', [0.02 0.04 0.96 0.90], ...
             'Color', [0.02 0.02 0.06], ...
             'NumberTitle', 'off');

ax_main = axes('Parent', fig, 'Position', [0.03 0.08 0.68 0.88]);
ax_info = axes('Parent', fig, 'Position', [0.74 0.56 0.24 0.40]);
ax_layers = axes('Parent', fig, 'Position', [0.74 0.32 0.24 0.20]);
ax_voids = axes('Parent', fig, 'Position', [0.74 0.08 0.24 0.20]);

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

layer_counts = zeros(num_layers, 1);
for L = 1:num_layers
    z_now = layer_values(L);
    count_here = 0;
    for s = 1:n_species
        idx = abs(atom_pos{s}(:,3) - z_now) <= tol;
        count_here = count_here + sum(idx);
    end
    layer_counts(L) = count_here;
end

axes(ax_layers);
cla(ax_layers);
hold(ax_layers, 'on');
h_layer = bar(ax_layers, 1:num_layers, layer_counts, 0.7, 'FaceColor', 'flat', 'EdgeColor', 'w');
base_c = repmat([0.30 0.45 0.85], num_layers, 1);
set(h_layer, 'CData', base_c);
set(ax_layers, 'Color', [0.08 0.08 0.13], 'XColor', 'w', 'YColor', 'w', 'GridColor', [0.30 0.30 0.35]);
grid(ax_layers, 'on');
xlim(ax_layers, [0.5 num_layers+0.5]);
ylim(ax_layers, [0 max(layer_counts)*1.15 + 1]);
if num_layers <= 16
    xticks(ax_layers, 1:num_layers);
else
    xticks(ax_layers, round(linspace(1, num_layers, 12)));
end
xlabel(ax_layers, 'Layer index', 'Color', 'w');
ylabel(ax_layers, 'Atoms in layer', 'Color', 'w');
title(ax_layers, 'Layer population', 'Color', 'w', 'FontSize', 10, 'FontWeight', 'bold');

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
xtickangle(ax_voids, 20);
ylim(ax_voids, [0 max(void_totals)*1.15 + 1]);
ylabel(ax_voids, 'Count', 'Color', 'w');
title(ax_voids, 'Void count: total vs visible', 'Color', 'w', 'FontSize', 10, 'FontWeight', 'bold');
legend(ax_voids, {'Total', 'Visible'}, 'TextColor', 'w', 'Color', [0.12 0.12 0.18], 'Location', 'northwest');

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

    cdata = base_c;
    cdata(L,:) = [1.0 0.58 0.22];
    set(h_layer, 'CData', cdata);
    set(h_visible, 'YData', void_visible);

    void_text = '';
    for v = 1:n_voids
        void_text = sprintf('%s%s: %d / %d\n', void_text, cfg.voids(v).name, void_visible(v), void_totals(v));
    end

    title(ax_main, sprintf('%s | Layer %d/%d | z = %.2f | Visible atoms = %d', cfg.name, L, num_layers, z_now, shown_atoms), 'Color', 'w', 'FontSize', 14, 'FontWeight', 'bold');
    set(status_handle, 'String', sprintf('Current layer: %d/%d\nVisible atoms: %d\n%s', L, num_layers, shown_atoms, void_text));

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
for i = 1:numel(cfg.info_lines)
    text(0.04, y, cfg.info_lines{i}, 'Units', 'normalized', 'Color', [0.92 0.92 0.92], 'FontSize', 9);
    y = y - 0.055;
end

y = max(0.42, y - 0.02);
text(0.04, y, 'Output legend', 'Units', 'normalized', 'Color', [0.9 0.95 1.0], 'FontSize', 10, 'FontWeight', 'bold');
y = y - 0.06;

for i = 1:numel(cfg.species)
    rectangle('Position', [0.04 y-0.02 0.06 0.03], 'FaceColor', cfg.species(i).color, 'EdgeColor', 'w');
    text(0.12, y-0.005, cfg.species(i).name, 'Units', 'normalized', 'Color', 'w', 'FontSize', 9);
    y = y - 0.05;
end

for i = 1:numel(cfg.voids)
    rectangle('Position', [0.04 y-0.02 0.06 0.03], 'FaceColor', cfg.voids(i).color, 'EdgeColor', 'w');
    text(0.12, y-0.005, cfg.voids(i).name, 'Units', 'normalized', 'Color', 'w', 'FontSize', 9);
    y = y - 0.05;
end
end
