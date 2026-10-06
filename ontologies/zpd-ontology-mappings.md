# ZPD Video Analysis: Ontology Mapping Notes

This note identifies existing CIDOC CRM and Mingei ontology terms that can help represent apprentice videos about craft learning. It is a guide for prompt construction, not an extension or modification of either ontology.

## Schema files

- [CIDOC CRM JSON-LD context](../schemas/CIDOC_CRM_v7.1.3_JSON-LD_Context.jsonld)
- [Mingei ontology in JSON-LD](../schemas/mingei-ontology.jsonld)
- [Mingei ontology in Turtle](../schemas/mingei-ontology.ttl)
- [Combined ZPD CRM/Mingei JSON-LD context](zpd-crm-mingei-context.jsonld)

The CIDOC CRM file is a JSON-LD context. The Mingei JSON-LD file is an expanded ontology document, not a ready-made `@context`. Attach it as a vocabulary reference; use explicitly declared aliases in the output context. The combined context file provides those aliases for the terms referenced in this note. The checked-in ontology files remain the authority for available terms.

## Useful context aliases

These aliases point to terms in the local schemas. They do not add new ontology classes or properties.

```json
{
  "@context": {
    "crm": "http://www.cidoc-crm.org/cidoc-crm/",
    "cro": "https://dlnarratives.eu/ontology#",

    "E21_Person": { "@id": "crm:E21_Person" },
    "E39_Actor": { "@id": "crm:E39_Actor" },
    "E5_Event": { "@id": "crm:E5_Event" },
    "E7_Activity": { "@id": "crm:E7_Activity" },
    "E22_Human_Made_Object": { "@id": "crm:E22_Human-Made_Object" },
    "E57_Material": { "@id": "crm:E57_Material" },
    "E53_Place": { "@id": "crm:E53_Place" },
    "E55_Type": { "@id": "crm:E55_Type" },

    "P2_has_type": { "@id": "crm:P2_has_type", "@type": "@id" },
    "P3_has_note": { "@id": "crm:P3_has_note" },
    "P7_took_place_at": { "@id": "crm:P7_took_place_at", "@type": "@id" },
    "P9_consists_of": { "@id": "crm:P9_consists_of", "@type": "@id" },
    "P11_had_participant": { "@id": "crm:P11_had_participant", "@type": "@id" },
    "P14_carried_out_by": { "@id": "crm:P14_carried_out_by", "@type": "@id" },
    "P16_used_specific_object": {
      "@id": "crm:P16_used_specific_object",
      "@type": "@id"
    },

    "Person": { "@id": "cro:Person" },
    "Event": { "@id": "cro:Event" },
    "ActorWithRole": { "@id": "cro:ActorWithRole" },
    "hasSubject": { "@id": "cro:hasSubject", "@type": "@id" },
    "hasRole": { "@id": "cro:hasRole" },
    "hasSubevent": { "@id": "cro:hasSubevent", "@type": "@id" },
    "Processing": { "@id": "cro:Processing" },
    "hasProcessingSubevent": {
      "@id": "cro:hasProcessingSubevent",
      "@type": "@id"
    },
    "used_hand_tool": { "@id": "cro:used_hand_tool", "@type": "@id" }
  }
}
```

The CRM context key `E22_Human_Made_Object` (underscores) maps to the IRI `crm:E22_Human-Made_Object` (hyphens). Preserve that supplied mapping; do not improvise a new key/IRI.

## Mapping observed video elements

| Video element | Existing schema terms | How to use them |
|---|---|---|
| Journeyman and apprentices | `crm:E21_Person`; `cro:Person` | Identify visible people. Use labels or notes for “journeyman” and “apprentice”; these are roles in this project, not new classes. |
| Demonstrating, attempting, and correcting | `crm:E7_Activity`; `crm:E5_Event`; `cro:Event` | Represent visible actions as activities/events. Use supported relations to connect participants and subevents. |
| Hammers and other tools | `crm:E22_Human-Made_Object`; `crm:P16_used_specific_object`; `cro:used_hand_tool` | Represent visible tools and their use when clearly supported by the footage. |
| Wood and other materials | `crm:E57_Material` | Identify visible materials; do not infer material composition where it is not discernible. |
| Workbench or setting | `crm:E53_Place`; `crm:P7_took_place_at` | Represent a location when identifiable. |
| Participants and role annotations | `crm:P11_had_participant`; `cro:ActorWithRole`; `cro:hasSubject`; `cro:hasRole` | Mingei describes `ActorWithRole` as a participation/role pattern. Its `hasRole` property is declared as an annotation property, and a `Role` class is not defined in the checked-in Mingei file. Use cautiously; do not assume it is a fully specified object-property relation. |
| ZPD state labels | `crm:E55_Type`; `crm:P2_has_type`; `crm:P3_has_note` | Project labels such as modeling or correction may be recorded as annotations/types when appropriate, but they are not established Mingei classes. |
| Embodied and social cues | `crm:P3_has_note` on a supported event/activity | Record timestamped descriptions of visible gaze, posture, gestures, imitation, expert demonstrations, or attention to multiple apprentices. The checked-in schemas do not define dedicated classes for these concepts. |

## Terms not defined in the checked-in schemas

The exact class names `CraftProcessStep` and `ScaffoldingInteraction` are not present in the checked-in schema files. Nor do they define dedicated classes for gaze following, ostensive gestures, expert skill off-loading, imitation, or keeping track of multiple apprentices.

Do not emit these as `@type` values or invent properties for them. Instead:

1. Represent visible actions with supported CRM/Mingei event or activity classes.
2. Connect participants, objects, and subevents using supported properties whose domains and ranges fit the data.
3. Record ZPD interpretations and observable social/embodied cues as timestamped notes, clearly distinguishing observations from interpretation.
4. Omit an inference when the footage does not provide sufficient evidence.

## Prompting and validation reminders

- Attach the two schema files to the local Qwen3-VL request as references.
- Ask the model to use only the terms in those schemas and to return one JSON-LD document with a declared `@context` and an `@graph`.
- Require source frame identifiers and timestamps for observations.
- Validate JSON syntax and check that every emitted class/property IRI is actually defined by a supplied schema.
- Check every referenced `@id`, relationship, timestamp, and claim against the video. Model output is a draft, not proof of ontology validity or visual accuracy.
- Keep the original model output and record any manually corrected version separately.
