To convert frame-by-frame annotation CSV logs into clean state transitions without burning through tokens, you need an algorithm that separates **structural schema validation** from **observed event log execution**.

The issue you faced in LLMs (Qwen/Llama) generating JSON-LD state machines stems from mixing two distinct ontology layers into a single schema:

1. **Schema Layer (E29\_Design\_or\_Procedure)**: The reusable control-flow graph (Nodes: Fork, Join, Branch, Merge, Alternative).  
2. **Instance Layer (E7\_Activity)**: Observed execution instances bound to specific video frames (E52\_Time\_Span).

### **MOP / CIDOC CRM State Machine Pseudocode**

The following pseudocode demonstrates how to parse CSV frame annotations into state machine transitions, evaluating conditions to match the control flows defined in **2\_mingei-hammering-activity-diagram.md** and mapped via **1\_map.csv**.

Python

```
import pandas as pd

# Load files to inspect schema
df_map = pd.read_csv('1_map.csv')
df_ann = pd.read_csv('annotations.csv')

print("MAP CSV columns:", df_map.columns.tolist())
print(df_map.head(3))
print("\nANNOTATIONS CSV columns:", df_ann.columns.tolist())
print(df_ann.head(3))

```

Code output

```
MAP CSV columns: ['CIDOC CRM class', 'Name', 'Mingei1', 'Mingei2', 'Mingei3', 'Mingei4', 'Mingei5']
  CIDOC CRM class        Name  Mingei1          Mingei2 Mingei3 Mingei4 Mingei5
0              E5       Event   Fabula  CraftingProcess     NaN     NaN     NaN
1              E7    Activity  Process      ProcessStep     NaN     NaN     NaN
2             E12  Production      NaN              NaN     NaN     NaN     NaN

ANNOTATIONS CSV columns: ['Mobject', 'E52 Time-Span, TemporalEntity', 'E5 Event, CraftingProcess', 'E29 Actor, ActorWithRole', 'E21 Person', 'E22 Human-Made Object, Tool', 'E57 Material, RawMaterial', 'E7 Activity, Process', 'E7 Activity, ProcessStep', 'E73 Information Object', 'E14 Condition Assessment']
    Mobject E52 Time-Span, TemporalEntity                         E5 Event, CraftingProcess E29 Actor, ActorWithRole   E21 Person E22 Human-Made Object, Tool E57 Material, RawMaterial  E7 Activity, Process E7 Activity, ProcessStep E73 Information Object E14 Condition Assessment
0  0030.jpg                          0:30  Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails  Journeyman Hammering                      NaN                    NaN              AlignHammer
1  0031.jpg                          0:31  Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails  Journeyman Hammering                BackSwing                    NaN                      NaN
2  0032.jpg                          0:32  Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails  Journeyman Hammering                      NaN                    NaN              AlignHammer

```

Python

```
print("Unique Process Steps:", df_ann['E7 Activity, ProcessStep'].dropna().unique())
print("Unique Condition Assessments:", df_ann['E14 Condition Assessment'].dropna().unique())
print("Unique Processes:", df_ann['E7 Activity, Process'].dropna().unique())

```

Code output

```
Unique Process Steps: ['BackSwing' 'DownSwing' 'RemoveNail' 'LoadDrillBit' 'Drill']
Unique Condition Assessments: ['AlignHammer' 'AlignBoardsFlush' 'InspectNail' 'AlignNail' 'AlignDrill'
 'HoldDrill']
Unique Processes: ['Journeyman Hammering' 'Journeyman Flush Align Panel Edges'
 'Apprentice Hammering' 'Journeyman Inspects Nail'
 'Apprentice Pulling Out Nail' 'Journeyman Realigns Nail'
 'Journeyman Drilling']

```

Python

```
print(df_ann.to_string())

```

Code output

```
      Mobject E52 Time-Span, TemporalEntity                                            E5 Event, CraftingProcess E29 Actor, ActorWithRole   E21 Person E22 Human-Made Object, Tool E57 Material, RawMaterial                E7 Activity, Process E7 Activity, ProcessStep E73 Information Object E14 Condition Assessment
0    0030.jpg                          0:30                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                      NaN                    NaN              AlignHammer
1    0031.jpg                          0:31                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                BackSwing                    NaN                      NaN
2    0032.jpg                          0:32                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                      NaN                    NaN              AlignHammer
3    0033.jpg                          0:33                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                DownSwing                    NaN                      NaN
4    0034.jpg                          0:34                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                      NaN                    NaN                      NaN
5    0035.jpg                          0:35                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                      NaN                    NaN              AlignHammer
6    0036.jpg                          0:36                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                      NaN                    NaN              AlignHammer
7    0037.jpg                          0:37                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                      NaN                    NaN              AlignHammer
8    0038.jpg                          0:38                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                      NaN                    NaN              AlignHammer
9    0039.jpg                          0:39                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                      NaN                    NaN              AlignHammer
10   0040.jpg                          0:40                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                      NaN                    NaN              AlignHammer
11   0041.jpg                          0:41                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                      NaN                    NaN              AlignHammer
12   0042.jpg                          0:42                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                      NaN                    NaN              AlignHammer
13   0043.jpg                          0:43                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                BackSwing                    NaN                      NaN
14   0044.jpg                          0:44                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                DownSwing                    NaN                      NaN
15   0045.jpg                          0:45                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                DownSwing                    NaN                      NaN
16   0046.jpg                          0:46                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                BackSwing                    NaN                      NaN
17   0047.jpg                          0:47                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                DownSwing                    NaN                      NaN
18   0048.jpg                          0:48                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                BackSwing                    NaN                      NaN
19   0049.jpg                          0:49                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                DownSwing                    NaN                      NaN
20   0050.jpg                          0:50                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                DownSwing                    NaN                      NaN
21   0051.jpg                          0:51                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                BackSwing                    NaN                      NaN
22   0052.jpg                          0:52                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                DownSwing                    NaN                      NaN
23   0053.jpg                          0:53                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                      NaN                    NaN              AlignHammer
24   0054.jpg                          0:54                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                BackSwing                    NaN                      NaN
25   0055.jpg                          0:55                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                BackSwing                    NaN                      NaN
26   0056.jpg                          0:56                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                DownSwing                    NaN                      NaN
27   0057.jpg                          0:57                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                      NaN                    NaN              AlignHammer
28   0058.jpg                          0:58                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                      NaN                    NaN              AlignHammer
29   0059.jpg                          0:59                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                      NaN                    NaN              AlignHammer
30   0100.jpg                          1:00                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                      NaN                    NaN              AlignHammer
31   0101.jpg                          1:01                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                Journeyman Hammering                      NaN                    NaN              AlignHammer
32   0102.jpg                          1:02                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                                 NaN                      NaN                    NaN                      NaN
33   0103.jpg                          1:03                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                                 NaN                      NaN                    NaN                      NaN
34   0104.jpg                          1:04                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                                 NaN                      NaN                    NaN                      NaN
35   0105.jpg                          1:05                     Journeyman modeling correct way to hammer a nail               Journeyman  Apprentice1                      Hammer               wood, nails                                 NaN                      NaN                    NaN                      NaN
36   0127.jpg                          1:27                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice2                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
37   0128.jpg                          1:28                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice2                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
38   0129.jpg                          1:29                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice2                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
39   0130.jpg                          1:30                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice2                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
40   0131.jpg                          1:31                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice2                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
41   0132.jpg                          1:32                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice2                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
42   0133.jpg                          1:33                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice2                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
43   0134.jpg                          1:34                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice2                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
44   0135.jpg                          1:35                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice2                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
45   0136.jpg                          1:36                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice2                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
46   0137.jpg                          1:37                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice2                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
47   0241.jpg                          2:41                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
48   0242.jpg                          2:42                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
49   0243.jpg                          2:43                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
50   0244.jpg                          2:44                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
51   0245.jpg                          2:45                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
52   0246.jpg                          2:46                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
53   0247.jpg                          2:47                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
54   0248.jpg                          2:48                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
55   0249.jpg                          2:49                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                DownSwing                   join                      NaN
56   0250.jpg                          2:50                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                BackSwing                    NaN                      NaN
57   0251.jpg                          2:51                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                         NaN                     nails            Journeyman Inspects Nail                      NaN                    NaN              InspectNail
58   0252.jpg                          2:52                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                         NaN                     nails            Journeyman Inspects Nail                      NaN                    NaN              InspectNail
59   0253.jpg                          2:53                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                         NaN                     nails            Journeyman Inspects Nail                      NaN                 branch              InspectNail
60   0254.jpg                          2:54                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                 Hammer Claw               wood, nails         Apprentice Pulling Out Nail               RemoveNail                    NaN                      NaN
61   0255.jpg                          2:55                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                 Hammer Claw               wood, nails         Apprentice Pulling Out Nail               RemoveNail                    NaN                      NaN
62   0256.jpg                          2:56                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                 Hammer Claw               wood, nails         Apprentice Pulling Out Nail               RemoveNail                    NaN                      NaN
63   0257.jpg                          2:57                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                 Hammer Claw               wood, nails         Apprentice Pulling Out Nail               RemoveNail                    NaN                      NaN
64   0258.jpg                          2:58                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                 Hammer Claw               wood, nails         Apprentice Pulling Out Nail               RemoveNail                    NaN                      NaN
65   0259.jpg                          2:59                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                 Hammer Claw               wood, nails         Apprentice Pulling Out Nail               RemoveNail                    NaN                      NaN
66   0300.jpg                          3:00                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                 Hammer Claw               wood, nails         Apprentice Pulling Out Nail               RemoveNail                    NaN                      NaN
67   0301.jpg                          3:01                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                 Hammer Claw               wood, nails         Apprentice Pulling Out Nail               RemoveNail                    NaN                      NaN
68   0302.jpg                          3:02                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                 Hammer Claw               wood, nails         Apprentice Pulling Out Nail               RemoveNail                    NaN                      NaN
69   0303.jpg                          3:03                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                 Hammer Claw               wood, nails         Apprentice Pulling Out Nail               RemoveNail                    NaN                      NaN
70   0304.jpg                          3:04                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                 Hammer Claw               wood, nails         Apprentice Pulling Out Nail               RemoveNail                    NaN                      NaN
71   0305.jpg                          3:05                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                 Hammer Claw               wood, nails         Apprentice Pulling Out Nail               RemoveNail                    NaN                      NaN
72   0306.jpg                          3:06                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                 Hammer Claw               wood, nails         Apprentice Pulling Out Nail               RemoveNail                    NaN                      NaN
73   0307.jpg                          3:07                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
74   0308.jpg                          3:08                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
75   0309.jpg                          3:09                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
76   0310.jpg                          3:10                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
77   0311.jpg                          3:11                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
78   0312.jpg                          3:12                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
79   0313.jpg                          3:13                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                      NaN                   join              AlignHammer
80   0314.jpg                          3:14                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
81   0315.jpg                          3:15                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                DownSwing                    NaN                      NaN
82   0316.jpg                          3:16                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                BackSwing                    NaN                      NaN
83   0317.jpg                          3:17                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                BackSwing                    NaN                      NaN
84   0318.jpg                          3:18                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                BackSwing                    NaN                      NaN
85   0319.jpg                          3:19                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              InspectNail
86   0320.jpg                          3:20                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              InspectNail
87   0321.jpg                          3:21                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              InspectNail
88   0322.jpg                          3:22                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              InspectNail
89   0323.jpg                          3:23                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                      NaN                 branch              InspectNail
90   0324.jpg                          3:24                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN                AlignNail
91   0325.jpg                          3:25                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
92   0326.jpg                          3:26                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                DownSwing                    NaN                      NaN
93   0327.jpg                          3:27                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                         NaN                     nails            Journeyman Inspects Nail                      NaN                    NaN              InspectNail
94   0328.jpg                          3:28                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                         NaN                     nails            Journeyman Inspects Nail                      NaN                    NaN              InspectNail
95   0329.jpg                          3:29                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                         NaN                     nails            Journeyman Inspects Nail                      NaN                    NaN              InspectNail
96   0330.jpg                          3:30                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                         NaN                     nails            Journeyman Inspects Nail                      NaN                    NaN              InspectNail
97   0331.jpg                          3:31                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                         NaN                     nails            Journeyman Inspects Nail                      NaN                 branch              InspectNail
98   0332.jpg                          3:32                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails            Journeyman Realigns Nail                      NaN                    NaN                AlignNail
99   0333.jpg                          3:33                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails            Journeyman Realigns Nail                      NaN                    NaN                AlignNail
100  0334.jpg                          3:34                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails            Journeyman Realigns Nail                      NaN                    NaN                AlignNail
101  0335.jpg                          3:35                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails            Journeyman Realigns Nail                      NaN                    NaN                AlignNail
102  0336.jpg                          3:36                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails            Journeyman Realigns Nail                      NaN                    NaN                AlignNail
103  0337.jpg                          3:37                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
104  0338.jpg                          3:38                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
105  0339.jpg                          3:39                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
106  0340.jpg                          3:40                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                         NaN                      wood  Journeyman Flush Align Panel Edges                      NaN                    NaN         AlignBoardsFlush
107  0341.jpg                          3:41                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                BackSwing                    NaN                      NaN
108  0342.jpg                          3:42                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                BackSwing                    NaN                      NaN
109  0343.jpg                          3:43                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                DownSwing                    NaN                      NaN
110  0344.jpg                          3:44                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                BackSwing                    NaN                      NaN
111  0345.jpg                          3:45                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                BackSwing                    NaN                      NaN
112  0346.jpg                          3:46                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                DownSwing                    NaN                      NaN
113  0347.jpg                          3:47                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                BackSwing                    NaN                      NaN
114  0348.jpg                          3:48                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                DownSwing                    NaN                      NaN
115  0349.jpg                          3:49                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                DownSwing                    NaN                      NaN
116  0350.jpg                          3:50                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              InspectNail
117  0351.jpg                          3:51                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                      NaN                 branch              InspectNail
118  0352.jpg                          3:52                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                BackSwing                    NaN                      NaN
119  0353.jpg                          3:53                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                DownSwing                    NaN                      NaN
120  0354.jpg                          3:54                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                BackSwing                    NaN                      NaN
121  0355.jpg                          3:55                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                BackSwing                    NaN                      NaN
122  0356.jpg                          3:56                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                DownSwing                    NaN                      NaN
123  0357.jpg                          3:57                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                BackSwing                    NaN                      NaN
124  0358.jpg                          3:58                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                DownSwing                    NaN                      NaN
125  0359.jpg                          3:59                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                BackSwing                    NaN                      NaN
126  0400.jpg                          4:00                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                BackSwing                    NaN                      NaN
127  0401.jpg                          4:01                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
128  0402.jpg                          4:02                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
129  0403.jpg                          4:03                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
130  0404.jpg                          4:04                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
131  0405.jpg                          4:05                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
132  0406.jpg                          4:06                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
133  0407.jpg                          4:07                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
134  0408.jpg                          4:08                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                DownSwing                    NaN                      NaN
135  0409.jpg                          4:09                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                DownSwing                    NaN                      NaN
136  0410.jpg                          4:10                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                BackSwing                    NaN                      NaN
137  0411.jpg                          4:11                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                DownSwing                    NaN                      NaN
138  0412.jpg                          4:12                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN                      NaN
139  0413.jpg                          4:13                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN                      NaN
140  0414.jpg                          4:14                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN                      NaN
141  0415.jpg                          4:15                           Journeyman/apprentice ZoPD hammering nails               Journeyman  Apprentice3                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN                      NaN
142  0550.jpg                          5:50                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN                      NaN
143  0551.jpg                          5:51                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN                      NaN
144  0553.jpg                          5:53                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN                      NaN
145  0554.jpg                          5:54                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN                      NaN
146  0556.jpg                          5:56                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN                      NaN
147  0557.jpg                          5:57                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
148  0559.jpg                          5:59                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                BackSwing                    NaN                      NaN
149  0700.jpg                          7:00                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              InspectNail
150  0701.jpg                          7:01                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                 branch              InspectNail
151  0702.jpg                          7:02                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN                AlignNail
152  0703.jpg                          7:03                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
153  0704.jpg                          7:04                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
154  0705.jpg                          7:05                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
155  0706.jpg                          7:06                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
156  0707.jpg                          7:07                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
157  0708.jpg                          7:08                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
158  0709.jpg                          7:09                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                BackSwing                    NaN                      NaN
159  0710.jpg                          7:10                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                DownSwing                    NaN                      NaN
160  0711.jpg                          7:11                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                DownSwing                    NaN                      NaN
161  0712.jpg                          7:12                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              InspectNail
162  0713.jpg                          7:13                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              InspectNail
163  0714.jpg                          7:14                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                         NaN                     nails            Journeyman Inspects Nail                      NaN                 branch              InspectNail
164  0715.jpg                          7:15                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails            Journeyman Realigns Nail                      NaN                    NaN                AlignNail
165  0716.jpg                          7:16                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails            Journeyman Realigns Nail                      NaN                    NaN                AlignNail
166  0717.jpg                          7:17                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails            Journeyman Realigns Nail                      NaN                    NaN                AlignNail
167  0718.jpg                          7:18                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails            Journeyman Realigns Nail                      NaN                    NaN                AlignNail
168  0719.jpg                          7:19                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                         NaN                     nails            Journeyman Inspects Nail                      NaN                    NaN              InspectNail
169  0720.jpg                          7:20                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                         NaN                     nails            Journeyman Inspects Nail                      NaN                 branch              InspectNail
170  0721.jpg                          7:21                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
171  0722.jpg                          7:22                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
172  0723.jpg                          7:23                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
173  0724.jpg                          7:24                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
174  0725.jpg                          7:25                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
175  0726.jpg                          7:26                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
176  0727.jpg                          7:27                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
177  0728.jpg                          7:28                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
178  0729.jpg                          7:29                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
179  0730.jpg                          7:30                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
180  0731.jpg                          7:31                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
181  0732.jpg                          7:32                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
182  0733.jpg                          7:33                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
183  0734.jpg                          7:34                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
184  0735.jpg                          7:35                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
185  0736.jpg                          7:36                    Journeyman supporting apprentice hammering a nail               Journeyman  Apprentice4                      Hammer               wood, nails                Apprentice Hammering                      NaN                    NaN              AlignHammer
186  0927.jpg                          9:27  Journeyman models using a power drill to make a pilot hole for nail               Journeyman  Apprentice5                 Power Drill               wood, nails                 Journeyman Drilling             LoadDrillBit                    NaN                      NaN
187  0928.jpg                          9:28  Journeyman models using a power drill to make a pilot hole for nail               Journeyman  Apprentice5                 Power Drill               wood, nails                 Journeyman Drilling             LoadDrillBit                    NaN                      NaN
188  0929.jpg                          9:29  Journeyman models using a power drill to make a pilot hole for nail               Journeyman  Apprentice5                 Power Drill               wood, nails                 Journeyman Drilling             LoadDrillBit                    NaN                      NaN
189  0930.jpg                          9:30  Journeyman models using a power drill to make a pilot hole for nail               Journeyman  Apprentice5                 Power Drill               wood, nails                 Journeyman Drilling             LoadDrillBit                    NaN                      NaN
190  0931.jpg                          9:31  Journeyman models using a power drill to make a pilot hole for nail               Journeyman  Apprentice5                 Power Drill               wood, nails                 Journeyman Drilling             LoadDrillBit                    NaN                      NaN
191  0932.jpg                          9:32  Journeyman models using a power drill to make a pilot hole for nail               Journeyman  Apprentice5                 Power Drill               wood, nails                 Journeyman Drilling                      NaN                    NaN               AlignDrill
192  0933.jpg                          9:33  Journeyman models using a power drill to make a pilot hole for nail               Journeyman  Apprentice5                 Power Drill               wood, nails                 Journeyman Drilling                      NaN                    NaN               AlignDrill
193  0934.jpg                          9:34  Journeyman models using a power drill to make a pilot hole for nail               Journeyman  Apprentice5                 Power Drill               wood, nails                 Journeyman Drilling                      NaN                    NaN               AlignDrill
194  0935.jpg                          9:35  Journeyman models using a power drill to make a pilot hole for nail               Journeyman  Apprentice5                 Power Drill               wood, nails                 Journeyman Drilling                      NaN                    NaN               AlignDrill
195  0936.jpg                          9:36  Journeyman models using a power drill to make a pilot hole for nail               Journeyman  Apprentice5                 Power Drill               wood, nails                 Journeyman Drilling                      NaN                    NaN                HoldDrill
196  0937.jpg                          9:37  Journeyman models using a power drill to make a pilot hole for nail               Journeyman  Apprentice5                 Power Drill               wood, nails                 Journeyman Drilling                      NaN                    NaN                HoldDrill
197  0938.jpg                          9:38  Journeyman models using a power drill to make a pilot hole for nail               Journeyman  Apprentice5                 Power Drill               wood, nails                 Journeyman Drilling                      NaN                    NaN                HoldDrill
198  0939.jpg                          9:39  Journeyman models using a power drill to make a pilot hole for nail               Journeyman  Apprentice5                 Power Drill               wood, nails                 Journeyman Drilling                    Drill                    NaN                      NaN
199  0940.jpg                          9:40  Journeyman models using a power drill to make a pilot hole for nail               Journeyman  Apprentice5                 Power Drill               wood, nails                 Journeyman Drilling                    Drill                    NaN                      NaN
200  0941.jpg                          9:41  Journeyman models using a power drill to make a pilot hole for nail               Journeyman  Apprentice5                 Power Drill               wood, nails                 Journeyman Drilling                    Drill                    NaN                      NaN
201  0942.jpg                          9:42  Journeyman models using a power drill to make a pilot hole for nail               Journeyman  Apprentice5                 Power Drill               wood, nails                 Journeyman Drilling                    Drill                    NaN                      NaN
202  0943.jpg                          9:43  Journeyman models using a power drill to make a pilot hole for nail               Journeyman  Apprentice5                 Power Drill               wood, nails                 Journeyman Drilling                    Drill                    NaN                      NaN
203  0944.jpg                          9:44  Journeyman models using a power drill to make a pilot hole for nail               Journeyman  Apprentice5                 Power Drill               wood, nails                 Journeyman Drilling                    Drill                    NaN                      NaN
204  0945.jpg                          9:45  Journeyman models using a power drill to make a pilot hole for nail               Journeyman  Apprentice5                 Power Drill               wood, nails                 Journeyman Drilling                    Drill                    NaN                      NaN
205  0946.jpg                          9:46  Journeyman models using a power drill to make a pilot hole for nail               Journeyman  Apprentice5                 Power Drill               wood, nails                 Journeyman Drilling                    Drill                    NaN                      NaN
206  0947.jpg                          9:47  Journeyman models using a power drill to make a pilot hole for nail               Journeyman  Apprentice5                 Power Drill               wood, nails                 Journeyman Drilling                      NaN                    NaN                      NaN
207  0948.jpg                          9:48  Journeyman models using a power drill to make a pilot hole for nail               Journeyman  Apprentice5                 Power Drill               wood, nails                 Journeyman Drilling                      NaN                    NaN                      NaN
208  0949.jpg                          9:49  Journeyman models using a power drill to make a pilot hole for nail               Journeyman  Apprentice5                 Power Drill               wood, nails                 Journeyman Drilling                      NaN                    NaN                      NaN
209  0950.jpg                          9:50  Journeyman models using a power drill to make a pilot hole for nail               Journeyman  Apprentice5                 Power Drill               wood, nails                 Journeyman Drilling                      NaN                    NaN                      NaN

```

To convert frame-by-frame annotation CSV logs into clean state transitions without burning through tokens, you need an algorithm that separates **structural schema validation** from **observed event log execution**.

The issue you faced in LLMs (Qwen/Llama) generating JSON-LD state machines stems from mixing two distinct ontology layers into a single schema:

1. **Schema Layer (E29\_Design\_or\_Procedure)**: The reusable control-flow graph (Nodes: Fork, Join, Branch, Merge, Alternative).

2. **Instance Layer (E7\_Activity)**: Observed execution instances bound to specific video frames (E52\_Time\_Span).

### **MOP / CIDOC CRM State Machine Pseudocode**

The following pseudocode demonstrates how to parse CSV frame annotations into state machine transitions, evaluating conditions to match the control flows defined in **2\_mingei-hammering-activity-diagram.md** and mapped via **1\_map.csv**.

Python

```
FUNCTION ParseAnnotationsToStateMachine(annotations_csv_path):
    # Step 1: Initialize JSON-LD Graph Container
    json_ld_graph = []

    # Step 2: Define Schema / Reified Control-Flow Nodes (from CrO Activity Diagram)
    schema_nodes = {
        "FORK_1":  {"type": "cro:Fork",  "forksFrom": "SetNail", "forksTo": ["AlignNail", "AlignHammer"]},
        "JOIN_1":  {"type": "cro:Join",  "joinsFrom": ["AlignNail", "AlignHammer"], "joinsTo": "TapHammer"},
        "BRANCH_1":{"type": "cro:Branch","branchesFrom": "AssessNail", "alternatives": ["ALT_A", "ALT_B", "ALT_C"]},
        "FORK_2":  {"type": "cro:Fork",  "forksFrom": "ALT_A", "forksTo": ["HoldPanel", "SwingPrep"]},
        "JOIN_2":  {"type": "cro:Join",  "joinsFrom": ["HoldPanel", "SwingPrep"], "joinsTo": "MERGE_3"},
        "BRANCH_2":{"type": "cro:Branch","branchesFrom": "DownSwing", "alternatives": ["ALT_D", "ALT_E", "ALT_F"]}
    }

    # Step 3: Load Frame-Level Annotations
    dataframe = ReadCSV(annotations_csv_path)
    
    previous_activity_instance = NULL
    previous_step_type = NULL

    # Step 4: Process Sequential Frames
    FOR EACH row IN dataframe:
        # Extract attributes mapped to CRM/CrO classes
        frame_id   = row['Mobject']                          # e.g., "0030.jpg"
        timestamp  = row['E52 Time-Span, TemporalEntity']     # e.g., "0:30"
        event_desc = row['E5 Event, CraftingProcess']         # Fabula level
        actor_role = row['E29 Actor, ActorWithRole']          # e.g., Journeyman
        person     = row['E21 Person']                        # e.g., Apprentice1
        tool       = row['E22 Human-Made Object, Tool']       # e.g., Hammer
        materials  = Split(row['E57 Material, RawMaterial'])  # e.g., ["wood", "nails"]
        
        # Step schema extraction (ProcessStep vs. Condition/Assessment)
        step_action = row['E7 Activity, ProcessStep']
        assessment  = row['E14 Condition Assessment']
        control_node= row['E73 Information Object']           # 'fork', 'join', 'branch', 'merge'

        # Determine active semantic step
        current_step_type = ResolveStepType(step_action, assessment)
        
        IF current_step_type IS NULL:
            CONTINUE  # Skip unannotated filler frames

        # Construct E7 Activity Instance
        activity_uri = "urn:5003:hammering:activity:" + ExtractFrameNumber(frame_id)
        
        activity_instance = {
            "@id": activity_uri,
            "@type": "crm:E7_Activity",
            "crm:P2_has_type": current_step_type,
            "crm:P4_has_time-span": {
                "@id": "urn:5003:hammering:timespan:" + ExtractFrameNumber(frame_id),
                "@type": "crm:E52_Time-Span",
                "crm:P3_has_note": timestamp
            },
            "crm:P11_had_participant": [person, actor_role],
            "crm:P16_used_specific_object": [tool, materials],
            "cro:correspondsTo": ResolveOntologySchemaURI(current_step_type)
        }
        
        json_ld_graph.Append(activity_instance)

        # Step 5: State Machine Transition Logic
        IF previous_activity_instance IS NOT NULL:
            
            # Case A: Control Flow Processing (Branch / Fork / Join / Merge)
            IF control_node IS NOT NULL:
                transition = HandleControlNodeTransition(
                    control_node_type = control_node,
                    from_activity     = previous_activity_instance["@id"],
                    to_activity       = activity_uri,
                    from_step         = previous_step_type,
                    to_step           = current_step_type
                )
            
            # Case B: Standard Step-to-Step Sequential Transition
            ELSE IF previous_step_type != current_step_type:
                transition = {
                    "@id": "urn:5003:hammering:transition:" + previous_step_type + "-to-" + current_step_type,
                    "@type": "cro:Transition",
                    "cro:transitsFrom": {"@id": previous_activity_instance["@id"]},
                    "cro:transitsTo":   {"@id": activity_uri},
                    "crm:P3_has_note": "Observed transition from " + previous_step_type + " to " + current_step_type
                }
            
            json_ld_graph.Append(transition)

        # Update pointers
        previous_activity_instance = activity_instance
        previous_step_type = current_step_type

    RETURN WrapInJSONLDContext(json_ld_graph)


FUNCTION HandleControlNodeTransition(control_node_type, from_activity, to_activity, from_step, to_step):
    
    # Branch Node Evaluation (Decision Branching e.g. InspectNail -> AdjustNail or RemoveNail)
    IF control_node_type == "branch":
        # Evaluate condition outcome (ALTERNATIVE A - F)
        predicate_val = DetermineAlternativePredicate(from_step, to_step)
        
        RETURN {
            "@id": "urn:5003:hammering:branch_eval:" + ExtractID(from_activity),
            "@type": "cro:Branch",
            "cro:branchesFrom": {"@id": from_activity},
            "cro:hasAlternative": {
                "@type": "cro:Alternative",
                "cro:hasPredicate": predicate_val,
                "cro:hasAlternativeDestination": {"@id": to_activity}
            }
        }
    
    # Fork / Join Synchronization Nodes
    ELSE IF control_node_type IN ["fork", "join", "merge"]:
        RETURN {
            "@id": "urn:5003:hammering:control:" + control_node_type + ":" + ExtractID(to_activity),
            "@type": "cro:" + Capitalize(control_node_type),
            "cro:" + control_node_type + "sFrom": {"@id": from_activity},
            "cro:" + control_node_type + "sTo":   {"@id": to_activity}
        }
```

### **Key Takeaways for Strict JSON-LD Generation**

1. **Avoid Inlining Schema inside Observations**: Do not embed full E29\_Design\_or\_Procedure graph structures within every individual timestamped E7\_Activity observation. Reference schema URIs via cro:correspondsTo.

2. **Reify Control Nodes**: Use reified cro:Transition, cro:Branch, cro:Fork, and cro:Join URIs instead of simple string fields to create explicit state machine transitions.

3. **Pre-Process CSVs via Deterministic Python Scripts**: Generating frame-by-frame RDF triples with LLMs like Qwen or LLaMA consumes excess tokens. Running deterministic Python code to turn annotations.csv rows into structured JSON-LD payloads reduces cost and ensures full schema conformance.

