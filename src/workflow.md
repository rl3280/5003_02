`E73 Information Object` Workflow Transition Subclasses

SetNail (Nondominant Hand): AlignNail   --> JOIN -->  TapHammer --> AssessNail
        (Dominant Hand):    AlignHammer

AssessNail --> If Straight --> (Nondominant Hand): HoldPanel  --> JOIN --> DriveNail --> AssessNail
                               (Dominant Hand):    AlignHammer
               If Crooked  --> AdjustNail --> AssessNail
               If Crooked again --> RemoveNail --> SetNail
