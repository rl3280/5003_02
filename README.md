Can apprenticeship be digitized?  This hypothesis is tested by the following experiment:

1. Video journeyman-apprentice ZoPD.
2. Apply CIDOC-CRM and Mingei Crafts Ontologies in .jsonld format
3. Prompt Qwen3-VL-4B-Instruct to extract Schema from the video
4. Pass Structured Output to Llama-3.1-8B-Instruct to pseudocode a state machine
5. Code HTML/CSS/JS interactive Web representation rendering of state transitions

This repo started in the docs/pre and then the mingei and finally ZoPD.
From that, I decided to build schemas folder and then the ontologies.
The mingei could only be downloaded in .ttf, I had to convert it to .jsonld.  The AI is having problems with that.