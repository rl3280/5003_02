Synthesize **Event 5: Journeyman power drills a pilot hole** (09:27–09:50) from the attached `event-05_concrete.json` array. Follow the attached `SYNTHESIS_RULES.md` exactly and use `ontology_reference.jsonld` as the allowed vocabulary.

Create only the Event 5 schema component, using IDs beginning `urn:5003:hammering:schema:event-05:`. Do not connect it to any other event. Include all 24 concrete `crm:E7_Activity` observations and map each to one generalized schema step with `cro:correspondsTo`.

Return only the strict JSON-LD document. Save the response as `state/outputs/event-05.jsonld`.
