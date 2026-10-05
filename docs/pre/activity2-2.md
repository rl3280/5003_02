# **Apprentice & Journeyman ZPD Hammering Project**

This document details the refined procedure for observing and modeling the interaction between an apprentice and a journeyman (the Zone of Proximal Development) during a hammering activity, combining the Heritage Representation Protocol, Computational Thinking (CT) principles, and local AI execution on a ThinkPad X14 via Qualcomm AI Hub Models and GenieX.

## **1\. Refined Step-by-Step Project Procedure**

### **Step 1: Video Capture of the ZPD Interaction (Protocol Step 1\)**

Focus camera placement on capturing both physical craft actions and interpersonal dynamics:

* **Camera Framing:** Use a wide/medium shot that includes the Journeyman's face/hands, the Apprentice's hands, and the workbench to record physical gestures, gaze direction, and posture adjustments.  
* **Key ZPD Perdurants (Events) to Record:**  
  * **Scaffolding / Demonstration:** Journeyman demonstrates tapping or holding posture.  
  * **Guided Execution:** Apprentice attempts action while Journeyman observes or physically guides.  
  * **Verbal / Gestural Feedback Loop:** Journeyman intervenes (e.g., "Grip higher up," "Stop, the nail is bending").  
  * **Independent Execution:** Apprentice hammers without intervention.

### **Step 2: Extracting ZPD Knowledge Elements (Protocol Step 2\)**

Map the social-pedagogical elements into heritage entities:

* **Persons:** Journeyman (Scaffolder), Apprentice (Learner).  
* **Objects / Tools:** Hammer, Nail, Wood.  
* **Interaction Events / States:**  
  * DemonstrateTechnique  
  * AttemptStrike  
  * Intervene\_Correction (e.g., stance fix, grip adjustment)  
  * Validate\_Success (verbal praise or physical nod)

### **Step 3: Recommended Models from Qualcomm AI Hub (for GenieX on ThinkPad X14)**

Because you are running locally on Snapdragon X architecture via GenieX, leverage Qualcomm AI Hub's hardware-optimized Vision-Language Models (VLMs) and Large Language Models (LLMs):

1. **Primary VLM for Video Frame Analysis:**  
   * **Qwen2.5-VL-7B-Instruct or Qwen3-VL-4B-Instruct:** Ideal for multimodal visual reasoning. Feed key video frame sequences (or short video clips) into this VLM to automatically identify physical interactions, tool orientation, and human intervention moments.  
   * **SmolVLM2-2.2B-Instruct / Intern3.5-VL-2B:** Ultra-lightweight alternatives if you want high frame-rate processing without heavy NPU/GPU overhead.  
2. **Code & Logic Generation Model:**  
   * **Qwen3-4B-Instruct or Llama-3.1-8B-Instruct:** Once the VLM outputs textual event logs of the interaction, pass the structured logs into one of these LLMs via GenieX to write the UML Activity Schema and execution pseudocode.

### **Step 4: Video-to-AI Analysis Workflow on GenieX**

Run a two-stage local inference pipeline using GenieX:

#### **Stage A: Frame/Video Analysis with VLM (Qwen2.5-VL or Qwen3-VL)**

Extract 4–8 key frames representing a complete instruction cycle and run this prompt in GenieX:

**Prompt to VLM:**

*"Analyze these video frames showing a Journeyman instructing an Apprentice on hammering a nail. Identify and log the following elements in sequence:*

1. *Journeyman action (e.g., demonstrating, pointing, physically intervening).*  
2. *Apprentice action (e.g., observing, attempting strike, adjusting grip).*  
3. *Decision/Feedback trigger (e.g., did the apprentice make a mistake, did the journeyman correct it?)."*

#### **Stage B: Pseudocode Schema Generation with LLM (Qwen3 or Llama-3.1)**

Feed the extracted event log into your local LLM to build a state-machine that models the ZPD feedback loop:

**Prompt to LLM:**

*"Using the attached event log of a Journeyman-Apprentice interaction, create structured pseudocode that models the Zone of Proximal Development (ZPD). Include variables for apprenticeCompetence, journeymanInterventionNeeded, nailState, and strikeSuccess. Use WHILE loops for repeated strikes and IF/ELSE branches for Journeyman scaffolding and corrections."*

### **Step 5: Example ZPD Pseudocode Output**

Plaintext

```
FUNCTION ZoneOfProximalDevelopment_Hammering(apprentice, journeyman, nail):
    apprentice.skillLevel = "NOVICE"
    nail.depth = 0
    nail.state = "UNSET"

    // Phase 1: Journeyman Demonstration (Scaffolding)
    journeyman.Execute(DemonstrateGripAndTap)
    apprentice.Observe()

    // Phase 2: Apprentice Attempt with Journeyman Supervision
    WHILE nail.depth < nail.targetDepth:
        // Apprentice attempts strike
        apprentice.Execute(DriveStrike)
        
        // Journeyman evaluates frame / action (Feedback Loop)
        IF DetectNailBent() OR DetectIncorrectGrip():
            journeyman.Intervene(CorrectionType="AdjustAngleOrGrip")
            apprentice.ApplyCorrection()
            apprentice.skillLevel += 0.1 // Learning progression
        ELSE:
            nail.depth += 8 // mm
            journeyman.ProvideFeedback(Type="PositiveReinforcement")

    nail.state = "FLUSH"
    RETURN "TASK_COMPLETED_WITH_SCAFFOLDING"
END FUNCTION
```

### **Step 6: Prototype & Submission (Activity Steps 4 & 5\)**

1. **Interactive Prototype (CodePen):** Create a two-actor web interface (e.g., two visual status indicators: "Apprentice Action" vs. "Journeyman Intervention") where clicking "Strike" occasionally triggers a Journeyman correction pop-up or state shift.  
2. **Google Doc & Canvas Submission:** Document the phenomenon (ZPD in craft heritage), include your GenieX/Qualcomm AI Hub model prompts, present your pseudocode/CodePen link, and reflect on how computational thinking helped quantify human learning and mentorship.

