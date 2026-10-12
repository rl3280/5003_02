# Instructions for synthesizing one event

Use the attached compact JSON-LD graph, `ontology_reference.jsonld`, and one event-specific run prompt. Synthesize only the event named in that run prompt. The concrete files are timestamped frame observations of one video, not independent end-to-end executions. In compact input, `E7`, `E21`, `E22`, `E55`, and `E57` are aliases for the corresponding `crm:` classes; `p11`, `p16`, `p2`, and `p3` alias the corresponding CRM properties. Their exact mappings are in the input's `@context`.

## Ontology-grounded representation

- Preserve the input context prefixes `crm` and `cro`. Return one strict JSON-LD document with `@context` and `@graph`; no Markdown, comments, or prose.
- The checked-in CrO ontology does not define `cro:Process`, `cro:ProcessStep`, or `cro:ProcessSchema`. Do not emit these invented types. Represent the generalized process-schema root and each schema step as `crm:E29_Design_or_Procedure`; identify them with readable `crm:P3_has_note` labels.
- Place each schema step under its event's schema root using `cro:hasSubStep`.
- The concrete activity in each input graph is `crm:E7_Activity`. Include a node for every input activity, preserve its original `@id`, use `crm:E7_Activity` as its output type, and add exactly one `cro:correspondsTo` reference to the generalized `crm:E29_Design_or_Procedure` step it instantiates. Many timestamped activities may correspond to the same generalized step.
- Use `crm:E21_Person` for people. Never use `crm:E29_Design_or_Procedure` to type a person or a concrete activity.
- Preserve annotation-code spellings and meanings from the input graphs and attached ontology reference. Do not normalize, rename, or invent codes.
- Use only classes and predicates declared in the attached compact ontology reference. Do not invent domain-specific classes or predicates.

## Explicit control flow

- Represent each unconditional step-to-step edge with its own `cro:Transition` node, typed `cro:Transition`, and references `cro:transistsFrom` and `cro:transistsTo` to the source and destination schema-step IDs. The ontology's spelling is `transists`, not `transitions`.
- Represent a decision only when the attached annotations provide evidence for multiple possible outcomes. Use a `cro:Branch` node with `cro:branchesFrom` and `cro:hasAlternative`; represent each outcome as a `cro:Alternative` with a concise `cro:hasPredicate` and `cro:hasAlternativeDestination` reference. Do not invent conditions, outcomes, retries, or loops to make the diagram look complete.
- Use `cro:Fork`/`cro:forksFrom`/`cro:forksTo` only for supported concurrent paths; use `cro:Join`/`cro:joinsFrom`/`cro:joinsTo` only when those paths synchronize; use `cro:Merge`/`cro:mergesFrom`/`cro:mergesTo` only when alternate paths rejoin. Do not infer concurrency merely because two people are present.
- Do not make direct step-to-step edges. Reify each sequential edge as a `cro:Transition`.
- Keep all identifiers unique within the output. Every reference between generated schema and control-flow nodes must resolve to a node in this document. Concrete activity IDs may refer back to their source graphs.

## Evidence, grouping, and boundaries

- Generalize repeated frame observations into a small number of meaningful steps; do not create a schema step for every second/frame.
- Use timestamps and labels only to order and group observations within the event in the run prompt. Each compact activity has its timestamp as the second `crm:P3_has_note`; the original activity label is the first. The frame number in the activity `@id` identifies its source image. Do not infer unobserved actions from an absence of frames.
- Keep the event root independent. Do not create any transition, branch, merge, or other control-flow edge to another event.
- For Event 4, treat 05:50–05:59 and 07:00–07:36 as two observed portions of the same event. The 06:00–06:59 interval is unavailable for privacy. Do not invent its actions and do not connect the last pre-gap observation directly to the first post-gap observation with a transition. Steps supported by each observed portion may still be represented beneath the same event schema root.
- If the evidence does not justify a decision, fork, join, or merge, omit that control node and state no unsupported behavior in a note. An explicit transition is still required wherever you assert an unconditional schema-step edge.

## Output checks before responding

Return a parseable JSON object, not a JSON array. It must contain one root `crm:E29_Design_or_Procedure`, one or more schema steps, and all observed `crm:E7_Activity` nodes linked by `cro:correspondsTo`. Use the event-specific ID prefix and output path from the run prompt. Do not include source-image visual descriptions in new notes. Return only the JSON-LD document.
