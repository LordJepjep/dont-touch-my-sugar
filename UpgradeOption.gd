extends ColorRect

var upgrade = null
@onready var player = get_tree().get_first_node_in_group("main")
@onready var lblName = $NameLabel
@onready var lblDesc = $DescLabel
@onready var lblLevel = $LevelLabel
@onready var upgradeIcon = $ColorRect/TextureRect

signal selected_upgrade(upgrade)

var isDisabled = true

func _ready():
	connect("selected_upgrade", Callable(player, "upgrade_attack"))
	if upgrade == null:
		upgrade = "damage"
	lblName.text = UpgradeDb.UPGRADES[upgrade]["displayname"]
	lblDesc.text = UpgradeDb.UPGRADES[upgrade]["desc"]
	lblLevel.text = UpgradeDb.UPGRADES[upgrade]["level"]
	upgradeIcon.texture = load(UpgradeDb.UPGRADES[upgrade]["icon"])
	$Timer.start()
	
func _gui_input(event):
	if InputEventScreenTouch and event.is_action_pressed("click") and isDisabled == false:
			print("Call stack:", get_stack())
			emit_signal("selected_upgrade", upgrade)

func _on_timer_timeout():
	isDisabled = false
