# Build the five disconnected workflow schemas

This folder is prepared for a Llama-3.1-8B-Instruct synthesis run. It contains all 210 annotated frame graphs, grouped into the five events you identified. Event 1 has an annotation-grounded interim state machine; outputs for Events 2–5 are still pending.

Event 1's `state/outputs/event-01.jsonld` was assembled from its source annotations after the Llama CLI response was found to be truncated and to include labels from other events. It contains four schema steps (AlignHammer, BackSwing, DownSwing, and phase-not-annotated), all 36 Event 1 activities linked to one step each, and six transitions observed between adjacent frames with annotated phases. It does not infer a transition across an unannotated phase. The preserved `event-01-partial.txt` is invalid diagnostic output, not JSON-LD; do not use it as a synthesis result.

## Before you start

1. In VS Code Continue, select your configured **Llama-3.1-8B-Instruct** model.
2. Run one event at a time. Do not attach all five input bundles at once.
3. For each run, attach:
   - `state/SYNTHESIS_RULES.md`
   - `state/ontology_reference.jsonld`
   - the event's `state/inputs/event-NN_llama.jsonld` file
4. Open the corresponding `state/prompts/run_event_NN.md`, copy its contents into Continue, and send it.
5. Have the model return only one JSON-LD document. Save it exactly as the destination filename stated in that event prompt under `state/outputs/`.
6. Repeat for events 01 through 05.
7. When all five event files exist, attach those five files, `state/ontology_reference.jsonld`, and `state/prompts/combine_five_events.md` to a final Continue request. Save its JSON-LD response as `state/outputs/hammering-workflow.jsonld`.
8. In the VS Code PowerShell terminal, run `.\state\validate_state_machine.ps1`. It checks each returned file parses as JSON, verifies every source activity has a schema correspondence, checks transition endpoints and event boundaries, and checks the combined graph if it exists.

The original event arrays (`event-NN_concrete.json`) remain unchanged. The smaller `event-NN_llama.jsonld` files are synthesis-focused JSON-LD derivatives: they keep every concrete E7 activity, participant, tool, material, annotation code, and timestamp, while omitting visual-description notes and repetitive image/time-span support nodes. Frame IDs still identify the source image, and each activity carries its timestamp as a note. `state/event_manifest.json` lists the source filenames, event time ranges, and frame counts.

## Important modeling choices

- The five events are five disconnected schema roots. There must be no transition from one event to another.
- Event 4 is one event with two observed portions: 05:50–05:59 and 07:00–07:36. The 06:00–06:59 privacy gap is unknown. Do not create steps or a transition that bridges the gap.
- The local CrO ontology does **not** define classes named `cro:Process`, `cro:ProcessStep`, or `cro:ProcessSchema`. It defines `cro:correspondsTo` for an observed `crm:E7_Activity` to schema `crm:E29_Design_or_Procedure`. The prompts use those real ontology terms rather than inventing missing classes.
- CrO spells the transition endpoints `cro:transistsFrom` and `cro:transistsTo` in the ontology. Keep that spelling exactly.
- The visual descriptions are included in the concrete graphs but are not needed for this synthesis. Ground the synthesis in the annotations and ontology codes.

`state/ontology_reference.jsonld` is a compact, task-specific reference. It includes all 20 annotation-code nodes found in the concrete outputs and the CRM/CrO classes and properties needed for the schema links and control-flow nodes; it is not a replacement for the full CIDOC CRM ontology.

The validator expects per-event files named `event-01.jsonld` through `event-05.jsonld`. To require that the combined file also exists, run `.\state\validate_state_machine.ps1 -RequireCombined`. It will report missing files until the Llama runs are complete.
