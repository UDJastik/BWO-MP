require "Scenarios/SAbstract"
require "BWOBuildTools"
BWOScenarios.Week = {}

BWOScenarios.Week = BWOScenarios.Abstract:derive("BWOScenarios.Abstract")

-- schedule stores sequences of events
BWOScenarios.Week.schedule = {
    [0] = {
        [1] = {
            {{"StartDay", {day="friday"}}, 1},
        },
    },
    [2] = {
        [22] = {
            {{"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreen, program="Patrol", d=30, intensity=8}}, 1},
        },
    },
    [4] = {
        [15] = {
            {{"Entertainer", {}}, 1},
        },
    },
    [5] = {
        [44] = {
            {{"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreen, program="Patrol", d=40, intensity=8}}, 1},
        },
    },
    [8] = {
        [5] = {
            {{"Arson", {profession="fireofficer"}}, 1},
        },
    },
    [11] = {
        [12] = {
            {{"BuildingParty", {roomName="bedroom", intensity=8}}, 1},
        },
    },
    [12] = {
        [30] = {
            {{"BuildingParty", {roomName="bedroom", intensity=8}}, 1},
        },
    },
    [13] = {
        [5] = {
            {{"BuildingParty", {roomName="bedroom", intensity=8}}, 1},
        },
        [25] = {
            {{"BuildingParty", {roomName="bedroom", intensity=8}}, 1},
        },
    },
    [15] = {
        [5] = {
            {{"BuildingParty", {roomName="bedroom", intensity=8}}, 1},
        },
        [25] = {
            {{"BuildingParty", {roomName="bedroom", intensity=8}}, 1},
        },
    },
    [16] = {
        [58] = {
            {{"BuildingParty", {roomName="bedroom", intensity=8}}, 1},
        },
    },
    [19] = {
        [42] = {
            {{"BuildingHome", {addRadio=false}}, 1},
        },
    },
    [24] = {
        [0] = {
            {{"StartDay", {day="saturday"}}, 1},
        },
    },
    [25] = {
        [44] = {
            {{"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreen, program="Patrol", d=40, intensity=8}}, 1},
        },
    },
    [26] = {
        [21] = {
            {{"SetHydroPower", {on=false}}, 1},
        },
        [22] = {
            {{"SetHydroPower", {on=true}}, 1},
        },
    },
    [27] = {
        [8] = {
            {{"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreen, program="Patrol", d=40, intensity=8}}, 1},
        },
    },
    [28] = {
        [33] = {
            {{"Entertainer", {}}, 1},
        },
    },
    [30] = {
        [33] = {
            {{"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreen, program="Patrol", d=40, intensity=8}}, 1},
        },
    },
    [35] = {
        [20] = {
            {{"BuildingParty", {roomName="bedroom", intensity=8}}, 1},
        },
    },
    [36] = {
        [10] = {
            {{"BuildingParty", {roomName="bedroom", intensity=8}}, 1},
        },
    },
    [37] = {
        [5] = {
            {{"BuildingParty", {roomName="bedroom", intensity=8}}, 1},
        },
        [25] = {
            {{"BuildingParty", {roomName="bedroom", intensity=8}}, 1},
        },
    },
    [39] = {
        [2] = {
            {{"BuildingParty", {roomName="bedroom", intensity=8}}, 1},
        },
        [14] = {
            {{"Arson", {profession="fireofficer"}}, 1},
        },
    },
    [42] = {
        [6] = {
            {{"BuildingHome", {addRadio=false}}, 1},
        },
    },
    [48] = {
        [0] = {
            {{"StartDay", {day="sunday"}}, 1},
        },
        [11] = {
            {{"ChopperAlert", {name="heli2", sound="BWOChopperGeneric", dir = 90, speed=2.7}}, 1},
        },
        [33] = {
            {{"SpawnGroup", {name="Hooligans", cid=Bandit.clanMap.Polish, program="Bandit", d=40, voice=101, intensity=14}}, 1},
        },
    },
    [51] = {
        [9] = {
            {{"ChopperAlert", {name="heli", sound="BWOChopperPolice1", dir = 0, speed=2.2}}, 1},
        },
        [11] = {
            {{"ChopperAlert", {name="heli2", sound="BWOChopperGeneric", dir = -90, speed=2.3}}, 1},
        },
    },
    [52] = {
        [5] = {
            {{"ChopperAlert", {name="heli", sound="BWOChopperPolice1", dir = 180, speed=1.8}}, 1},
        },
        [11] = {
            {{"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=75, intensity=2}}, 1},
        },
    },
    [53] = {
        [1] = {
            {{"ChopperAlert", {name="heli", sound="BWOChopperPolice1", dir = -90, speed=2.2}}, 1},
        },
    },
    [54] = {
        [28] = {
            {{"ChopperAlert", {name="heli", sound="BWOChopperPolice1", dir = 90, speed=1.8}}, 1},
        },
        [30] = {
            {{"Arson", {}}, 1},
        },
    },
    [55] = {
        [11] = {
            {{"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=74, intensity=2}}, 1},
        },
    },
    [58] = {
        [33] = {
            {{"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=73, intensity=3}}, 1},
        },
    },
    [59] = {
        [56] = {
            {{"SpawnGroup", {name="Suicide Bomber", cid=Bandit.clanMap.SuicideBomber, program="Shahid", d=45, intensity=2}}, 1},
        },
    },
    [62] = {
        [55] = {
            {{"ChopperAlert", {name="heli", sound="BWOChopperPolice1", dir = 180, speed=1.7}}, 1},
        },
    },
    [63] = {
        [30] = {
            {{"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=72, intensity=4}}, 1},
        },
    },
    [66] = {
        [39] = {
            {{"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=71, intensity=3}}, 1},
        },
        [40] = {
            {{"ChopperAlert", {name="heli", sound="BWOChopperPolice1", dir = 0, speed=1.8}}, 1},
        },
        [41] = {
            {{"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=70, intensity=3}}, 1},
        },
    },
    [67] = {
        [13] = {
            {{"ChopperAlert", {name="heli2", sound="BWOChopperGeneric", dir = 0, speed=2.9}}, 1},
        },
    },
    [72] = {
        [0] = {
            {{"StartDay", {day="monday"}}, 1},
        },
    },
    [77] = {
        [22] = {
            {{"SpawnGroup", {name="Suicide Bomber", cid=Bandit.clanMap.SuicideBomber, program="Shahid", d=41, intensity=2}}, 1},
        },
        [33] = {
            {{"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=69, intensity=4}}, 1},
        },
        [39] = {
            {{"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=68, intensity=4}}, 1},
        },
    },
    [79] = {
        [14] = {
            {{"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalClassy, program="Bandit", d=67, intensity=3}}, 1},
        },
        [15] = {
            {{"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalClassy, program="Bandit", d=66, intensity=3}}, 1},
        },
        [55] = {
            {{"Arson", {}}, 1},
        },
    },
    [82] = {
        [31] = {
            {{"ChopperAlert", {name="heli2", sound="BWOChopperCDC1", dir = 0, speed=1.8}}, 1},
        },
        [42] = {
            {{"ChopperAlert", {name="heli2", sound="BWOChopperCDC1", dir = 180, speed=2.1}}, 1},
        },
    },
    [83] = {
        [35] = {
            {{"BuildingHome", {addRadio=false}}, 1},
        },
    },
    [85] = {
        [33] = {
            {{"ChopperAlert", {name="heli", sound="BWOChopperPolice1", dir = -90, speed=1.7}}, 1},
        },
    },
    [86] = {
        [40] = {
            {{"ChopperAlert", {name="heli", sound="BWOChopperPolice1", dir = 90, speed=1.7}}, 1},
        },
    },
    [87] = {
        [27] = {
            {{"Arson", {}}, 1},
        },
        [33] = {
            {{"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalClassy, program="Bandit", d=65, intensity=4}}, 1},
        },
        [50] = {
            {{"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalClassy, program="Bandit", d=64, intensity=5}}, 1},
        },
    },
    [88] = {
        [44] = {
            {{"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=63, intensity=6}}, 1},
        },
        [46] = {
            {{"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=62, intensity=7}}, 1},
        },
        [47] = {
            {{"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=61, intensity=6}}, 1},
        },
    },
    [89] = {
        [52] = {
            {{"Arson", {}}, 1},
        },
        [58] = {
            {{"BuildingHome", {addRadio=false}}, 1},
        },
    },
    [91] = {
        [4] = {
            {{"Arson", {}}, 1},
        },
        [23] = {
            {{"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=65, intensity=4}}, 1},
        },
    },
    [94] = {
        [33] = {
            {{"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=60, intensity=5}}, 1},
        },
        [37] = {
            {{"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=59, intensity=6}}, 1},
        },
    },
    [95] = {
        [22] = {
            {{"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=65, intensity=4}}, 1},
        },
        [33] = {
            {{"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=58, intensity=5}}, 1},
        },
        [37] = {
            {{"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=57, intensity=4}}, 1},
        },
    },
    [96] = {
        [0] = {
            {{"StartDay", {day="tuesday"}}, 1},
        },
        [15] = {
            {{"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreen, program="Police", d=45, intensity=10}}, 1},
        },
    },
    [97] = {
        [3] = {
            {{"SpawnGroup", {name="Biker Gang", cid=Bandit.clanMap.Biker, program="Bandit", d=60, intensity=14}}, 1},
        },
    },
    [112] = {
        [0] = {
            {{"Arson", {}}, 1},
        },
        [11] = {
            {{"Arson", {}}, 1},
        },
        [12] = {
            {{"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=64, intensity=6}}, 1},
        },
        [44] = {
            {{"Arson", {}}, 1},
        },
        [45] = {
            {{"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=63, intensity=6}}, 1},
        },
        [56] = {
            {{"SpawnGroup", {name="Biker Gang", cid=Bandit.clanMap.Biker, program="Bandit", d=60, intensity=14}}, 1},
        },
    },
    [113] = {
        [22] = {
            {{"Arson", {}}, 1},
        },
        [23] = {
            {{"ChopperAlert", {name="heli", sound="BWOChopperPolice1", dir = 0, speed=1.9}}, 1},
        },
        [33] = {
            {{"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=57, intensity=4}}, 1},
        },
        [35] = {
            {{"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=56, intensity=5}}, 1},
        },
        [36] = {
            {{"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=61, intensity=6}}, 1},
        },
        [37] = {
            {{"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=55, intensity=5}}, 1},
        },
        [38] = {
            {{"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=60, intensity=5}}, 1},
        },
        [39] = {
            {{"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=59, intensity=2}}, 1},
        },
    },
    [116] = {
        [16] = {
            {{"BuildingHome", {addRadio=false}}, 1},
        },
    },
    [120] = {
        [0] = {
            {{"StartDay", {day="wednesday"}}, 1},
        },
    },
    [121] = {
        [2] = {
            {{"ProtestAll", {}}, 1},
        },
        [16] = {
            {{"ChopperAlert", {name="heli", sound="BWOChopperPolice2", dir = -90, speed=1.6}}, 1},
        },
        [45] = {
            {{"ChopperAlert", {name="heli", sound="BWOChopperPolice2", dir = 90, speed=1.7}}, 1},
        },
    },
    [122] = {
        [0] = {
            {{"Siren", {}}, 1},
        },
        [11] = {
            {{"SpawnGroup", {name="Riot Police", cid=Bandit.clanMap.PoliceRiot, program="RiotPolice", d=30, intensity=12}}, 1},
        },
        [12] = {
            {{"ChopperAlert", {name="heli", sound="BWOChopperPolice2", dir = -90, speed=1.8}}, 1},
        },
        [15] = {
            {{"SpawnGroup", {name="Riot Police", cid=Bandit.clanMap.PoliceRiot, program="RiotPolice", d=30, intensity=12}}, 1},
        },
        [16] = {
            {{"Shahids", {intensity=1}}, 1},
        },
        [17] = {
            {{"SpawnGroup", {name="Riot Police", cid=Bandit.clanMap.PoliceRiot, program="RiotPolice", d=30, intensity=12}}, 1},
        },
        [44] = {
            {{"ChopperAlert", {name="heli", sound="BWOChopperPolice2", dir = 90, speed=1.6}}, 1},
        },
    },
    [123] = {
        [27] = {
            {{"Arson", {}}, 1},
        },
        [33] = {
            {{"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalClassy, program="Bandit", d=54, intensity=4}}, 1},
        },
        [39] = {
            {{"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalClassy, program="Bandit", d=53, intensity=4}}, 1},
        },
        [41] = {
            {{"ChopperAlert", {name="heli", sound="BWOChopperPolice2", dir = 180, speed=2.7}}, 1},
        },
        [45] = {
            {{"SpawnGroup", {name="Riot Police", cid=Bandit.clanMap.PoliceRiot, program="RiotPolice", d=30, intensity=12}}, 1},
        },
        [56] = {
            {{"VehicleCrash", {x=-70, y=0, vtype="pzkHeli350PoliceWreck"}}, 1},
        },
    },
    [124] = {
        [1] = {
            {{"ChopperFliers", {}}, 1},
        },
    },
    [125] = {
        [2] = {
            {{"Arson", {}}, 1},
        },
        [3] = {
            {{"SpawnGroup", {name="Asylum Escapes", cid=Bandit.clanMap.Mental, program="Bandit", d=34, intensity=16}}, 1},
        },
        [5] = {
            {{"Arson", {}}, 1},
        },
    },
    [128] = {
        [27] = {
            {{"Arson", {}}, 1},
        },
    },
    [130] = {
        [0] = {
            {{"Siren", {}}, 1},
        },
    },
    [132] = {
        [0] = {
            {{"Siren", {}}, 1},
        },
    },
    [133] = {
        [54] = {
            {{"Siren", {}}, 1},
        },
        [56] = {
            {{"PlaneCrashSequence", {}}, 1},
        },
    },
    [134] = {
        [40] = {
            {{"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=46, intensity=12}}, 1},
        },
    },
    [135] = {
        [0] = {
            {{"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=58, intensity=4}}, 1},
        },
        [1] = {
            {{"SetHydroPower", {on=false}}, 1},
        },
        [2] = {
            {{"SetHydroPower", {on=true}}, 1},
        },
        [8] = {
            {{"SetHydroPower", {on=false}}, 1},
        },
        [10] = {
            {{"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=57, intensity=4}}, 1},
        },
        [20] = {
            {{"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=56, intensity=4}}, 1},
        },
        [30] = {
            {{"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=55, intensity=4}}, 1},
        },
        [32] = {
            {{"SetHydroPower", {on=true}}, 1},
        },
        [40] = {
            {{"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=54, intensity=4}}, 1},
        },
        [50] = {
            {{"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=53, intensity=4}}, 1},
        },
    },
    [136] = {
        [12] = {
            {{"SpawnGroup", {name="Veterans", cid=Bandit.clanMap.Veteran, program="Police", d=47, intensity=10}}, 1},
        },
        [14] = {
            {{"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=48, intensity=10}}, 1},
        },
    },
    [138] = {
        [2] = {
            {{"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=52, intensity=3}}, 1},
        },
    },
    [144] = {
        [0] = {
            {{"StartDay", {day="thursday"}}, 1},
        },
    },
    [145] = {
        [6] = {
            {{"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=49, intensity=5}}, 1},
        },
        [17] = {
            {{"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=50, intensity=5}}, 1},
        },
    },
    [146] = {
        [0] = {
            {{"Siren", {}}, 1},
        },
        [5] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
        [25] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
        [45] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
    },
    [147] = {
        [8] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
        [24] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
        [28] = {
            {{"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=51, intensity=5}}, 1},
        },
        [47] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
        [48] = {
            {{"Horde", {cnt=100, x=45, y=45}}, 1},
        },
        [50] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
        [51] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
    },
    [150] = {
        [9] = {
            {{"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=52, intensity=10}}, 1},
        },
        [24] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
        [25] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
        [26] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
        [49] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
        [50] = {
            {{"Horde", {cnt=100, x=45, y=45}}, 1},
        },
        [58] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
    },
    [152] = {
        [12] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
        [24] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
    },
    [153] = {
        [44] = {
            {{"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=53, intensity=5}}, 1},
        },
        [45] = {
            {{"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="Bandit", d=50, intensity=5}}, 1},
        },
        [46] = {
            {{"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=54, intensity=2}}, 1},
        },
        [50] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
    },
    [154] = {
        [25] = {
            {{"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=55, intensity=4}}, 1},
        },
        [26] = {
            {{"SpawnGroup", {name="Inmates", cid=Bandit.clanMap.InmateFree, program="Bandit", d=55, intensity=14}}, 1},
        },
        [27] = {
            {{"SpawnGroup", {name="Inmates", cid=Bandit.clanMap.InmateFree, program="Bandit", d=59, intensity=13}}, 1},
        },
    },
    [155] = {
        [5] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
        [15] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
        [16] = {
            {{"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="Bandit", d=49, intensity=3}}, 1},
        },
        [17] = {
            {{"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="Bandit", d=48, intensity=3}}, 1},
        },
        [18] = {
            {{"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="Bandit", d=47, intensity=3}}, 1},
        },
        [25] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
        [26] = {
            {{"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=56, intensity=10}}, 1},
        },
    },
    [156] = {
        [5] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
        [10] = {
            {{"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="Bandit", d=46, intensity=12}}, 1},
        },
        [15] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
        [25] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
        [26] = {
            {{"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=57, intensity=10}}, 1},
        },
    },
    [158] = {
        [0] = {
            {{"Siren", {}}, 1},
        },
        [8] = {
            {{"JetfighterSequence", {arm="gas"}}, 1},
        },
        [9] = {
            {{"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.Mental, program="Bandit", d=45, intensity=12}}, 1},
        },
        [24] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
        [31] = {
            {{"JetfighterSequence", {arm="gas"}}, 1},
        },
        [49] = {
            {{"JetfighterSequence", {arm="gas"}}, 1},
        },
        [51] = {
            {{"SetHydroPower", {on=false}}, 1},
        },
        [52] = {
            {{"SetHydroPower", {on=true}}, 1},
        },
        [53] = {
            {{"Horde", {cnt=100, x=45, y=45}}, 1},
        },
    },
    [159] = {
        [8] = {
            {{"JetfighterSequence", {arm="bomb"}}, 1},
        },
        [9] = {
            {{"SetHydroPower", {on=false}}, 1},
        },
        [10] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
        [11] = {
            {{"SetHydroPower", {on=true}}, 1},
        },
        [24] = {
            {{"JetfighterSequence", {arm="bomb"}}, 1},
        },
        [25] = {
            {{"SetHydroPower", {on=false}}, 1},
        },
        [27] = {
            {{"SetHydroPower", {on=true}}, 1},
        },
        [49] = {
            {{"JetfighterSequence", {arm="bomb"}}, 1},
        },
    },
    [160] = {
        [8] = {
            {{"JetfighterSequence", {arm="bomb"}}, 1},
        },
        [9] = {
            {{"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="Bandit", d=45, intensity=9}}, 1},
        },
        [24] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
        [25] = {
            {{"SetHydroPower", {on=false}}, 1},
        },
        [26] = {
            {{"SetHydroPower", {on=true}}, 1},
        },
        [49] = {
            {{"JetfighterSequence", {arm="bomb"}}, 1},
        },
        [51] = {
            {{"SetHydroPower", {on=false}}, 1},
        },
        [53] = {
            {{"SetHydroPower", {on=true}}, 1},
        },
        [54] = {
            {{"Horde", {cnt=100, x=45, y=-45}}, 1},
        },
    },
    [161] = {
        [8] = {
            {{"JetfighterSequence", {arm="gas"}}, 1},
        },
        [24] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
        [49] = {
            {{"JetfighterSequence", {arm="gas"}}, 1},
        },
        [51] = {
            {{"SetHydroPower", {on=false}}, 1},
        },
        [58] = {
            {{"SetHydroPower", {on=true}}, 1},
        },
    },
    [162] = {
        [8] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
        [24] = {
            {{"JetfighterSequence", {arm="bomb"}}, 1},
        },
        [49] = {
            {{"JetfighterSequence", {arm="bomb"}}, 1},
        },
        [50] = {
            {{"SetHydroPower", {on=false}}, 1},
        },
        [51] = {
            {{"SetHydroPower", {on=true}}, 1},
        },
        [68] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
    },
    [163] = {
        [8] = {
            {{"JetfighterSequence", {arm="bomb"}}, 1},
        },
        [15] = {
            {{"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="Bandit", d=45, intensity=5}}, 1},
        },
        [24] = {
            {{"JetfighterSequence", {arm="bomb"}}, 1},
        },
        [30] = {
            {{"JetfighterSequence", {arm="gas"}}, 1},
        },
        [43] = {
            {{"JetfighterSequence", {arm="gas"}}, 1},
        },
        [45] = {
            {{"JetfighterSequence", {arm="mg"}}, 1},
        },
        [49] = {
            {{"JetfighterSequence", {arm="bomb"}}, 1},
        },
    },
    [164] = {
        [8] = {
            {{"JetfighterSequence", {arm="bomb"}}, 1},
        },
        [9] = {
            {{"VehicleCrash", {x=22, y=-70, vtype="pzkA10wreck"}}, 1},
        },
        [10] = {
            {{"SetHydroPower", {on=false}}, 1},
        },
        [13] = {
            {{"SetHydroPower", {on=true}}, 1},
        },
        [24] = {
            {{"JetfighterSequence", {arm="bomb"}}, 1},
        },
        [49] = {
            {{"JetfighterSequence", {arm="bomb"}}, 1},
        },
        [51] = {
            {{"VehicleCrash", {x=-32, y=60, vtype="pzkA10wreck"}}, 1},
        },
    },
    [165] = {
        [2] = {
            {{"ChopperFliers", {}}, 1},
        },
        [18] = {
            {{"VehicleCrash", {x=2, y=70, vtype="pzkHeli350MedWreck"}}, 1},
        },
    },
    [166] = {
        [4] = {
            {{"SpawnGroup", {name="Hammer Brothers", cid=Bandit.clanMap.HammerBrothers, program="Bandit", d=50, intensity=3}}, 1},
        },
    },
    [168] = {
        [0] = {
            {{"StartDay", {day="friday"}}, 1},
        },
        [4] = {
            {{"Siren", {}}, 1},
        },
        [30] = {
            {{"FinalSolution", {}}, 1},
        },
        [34] = {
            {{"SetHydroPower", {on=false}}, 1},
        },
        [35] = {
            {{"Horde", {cnt=100, x=-45, y=45}}, 1},
        },
    },
    [176] = {
        [25] = {
            {{"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=2}}, 1},
        },
    },
    [177] = {
        [25] = {
            {{"SpawnGroup", {name="Hammer Brothers", cid=Bandit.clanMap.HammerBrothers, program="Bandit", d=30, intensity=3}}, 1},
        },
    },
    [189] = {
        [12] = {
            {{"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=3}}, 1},
        },
    },
    [192] = {
        [33] = {
            {{"Horde", {cnt=100, x=45, y=-45}}, 1},
        },
    },
    [211] = {
        [44] = {
            {{"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=4}}, 1},
        },
    },
    [235] = {
        [3] = {
            {{"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=3}}, 1},
        },
    },
    [236] = {
        [12] = {
            {{"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=3}}, 1},
        },
    },
    [253] = {
        [42] = {
            {{"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=7}}, 1},
        },
    },
    [315] = {
        [11] = {
            {{"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=4}}, 1},
        },
        [30] = {
            {{"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=3}}, 1},
        },
    },
    [333] = {
        [4] = {
            {{"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=8}}, 1},
        },
    },
    [376] = {
        [4] = {
            {{"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=8}}, 1},
        },
    },
    [400] = {
        [32] = {
            {{"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=12}}, 1},
        },
    }
}

BWOScenarios.Week.roomSpawns = {
    ["armysurplus"] = {
        {waMin=0, waMax=2, cid=Bandit.clanMap.Veteran, size = 2, hostile = false},
        {waMin=2, waMax=24, cid=Bandit.clanMap.Militia, size = 6, hostile = true},
    },
    ["artstore"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 6, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Robbers, size = 8, hostile = true},
    },
    ["bank"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 4, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Robbers, size = 6, hostile = true},
    },
    ["bar"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Biker, size = 5, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Biker, size = 7, hostile = true},
    },
    ["barcountertwiggy"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Biker, size = 3, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Biker, size = 4, hostile = true},
    },
    ["barkitchen"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Biker, size = 3, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Biker, size = 4, hostile = true},
    },
    ["barstorage"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Biker, size = 3, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Biker, size = 4, hostile = true},
    },
    ["bankstorage"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 2, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Robbers, size = 3, hostile = true},
    },
    ["clinic"] = {
        {waMin=0, waMax=4, cid=Bandit.clanMap.Medic, size = 3, hostile = false},
        {waMin=4, waMax=24, cid=Bandit.clanMap.BanditStrong, size = 4, hostile = true},
    },
    ["conveniencestore"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 2, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.CriminalBlack, size = 3, hostile = true},
    },
    ["cornerstore"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 4, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.CriminalBlack, size = 6, hostile = true},
    },
    ["departmentstore"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 4, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.CriminalBlack, size = 6, hostile = true},
    },
    ["detectiveoffice"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.PoliceBlue, size = 5, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Militia, size = 7, hostile = true},
    },
    ["generalstore"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 4, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.CriminalBlack, size = 6, hostile = true},
    },
    ["giftstore"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 2, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Robbers, size = 2, hostile = true},
    },
    ["gigamart"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 5, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.CriminalBlack, size = 10, hostile = true},
    },
    ["gunstore"] = {
        {waMin=0, waMax=2, cid=Bandit.clanMap.Veteran, size = 2, hostile = false},
        {waMin=2, waMax=24, cid=Bandit.clanMap.Militia, size = 5, hostile = true},
    },
    ["jewelrystore"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 4, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Robbers, size = 6, hostile = true},
    },
    ["leatherclothesstore"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 2, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.CriminalClassy, size = 3, hostile = true},
    },
    ["liquorstore"] = {
        {waMin=0, waMax=2, cid=Bandit.clanMap.Security, size = 1, hostile = false},
        {waMin=2, waMax=24, cid=Bandit.clanMap.Redneck, size = 8, hostile = true},
    },
    ["medclinic"] = {
        {waMin=0, waMax=4, cid=Bandit.clanMap.Medic, size = 3, hostile = false},
        {waMin=4, waMax=24, cid=Bandit.clanMap.BanditStrong, size = 4, hostile = true},
    },
    ["medical"] = {
        {waMin=0, waMax=4, cid=Bandit.clanMap.Medic, size = 3, hostile = false},
        {waMin=4, waMax=24, cid=Bandit.clanMap.BanditStrong, size = 4, hostile = true},
    },
    ["medicaloffice"] = {
        {waMin=0, waMax=4, cid=Bandit.clanMap.Medic, size = 2, hostile = false},
        {waMin=4, waMax=24, cid=Bandit.clanMap.BanditStrong, size = 3, hostile = true},
    },
    ["medicalclinic"] = {
        {waMin=0, waMax=4, cid=Bandit.clanMap.Medic, size = 3, hostile = false},
        {waMin=4, waMax=24, cid=Bandit.clanMap.BanditStrong, size = 4, hostile = true},
    },
    ["medicalstorage"] = {
        {waMin=0, waMax=4, cid=Bandit.clanMap.Medic, size = 1, hostile = false},
        {waMin=4, waMax=24, cid=Bandit.clanMap.BanditStrong, size = 1, hostile = true},
    },
    ["pawnshop"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 1, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.CriminalWhite, size = 4, hostile = true},
    },
    ["policearchive"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.PoliceBlue, size = 1, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Militia, size = 1, hostile = true},
    },
    ["policegarage"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.PoliceBlue, size = 3, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Militia, size = 3, hostile = true},
    },
    ["policegunstorage"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.SWAT, size = 2, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Militia, size = 4, hostile = true},
    },
    ["policehall"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.SWAT, size = 2, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Militia, size = 2, hostile = true},
    },
    ["policelocker"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.SWAT, size = 2, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Militia, size = 2, hostile = true},
    },
    ["policeoffice"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.PoliceBlue, size = 2, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Militia, size = 2, hostile = true},
    },
    ["policestorage"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.SWAT, size = 2, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Militia, size = 2, hostile = true},
    },
    ["pharmacy"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Medic, size = 2, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.BanditStrong, size = 3, hostile = true},
    },
    ["pharmacystorage"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Medic, size = 2, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.BanditStrong, size = 3, hostile = true},
    },
    ["security"] = {
        {waMin=0, waMax=4, cid=Bandit.clanMap.Security, size = 2, hostile = false},
    },
    ["zippeestorage"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 1, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.CriminalBlack, size = 2, hostile = true},
    },
    ["zippeestore"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 1, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.CriminalBlack, size = 2, hostile = true},
    },
}

BWOScenarios.Week.playerSpawns = {
    [1] = {x = 11933, y = 6863, z = 0}
}

function BWOScenarios.Week:waitingRoom()
    print ("waiting room build executed")
    local sx, sy, sz = 11782, 947, 0

    --[[
    BanditBaseGroupPlacements.ClearSpace (sx, sy, 0, 25, 25)
    BanditBaseGroupPlacements.ClearSpace (sx, sy, 1, 25, 25)
    BanditBaseGroupPlacements.ClearSpace (sx, sy, 2, 25, 25)
    ]]

    -- created procedurally
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 0, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_34", sx + 0, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 0, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_1", sx + 0, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 0, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_1", sx + 0, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 0, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_43", sx + 0, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 0, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("location_business_office_generic_01_37", sx + 0, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_42", sx + 0, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 0, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("location_business_office_generic_01_36", sx + 0, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_43", sx + 0, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 0, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_42", sx + 0, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 0, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 0, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_1", sx + 0, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 0, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_13", sx + 0, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_04_86", sx + 0, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_counters_01_59", sx + 0, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_sinks_01_21", sx + 0, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_13", sx + 0, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_04_84", sx + 0, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_bathroom_01_5", sx + 0, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 0, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_34", sx + 0, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("vegetation_indoor_01_11", sx + 0, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 0, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 0, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 0, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 0, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 0, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 0, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 0, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 0, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("location_community_school_01_33", sx + 0, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 0, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("vegetation_indoor_01_11", sx + 0, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_49", sx + 0, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 1, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_43", sx + 1, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_frames_01_3", sx + 1, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_01_57", sx + 1, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("lighting_indoor_01_25", sx + 1, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 1, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 1, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 1, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 1, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 1, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 1, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 1, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 1, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 1, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_13", sx + 1, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_04_95", sx + 1, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_frames_01_3", sx + 1, sy + 10, sz + 0)
    BWOBuildTools.IsoDoor ("fixtures_doors_01_15", sx + 1, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_13", sx + 1, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 1, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 1, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 1, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 1, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_1", sx + 1, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 1, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 1, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 1, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 1, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_1", sx + 1, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 1, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 1, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 1, sy + 21, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_17", sx + 1, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 2, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 2, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 2, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 2, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 2, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 2, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 2, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 2, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 2, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 2, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 2, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_13", sx + 2, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_04_85", sx + 2, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_13", sx + 2, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_bathroom_01_15", sx + 2, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("trashcontainers_01_20", sx + 2, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 2, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 2, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 2, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_0", sx + 2, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 2, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_23", sx + 2, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 2, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_2", sx + 2, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 2, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 2, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_0", sx + 2, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 2, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_23", sx + 2, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 2, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_2", sx + 2, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 2, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 2, sy + 21, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_17", sx + 2, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 3, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_5", sx + 3, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_14", sx + 3, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_frames_01_2", sx + 3, sy + 0, sz + 0)
    BWOBuildTools.IsoDoor ("fixtures_doors_01_56", sx + 3, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 3, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_4", sx + 3, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 3, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_4", sx + 3, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("appliances_cooking_01_20", sx + 3, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("appliances_cooking_01_68", sx + 3, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 3, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_4", sx + 3, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("appliances_cooking_01_20", sx + 3, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("appliances_cooking_01_68", sx + 3, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 3, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_4", sx + 3, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("appliances_cooking_01_52", sx + 3, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("appliances_cooking_01_68", sx + 3, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 3, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_4", sx + 3, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("appliances_cooking_01_41", sx + 3, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 3, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_4", sx + 3, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("appliances_cooking_01_40", sx + 3, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 3, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 3, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 3, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 3, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_13", sx + 3, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_04_86", sx + 3, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_counters_01_59", sx + 3, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_sinks_01_21", sx + 3, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_13", sx + 3, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_04_84", sx + 3, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_bathroom_01_5", sx + 3, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 3, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 3, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 3, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 3, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_3", sx + 3, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 3, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 3, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 3, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 3, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_3", sx + 3, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 3, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 3, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 3, sy + 21, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_17", sx + 3, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 4, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_5", sx + 4, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("location_community_school_01_32", sx + 4, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 4, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 4, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 4, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 4, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 4, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 4, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 4, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 4, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 4, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 4, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_13", sx + 4, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_04_95", sx + 4, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_frames_01_3", sx + 4, sy + 10, sz + 0)
    BWOBuildTools.IsoDoor ("fixtures_doors_01_15", sx + 4, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_13", sx + 4, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 4, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 4, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 4, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 4, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 4, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 4, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 4, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 4, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 4, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 4, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 4, sy + 21, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_17", sx + 4, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 5, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_5", sx + 5, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("appliances_refrigeration_01_22", sx + 5, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 5, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 5, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("trashcontainers_01_17", sx + 5, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 5, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_counters_01_39", sx + 5, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 5, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_counters_01_39", sx + 5, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 5, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 5, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 5, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 5, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 5, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 5, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_13", sx + 5, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_04_85", sx + 5, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_13", sx + 5, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_bathroom_01_15", sx + 5, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("trashcontainers_01_20", sx + 5, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 5, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 5, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 5, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 5, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_1", sx + 5, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 5, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 5, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 5, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 5, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_1", sx + 5, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 5, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 5, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 5, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_49", sx + 5, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 6, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_5", sx + 6, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("appliances_refrigeration_01_22", sx + 6, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 6, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 6, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 6, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_counters_01_35", sx + 6, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_sinks_01_16", sx + 6, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 6, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_counters_01_35", sx + 6, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 6, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 6, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 6, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_14", sx + 6, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_frames_01_2", sx + 6, sy + 7, sz + 0)
    BWOBuildTools.IsoDoor ("fixtures_doors_02_16", sx + 6, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 6, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 6, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 6, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 6, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 6, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 6, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 6, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 6, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 6, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 6, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_0", sx + 6, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 6, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_23", sx + 6, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 6, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_2", sx + 6, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 6, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 6, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_0", sx + 6, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 6, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_23", sx + 6, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 6, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_2", sx + 6, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 6, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 6, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_34", sx + 6, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_49", sx + 6, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 7, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_5", sx + 7, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("appliances_refrigeration_01_22", sx + 7, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 7, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 7, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 7, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 7, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 7, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 7, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 7, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("lighting_indoor_01_3", sx + 7, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 7, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 7, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 7, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 7, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 7, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 7, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_43", sx + 7, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_frames_01_3", sx + 7, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 7, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 7, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_3", sx + 7, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 7, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 7, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 7, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 7, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_3", sx + 7, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 7, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 7, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 7, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 7, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("blends_street_01_21", sx + 7, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_49", sx + 7, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 8, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_5", sx + 8, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_counters_01_38", sx + 8, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 8, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_counters_01_39", sx + 8, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 8, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("appliances_cooking_01_14", sx + 8, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("appliances_cooking_01_71", sx + 8, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 8, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("appliances_cooking_01_14", sx + 8, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("appliances_cooking_01_71", sx + 8, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 8, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_counters_01_39", sx + 8, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 8, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_counters_01_39", sx + 8, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 8, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_sinks_01_34", sx + 8, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 8, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("appliances_cooking_01_66", sx + 8, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 8, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 8, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 8, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 8, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 8, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 8, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 8, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("vegetation_indoor_01_12", sx + 8, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 8, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 8, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 8, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 8, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 8, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 8, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 8, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 8, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("lighting_indoor_01_3", sx + 8, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 8, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 8, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_49", sx + 8, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 9, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 0, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_65", sx + 9, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("vegetation_indoor_01_7", sx + 9, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 9, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_0", sx + 9, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 9, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_23", sx + 9, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 9, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_2", sx + 9, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 9, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 9, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 9, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 9, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 9, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_35", sx + 9, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 9, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 9, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 9, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 9, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 9, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("location_community_school_01_33", sx + 9, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_5", sx + 9, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 9, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 9, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_39", sx + 9, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 9, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_38", sx + 9, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 9, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_37", sx + 9, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 9, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 9, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 9, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_42", sx + 9, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_frames_01_2", sx + 9, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 9, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_35", sx + 9, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_49", sx + 9, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 10, sy + 0, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_65", sx + 10, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 10, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 10, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 10, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 10, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 10, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_0", sx + 10, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 10, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_23", sx + 10, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 10, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_2", sx + 10, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 10, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 10, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 10, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 10, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 10, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 10, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_5", sx + 10, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_35", sx + 10, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 10, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 10, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 10, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 10, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 10, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 10, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 10, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 10, sy + 21, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_17", sx + 10, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 11, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("walls_commercial_01_75", sx + 11, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_01_37", sx + 11, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 11, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 11, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 11, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 11, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 11, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 11, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 11, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 11, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 11, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 11, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 11, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 11, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 11, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_6", sx + 11, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 11, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_7", sx + 11, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 11, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_7", sx + 11, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 11, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_7", sx + 11, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 11, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_7", sx + 11, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 11, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_7", sx + 11, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 11, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_counters_01_55", sx + 11, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("location_shop_accessories_01_23", sx + 11, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 11, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 11, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_49", sx + 11, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 12, sy + 0, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_65", sx + 12, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 12, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 12, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 12, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 12, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 12, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 12, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 12, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 12, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 12, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 12, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 12, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 12, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 12, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 12, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_25", sx + 12, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 12, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_25", sx + 12, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 12, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_25", sx + 12, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 12, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_25", sx + 12, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 12, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_25", sx + 12, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 12, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 12, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 12, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_49", sx + 12, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 0, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_65", sx + 13, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 13, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 13, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_49", sx + 13, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 0, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_65", sx + 14, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_rugs_01_28", sx + 14, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_0", sx + 14, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_rugs_01_36", sx + 14, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_40", sx + 14, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_rugs_01_44", sx + 14, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_2", sx + 14, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 14, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("recreational_01_45", sx + 14, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 14, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("recreational_01_44", sx + 14, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 14, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("recreational_01_40", sx + 14, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 14, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("recreational_01_10", sx + 14, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 14, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 14, sy + 21, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_17", sx + 14, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 0, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_65", sx + 15, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_rugs_01_29", sx + 15, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_0", sx + 15, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_rugs_01_37", sx + 15, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_41", sx + 15, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_rugs_01_45", sx + 15, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_2", sx + 15, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 15, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("recreational_01_43", sx + 15, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 15, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("recreational_01_42", sx + 15, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 15, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("recreational_01_41", sx + 15, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 15, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("recreational_01_11", sx + 15, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 15, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 15, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_49", sx + 15, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 16, sy + 0, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_65", sx + 16, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 16, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 16, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 16, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 16, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 16, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 16, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 16, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 16, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 16, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 16, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 16, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 16, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 16, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_railings_01_118", sx + 16, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 16, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_railings_01_116", sx + 16, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 16, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_railings_01_116", sx + 16, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_03_65", sx + 16, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 16, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_railings_01_116", sx + 16, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_03_64", sx + 16, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 16, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_railings_01_116", sx + 16, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_03_65", sx + 16, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 16, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_railings_01_116", sx + 16, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_03_64", sx + 16, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 16, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_railings_01_116", sx + 16, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("vegetation_indoor_01_9", sx + 16, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 16, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_railings_01_119", sx + 16, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 16, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_49", sx + 16, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 17, sy + 0, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_65", sx + 17, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 17, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 17, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 17, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 17, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 17, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 17, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 17, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 17, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 17, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 17, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 17, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_1", sx + 17, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 17, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_1", sx + 17, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 17, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_railings_01_117", sx + 17, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 17, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 17, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 17, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 17, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 17, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 17, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 17, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 17, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_49", sx + 17, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 18, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("walls_commercial_01_75", sx + 18, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_01_37", sx + 18, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 18, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 18, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 18, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 18, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 18, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 18, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 18, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 18, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 18, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 18, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 18, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_43", sx + 18, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 18, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_42", sx + 18, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 18, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_railings_01_117", sx + 18, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 18, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 18, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 18, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 18, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 18, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 18, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 18, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 18, sy + 21, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_17", sx + 18, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 19, sy + 0, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_65", sx + 19, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 19, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 19, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 19, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 19, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 19, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_0", sx + 19, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 19, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_23", sx + 19, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 19, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_2", sx + 19, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 19, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 19, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 19, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 19, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_3", sx + 19, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 19, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_3", sx + 19, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 19, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_railings_01_117", sx + 19, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 19, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 19, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 19, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_rugs_01_59", sx + 19, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 19, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_rugs_01_58", sx + 19, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 19, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 19, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 19, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 19, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_49", sx + 19, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 20, sy + 0, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_65", sx + 20, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("vegetation_indoor_01_7", sx + 20, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 20, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_0", sx + 20, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 20, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_23", sx + 20, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 20, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_2", sx + 20, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 20, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 20, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 20, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 20, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 20, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 20, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 20, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 20, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 20, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("vegetation_indoor_01_7", sx + 20, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_01_1", sx + 20, sy + 13, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_16", sx + 20, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("lighting_outdoor_01_26", sx + 20, sy + 13, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_16", sx + 20, sy + 14, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_16", sx + 20, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_51", sx + 20, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_frames_01_25", sx + 20, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_02_40", sx + 20, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_frames_01_24", sx + 20, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_02_44", sx + 20, sy + 17, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_16", sx + 20, sy + 18, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_16", sx + 20, sy + 19, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_16", sx + 20, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("lighting_outdoor_01_30", sx + 20, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_exterior_street_01_16", sx + 20, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_6", sx + 20, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_01_1", sx + 20, sy + 22, sz + 0)
end

function BWOScenarios.Week:controller()
	local worldAge = BWOUtils.GetWorldAge()
	local zcnt = 0
	if zcnt > 100 then zcnt = 100 end
    BWOPopControl.zombiePercent = zcnt
end