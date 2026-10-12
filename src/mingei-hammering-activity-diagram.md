# Mingei Crafts Ontology (CrO) Activity Diagram
## Carpentry ZPD Hammering Workflow with Bent-Nail Remediation (ALTERNATIVE F)

In the **Mingei Crafts Ontology (CrO)** and **Mingei Online Platform (MOP)**, craft processes are modeled as Activity Diagrams. Control-flow nodes (such as **FORK**, **JOIN**, **BRANCH**, **ALTERNATIVE**, and **MERGE**) are reified as specialized subclasses of CIDOC CRM Class **`E73 Information Object`** to allow multi-arity control flows in RDF/OWL graph networks.

Below is the complete, clarified Activity Diagram representing an Apprentice learning to hammer a nail under Journeyman guidance within the *Zone of Proximal Development (ZPD)*. It includes three modular stages and incorporates **ALTERNATIVE F** after **BRANCH 2** to handle bent nails detected during heavy driving strikes.

```
================================================================================
STAGE 1: SetNail (Initial Tap)
================================================================================
[ Start Workpiece Prep ]
       │
       ▼
  ( MERGE 1 ) ◀───────────── (Path re-entry from bent nail replacement)
       │
       ▼
   ┌───────┐
   │ FORK 1│ (Splits execution into bimanual parallel actions)
   └───┬───┘
       ├─────────────────────────────────┐
       ▼                                 ▼
(Nondominant Hand): AlignNail     (Dominant Hand): AlignHammer
       │                                 │
       └────────────────┬────────────────┘
                        ▼
                    ┌────────┐
                    │ JOIN 1 │ (Synchronizes both hands before blow)
                    └───┬────┘
                        ▼
                   TapHammer (Light setting strike)
                        │
                        ▼
                  ( MERGE 2 ) ◀─── (Re-entry from AdjustNail OR ALTERNATIVE F)
                        │
                        ▼
                   AssessNail
                        │
                        ▼
================================================================================
STAGE 2: AssessNail (Decision Branching)
================================================================================
                   ┌──────────┐
                   │ BRANCH 1 │ (Evaluates initial setting & bent nail status)
                   └────┬─────┘
                        │
      ┌─────────────────┼─────────────────────────┐
      │                 │                         │
      ▼                 ▼                         ▼
ALTERNATIVE A     ALTERNATIVE B             ALTERNATIVE C
[Nail Straight]   [Nail Crooked]            [Nail Crooked Again / Bent]
      │                 │                         │
      ▼                 ▼                         ▼
 (Proceed to       AdjustNail                 RemoveNail
   FORK 2)     (Angled tap correction)      (Pull damaged nail out)
      │                 │                         │
      │                 └──────────────┬──────────┼──────┐
      │                                │          │      │
      │   (Loops to MERGE 2) ──────────┘          ▼      │
      │                                       ( MERGE 1 )│ (Loops to start)
      │                                                  │
      └──────────────────────────────────────────────────┘

================================================================================
STAGE 3: DriveNail (Main Driving Loop & Expanded Branching)
================================================================================
   ┌───────┐
   │ FORK 2│ (Bimanual driving preparation)
   └───┬───┘
       ├─────────────────────────────────┐
       ▼                                 ▼
(Nondominant Hand): HoldPanel     (Dominant Hand): SwingPrep
       │                                 │
       └────────────────┬────────────────┘
                        ▼
                    ┌────────┐
                    │ JOIN 2 │ (Synchronizes panel hold + swing execution)
                    └───┬────┘
                        ▼
                   ( MERGE 3 ) ◀──┐ (Re-entry for continuous driving blows)
                        │        │
                        ▼        │
                    DownSwing    │
                        │        │
                        ▼        │
                   ┌──────────┐  │
                   │ BRANCH 2 │  │
                   └────┬─────┘  │
                        │        │
      ┌─────────────────┼────────┴────────────────┐
      │                 │                         │
      ▼                 ▼                         ▼
ALTERNATIVE D     ALTERNATIVE E             ALTERNATIVE F
 [Nail Flush]    [Nail Not Flush]           [Nail Bent / Crooked]
      │                 │                         │
      ▼                 ▼                         │
  [ Stop / ]         UpSwing                      │
[ Inspection ]          │                         │
                        └─────────────────────────┼──────┐
                                                  │      │
                      (Loops to MERGE 2) ─────────┴──────┘
```

---

### Formal MOP / CrO Ontological Mapping

| Activity Diagram Element | CIDOC CRM / CrO Class | MOP Structural Function & Properties |
| :--- | :--- | :--- |
| **SetNail, AssessNail, DriveNail** | Process schema step *(subclass of `E29 Design or Procedure`)* | Main step schemas containing nested sub-steps (`hasSubStep`). |
| **Hand Roles** | `ActorWithRole` *(subclass of `E39 Actor`)* | Links Apprentice (`E21 Person`) to Dominant Hand Operator vs. Nondominant Support. |
| **FORK 1 & FORK 2** | `Fork` *(subclass of `E73 Information Object`)* | Splits execution flow via `forksFrom` (1 input) and `forksTo` (multiple parallel outputs). |
| **JOIN 1 & JOIN 2** | `Join` *(subclass of `E73 Information Object`)* | Synchronizes parallel flows via `joinsFrom` (multiple inputs) and `joinsTo` (1 output). |
| **BRANCH 1 & BRANCH 2** | `Branch` *(subclass of `E73 Information Object`)* | Evaluates conditions via `branchesFrom` (1 input) and points to `Alternative` objects. |
| **ALTERNATIVE A - F** | `Alternative` *(subclass of `E73 Information Object`)* | Encapsulates evaluation via `hasPredicate` (e.g. `"Nail Bent"`) and `hasAlternativeDestination`. |
| **MERGE 1 - 3** | `Merge` *(subclass of `E73 Information Object`)* | Unites multiple incoming paths via `mergesFrom` into a single output step without synchronization. |

---

### Expanded BRANCH 2 Schema with ALTERNATIVE F

**BRANCH 2** evaluates three distinct candidate paths after each downward hammering stroke:
- **ALTERNATIVE D:** *"Nail is Flush with Panel"* → Proceed to `Stop / Final Joint Inspection`.
- **ALTERNATIVE E:** *"Nail is Not Flush (and Straight)"* → Execute `UpSwing` → `MERGE 3` → `DownSwing`.
- **ALTERNATIVE F:** *"Nail is Bent / Crooked"* → Loops back to `MERGE 2` → `AssessNail` → `BRANCH 1` (enabling correction via `AdjustNail` or `RemoveNail`).
