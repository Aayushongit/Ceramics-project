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

run_layer_stacking_animation(cfg);
