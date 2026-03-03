clear; clc; close all;

a_site = [0 0 0];
b_site = [0.5 0.5 0.5];
o_site = [0.5 0.5 0; 0.5 0 0.5; 0 0.5 0.5];
tet_empty = [0.25 0.25 0.25; 0.25 0.75 0.75; 0.75 0.25 0.75; 0.75 0.75 0.25; ...
             0.75 0.25 0.25; 0.25 0.75 0.25; 0.25 0.25 0.75; 0.75 0.75 0.75];

cfg = struct;
cfg.name = 'Perovskite (ABO3) layer stacking';
cfg.window_title = 'Perovskite Layer Stacking Animation';
cfg.stacking_line = 'Alternating AO and BO2 layers with BO6 framework';
cfg.info_lines = {
    'Formula: ABO3'
    'Cubic system: Pm3m'
    'Atoms per cell: 1 A + 1 B + 3 O'
    'Coordination: A = 12, B = 6'
    'Layer build: A corners, B center, O faces'
};
cfg.a = 1;
cfg.grid = [3 3 2];
cfg.drop_height = 0.8;
cfg.layer_steps = 7;
cfg.void_steps = 4;
cfg.layer_pause = 0.12;
cfg.atom_quality = 14;
cfg.void_quality = 10;

cfg.species(1) = struct('name', 'A-site layer', 'basis', a_site, 'color', [0.25 0.48 0.92], 'radius', 0.14, 'alpha', 0.90);
cfg.species(2) = struct('name', 'B-site layer', 'basis', b_site, 'color', [0.66 0.28 0.86], 'radius', 0.10, 'alpha', 0.93);
cfg.species(3) = struct('name', 'O layer', 'basis', o_site, 'color', [0.92 0.32 0.32], 'radius', 0.11, 'alpha', 0.90);

cfg.voids(1) = struct('name', 'Octa center (B-site)', 'basis', b_site, 'color', [1.00 0.55 0.10], 'radius', 0.055, 'alpha', 0.30);
cfg.voids(2) = struct('name', 'Tetra void empty', 'basis', tet_empty, 'color', [0.35 0.78 0.35], 'radius', 0.044, 'alpha', 0.22);

run_layer_stacking_animation(cfg);
