Synthesize **Event 2: Journeyman inspects flush panels** (01:27–01:37) from the attached `event-02_llama.jsonld`. Follow the attached `SYNTHESIS_RULES.md` exactly and use `ontology_reference.jsonld` as the allowed vocabulary.

Create only the Event 2 schema component, using IDs beginning `urn:5003:hammering:schema:event-02:`. Do not connect it to any other event. Include all 11 concrete `crm:E7_Activity` observations and map each to one generalized schema step with `cro:correspondsTo`.

Return only the strict JSON-LD document. Save the response as `state/outputs/event-02.jsonld`.
