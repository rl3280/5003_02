import csv
import json
import sys

from pathlib import Path

def generate_qwen_prompt(csv_file_path: str, output_prompt_path: str | None = None):
    """
    Reads a CSV annotation file and produces a structured prompt enforcing 
    strict CIDOC CRM v7.1.3 and Mingei CrO JSON-LD output from Qwen3-VL-4B-Instruct.
    """
    records = []
    with open(csv_file_path, mode='r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            records.append(row)
    if output_prompt_path is None:
        file_name = records[0].get("file_name", "").strip() if records else ""
        output_prompt_path = (
            Path(file_name).with_suffix(".txt").name
            if file_name
            else "qwen_prompt.txt"
        )
    system_prompt = """You are an expert Semantic Web and Cultural Heritage ontology engineer specializing in the Mingei Crafts Ontology (CrO) and CIDOC CRM (v7.1.3).
Your task is to analyze the provided video clip keyframes and metadata records, and decompose them into STRICT JSON-LD output adhering to the provided contexts.

### MANDATORY CONTEXT REFERENCES
- Context 1: @CIDOC_CRM_v7.1.3_JSON-LD_Context.jsonld
- Context 2: @mingei-ontology.jsonld

### ONTOLOGY MAPPING &amp; DECOMPOSITION RULES
1. Tools &amp; Objects:
   - Physical tools (e.g., Hammer, Saw, Hand Plane) =&gt; `cro:Tool` (Extension of CIDOC CRM `E22 Human-Made Object`).
     Example: Hammer =&gt; `cro:Tool` =&gt; Extension of `E22 Human-Made Object` (`crm:P2_has_type`: "Tool").
   - Consumables &amp; Raw Materials (e.g., Nails, Timber) =&gt; `crm:E57_Material` or `cro:Product` (Extension of `E22 Human-Made Object`).
2. Actors &amp; ZPD Roles:
   - Journeyman and Apprentices =&gt; `cro:ActorWithRole` (subclass of `E39 Actor`).
   - Link `crm:E21_Person` to their role string ("Journeyman", "Apprentice").
3. Process Performance vs. Media Objects:
   - Observed activity segment =&gt; `cro:Process step` (subclass of CIDOC CRM `E7 Activity`).
   - Video media object fragment =&gt; `cro:MObject` (subclass of `E73 Information Object`), linked via `cro:refersToMO`.

### OUTPUT FORMAT REQUIREMENTS
- Emit ONLY valid, syntactically correct JSON-LD objects or a JSON-LD array.
- Do NOT include conversational filler, preamble, or explanations outside the JSON-LD code block.

### INPUT ANNOTATION RECORDS:
"""

    prompt_body = [system_prompt]

    for idx, rec in enumerate(records, 1):
        prompt_body.append(f"--- ANNOTATION RECORD {idx} ---")
        prompt_body.append(f"Media File: {rec.get('file_name', '')}")
        prompt_body.append(f"Time-Span: {rec.get('timestamp_start', '')} TO {rec.get('timestamp_end', '')}")
        prompt_body.append(f"Observed Craft Action: {rec.get('observed_action', '')}")
        prompt_body.append(f"Participating Actors: {rec.get('actors', '')}")
        prompt_body.append(f"Tools &amp; Materials: {rec.get('tools_materials', '')}")
        prompt_body.append(f"Target CRM/CrO Classes: {rec.get('crm_cro_ids', '')}")
        prompt_body.append("")

    prompt_body.append("### INSTRUCTION FOR QWEN3-VL:")
    prompt_body.append("For each record above, process the clip frames and generate the corresponding `cro:Process step` JSON-LD object using `@mingei-ontology.jsonld` and `@CIDOC_CRM_v7.1.3_JSON-LD_Context.jsonld`.")

    full_prompt_text = "\n".join(prompt_body)

    with open(output_prompt_path, "w", encoding="utf-8") as out_file:
        out_file.write(full_prompt_text)

    print(f"[SUCCESS] Efficient Qwen3-VL prompt generated and saved to: {output_prompt_path}")
    return full_prompt_text

if __name__ == "__main__":
    if len(sys.argv) > 1:
        generate_qwen_prompt(sys.argv[1])
    else:
        print("Usage: python csv2prompt.py <annotations.csv>")
