extends StaticBody2D

class_name SugarTarget
signal outOfSugar

@onready var hit_flash_anim_player = $HitFlashAnimationPlayer
@onready var hpBar = get_tree().get_first_node_in_group("main").get_node("%SugarHPBar")
@onready var normal = preload("res://assets/sugar/sugar1.png")
@onready var hurt = preload("res://assets/sugar/sugar2.png")
@onready var veryHurt = preload("res://assets/sugar/sugar3.png")
@onready var megaHurt = preload("res://assets/sugar/sugar4.png")
@onready var bigSugar = $BigSugar
@onready var mediumSugar = $MediumSugar
@onready var smallSugar = $SmallSugar
@export var max_hp: float = 100
@export var current_hp: float = 100

func _ready():
	hpBar.max_value = max_hp
	hpBar.value = current_hp
	updateTexture()
	
func gameOver():
	outOfSugar.emit()

func _on_hurt_box_hurt(damage):
	$hurt_sfx.play()
	hit_flash_anim_player.play("hit_flash")
	current_hp -= damage
	hpBar.max_value = max_hp
	hpBar.value = current_hp
	updateTexture()
	print("Sugar Damaged: ", damage)
	print("Sugar HP: ", current_hp)
	
	if current_hp <= 0:
		gameOver()
		
func updateTexture():
	if current_hp <= (max_hp * .10):
		bigSugar.texture = megaHurt
		mediumSugar.texture = megaHurt
		smallSugar.texture = megaHurt
	elif current_hp <= (max_hp * .20):
		bigSugar.texture = megaHurt
		mediumSugar.texture = megaHurt
		smallSugar.texture = veryHurt
	elif current_hp <= (max_hp * .30):
		bigSugar.texture = megaHurt
		mediumSugar.texture = veryHurt
		smallSugar.texture = veryHurt
	elif current_hp <= (max_hp * .40):
		bigSugar.texture = veryHurt
		mediumSugar.texture = veryHurt
		smallSugar.texture = veryHurt
	elif current_hp <= (max_hp * .50):
		bigSugar.texture = veryHurt
		mediumSugar.texture = veryHurt
		smallSugar.texture = hurt
	elif current_hp <= (max_hp * .60):
		bigSugar.texture = veryHurt
		mediumSugar.texture = hurt
		smallSugar.texture = hurt
	elif current_hp <= (max_hp * .70):
		bigSugar.texture = hurt
		mediumSugar.texture = hurt
		smallSugar.texture = hurt
	elif current_hp <= (max_hp * .80):
		bigSugar.texture = hurt
		mediumSugar.texture = hurt
		smallSugar.texture = normal
	elif current_hp <= (max_hp * .90):
		bigSugar.texture = hurt
		mediumSugar.texture = normal
		smallSugar.texture = normal
	elif current_hp <= max_hp:
		bigSugar.texture = normal
		mediumSugar.texture = normal
		smallSugar.texture = normal
