Combine the five attached event-schema JSON-LD documents into one JSON-LD document named `hammering-workflow.jsonld`. Use the attached `ontology_reference.jsonld` only as a vocabulary reference.

Copy every node from the five input `@graph` arrays into one output `@graph`. Keep the common `crm` and `cro` context. Preserve every `@id`, `@type`, predicate, and relationship exactly; do not summarize, rename, remove, or add nodes.

The result must contain five disconnected schema roots, one for each event. Do not add any transition or other edge between events, including between the ending step of one and the starting step of another. Keep Event 4's privacy-gap boundary: do not add a transition from the 05:50–05:59 observed portion to the 07:00–07:36 observed portion.

Before responding, ensure there are no duplicate `@id` values and that every `cro:correspondsTo`, `cro:hasSubStep`, `cro:transistsFrom`, and `cro:transistsTo` reference resolves to the intended node. Return only one strict JSON-LD object with `@context` and `@graph`; no Markdown or prose.
