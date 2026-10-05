# **Apprentice Hammering Project: Step-by-Step Procedure & Video-to-AI Workflow**

This document provides a comprehensive procedure for executing the computational thinking project on apprentices hammering nails in a basement workshop, combining the Heritage Representation Protocol with Computational Thinking (CT) principles and AI workflows.

## **1\. Step-by-Step Project Execution Procedure**

### **Step 1: Understanding & Video Recording (Protocol Step 1\)**

> * **Identify Entities & Context:** Outline key elements prior to filming:  
  * **Physical Items (Endurants):** Nails, hammers, workbenches, protective gear, wood blocks.  
  * **Craft Actions (Perdurants):** Positioning the nail, tapping (setting), driving strikes, adjusting grip, clearing bent nails.  
  * **Contextual/Social Factors:** Apprentice roles, instruction patterns, workshop environment (basement setup).  
> * **Record Audiovisual Data:** Film the apprentices hammering nails. Capture overall workshop activity, close-ups of hands and tool interactions, and varied apprentice skill levels.

### **Step 2: Extract Knowledge Elements (Protocol Step 2\)**

Watch your footage and define your core domain elements:

> * **Persons:** Apprentice(s), Instructor.  
> * **Objects & Materials:** Hammer (type/weight), Nail (length/material), Wood.  
> * **Events / Actions:**  
  * PositionNail (holding nail perpendicular)  
  * TapStrike (light initial hit to set)  
  * DriveStrike (full force hit)  
  * Inspect/Adjust (checking alignment or fixing bent nails)

### **Step 3: Computational Thinking Decomposition & Schema Modeling (Protocol Step 3 & Activity Step 2\)**

Apply CT principles to model the hammering process as an activity workflow (schema):

> 1. **Decomposition & Abstraction:** Strip away background noise and isolate essential variables (e.g., nail depth, hammer velocity, nail straightness).  
> 2. **Build Process Schema Steps (UML Activity Logic):** Model the sequential and conditional logic:  
   * **Start:** Pick up hammer and nail.  
   * **Action:** Place nail on surface.  
   * **Branching Node (Decision):** Is the nail flush with the wood?  
     * *No:* Apply DriveStrike. Is nail bent?  
       * *Yes:* Apply Adjust/Straighten or ExtractNail.  
       * *No:* Repeat strike loop.  
     * *Yes:* Process complete.

### **Step 4: Pseudocode Development with AI (Activity Step 3\)**

Use ChatGPT (or the CT Custom GPT) as a thinking partner to formalize your schema into pseudocode:

> 1. **Prompt AI:** Pass your extracted knowledge elements and step schema into AI.  
>    *Example Prompt:* "I am modeling apprentices hammering nails in a workshop. Help me translate this workflow into structured pseudocode. Include variables for nailDepth, hammerForce, and nailAngle, with conditional loops for setting, driving, and correcting bent nails."  
> 2. **Iterate & Refine:** Review AI logic against real video footage to ensure human intent, feedback loops, and errors (e.g., missed hits or bent nails) are captured correctly.

#### **Example Generated Pseudocode**

`FUNCTION HammerNail(nail, surface):`  
    `nail.depth = 0`  
    `nail.state = "UNSET"`  
      
    `// Step 1: Setting the nail`  
    `WHILE nail.state == "UNSET":`  
        `Execute TapStrike(force="LOW")`  
        `nail.depth += 2 // mm`  
        `IF nail.depth >= 5:`  
            `nail.state = "SET"`  
              
    `// Step 2: Driving the nail`  
    `WHILE nail.depth < nail.targetDepth:`  
        `Execute DriveStrike(force="HIGH")`  
          
        `// Branching / Conditional logic`  
        `IF DetectNailBent():`  
            `nail.state = "BENT"`  
            `Execute StraightenNail()`  
        `ELSE:`  
            `nail.depth += 10 // mm`  
              
    `nail.state = "FLUSH"`  
    `RETURN "SUCCESS"`  
`END FUNCTION`

### **Step 5: Web Prototype & Representation (Activity Step 4 & Protocol Step 5\)**

Create a simple HTML/CSS/JS interactive prototype (e.g., on CodePen) reflecting your state machine or interaction:

> * **Literal Example:** A button labeled "Strike" that increments a progress bar representing nail.depth until flush.  
> * **Abstract Example:** Visual indicator changing color/shape based on strike rhythm, precision, or nail state (e.g., Green \= straight, Red \= bent).

### **Step 6: Documentation & Submission (Activity Step 5 & Protocol Step 6\)**

Compile a Google Doc with your findings and submit via Canvas:

> 1. **Description of Phenomenon:** Overview of the basement hammering activity, roles, tools, and actions observed.  
> 2. **Heritage Protocol Mapping:** Outline how your video analysis mapped into Entities (Step 2\) and Process Schemas (Step 3).  
> 3. **AI Interaction Log:** Include prompts, raw AI outputs, and reflections on how you refined AI suggestions.  
> 4. **Code & Visuals:** Embed CodePen links, code snippets, and design sketches/diagrams.  
> 5. **CT Reflections:** Reflect on how decomposition and abstraction altered your perception of apprenticeship, craft dexterity, and physical practice.

## **2\. Passing Video Data into AI for Pseudocode Generation**

### **Option 1: Direct Video Upload (Fastest)**

Multimodal models can process video files directly:

> 1. **Trim & Keep It Short:** Clip your raw footage down to short, clear segments (15–45 seconds each) showing single complete actions (e.g., setting a nail, driving a nail, or correcting a bent nail).  
> 2. **Upload directly:** Attach and upload your MP4 file directly into the chat prompt, or share an unlisted link via Google Drive / YouTube if file sizes are large.  
> 3. **Use a Structured Prompt:***"Analyze this video clip of an apprentice hammering a nail. Extract the specific sequential physical actions, decision points (e.g., checking if the nail is straight or flush), and error states. Then, represent this entire process as clean, structured pseudocode with function calls, loops, and conditional statements."*

### **Option 2: Image Snapshots \+ Written Observations (Best Control)**

If video uploads are restricted by size or model capabilities, break the footage down into key frames:

> 1. **Extract Key Frame Screenshots:** Take 4–6 screenshots representing distinct stages of the hammering sequence:  
   * Frame 1: Initial positioning/grip  
   * Frame 2: Setting tap strikes  
   * Frame 3: Full driving strikes  
   * Frame 4: Decision check (straightening a bent nail or checking for a flush finish)  
> 2. **Upload Images as a Grid:** Drag all screenshots into your prompt at once.  
> 3. **Combine Visuals with Timestamp Notes:** Provide brief text notes along with the images to give context:*"Attached are 4 screenshots showing our basement hammering workflow:*  
>    *\- Image 1: PositionNail phase*  
>    *\- Image 2: TapStrike loop*  
>    *\- Image 3: Heavy DriveStrike loop*  
>    *\- Image 4: Checking depth/angle*

>    *Please map these 4 visual stages into a formal Process Schema (UML activity logic) and output equivalent pseudocode with WHILE loops for repeating strikes and IF/ELSE branches for correcting bent nails."*

### **Recommended Prompting Sequence for Refinement**

> 1. **Step 1 (Extract Schema):** Ask the AI to first list all **Variables** (e.g., nailDepth, hammerForce, isBent), **States** (e.g., UNSET, DRIVING, FLUSH), and **Events** it observes in the video.  
> 2. **Step 2 (Generate Code):** Once the schema is correct, ask the AI: *"Now translate those variables and states into pseudocode following standard programming syntax."*
