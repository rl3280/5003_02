Synthesize **Event 1: Journeyman models hammering** (00:30–01:05) from the attached `event-01_llama.jsonld`. Follow the attached `SYNTHESIS_RULES.md` exactly and use `ontology_reference.jsonld` as the allowed vocabulary.

Create only the Event 1 schema component, using IDs beginning `urn:5003:hammering:schema:event-01:`. Do not connect it to any other event. Include all 36 concrete `crm:E7_Activity` observations and map each to one generalized schema step with `cro:correspondsTo`.

Return only the strict JSON-LD document. Save the response as `state/outputs/event-01.jsonld`.
