# FUSESAFE — Day 2, Task 14: Limitations Register

## 1. Purpose

This register records the limitations, assumptions and unresolved verification items associated with the current FUSESAFE structural analysis.

FUSESAFE is an educational finite-element study. Its results are not a certification of aircraft structural safety or airworthiness.

## 2. Material limitations

- The aluminium 2024-T3 material definition is provisional.
- The currently documented material model uses isotropic linear elasticity.
- Plasticity and post-yield behaviour have not been established.
- Material allowables and their suitability for a real aircraft design require independent verification.

## 3. Structural analysis limitations

- The current analyses are static structural analyses.
- Fatigue life, crack propagation, impact response and buckling resistance have not been established.
- A static stress result alone cannot establish the complete structural performance of an aircraft fuselage panel.
- The models use idealized supports and applied boundary loads rather than a complete representation of the surrounding aircraft structure.

## 4. Case A limitations — Intact reference panel

- Case A represents an intact reference panel without the reinforced window-opening configuration.
- The theoretical membrane-stress comparison provides a useful numerical consistency check, but does not independently validate the complete model.
- The cylindrical-coordinate hoop stress result was evaluated using the existing solved data; no new structural solve was performed after adding the cylindrical coordinate system.

## 5. Case B limitations — Reinforced window panel

- The window-opening load transfer is represented using an approximate perimeter force.
- This approximation does not reproduce a detailed physical window-frame, sealant or attachment load-transfer mechanism.
- The reinforced region uses a provisional material definition.
- The reported maximum equivalent stress and deformation must be interpreted in the context of the model assumptions and verified project revision.
- The final assembled-load equilibrium review and exact solver-warning assessment remain to be confirmed.

## 6. Numerical verification limitations

- A formal mesh-convergence study has not yet been established in the available project record.
- Solver completion does not, by itself, prove that all modelling assumptions or inputs are physically appropriate.
- The exact impact of the outstanding Case B solver warnings has not yet been assessed.
- Reinforcement-only mass still requires verified extraction or calculation.

## 7. MATLAB and automation limitations

- The intended MATLAB-to-ANSYS parameterization and batch-execution workflow has not yet been demonstrated as complete.
- Automated extraction of stress, deformation and reinforcement mass remains to be established.
- No verified optimization history or completed thickness sweep is currently established by the available record.

## 8. Overall conclusion

The current FUSESAFE models provide an educational basis for investigating the structural response of an intact fuselage panel and a reinforced panel containing a window opening.

However, the results must be interpreted within the limitations of the provisional material definition, idealized boundary conditions, approximate window load transfer, numerical verification and incomplete automation workflow.

A successful static analysis does not establish that the design is safe for real aircraft service.

---

**Status:** Draft prepared for Day 2 — Task 14.  
**Outstanding:** Review Case B solver warnings, final equilibrium evidence, mesh convergence and reinforcement-only mass before treating those verification items as closed.
