Read the Mingei files as references while we create  HTML/CSS/JS interaction reflecting the "zone of proximal development" between a journeyman and apprentice

Camera Framing: Use a wide/medium shot that includes the Journeyman's face/hands, the Apprentice's hands, and the workbench to record physical gestures, gaze direction, and posture adjustments.

Endurants: 
 - the materials used to build a product: 2" x 4" pieces of wood, wires, tiles, pipes
 - the tools used: hammer, screwdriver, drill, solder gun

Perdurants:
 - correct handling of tools and materials
 - correct motion of tool to materials e.g, hammering a nail, drilling a screw, welding a pipe

Contextual/Social:
 - the relationship between journeyman and apprentice: modeling, scaffolding, gestures

Persons: Apprentice(s), Instructor.
Objects & Materials: from Endurants
Events / Actions: from Contextual/Social

Computational Thinking:
 - Decompose
 - Abstract
 - Algorithm
 - Build Process Schema steps (UML Activity Logic)

Pseudocode with AI
 - video feed -> extract schema use Qwen3-VL-4B-Instruct
 - variables -> generate code use Llama-3.1-8B-Instruct
 - use GitHub version control to file prompts

Web Prototype and Representation
HTML/CSS/JS interaction reflecting state machine interaction

That confirms QAIRT text generation works. To verify the vision path too, start interactive chat with the QAIRT model:

geniex-py chat qualcomm/Qwen3-VL-4B-Instruct


When it’s ready, type a prompt followed by the path to an image file, for example:

Describe this image: C:\Users\YourName\Pictures\photo.jpg



C:\Users\rlewis\.continue\config.yaml

& 'C:\Users\rlewis\AppData\Local\GenieX CLI\geniex.exe' serve

Local hosting on http://127.0.0.1:18181/