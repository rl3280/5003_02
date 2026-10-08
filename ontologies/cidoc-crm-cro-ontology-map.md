# CIDOC CRM -> CrO Ontology Map

Here is the updated mapping table showing how the **Mingei Crafts Ontology (CrO)** entities align directly with **CIDOC CRM (ISO 21127:2014)**, with all Europeana Data Model (EDM) references removed:

##### **Mapping Table: Mingei Crafts Ontology (CrO) to CIDOC CRM**

| **Mingei / CrO Entity** | **CIDOC CRM Base Entity / Subclass** | **Functional Description in MOP** |
| ------ | ------ | ------ |
| **cro:Narrative** | Subclass of E28 Conceptual Object / E73 Information Object | Overarching socio-historical story or cultural topic. |
| **Fabula** | Sequence of E5 Event entities | Chronological sequence of real-world events forming the structural backbone of a narrative. |
| **Narration** | Subclass of E33 Linguistic Object / E73 Information Object | Specific textual or verbal expression or telling of a story/Fabula. |
| **Presentation** | Subclass of E73 Information Object | Delivery format for a Narration tailored to specific devices or platforms (Web, VR, Mobile). |
| **Presentation Segment** | Subclass of E73 Information Object | Individual components of a Presentation mapped to specific communication channels. |
| **Channel** | Subclass of E73 Information Object | Serial media communication channels (e.g., video, audio, text). |
| **cro:MObject** *(Media Object)* | Subclass of E73 Information Object | Digital assets (photos, videos, audio, 3D models, motion capture/MoCap recordings). |
| **Process schema** | Subclass of E29 Design or Procedure | Abstract conceptual plan or prescription for how a craft process operates. |
| **Process schema step** | Subclass of E29 Design or Procedure | Individual step or sub-procedure within a process schema. |
| **Process** | Subclass of E7 Activity | Real physical execution or performance of a craft activity. |
| **Process step** | Subclass of E7 Activity | Individual physical action or event occurring during a craft process. |
| **Transition** | Subclass of E73 Information Object | Reified unconditional control-flow transition between schema steps without high-arity properties. |
| **Fork** | Subclass of E73 Information Object | Control-flow element splitting execution into parallel paths (1 input $\rightarrow$ multiple output steps). |
| **Merge** | Subclass of E73 Information Object | Control-flow element uniting multiple control paths into a single flow. |
| **Join** | Subclass of E73 Information Object | Control-flow element synchronizing parallel flows before proceeding to the next step. |
| **Branch** | Subclass of E73 Information Object | Decision step evaluating conditions to choose an outgoing path. |
| **Alternative** | Subclass of E73 Information Object | Represents alternative paths stemming from a Branch, including predicate conditions and destination steps. |
| **ActorWithRole** | Subclass of E39 Actor | Links a practitioner (E21 Person or E74 Group) to their specific role during an event or process step. |
| **Tool** | Extension of E22 Human-Made Object | Apparatus, hand tool, or body member employed during crafting. |
| **Product** | Extension of E22 Human-Made Object | Physical article created or material transformed through craft activities. |
| **E57 Material** | E57 Material | Physical substance used or transformed during crafting (e.g., glass, silk, marble). |
| **E53 Place** | E53 Place | Spatial location, workshop address, or geographic region. |
| **E52 Time-Span** | E52 Time-Span | Temporal duration, execution timeframe, or historical era. |
