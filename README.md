# Crystal Structure Visualization - MATLAB

Interactive 3D visualization of FCC (Face-Centered Cubic) and HCP (Hexagonal Close-Packed) crystal structures with interstitial voids.

## Project Structure

```
Ceramics-project/
├── unitcell/                    # Static unit cell visualizations
│   ├── fcc_octahedral_voids.m   # FCC with octahedral voids
│   ├── fcc_tetrahedral_voids.m  # FCC with tetrahedral voids
│   ├── fcc_all_voids.m          # FCC with all voids
│   ├── hcp_octahedral_voids.m   # HCP with octahedral voids
│   ├── hcp_tetrahedral_voids.m  # HCP with tetrahedral voids
│   ├── hcp_all_voids.m          # HCP with all voids
│   └── fcc_hcp_comparison.m     # Side-by-side comparison
│
├── crystall_animation/          # Animated layer stacking
│   ├── fcc_animation.m          # FCC ABC stacking animation
│   ├── hcp_animation.m          # HCP ABAB stacking animation
│   ├── fcc_hcp_comparison.m     # Static comparison view
│   └── unit_cell_explorer.m     # Interactive FCC unit cell
│
└── README.md
```

## Requirements

- MATLAB R2016b or later
- No additional toolboxes required

## How to Run

1. Open MATLAB
2. Navigate to the desired folder (`unitcell` or `crystall_animation`)
3. Run any `.m` file directly
4. Use mouse to rotate the 3D view
5. Close the figure window to exit

## Crystal Structure Parameters

### FCC (Face-Centered Cubic)

| Parameter | Value |
|-----------|-------|
| Lattice Parameter | a |
| Atoms per Unit Cell | 4 |
| Coordination Number | 12 |
| Packing Efficiency | 74% |
| Stacking Sequence | ABCABC... |
| Octahedral Voids | 4 per unit cell |
| Tetrahedral Voids | 8 per unit cell |
| Examples | Cu, Al, Au, Ag, Ni, Pb, Pt |

**Atom Positions (FCC):**
- 8 corner atoms: (0,0,0), (a,0,0), (0,a,0), (0,0,a), (a,a,0), (a,0,a), (0,a,a), (a,a,a)
- 6 face-center atoms: (a/2,a/2,0), (a/2,a/2,a), (a/2,0,a/2), (a/2,a,a/2), (0,a/2,a/2), (a,a/2,a/2)

### HCP (Hexagonal Close-Packed)

| Parameter | Value |
|-----------|-------|
| Lattice Parameter a | a |
| Lattice Parameter c | 1.633a (ideal) |
| c/a Ratio | 1.633 (√(8/3)) |
| Atoms per Unit Cell | 2 (primitive), 6 (hexagonal) |
| Coordination Number | 12 |
| Packing Efficiency | 74% |
| Stacking Sequence | ABAB... |
| Octahedral Voids | 2 per 2-atom basis |
| Tetrahedral Voids | 4 per 2-atom basis |
| Examples | Mg, Zn, Ti, Co, Cd, Zr |

## Interstitial Voids

### Octahedral Voids

| Property | FCC | HCP |
|----------|-----|-----|
| Number per unit cell | 4 | 2 |
| Radius ratio (r/R) | 0.414 | 0.414 |
| Coordination | 6 atoms | 6 atoms |
| Location (FCC) | Body center + edge centers | Between layers |

**FCC Octahedral Void Positions:**
- Body center: (a/2, a/2, a/2)
- Edge centers: (a/2,0,0), (0,a/2,0), (0,0,a/2), etc.

### Tetrahedral Voids

| Property | FCC | HCP |
|----------|-----|-----|
| Number per unit cell | 8 | 4 |
| Radius ratio (r/R) | 0.225 | 0.225 |
| Coordination | 4 atoms | 4 atoms |
| Location (FCC) | At (a/4, a/4, a/4) positions | Between layers |

**FCC Tetrahedral Void Positions:**
- (a/4, a/4, a/4), (3a/4, 3a/4, a/4), (3a/4, a/4, 3a/4), (a/4, 3a/4, 3a/4)
- (3a/4, a/4, a/4), (a/4, 3a/4, a/4), (a/4, a/4, 3a/4), (3a/4, 3a/4, 3a/4)

## Color Coding

### Unit Cell Visualizations (unitcell/)

| Element | Color |
|---------|-------|
| Atoms | Blue (0.2, 0.4, 0.8) |
| Octahedral Voids | Red (0.9, 0.2, 0.2) |
| Tetrahedral Voids | Green (0.2, 0.8, 0.3) |
| Cell Edges | Dark Gray (0.3, 0.3, 0.3) |

### Animation Visualizations (crystall_animation/)

| Element | Color |
|---------|-------|
| Layer A atoms | Blue (0.2, 0.5, 1.0) |
| Layer B atoms | Red (1.0, 0.3, 0.3) |
| Layer C atoms | Green (0.3, 0.9, 0.4) |
| Octahedral Voids | Orange (1.0, 0.6, 0.0) |
| Tetrahedral Voids | Purple (0.9, 0.2, 0.9) |

## Key Differences: FCC vs HCP

| Property | FCC | HCP |
|----------|-----|-----|
| Stacking | ABCABC (3-layer repeat) | ABAB (2-layer repeat) |
| Unit Cell | Cubic | Hexagonal prism |
| Slip Systems | 12 (more ductile) | 3-6 (less ductile) |
| Symmetry | Higher | Lower |
| Atoms/cell | 4 | 2 |

Both structures have identical:
- Packing efficiency (74%)
- Coordination number (12)
- Void radius ratios

## Formulas

**Packing Efficiency:**
```
APF = (Volume of atoms in unit cell) / (Volume of unit cell)
APF = (4 × (4/3)πr³) / a³ = 0.74 (for FCC, where a = 2√2 r)
```

**Void Radius Ratios:**
```
Octahedral: r/R = √2 - 1 = 0.414
Tetrahedral: r/R = √(3/2) - 1 = 0.225
```

**HCP c/a Ratio:**
```
c/a = √(8/3) = 1.633 (ideal)
```

## Features

- Interactive 3D rotation (mouse drag)
- Transparent atoms to visualize internal voids
- Coordination polyhedra visualization (octahedron, tetrahedron)
- Layer-by-layer stacking animation
- Side-by-side structure comparison
- Gouraud lighting for realistic rendering
