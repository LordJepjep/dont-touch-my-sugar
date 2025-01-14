extends Node

const ICON_PATH = "res://assets/upgrades/"
const UPGRADES = {
	"toothpick1":{
		"icon": ICON_PATH + "toothpick lvl 1.png",
		"displayname": "Toothpick",
		"desc": "A mighty wooden spear that attacks a random enemy",
		"level":"Level: 1",
		"prereq": [],
		"type": "weapon"
	},
	"toothpick2":{
		"icon": ICON_PATH + "toothpick lvl 2.png",
		"displayname": "Toothpick",
		"desc": "A slightly better toothpick",
		"level":"Level: 2",
		"prereq": ["toothpick1"],
		"type": "weapon"
	},
	"toothpick3":{
		"icon": ICON_PATH + "toothpick lvl 3.png",
		"displayname": "Toothpick",
		"desc": "Damn, that's one sharp toothpick!",
		"level":"Level: 3",
		"prereq": ["toothpick2"],
		"type": "weapon"
	}, 
	"toothpick4":{
		"icon": ICON_PATH + "toothpick lvl 4.png",
		"displayname": "Toothpick",
		"desc": "What if you have a machine gun?",
		"level":"Level: 4",
		"prereq": ["toothpick3"],
		"type": "weapon"
	},  
	"toothpick5":{
		"icon": ICON_PATH + "toothpick lvl 5.png",
		"displayname": "Toothpick",
		"desc": "I need bigger weapon, sir!",
		"level":"Level: 5",
		"prereq": ["toothpick4"],
		"type": "weapon"
	},
	"more_toothpick1":{
		"icon": ICON_PATH + "more toothpick1.png",
		"displayname": "More Toothpick",
		"desc": "What's better than one toothpick? Another toothpick!",
		"level":"Level: 1",
		"prereq": ["toothpick2"],
		"type": "upgrade"
	}, 
	"more_toothpick2":{
		"icon": ICON_PATH + "more toothpick2.png",
		"displayname": "More Toothpick",
		"desc": "What's better than two toothpicks? Another toothpick!",
		"level":"Level: 2",
		"prereq": ["more_toothpick1", "toothpick4"],
		"type": "upgrade"
	},   
	"more_toothpick3":{
		"icon": ICON_PATH + "more toothpick3.png",
		"displayname": "More Toothpick",
		"desc": "4 in Japanese means DEATH",
		"level":"Level: 3",
		"prereq": ["more_toothpick2", "toothpick5"],
		"type": "upgrade"
	},
	"toothpick_stun":{
		"icon": ICON_PATH + "toothpick stun.png",
		"displayname": "Toothpick Stun",
		"desc": "Damn! Those toothpicks got them knockers!",
		"level":"Level 1",
		"prereq": ["stun1", "more_toothpick1"],
		"type": "upgrade"
	},
	"damage":{
		"icon": ICON_PATH + "add_damage.png",
		"displayname": "Additional Damage",
		"desc": "Imagine hitting a little bit harder...",
		"level":"N/A",
		"prereq": [],
		"type": "upgrade"
	}, 
	"double_damage":{
		"icon": ICON_PATH + "double damage.png",
		"displayname": "Double Damage",
		"desc": "Now image hitting twice as hard!!!",
		"level":"N/A",
		"prereq": [],
		"type": "upgrade"
	}, 
	"heal_sugar":{
		"icon": ICON_PATH + "heal sugar.png",
		"displayname": "Heal Sugar",
		"desc": "Recover depleted sugar the ants stole from you!",
		"level":"N/A",
		"prereq": [],
		"type": "item"
	},
	"more_sugar":{
		"icon": ICON_PATH + "more sugar.png",
		"displayname": "More Sugar",
		"desc": "You just can't have enough sugars!",
		"level":"N/A",
		"prereq": [],
		"type": "upgrade"
	}, 
	"stun1":{
		"icon": ICON_PATH + "stun1.png",
		"displayname": "Stun",
		"desc": "Give them ants a good ol' wallop",
		"level":"level: 1",
		"prereq": [],
		"type": "upgrade"
	}, 
	"stun2":{
		"icon": ICON_PATH + "stun2.png",
		"displayname": "Stun",
		"desc": "Give them ants a good ol' wallop!",
		"level":"level: 2",
		"prereq": ["stun1"],
		"type": "upgrade"
	},
	"stun3":{
		"icon": ICON_PATH + "stun3.png",
		"displayname": "Stun",
		"desc": "Nap time!",
		"level":"level: 3",
		"prereq": ["stun2"],
		"type": "upgrade"
	}, 
	"stun4":{
		"icon": ICON_PATH + "stun4.png",
		"displayname": "Stun",
		"desc": "Sleep well, mahdudes...",
		"level":"level: 4",
		"prereq": ["stun3"],
		"type": "upgrade"
	}, 
	"stun5":{
		"icon": ICON_PATH + "stun5.png",
		"displayname": "Stun",
		"desc": "A deep sleeper, you are!",
		"level":"level: 5",
		"prereq": ["stun4"],
		"type": "upgrade"
	}, 
	"stun_aoe":{
		"icon": ICON_PATH + "stun aoe.png",
		"displayname": "Shockwave Stun",
		"desc": "Nap time!",
		"level":"level: 1",
		"prereq": ["shockwave1","stun1"],
		"type": "upgrade"
	}, 
	"knockback1":{
		"icon": ICON_PATH + "knockback1.png",
		"displayname": "Knockback",
		"desc": "Pushes an enemy back.",
		"level":"level: 1",
		"prereq": [],
		"type": "upgrade"
	},
	"knockback2":{
		"icon": ICON_PATH + "knockback2.png",
		"displayname": "Knockback",
		"desc": "Pushes an enemy back a little bit harder",
		"level":"level: 2",
		"prereq": ["knockback1"],
		"type": "upgrade"
	},
	"knockback3":{
		"icon": ICON_PATH + "knockback3.png",
		"displayname": "Knockback",
		"desc": "Pushes enemies back harder",
		"level":"level: 3",
		"prereq": ["knockback2"],
		"type": "upgrade"
	},
	"shockwave1":{
		"icon": ICON_PATH + "shockwave.png",
		"displayname": "Shockwave",
		"desc": "Pushes enemies back in a bigger radius.",
		"level":"level: 1",
		"prereq": ["knockback3"],
		"type": "upgrade"
	},
	"shockwave2":{
		"icon": ICON_PATH + "shockwave2.png",
		"displayname": "Shockwave",
		"desc": "Pushes an enemy back a little bit harder in a little bit bigger radius.",
		"level":"level: 2",
		"prereq": ["shockwave1"],
		"type": "upgrade"
	},
	"shockwave3":{
		"icon": ICON_PATH + "shockwave3.png",
		"displayname": "Shockwave",
		"desc": "Pushes enemies back harder in a bigger radius",
		"level":"level: 3",
		"prereq": ["shockwave2"],
		"type": "upgrade"
	},
	"shockwave4":{
		"icon": ICON_PATH + "shockwave4.png",
		"displayname": "Shockwave",
		"desc": "Pushes enemies back harder in a bit bigger radius",
		"level":"level: 4",
		"prereq": ["shockwave3"],
		"type": "upgrade"
	},
	"shockwave5":{
		"icon": ICON_PATH + "shockwave5.png",
		"displayname": "Shockwave",
		"desc": "Pushes enemies back harder in a bigger radius",
		"level":"level: 5",
		"prereq": ["shockwave4"],
		"type": "upgrade"
	},
	"shockwave6":{
		"icon": ICON_PATH + "shockwave6.png",
		"displayname": "Shockwave",
		"desc": "Pushes enemies back harder in a bigger bigger radius",
		"level":"level: 6",
		"prereq": ["shockwave5"],
		"type": "upgrade"
	},
	"shockwave7":{
		"icon": ICON_PATH + "shockwave7.png",
		"displayname": "Shockwave",
		"desc": "Pushes enemies back harder in a bigger bigger bigger radius",
		"level":"level: 7",
		"prereq": ["shockwave6"],
		"type": "upgrade"
	},
	
	"bigger_shockwave":{
		"icon": ICON_PATH + "bigger shockwave.png",
		"displayname": "Bigger Shockwave",
		"desc": "Imagine pushing them harder than ever.",
		"level":"N/A",
		"prereq": ["shockwave7"],
		"type": "upgrade"
	},
	"deadlier_shockwave":{
		"icon": ICON_PATH + "deadlier shockwave.png",
		"displayname": "Deadlier Shockwave",
		"desc": "What if the wind is as strong as your fists?",
		"level":"N/A",
		"prereq": ["shockwave7"],
		"type": "upgrade"
	},
	"critical_chance":{
		"icon": ICON_PATH + "critical chance.png",
		"displayname": "More Critical Chance",
		"desc": "May RNG be with you.",
		"level":"N/A",
		"prereq": [],
		"type": "upgrade"
	},
	"critical_damage":{
		"icon": ICON_PATH + "critical damage.png",
		"displayname": "More Critical Damage",
		"desc": "Sting like a bee!",
		"level":"N/A",
		"prereq": [],
		"type": "upgrade"
	},
	"xp_boost":{
		"icon": ICON_PATH + "xp boost.png",
		"displayname": "XP Boost",
		"desc": "Gains a bit more xp...",
		"level":"N/A",
		"prereq": [],
		"type": "upgrade"
	},  

}
