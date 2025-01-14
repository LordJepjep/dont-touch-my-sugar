extends Node2D

@onready var gameOverScreen = $UILayer/GameOver
@onready var pause_screen = $UILayer/Pause
@onready var toothpick_dispenser = $UpgradeVisuals/ToothpickDispenser
@onready var xp_bar = get_node("%XPBar")
@onready var lvl_lbl = $GUILayer/GUI/XPBar/LevelLabel
@onready var lvl_panel = $GUILayer/GUI/LevelUp
@onready var upgrade_options = $GUILayer/GUI/LevelUp/UpgradeOptions
@onready var lvlUp_sfx = $lvlUp_snd
@onready var upgrade_options_indiv = preload("res://Scenes/upgrade_option.tscn")
@onready var shockwave = preload("res://Scenes/shockwave.tscn")
@onready var timer_lbl = $GUILayer/GUI/TimerLabel
@onready var collectedWeapons = $GUILayer/GUI/CollectedWeapons
@onready var collectedUpgrades = $GUILayer/GUI/CollectedUpgrades
@onready var itemContainer = preload("res://Utility/item_container.tscn")
var score # tracks current score based on a formula

var argtime = 0
var total_time = 0 # tracks time elapsed

var sugar = null
var spawner = null
var xp = 0
var level = 1 
var collected_exp = 0
var total_kill_count = 0
var total_xp_global = 0 # tracks total xp throughout the game

# Attack Upgrades
var xp_add_percentage = 0
var sugar_hp = 0
var sugar_maxhp = 0
var collected_upgrades = []
var upgrade_options_list = []

var attack_damage = 0.5
var critical_chance: float = 0.05
var critical_damage_percentage = .25

var hasShockwave = false
var shockwave_radius = 50
var shockwave_displacement = 50
var shockwave_damage_percent = 0.1

var hasKnockback = false
var knockback_displacement = 20
var knockback_damage = attack_damage / 2

var hasStun = false
var stun_duration = 0
var isStunAOE = false # if aoe, use shockwave radius 

# Toothpick
var toothpick = preload("res://Scenes/toothpick.tscn")
@onready var toothpickTimer = get_node("Attack/ToothpickTimer")
@onready var toothpickAttackTimer = get_node("Attack/ToothpickTimer/ToothpickAttackTimer")

var toothpick_ammo = 0
var toothpick_baseammo = 1
var toothpick_attackspeed = 1.5
var toothpick_level = 0
var hasToothpickStun = false

var enemy_close = []

func _ready():
	attack()
	sugar = get_tree().get_first_node_in_group("sugar_group")
	sugar_hp = sugar.current_hp
	sugar_maxhp = sugar.max_hp
	spawner = get_node("EnemySpawner")
	sugar.outOfSugar.connect(on_outOfSugar)
	spawner.enemy_dead.connect(calculate_exp)
	set_xp_bar(xp, calculate_exp_cap())
	
func _process(delta):
	score = int(total_time + total_kill_count + total_xp_global)
	Global.score = score
	Global.total_time = total_time
	Global.total_kill_count = total_kill_count
	Global.level = level

func _physics_process(delta):
	argtime += delta #tracks time elapsed in game
	change_time(argtime)
	total_time = argtime 

func change_time(argtime = 0):
	var time = int(argtime)
	var minutes = int(time/60.0)
	var seconds = time % 60
	if minutes < 10:
		minutes = str(0, minutes)
	if seconds < 10:
		seconds = str(0, seconds)
	timer_lbl.text = str(minutes,":",seconds)
	
func on_outOfSugar():
	await get_tree().create_timer(0.5).timeout
	$BGM.stop()
	$UILayer/GameOver/gameover_snd.play()
	gameOverScreen.visible = true
	get_tree().paused = true
	
func _on_pause_button_pressed():
	$ButtonClick.play()
	pause_screen.visible = true
	get_tree().paused = true

func _on_bgm_finished():
	$BGM.play()

func calculate_exp(enemy_exp, kill_counter):
	var exp_required = calculate_exp_cap()
	var xp_add = xp_add_percentage * enemy_exp # additional xp from xp boost upgrade
	collected_exp = enemy_exp + xp_add
	total_xp_global += collected_exp
	total_kill_count += kill_counter # counts kills
	
	print("Total Kills: ", total_kill_count)
	print("Total XP: ", total_xp_global)
	
	if xp + collected_exp >= exp_required:
		collected_exp -= exp_required - xp
		level += 1
		level_up()
		xp = 0
		exp_required = calculate_exp_cap()
	else:
		xp += collected_exp
		collected_exp = 0
	set_xp_bar(xp, exp_required)
		
func calculate_exp_cap():
	var exp_cap = level
	if level < 20:
		exp_cap = level * 5
	elif level < 40:
		exp_cap = 95 + (level-19) * 8
	else:
		exp_cap = 255 + (level - 39) * 12
	return exp_cap
	
func set_xp_bar(set_value, set_max_value):
	xp_bar.value = set_value
	xp_bar.max_value = set_max_value
	
func level_up():
	lvlUp_sfx.play()
	lvl_lbl.text = str("Level: ", level)
	
	var tween = lvl_panel.create_tween()
	tween.tween_property(lvl_panel, "position", Vector2(8, 248), 0.2).set_trans(Tween.TRANS_QUINT). set_ease(Tween.EASE_IN)
	tween.play()
	
	lvl_panel.visible = true
	
	var options = 0
	var optionmax = 4
	while options < optionmax:
		var option_choice = upgrade_options_indiv.instantiate()
		option_choice.upgrade = get_random_upgrade()
		upgrade_options.add_child(option_choice)
		options+=1
	get_tree().paused = true
	
func upgrade_attack(upgrade):
	match upgrade:
		"damage":
			attack_damage += 0.25
		"double_damage":
			attack_damage *= 1.5
		"heal_sugar":
			sugar.current_hp += 5
			sugar.current_hp = clamp(sugar_hp, 0, sugar_maxhp)
			sugar_hp = sugar.current_hp
			print(sugar_hp)
		"more_sugar":
			sugar.max_hp += 10
			sugar_maxhp = sugar.max_hp
			sugar.current_hp += 10
			if sugar.current_hp > sugar_maxhp:
				sugar.current_hp = sugar_maxhp
			print(sugar.max_hp)
		"critical_chance":
			critical_chance += 0.075
		"critical_damage":
			critical_damage_percentage += 0.25
		"xp_boost":
			xp_add_percentage += 0.1
		"knockback1":
			hasShockwave = true
			shockwave_radius = 5
			shockwave_displacement = 50
			shockwave_damage_percent = 0.1
		"knockback2":
			shockwave_radius = 5
			shockwave_displacement = 55
			shockwave_damage_percent = 0.15
		"knockback3":
			shockwave_radius = 15
			shockwave_displacement = 60
			shockwave_damage_percent = 0.2
		"shockwave1", "shockwave2", "shockwave3", "shockwave4", "shockwave5", "shockwave6", "shockwave7":
			shockwave_damage_percent += 0.15
			shockwave_displacement += 5
			shockwave_radius += 10
		"bigger_shockwave":
			shockwave_radius *= 1.5
		"deadlier_shockwave":
			shockwave_damage_percent *= 1.5
		"toothpick1":
			toothpick_level = 1	
			toothpick_dispenser.visible = true
		"toothpick2":
			toothpick_level = 2
			toothpick_attackspeed += 0.15
		"toothpick3":
			toothpick_level = 3
			toothpick_attackspeed += 0.15
		"toothpick4":
			toothpick_level = 4
			toothpick_attackspeed += 0.15
		"toothpick5":
			toothpick_level = 3
			toothpick_attackspeed += 0.15
		"more_toothpick1":
			toothpick_baseammo = 2
			toothpick_dispenser.texture = load("res://assets/upgrades/upgrade_visuals/toothpick dispenser2.png")
		"more_toothpick2":
			toothpick_baseammo = 3
			toothpick_dispenser.texture = load("res://assets/upgrades/upgrade_visuals/toothpick dispenser3.png")
		"more_toothpick3":
			toothpick_baseammo = 4
			toothpick_dispenser.texture = load("res://assets/upgrades/upgrade_visuals/toothpick dispenser4.png")
		"toothpick_stun":
			hasToothpickStun = true
		"stun1":
			hasStun = true
		"stun2","stun3":
			stun_duration += 0.5
		"stun4":
			stun_duration += 0.75
		"stun5":
			stun_duration += 1
		"stun_aoe":
			isStunAOE = true
			
	adjust_gui_collection(upgrade)
	attack()
	var option_children = upgrade_options.get_children()
	for i in option_children:
		i.queue_free()
	upgrade_options_list.clear()
	collected_upgrades.append(upgrade)
	lvl_panel.visible = false
	lvl_panel.position = Vector2(800, 73)
	get_tree().paused = false
	$upgrade_snd.play()

func get_random_upgrade():
	var dbList = []
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades: #if already in collected upgrades
			pass
		elif i in upgrade_options_list: # if already in options
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item" and sugar.current_hp == sugar.max_hp:
			pass
		elif UpgradeDb.UPGRADES[i]["prereq"].size() > 0: #check for prereqs
			var to_add = true
			for n in UpgradeDb.UPGRADES[i]["prereq"]: 
				if not n in collected_upgrades:
					to_add = false
				if to_add:
					dbList.append(i)
		else:
			dbList.append(i)
	if dbList.size() > 0:
		var randomUpgrade = dbList.pick_random()
		upgrade_options_list.append(randomUpgrade)
		return randomUpgrade
	else:
		return null

func _input(event):
	if event is InputEventScreenTouch:
		if event.index < 1: # limits multitouch to one click at a time
			if event.is_pressed():
				if hasShockwave:
					createShockwave(event.position)

func createShockwave(pos):
	var new_shockwave = shockwave.instantiate()
	new_shockwave.setSize(shockwave_radius)
	new_shockwave.global_position = pos
	add_child(new_shockwave)
	
func attack():
	if toothpick_level > 0:
		toothpickTimer.wait_time = toothpick_attackspeed
		if toothpickTimer.is_stopped():
			toothpickTimer.start()
	
func _on_toothpick_timer_timeout():
	toothpick_ammo += toothpick_baseammo
	toothpickAttackTimer.start()
		
func _on_toothpick_attack_timer_timeout():
	if toothpick_ammo > 0:
		var toothpick_attack = toothpick.instantiate()
		toothpick_attack.position = Vector2(toothpick_dispenser.position.x, toothpick_dispenser.position.y - 50)
		toothpick_attack.target = get_random_target()
		toothpick_attack.level = toothpick_level
		add_child(toothpick_attack)
		toothpick_ammo -= 1
		if toothpick_ammo > 0:
			toothpickAttackTimer.start()
		else:
			toothpickAttackTimer.stop()
		
func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.DOWN


func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		if body != sugar:
			enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		if body != sugar:
			pass
		enemy_close.erase(body)

func adjust_gui_collection(upgrade):
	var get_upgraded_displayname = UpgradeDb.UPGRADES[upgrade]["displayname"]
	var get_upgrade_icon = UpgradeDb.UPGRADES[upgrade]["icon"]
	var get_upgrade_lvl = UpgradeDb.UPGRADES[upgrade]["level"]
	var get_type = UpgradeDb.UPGRADES[upgrade]["type"]
	if get_type != "item":
		var get_collected_displayname = []
		for i in collected_upgrades:
			get_collected_displayname.append(UpgradeDb.UPGRADES[i]["displayname"])
		if not get_upgraded_displayname in get_collected_displayname:
				var new_item = itemContainer.instantiate()
				new_item.upgrade = upgrade
				match get_type:
					"weapon":
						collectedWeapons.add_child(new_item)
					"upgrade":
						collectedUpgrades.add_child(new_item)
		else:
			var container = null
			match get_type:
				"weapon":
					container = collectedWeapons
				"upgrade":
					container = collectedUpgrades
			for i in range(container.get_child_count()):
				if get_upgrade_lvl == "N/A":
					var item = container.get_child(i)
					var item_name = item.item_name
					if item_name == get_upgraded_displayname:
						var num = item.get_node("Label").text
						if num == "":
							item.get_node("Label").text = "2"
						else:
							item.get_node("Label").text = str(int(num) + 1)
				else:
					var item = container.get_child(i)
					var item_name = item.item_name
					if item_name == get_upgraded_displayname:
						item.get_node("ItemTexture").texture = load(get_upgrade_icon)
