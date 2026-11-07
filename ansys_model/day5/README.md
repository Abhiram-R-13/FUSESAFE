# Day5 ANSYS geometry and mesh handoff

ANSYS 2025 R1. Geometry and mesh validation only; no structural solves.

## Recommended nominal automation baseline

Use this matching pair:
- FUSESAFE_M2_Day5_NominalBaseline_Automation.wbpz
- FUSESAFE_M2_Day5_NominalBaseline_Automation.dat

Configuration: W400/H400/R2000 mm, skin 2 mm, band total 4 mm.
Material: Structural Steel.
Skin offset: Middle.
Band offset: User Defined, membrane offset -0.001 m.

Regenerated mesh:
- 9845 nodes, 3217 shells
- 3065 Quad8, 152 Tri6
- Element Quality: minimum 0.61901, average 0.97054, maximum 0.99993
- Export audit: complete disjoint skin/band coverage and clean interface connectivity

This mesh differs from the original nominal baseline mesh.
Archive saved from the corresponding project; restoration comparison against the DAT remains pending.
Member 4 should restore and compare before adding loads/supports in a separate working copy.
Keep Day3 and original source files unchanged.

## Day5 geometry convention

- W250–500 mm; H300–550 mm
- Shell midsurface radius R1500–2500 mm
- Preserve 1600 mm developed circumferential panel length
- Fixed inner fillet R40 mm
- Band width 50 mm; outer fillet R90 mm
- Skin 1.8–3 mm; added reinforcement fixed at 2 mm
- Band total = skin + 2 mm

## Individual geometry endpoint files

Each stem below has matching .dat and .wbpz files:

| W/H/R (mm) | Filename stem |
|---|---|
|250/400/2000|FUSESAFE_M2_Day5_W250_H400_R2000_Skin2_Band4_Review|
|500/400/2000|FUSESAFE_M2_Day5_W500_H400_R2000_Skin2_Band4_Hard10mm|
|400/300/2000|FUSESAFE_M2_Day5_W400_H300_R2000_Skin2_Band4_Review|
|400/550/2000|FUSESAFE_M2_Day5_W400_H550_R2000_Skin2_Band4_Review|
|400/400/1500|FUSESAFE_M2_Day5_W400_H400_R1500_Skin2_Band4_Review|
|400/400/2500|FUSESAFE_M2_Day5_W400_H400_R2500_Skin2_Band4_Review|

All selected endpoint exports pass section and connectivity audits.

## Combined geometry files

Eight combinations:
W = {250, 500}, H = {300, 550}, R = {1500, 2500} mm.

Filename pattern:
FUSESAFE_M2_Day5_W{W}_H{H}_R{R}_Skin2_Band4.dat
with matching .wbpz archives.

## Combined thickness checks

W250/H300/R2500:
- FUSESAFE_M2_Day5_W250_H300_R2500_Skin1p8_Band3p8.dat
- FUSESAFE_M2_Day5_W250_H300_R2500_Skin3_Band5.dat

Both have identical NBLOCK/EBLOCK to the corresponding Skin2/Band4 export.
The Skin3/Band5 archive is also available.

## W500 mesh exception

Use the Hard10mm pair for W500/H400/R2000.
Passing settings: B_Band face sizing 0.01 m, Hard behavior, mesh defeaturing off.

Earlier W500 Review and NoDefeat exports retain an interface irregularity.
They are diagnostic files and must not be used as passing simulation sources.
The underlying cause is not established.

## Limitations

Mesh validation does not establish structural safety or mesh convergence.
Loads, supports, structural setup and solution verification remain separate work.
Not every archive has been restore-tested.
