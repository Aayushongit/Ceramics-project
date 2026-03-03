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
cfg.layer_steps = 7;
cfg.void_steps = 4;
cfg.layer_pause = 0.12;
cfg.atom_quality = 14;
cfg.void_quality = 10;

cfg.species(1) = struct('name', 'S anion layer', 'basis', fcc, 'color', [0.94 0.72 0.24], 'radius', 0.14, 'alpha', 0.90);
cfg.species(2) = struct('name', 'Zn cation layer', 'basis', tet_filled, 'color', [0.25 0.48 0.92], 'radius', 0.10, 'alpha', 0.92);

cfg.voids(1) = struct('name', 'Tetra void filled', 'basis', tet_filled, 'color', [0.20 0.82 0.35], 'radius', 0.050, 'alpha', 0.32);
cfg.voids(2) = struct('name', 'Tetra void empty', 'basis', tet_empty, 'color', [0.55 0.55 0.55], 'radius', 0.046, 'alpha', 0.26);
cfg.voids(3) = struct('name', 'Octa void empty', 'basis', oct_all, 'color', [1.00 0.55 0.10], 'radius', 0.052, 'alpha', 0.22);

run_layer_stacking_animation(cfg);
