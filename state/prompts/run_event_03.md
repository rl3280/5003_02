Synthesize **Event 3: Journeyman/Apprentice hammering nails** (02:41–04:15) from the attached `event-03_concrete.json` array. Follow the attached `SYNTHESIS_RULES.md` exactly and use `ontology_reference.jsonld` as the allowed vocabulary.

Create only the Event 3 schema component, using IDs beginning `urn:5003:hammering:schema:event-03:`. Do not connect it to any other event. Include all 95 concrete `crm:E7_Activity` observations and map each to one generalized schema step with `cro:correspondsTo`.

Return only the strict JSON-LD document. Save the response as `state/outputs/event-03.jsonld`.
