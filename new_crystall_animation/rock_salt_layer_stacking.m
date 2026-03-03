clear; clc; close all;

fcc = [0 0 0; 0.5 0.5 0; 0.5 0 0.5; 0 0.5 0.5];
oct_all = [0.5 0.5 0.5; 0.5 0 0; 0 0.5 0; 0 0 0.5];
tet_all = [0.25 0.25 0.25; 0.25 0.75 0.75; 0.75 0.25 0.75; 0.75 0.75 0.25; ...
           0.75 0.25 0.25; 0.25 0.75 0.25; 0.25 0.25 0.75; 0.75 0.75 0.75];

cfg = struct;
cfg.name = 'Rock Salt (NaCl) layer stacking';
cfg.window_title = 'Rock Salt Layer Stacking Animation';
cfg.stacking_line = 'FCC anion layers with all octahedral sites occupied';
cfg.info_lines = {
    'Formula: NaCl'
    'Cubic system: Fm3m'
    'Atoms per cell: 4 Na + 4 Cl'
    'Coordination: Na = 6, Cl = 6'
    'Layer build: Cl layers + Na in octa sites'
};
cfg.a = 1;
cfg.grid = [3 3 2];
cfg.drop_height = 0.8;
cfg.layer_steps = 7;
cfg.void_steps = 4;
cfg.layer_pause = 0.12;
cfg.atom_quality = 14;
cfg.void_quality = 10;

cfg.species(1) = struct('name', 'Cl anion layer', 'basis', fcc, 'color', [0.92 0.72 0.20], 'radius', 0.14, 'alpha', 0.90);
cfg.species(2) = struct('name', 'Na cation layer', 'basis', oct_all, 'color', [0.25 0.48 0.92], 'radius', 0.10, 'alpha', 0.92);

cfg.voids(1) = struct('name', 'Octa void filled', 'basis', oct_all, 'color', [1.00 0.55 0.10], 'radius', 0.055, 'alpha', 0.30);
cfg.voids(2) = struct('name', 'Tetra void empty', 'basis', tet_all, 'color', [0.55 0.55 0.55], 'radius', 0.045, 'alpha', 0.24);

run_layer_stacking_animation(cfg);
