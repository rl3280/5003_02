Synthesize **Event 4: Journeyman supports Apprentice hammering a nail** from the attached `event-04_llama.jsonld`. Its two observed portions are 05:50–05:59 and 07:00–07:36. The video from 06:00–06:59 is unavailable for student privacy.

Follow the attached `SYNTHESIS_RULES.md` exactly and use `ontology_reference.jsonld` as the allowed vocabulary. Treat both observed portions as the same event and create one Event 4 schema component, using IDs beginning `urn:5003:hammering:schema:event-04:`. Do not connect it to another event. Include all 44 concrete `crm:E7_Activity` observations and map each to one generalized schema step with `cro:correspondsTo`. Do not invent actions in the unavailable interval or add a transition that bridges the gap.

Return only the strict JSON-LD document. Save the response as `state/outputs/event-04.jsonld`.
