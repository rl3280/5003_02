I will be videoing a group of apprentices learning from two carpentry tradesmen about how to make an artifact, using tools like hammers, nails, and saws, and materials, like wood.
This phenomenon is the "Zone of Proximal Development" which encompasses many concepts, such as:
 - Embodied Cognition
  - Situated
  - Experts off-load mastered skills
  - Environmental context
- Social Cognition
 - Gaze Following
 - Apprentice Mimicing Journeyman
 - Journeyman "keeping track of" multiple Apprentices
 - Ostensive Gestures

This is the first step of my second assignment for Theory and Programming of Interactive Media.  The assignment is located at ../pre/Activity_2.md  Please read it.
Step 2, decomposition... to final product, I will be doing using this computer, a Levono ThinkPad X14 Elite, with a local install of the following:
 - GenieX
 - Qwen3-VL-4B-Instruct
 - Llama-3.1-8B-Instruct
 - CIDOC_CRM_v7.1.3_JSON-LD_Context.jsonld
 - mingei-ontology.jsonld

 My UI is VS Code, using the Continue extension.  Output will be generated through my local server:

 & 'C:\Users\rlewis\AppData\Local\GenieX CLI\geniex.exe' serve

Local hosting on http://127.0.0.1:18181/

Here is where I am in the Activity 2 process right now: I need to craft prompts that will make it clear to the AGENT System, a visual extraction model, to analyze the apprentice videos and generate output in JSON-LD format that strictly adheres to the following context mappings:

1. "CIDOC object-oriented Conceptual Reference Model" (CRM), which is also ISO 21127:2023, and is stored locally at ../schemas
2. Mingei Craft Ontology, also stored at ../schemas. There are also academic articles on this schema at ../mingei

So when I chat with Qwen3-VL-4B-Instruct through the Continue Extension in VS Code, with CIDOC and mingei preloaded into the chat, I want it to decompose the phenomenon into parts like

crm:E21_Person (Journeyman and Apprentice)
crm:E22_Human-Made_Object (Tools like drills, hammers)
crm:E57_Material (Wood, wire, pipes)
cro:CraftProcessStep and 
cro:ScaffoldingInteraction (ZPD states, gestures, postures)

that are items in the CIDOC and Mingei Ontologies.

Please produce a procedure of steps that will help me craft efficient prompts of the Qwen3-VL-4B-Instruct mode, making sure it generates strict JSON-LD output, that decomposes the video into items delimited in CIDOC and Mingei Ontologies.  Make sure to keep it in context of my VS Code UI on my Levono ThinkPad X14 Elite using GenieX.

## Next Steps: Video-to-JSON-LD Procedure

Use this workflow for each apprentice video. Keep the video analysis grounded in visible evidence, use the checked-in ontology files as the vocabulary authority, and validate each result before combining clips.

### 1. Start GenieX and select the vision model

1. In VS Code, open the integrated PowerShell terminal and start the local GenieX server using the installed executable:

   ```powershell
   & 'C:\Users\rlewis\AppData\Local\GenieX CLI\geniex.exe' serve
   ```

2. Leave the server running at `http://127.0.0.1:18181/`.
3. In Continue, select the configured GenieX entry for `Qwen3-VL-4B-Instruct`. Confirm it is the vision-capable model, not the text-only Llama model.
4. Run a smoke test by attaching one representative image frame and asking for a one-sentence visual description. Confirm that the prompt reaches the local server and that the response describes the attached image.

**Check:** Do not process the full video until the local vision request succeeds. If Continue/GenieX does not accept the video file, extract a small set of timestamped frames or short clips using a local tool and attach those images instead. Do not upload apprentice footage to a hosted service.

### 2. Attach the authoritative schemas in Continue

1. In the Continue prompt, attach:
   - `schemas/CIDOC_CRM_v7.1.3_JSON-LD_Context.jsonld`
   - `schemas/mingei-ontology.jsonld`
2. Use the JSON-LD ontology as the primary Mingei reference. Attach `mingei-ontology.ttl` only when checking an ontology detail that is unclear in the JSON-LD file.
3. Reuse the schema attachments for successive clips in the same Continue conversation when they remain in context. Avoid pasting the entire ontology text into every prompt; include only the relevant terms in the clip prompt.

**Check:** Ask Qwen to identify the exact class/property terms it plans to use before the first extraction, then manually confirm each against the attached files. Do not treat model-generated schema summaries as authoritative.

### 3. Prepare a manageable video input

1. Work on one short, coherent activity segment at a time: for example, a demonstration, an apprentice attempt, or a correction.
2. Prefer a few frames that cover the start, action, and result of that segment. Keep the timestamps alongside the images, and include more frames only when needed to resolve an action or sequence.
3. Make sure the view includes the relevant people, hands, tool, material, and work surface. If the action is obscured, instruct the model to mark it uncertain rather than infer it.
4. Give the frames stable labels such as `frame_001` and preserve their original video timestamps.

**Check:** Each frame must be traceable to its source video and timestamp. Process another segment separately if the first prompt becomes too long or mixes several unrelated actions.

### 4. Use a concise, evidence-first extraction prompt

Attach the segment's frames and schemas, then adapt this prompt. Replace the bracketed values; do not leave placeholders in a production request.

```text
Analyze the attached timestamped frames from a local video of apprentices learning carpentry from a journeyman.

Use only the attached CIDOC CRM context and Mingei ontology for class and property IRIs. The schemas are authoritative. Do not invent classes, properties, prefixes, or ontology terms. The supplied CRM context key E22_Human_Made_Object maps to the CRM IRI crm:E22_Human-Made_Object; use the supplied mapping rather than creating an alias.

Extract only what is visible:
- people and their observed actions;
- tools and materials;
- ordered craft actions, including demonstration, observation, attempt, guidance/correction, and independent execution when visible;
- visible gaze, gesture, posture, and tool/material contact when clear;
- the source frame IDs and video timestamps for each observation.

Represent people with crm:E21_Person; tools/objects with crm:E22_Human-Made_Object; and materials with crm:E57_Material. Represent observed actions with supported CRM/Mingei event or activity classes and supported relationships. Treat “journeyman”, “apprentice”, and ZPD states as descriptions unless a matching role/type term is explicitly present in the schemas. ScaffoldingInteraction and CraftProcessStep are conceptual labels, not schema terms: do not emit them as @type values unless the attached schema actually defines them.

Return one JSON-LD document only: valid JSON, with an @context and an @graph of nodes. Define crm as http://www.cidoc-crm.org/cidoc-crm/ and cro as https://dlnarratives.eu/ontology# in @context. Use stable IDs within this segment, link entities using supported properties, and use only schema-defined @type and property IRIs. Preserve evidence and timestamps in crm:P3_has_note values. If a detail cannot be seen, omit it or state that it is uncertain; never guess an identity, intention, emotion, skill level, or causal relationship. Do not include markdown fences, prose outside the JSON-LD, comments, or trailing commas.

Video segment: [SEGMENT ID AND TIME RANGE]
Frame IDs and timestamps: [FRAME ID = VIDEO TIMESTAMP, ...]
```

**Check:** Confirm the response begins with `{`, parses as JSON, and contains an `@context` and an `@graph`. Reject any answer with explanatory prose, markdown fences, guessed observations, or ontology terms that are not in the supplied files.

### 5. Keep ZPD interpretation separate from visual evidence

Qwen can report that a person points, demonstrates a grip, watches an attempt, or corrects a movement when those actions are visible. It cannot establish a learner's internal understanding, competence, intention, or that an action caused learning from a still frame alone.

Use observable descriptions first. Only classify an interaction as `MODELING`, `SCAFFOLDING`, `CORRECTION`, or `INDEPENDENT` when the sequence provides evidence; otherwise use an uncertainty description or leave the state unclassified. Treat these state names as project annotations unless the local ontology explicitly provides corresponding types.

**Check:** For each event, be able to point to its source frame(s) and timestamp(s). Remove claims that cannot be tied to visible evidence.

### 6. Validate and repair one segment at a time

1. Parse the output as JSON. Then check that:
   - every `@type` and property is defined by one of the attached schemas;
   - compact IRIs have prefixes in `@context`, or are replaced by their full IRIs;
   - each referenced `@id` has a corresponding node in the graph or an intentional external identifier;
   - CRM and Mingei relationships are used for their defined purpose;
   - frame IDs, timestamps, and descriptions match the supplied evidence.
2. If the output is invalid, send only the invalid JSON-LD and a focused repair request, for example:

   ```text
   Repair the JSON-LD below. Preserve its observations and IDs. Use only terms present in the attached schemas. Return only valid JSON-LD. Do not add facts or unsupported classes/properties.
   [PASTE INVALID OUTPUT]
   ```

3. Recheck the repaired output from the beginning; a repair prompt does not prove schema validity.
4. Save the accepted JSON-LD beside a note of the source video, segment/frame timestamps, selected model, and prompt version. Keep the raw model response if it differs from the accepted version.

### 7. Combine accepted segments and review the complete graph

After each segment passes validation, combine its `@graph` nodes into one graph. Preserve IDs or namespace them by segment to prevent collisions. Check that repeated people, tools, and materials are linked consistently across segments, and that event order follows the source timestamps. Run the JSON/JSON-LD validation again on the combined output.

**Completion check:** The final graph is parseable JSON-LD, uses only verified CRM/Mingei terms, can be traced back to the local video evidence, and distinguishes observations from interpretation.

### Schema note for this project

The supplied CRM context defines `E21_Person`, `E22_Human_Made_Object` (mapped to the CRM IRI `crm:E22_Human-Made_Object`), `E57_Material`, `E7_Activity`, and `P3_has_note`, among other terms. The Mingei file includes the classes `Person`, `Event`, and `ActorWithRole` under the namespace `https://dlnarratives.eu/ontology#`; `cro:` is a convenient prefix for that namespace only when it is declared in `@context`. The exact terms `CraftProcessStep` and `ScaffoldingInteraction` do not appear in the checked-in schema files, so do not use them as ontology classes. Model craft actions and scaffolding as supported events/activities with observed descriptions and links; adding new ontology classes would require separately defining and validating them in the schema.