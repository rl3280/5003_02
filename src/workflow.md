`E73 Information Object` Workflow Transition Subclasses

SetNail (Nondominant Hand): AlignNail   --> JOIN -->  TapHammer --> AssessNail
        (Dominant Hand):    AlignHammer

AssessNail BRANCH --> If Nail Straight FORK             --> (Nondominant Hand): HoldPanel  --> JOIN --> DriveNail --> AssessNail
                                                            (Dominant Hand):    AlignHammer
                  --> ALTERNATIVE If Nail Crooked       --> AdjustNail --> AssessNail
                  --> ALTERNATIVE If Nail Crooked again --> RemoveNail --> SetNail

DriveNail --> DownSwing --> BRANCH --> If Flush with Panel --> STOP
                                       If Not Flush --> UpSwing --> DownSwing

MERGE Apprentice2
