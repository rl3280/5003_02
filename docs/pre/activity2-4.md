The implementation aligns with the **Mingei Crafts Ontology (CrO)** and the **Mingei Online Platform (MOP)** framework. By using Mingei's core distinction between **Endurants** (physical entities), **Perdurants** (actions/gestures), and **Process Schemas** (UML activity/decision loops), this setup structures the Zone of Proximal Development (ZPD) modeling, multimodal extraction, and the HTML/CSS/JS state machine implementation.

---

### Step 1: Mapping Entities to Mingei Ontology Schema

The activity maps directly onto Mingei’s conceptualization (extending CIDOC-CRM):

* **Persons:** `E21 Person` $\rightarrow$ Journeyman (Instructor), Apprentice.


* **Endurants (`E22 Human-Made Object` / `E57 Material`):**
* *Materials:* 2" x 4" wood, wires, tiles, pipes.


* *Tools:* Hammer, screwdriver, drill, solder gun.


* *Workspace:* Workbench (`E53 Place` reference).




* **Perdurants (`E7 Activity` / `E55 Type`):**
* *Physical Gestures:* Motion-capture/visual-tracking vectors derived from frame extraction.


* *Skeletal Data / Body Members:* Postures and gestures (hands, face, posture adjustments).




* **Contextual / Social (ZPD Interactions):**
* *Scaffolding Events:* Modeling (Journeyman demonstrates), Guiding (Apprentice executes, Journeyman corrects via gesture/gaze).





---

### Step 2: Activity Logic Workflow (ZPD Build Process Schema)

In Mingei, craft processes are represented as **Process Schemas** with conditional transition points. The ZPD interaction uses a state machine flow:

```text
[START: Task Assignment]
       │
       ▼
[State 1: MODELING] ──► Journeyman demonstrates tool/material interaction.
       │                Apprentice observes (Gaze/Posture logged).
       ▼
[State 2: SCAFFOLDING] ─► Apprentice attempts action (e.g., drilling/soldering).
       │                 Journeyman evaluates execution in real time.
       ▼
[Decision Point: Threshold Met?]
   ├── NO  ──► [State 3: INTERVENTION / CORRECTION]
   │             Journeyman uses gesture/verbal feedback ──► (Loop back to State 2)
   │
   └── YES ──► [State 4: INDEPENDENT EXECUTION] ──► [END]

```

---

### Step 3: Pipeline Architecture & Prompts (Qwen3-VL & Llama 3.1)

#### 1. Vision-Language Model Pipeline (`Qwen3-VL-4B-Instruct`)

*Target:* Extract perdurants (posture, gestures, gaze) and endurants (tools, materials) from the wide/medium camera shot to output Mingei JSON-LD metadata.

```text
PROMPT (Qwen3-VL-4B-Instruct):
Analyze the provided camera feed frame depicting a craft training session.
Extract the following entities as structured JSON matching Mingei Craft Ontology:
1. "endurants": List all visible tools (e.g., hammer, drill, solder gun) and materials (e.g., 2x4 wood, wires, tiles, pipes) on the workbench.
2. "perdurants":
   - "journeyman": Note body posture, hand gestures, and gaze direction (e.g., inspecting, demonstrating, pointing).
   - "apprentice": Note hand positioning, motion relative to material (e.g., hammering, drilling), and posture adjustments.
3. "zpd_interaction_state": Classify the current state as one of ["MODELING", "SCAFFOLDING", "CORRECTION", "INDEPENDENT"].

Output strictly valid JSON.

```

#### 2. Code/State Generation Pipeline (`Llama-3.1-8B-Instruct`)

*Target:* Convert extracted Mingei frame schema into state transitions for the Web frontend.

```text
PROMPT (Llama-3.1-8B-Instruct):
You are an expert JavaScript developer.
Given the following Mingei JSON representation of a craft interaction:
{{ QWEN_JSON_OUTPUT }}

Generate a JavaScript state machine update object with the properties:
- currentState: string
- activeEndurants: array of objects { name, status }
- activePerdurants: array of objects { actor, action, bodyMember }
- scaffoldingRequired: boolean
- nextActionMessage: string

Ensure compatibility with standard HTML5 custom event dispatching.

```

---

### Step 4: Web Prototype (HTML / CSS / JS Interaction)

This interactive Web representation renders state transitions between the **Journeyman** and **Apprentice** using a state-machine UI.

#### `index.html`

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Mingei ZPD Craft State Machine</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="container">
    <h1>Zone of Proximal Development: Craft Schema</h1>
    
    <!-- Camera Feed Representation -->
    <div id="workbench-view">
      <div id="journeyman-zone" class="actor">
        <h3>Journeyman (Instructor)</h3>
        <p>Gaze/Gesture: <span id="jm-gesture">Demonstrating</span></p>
      </div>
      
      <div id="apprentice-zone" class="actor">
        <h3>Apprentice</h3>
        <p>Action: <span id="app-action">Observing</span></p>
      </div>
      
      <div id="workbench" class="endurants-panel">
        <h3>Workbench Endurants</h3>
        <p>Tool in use: <span id="active-tool">None</span></p>
        <p>Material: <span id="active-material">2x4 Wood</span></p>
      </div>
    </div>

    <!-- State Control & Status -->
    <div class="controls">
      <div class="state-badge">Current State: <strong id="current-state">MODELING</strong></div>
      <button onclick="triggerStep('MODELING')">1. Model Action</button>
      <button onclick="triggerStep('SCAFFOLDING')">2. Apprentice Attempt</button>
      <button onclick="triggerStep('CORRECTION')">3. Correct / Adjust</button>
      <button onclick="triggerStep('INDEPENDENT')">4. Mastered</button>
    </div>

    <div id="log-output"></div>
  </div>

  <script src="app.js"></script>
</body>
</html>

```

#### `style.css`

```css
body {
  font-family: Arial, sans-serif;
  background-color: #f4f6f8;
  color: #333;
  padding: 20px;
}

.container {
  max-width: 800px;
  margin: 0 auto;
  background: #fff;
  padding: 24px;
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}

#workbench-view {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  margin-bottom: 20px;
}

.actor, .endurants-panel {
  border: 2px solid #ddd;
  border-radius: 6px;
  padding: 12px;
  background-color: #fafafa;
}

.endurants-panel {
  grid-column: span 2;
  background-color: #eef3f8;
}

.controls {
  display: flex;
  gap: 8px;
  align-items: center;
  margin-bottom: 16px;
}

.state-badge {
  padding: 8px 12px;
  background: #e2e8f0;
  border-radius: 4px;
}

button {
  padding: 8px 12px;
  border: none;
  background-color: #0066cc;
  color: white;
  border-radius: 4px;
  cursor: pointer;
}

button:hover {
  background-color: #004b99;
}

#log-output {
  font-family: monospace;
  background: #1e1e1e;
  color: #00ff66;
  padding: 12px;
  border-radius: 4px;
  min-height: 80px;
}

```

#### `app.js`

```javascript
// Mingei Craft Schema State Machine Simulation
const zpdStateMachine = {
  currentState: 'MODELING',
  schemaData: {
    MODELING: {
      jmGesture: 'Modeling proper drill tilt (90°)',
      appAction: 'Observing posture and grip',
      tool: 'Drill',
      material: '2" x 4" Wood',
      log: '[Mingei Schema]: Journeyman establishes initial process schema via physical demonstration.'
    },
    SCAFFOLDING: {
      jmGesture: 'Close monitoring, hands near workbench',
      appAction: 'Drilling screw into wood (Posture offset: +12°)',
      tool: 'Drill',
      material: '2" x 4" Wood',
      log: '[Mingei Schema]: Apprentice executing perdurant. Deviation detected in motion vector.'
    },
    CORRECTION: {
      jmGesture: 'Physical adjustment / hand guidance',
      appAction: 'Adjusting grip based on scaffolding',
      tool: 'Drill',
      material: '2" x 4" Wood',
      log: '[Mingei Schema]: ZPD Scaffolding active. Journeyman applies posture correction.'
    },
    INDEPENDENT: {
      jmGesture: 'Observing from medium distance',
      appAction: 'Precise drilling complete',
      tool: 'Drill',
      material: '2" x 4" Wood',
      log: '[Mingei Schema]: Task successfully executed within tolerance thresholds.'
    }
  }
};

function triggerStep(state) {
  zpdStateMachine.currentState = state;
  const data = zpdStateMachine.schemaData[state];

  // Update DOM elements representing Mingei Endurants and Perdurants
  document.getElementById('current-state').textContent = state;
  document.getElementById('jm-gesture').textContent = data.jmGesture;
  document.getElementById('app-action').textContent = data.appAction;
  document.getElementById('active-tool').textContent = data.tool;
  document.getElementById('active-material').textContent = data.material;
  
  // Append transition log
  const logDiv = document.getElementById('log-output');
  logDiv.textContent = data.log;
}

// Initial state load
triggerStep('MODELING');

```
