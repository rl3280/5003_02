# Build the five disconnected workflow schemas

This folder is prepared for a Llama-3.1-8B-Instruct synthesis run. It contains all 210 annotated frame graphs, grouped into the five events you identified. It does not contain synthesized state-machine outputs yet; those are saved under `state/outputs/` after you run Llama.

## Before you start

1. In VS Code Continue, select your configured **Llama-3.1-8B-Instruct** model.
2. Run one event at a time. Do not attach all five input bundles at once.
3. For each run, attach:
   - `state/SYNTHESIS_RULES.md`
   - `state/ontology_reference.jsonld`
   - the event's `state/inputs/event-NN_concrete.json` file
4. Open the corresponding `state/prompts/run_event_NN.md`, copy its contents into Continue, and send it.
5. Have the model return only one JSON-LD document. Save it exactly as the destination filename stated in that event prompt under `state/outputs/`.
6. Repeat for events 01 through 05.
7. When all five event files exist, attach those five files, `state/ontology_reference.jsonld`, and `state/prompts/combine_five_events.md` to a final Continue request. Save its JSON-LD response as `state/outputs/hammering-workflow.jsonld`.
8. In the VS Code PowerShell terminal, run `.\state\validate_state_machine.ps1`. It checks each returned file parses as JSON, verifies every source activity has a schema correspondence, checks transition endpoints and event boundaries, and checks the combined graph if it exists.

The event inputs are arrays of the original JSON-LD documents, not rewritten versions. `state/event_manifest.json` lists the source filenames, event time ranges, and frame counts.

## Important modeling choices

- The five events are five disconnected schema roots. There must be no transition from one event to another.
- Event 4 is one event with two observed portions: 05:50–05:59 and 07:00–07:36. The 06:00–06:59 privacy gap is unknown. Do not create steps or a transition that bridges the gap.
- The local CrO ontology does **not** define classes named `cro:Process`, `cro:ProcessStep`, or `cro:ProcessSchema`. It defines `cro:correspondsTo` for an observed `crm:E7_Activity` to schema `crm:E29_Design_or_Procedure`. The prompts use those real ontology terms rather than inventing missing classes.
- CrO spells the transition endpoints `cro:transistsFrom` and `cro:transistsTo` in the ontology. Keep that spelling exactly.
- The visual descriptions are included in the concrete graphs but are not needed for this synthesis. Ground the synthesis in the annotations and ontology codes.

`state/ontology_reference.jsonld` is a compact, task-specific reference. It includes all 20 annotation-code nodes found in the concrete outputs and the CRM/CrO classes and properties needed for the schema links and control-flow nodes; it is not a replacement for the full CIDOC CRM ontology.

The validator expects per-event files named `event-01.jsonld` through `event-05.jsonld`. To require that the combined file also exists, run `.\state\validate_state_machine.ps1 -RequireCombined`. It will report missing files until the Llama runs are complete.
