`E73 Information Object` Workflow Transition Subclasses

SetNail 

   (Nondominant Hand): AlignNail   --> JOIN -->  TapHammer --> AssessNail
   
   (Dominant Hand):    AlignHammer

AssessNail 

   BRANCH --> If Nail Straight FORK  --> (Dominant Hand):    AlignHammer --> JOIN --> DriveNail --> AssessNail 
                                         (Nondominant Hand): HoldPanel                                          
                                                            
          --> ALTERNATIVE If Nail Crooked       --> AdjustNail --> AssessNail
                  
          --> ALTERNATIVE If Nail Crooked again --> RemoveNail --> SetNail

DriveNail --> DownSwing --> BRANCH --> If Flush with Panel --> STOP

                                   --> ALTERNATIVE If Not Flush --> UpSwing --> DownSwing

FORK Apprentice2
