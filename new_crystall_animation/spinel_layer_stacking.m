clear; clc; close all;

o_site = [0 0 0; 0.5 0.5 0; 0.5 0 0.5; 0 0.5 0.5; ...
          0.25 0.25 0.25; 0.75 0.75 0.25; 0.75 0.25 0.75; 0.25 0.75 0.75];
a_tet = [0.125 0.125 0.125; 0.625 0.625 0.125; 0.625 0.125 0.625; 0.125 0.625 0.625];
b_oct = [0.5 0.5 0.5; 0.5 0 0; 0 0.5 0; 0 0 0.5; ...
         0.25 0.25 0.5; 0.25 0.5 0.25; 0.5 0.25 0.25; 0.75 0.75 0.75];
empty_tet = [0.375 0.125 0.125; 0.125 0.375 0.125; 0.125 0.125 0.375; 0.375 0.375 0.375];

cfg = struct;
cfg.name = 'Spinel (AB2O4) layer stacking';
cfg.window_title = 'Spinel Layer Stacking Animation';
cfg.stacking_line = 'O framework with A in tetra sites and B in octa sites';
cfg.info_lines = {
    'Formula: AB2O4'
    'Cubic system: Fd3m (simplified model)'
    'A occupies tetrahedral sites'
    'B occupies octahedral sites'
    'Layer build: oxygen framework + cation filling'
};
cfg.a = 1;
cfg.grid = [2 2 2];
cfg.drop_height = 0.8;
cfg.layer_steps = 7;
cfg.void_steps = 4;
cfg.layer_pause = 0.12;
cfg.atom_quality = 13;
cfg.void_quality = 9;

cfg.species(1) = struct('name', 'O framework layer', 'basis', o_site, 'color', [0.92 0.32 0.32], 'radius', 0.10, 'alpha', 0.86);
cfg.species(2) = struct('name', 'A tetra layer', 'basis', a_tet, 'color', [0.25 0.48 0.92], 'radius', 0.08, 'alpha', 0.93);
cfg.species(3) = struct('name', 'B octa layer', 'basis', b_oct, 'color', [0.66 0.28 0.86], 'radius', 0.075, 'alpha', 0.93);

cfg.voids(1) = struct('name', 'Tetra void filled', 'basis', a_tet, 'color', [0.20 0.82 0.35], 'radius', 0.042, 'alpha', 0.30);
cfg.voids(2) = struct('name', 'Octa void filled', 'basis', b_oct, 'color', [1.00 0.55 0.10], 'radius', 0.045, 'alpha', 0.30);
cfg.voids(3) = struct('name', 'Tetra void empty', 'basis', empty_tet, 'color', [0.55 0.55 0.55], 'radius', 0.040, 'alpha', 0.24);

run_layer_stacking_animation(cfg);
