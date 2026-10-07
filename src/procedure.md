In the Mingei protocol for traditional craft documentation, filming under **native conditions** (unscripted, live ethnographic observation) captures what craft theory calls the *"workmanship of risk"*—spontaneous decision-making, error corrections, and embodied learning gestures as they happen in real time.

Here is the procedure tailored to your **2-hour unscripted shoot**, detailed **clip metadata conventions**, and **HandBrake segmentation workflow** (with the CSV prompt tool removed as requested).

---

### **1. Filming in "Native" Unscripted Conditions (2-Hour Window)**

When recording live, unscripted interactions between a Journeyman and Apprentices, the goal is to capture continuous activity without interrupting the flow of work or forcing artificial pauses.

```
                  ┌──────────────────────────────────────────────────┐
                  │       NATIVE (UNSCRIPTED) DUAL-CAMERA SETUP      │
                  └─────────────────────────┬────────────────────────┘
                                            │
               ┌────────────────────────────┴────────────────────────────┐
               ▼                                                         ▼
  ┌───────────────────────────┐                             ┌───────────────────────────┐
  │  4K NIKON (Master View)   │                             │   PHONE (Mobile ZPD View) │
  │ • Continuous spatial log  │                             │ • Handheld                │
  │ • Captures workspace &    │                             │ • Dynamic close-ups of    │
  │   both actors throughout  │                             │   tool grips, posture, &  │
  │                           │                             │   spontaneous corrections │
  └───────────────────────────┘                             └───────────────────────────┘
```

#### **Phase A: Sync & Initial Setup (10 Minutes)**
1. **Continuous Timecode & Audio Clap**: Start both cameras recording. Before any woodworking begins, perform a clear visual and audio hands-clap in full view of both cameras. This sync point lets you correlate timecodes between the 4K Nikon master shot and the mobile phone close-ups post-shoot.
2. **Camera Positioning**:
   * **4K Nikon (Master View)**: Handheld in native environment. Keeps the entire bench, Journeyman, Apprentices, tools, and raw materials (`E57 Material`) in frame at all times.
   * **Phone Camera (Mobile ZPD View)**: Move around the workbench to capture **micro-gestures**: hand position on the hammer handle, saw angle adjustments, and moments where the Journeyman physically guides an apprentice's hand or points out a mistake.

#### **Phase B: Live Observation (110 Minutes)**
3. **Capture Natural ZPD Interactions**: Let the artisans work naturally. Watch specifically for:
   * **Demonstration & Imitation**: Journeyman executing a stroke vs. Apprentice attempting it (`cro:Process step`).
   * **Decision Branches (`cro:Branch`)**: The apprentice checking if a joint is flush or evaluating a measurement.
   * **Error Recovery (`cro:Alternative`)**: Spontaneous corrections, such as pulling a bent nail, re-marking wood, or adjusting grip.
   * **Parallel Actions (`cro:Fork` / `Join`)**: Journeyman holding a piece stationary while an apprentice saws or hammers.
4. **Running Timestamp Log**: Wear a digital watch or keep a notebook to jot down rough timestamps when noticeable transitions or learning corrections occur (e.g., `14:22 - Journeyman adjusts apprentice wrist angle on hammer`).
5. Return to Phase A and restart filming every ~15 minutes.

---

### **2. HandBrake Clip Segmentation & Metadata Conventions**

After capture, long continuous video files must be segmented into short, focused clips representing distinct task episodes, and prepared for VLM processing.

#### **A. HandBrake Processing Protocol**

1. **Range Selection (Trimming)**:
   * Change the **Range** selector from *Chapters* to *Seconds* (or *Frames*).
   * Input the exact start/end timecode identified from your live log (e.g., `00:14:20` to `00:14:45`).
2. **Dimensions Tab (Standardization)**:
   * Set **Max Storage Size** to **1920x1080** (1080p). Standardizing resolution optimizes token usage in Qwen3-VL.
3. **Video Tab (1 FPS Frame Extraction)**:
   * Set **Framerate (FPS)** to **1** (or **2** for fast action).
   * Set **Framerate Mode** to **Constant Framerate (CFR)**. This outputs 1 representative frame per second across the clip, eliminating the need to manually dump raw JPG folders.
   * Set **Encoder** to H.264 (Fast profile).
4. **Export Batch**: Queue all trimmed ranges and export into a dedicated `/workspace/clips/` directory.

---

#### **B. Comprehensive Metadata Naming & Structure**

Each exported clip must follow a strict, deterministic file naming schema and associated metadata file to tie signal assets (`cro:MObject`) to semantic entities in the graph.

##### **1. File Naming Schema**
clip _ [CAMERA] _ [SCENE/TASK] _ [STARTTIME] _ [ENDTIME].[ext]

* **Master Camera Example**: `clip_nikon_nailing_001420_001445.mkv`
* **Mobile Phone Example**: `clip_phone_nailing_001420_001445.mkv`

##### **2. JSON Metadata Record (`clip_nikon_nailing_001420_001445.json`)**
Alongside each exported clip, save a structured JSON metadata file containing technical attributes, observational tags, and target ontology classes:
##### **Minimalist JSON Metadata File Example (** **clip\_nikon\_nailing\_001420\_001445.json** **)**

```
{
  "file_name": "clip_nikon_nailing_001420_001445.mp4",
  "start": "00:14:20.000",
  "end": "00:14:45.000",
  "action": "Journeyman adjusting Apprentice stance and wrist grip during hammering",
  "elements": "Journeyman, Apprentice_1, Claw Hammer, Steel Nail, Wood Board"
}

```

---

#### **3\. Step-by-Step**
---

### **3. Day-by-Day Execution Procedure**

```
                     ┌──────────────────────────────────────────────┐
                     │          DAYS 1 & 2: FILMING & CLIPS         │
                     │ • Native, unscripted dual-camera filming     │
                     │ • HandBrake clip segmentation & 1 FPS CFR    │
                     │ • Populate metadata JSON / CSV table         │
                     └──────────────────────┬───────────────────────┘
                                            │
                                            ▼
                     ┌──────────────────────────────────────────────┐
                     │          DAY 3: VISUAL ANALYSIS              │
                     │ • Run Qwen3-VL-4B-Instruct via GitHub tool   │
                     │ • Parse clip keyframes + metadata CSV        │
                     │ • Generate concrete `cro:Process step`       │
                     │   JSON-LD instance graphs                    │
                     └──────────────────────┬───────────────────────┘
                                            │
                                            ▼
                     ┌──────────────────────────────────────────────┐
                     │        DAY 4: STATE MACHINE BUILDING         │
                     │ • Run Llama-3.1-8B-Instruct on JSON-LD array │
                     │ • Synthesize abstract `cro:Process schema`   │
                     │ • Reify `Branch`, `Alternative`, `Fork`      │
                     │ • Connect instances via `cro:correspondsTo`  │
                     └──────────────────────────────────────────────┘
```

#### **DAYS 1 & 2: Filming & Video Preparation**
1. **Shoot Unscripted Footage**: Execute the 2-hour native video session following the dual-camera setup and running timestamp jottings.
2. **Segment Clips in HandBrake**: Load raw footage into HandBrake, trim task episodes into 10–30 second clips at 1 FPS (CFR), and export to `/workspace/clips/`.
3. **Populate Annotations CSV**: Enter clip file names, time-spans, observed actors, tools, materials, and target CrO/CRM IDs into your master CSV table (`annotations.csv`).

#### **DAY 3: Visual Analysis via Qwen3-VL (Process Instance Extraction)**
1. **Generate Prompt Payload**: Use your GitHub Python script to convert `annotations.csv` into the structured Qwen prompt referencing `@mingei-ontology.jsonld` and `@CIDOC_CRM_v7.1.3_JSON-LD_Context.jsonld`.
2. **Run Qwen3-VL-4B-Instruct**: Pass the 1 FPS clip frame sequences alongside the prompt.
3. **Collect JSON-LD Instances**: Qwen will emit valid `cro:Process step` JSON-LD graphs representing the concrete observed events, complete with `cro:ActorWithRole`, `cro:Tool`, `E57 Material`, `E52 Time-Span`, and links to media fragments (`cro:MObject` via `cro:refersToMO`).

#### **DAY 4: State Machine Synthesis via Llama-3.1 (Schema Abstractor)**
1. **Feed Concrete Graphs to Llama-3.1-8B-Instruct**: Input the array of concrete `cro:Process step` JSON-LD outputs produced on Day 3.
2. **Synthesize `cro:Process schema`**: Prompt Llama-3.1 to abstract the individual executions into a generalized workflow state machine.
3. **Reify Control-Flow Nodes**: Require Llama-3.1 to structure decision points and transitions using explicit CrO transition classes:
   * `cro:Branch` & `cro:Alternative` (for decision conditions like "Nail Flush == True/False").
   * `cro:Fork` & `cro:Join` (for parallel Journeyman/Apprentice tasks).
   * `cro:Transition` (for simple sequential steps).
4. **Link Instances to Schema**: Add `cro:correspondsTo` predicates to link each concrete `cro:Process step` instance to its parent `cro:Process schema step`.

---

💡 **Next Steps**: As you prepare for filming in two days, would you like me to draft the system prompt for **Llama-3.1-8B-Instruct** on Day 4 to ensure its state-machine JSON-LD output strictly reifies `cro:Branch` and `cro:Alternative` nodes without syntax errors?
