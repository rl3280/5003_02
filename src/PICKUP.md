Treat the **sanding activity as one event** and the Nikon and Moto recordings as **two views of that event**. In your prompt, replace the single `Media File` line with a shared event ID and a list of recordings. For example:

```text
Observation ID: sanding_event_001
Observed Craft Action: Apprentice sanding a wood panel under Journeyman guidance.
This is one activity recorded contemporaneously by two cameras—not two separate activities.

Media Evidence:
- Camera: Nikon
  File: clip1_nikon_sanding_0425_0445.mkv
  Segment: 4:25 to 4:45 (Nikon file time)
  Perspective: [describe what this camera shows]
- Camera: Moto
  File: [exact Moto clip filename]
  Segment: [start to end time in Moto file]
  Perspective: [describe what this camera shows]

Participating Actors: Journeyman, Apprentice_1
Tools & Materials: Hand Plane (Tool), Wood Panel (E57 Material)
Target CRM/CrO Classes: cro:Process step, cro:ActorWithRole, cro:Tool, crm:E57_Material, cro:MObject
```

Then change the final instruction to make the intended result explicit:

```text
Treat all media evidence listed for an Observation ID as different perspectives of the same activity. Generate ONE cro:Process step for that activity, not one per camera. Represent the Nikon and Moto recordings as separate cro:MObject media items, and link both to that same process step using the relationship defined by the provided ontology contexts. Use the extracted frames as visual evidence for their respective recordings.
```

Use each camera’s **own file-relative timestamps**. Only describe the segments as precisely synchronized if you know the recordings’ time offsets; otherwise, “recorded contemporaneously” is safer. For extracted pictures, list the image filenames under the corresponding camera’s evidence so GenieX can tell which viewpoint each frame came from.
