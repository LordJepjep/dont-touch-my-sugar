extends Node2D

@export var MAX_HEALTH := 1.0
var health: float

func _ready():
	health = MAX_HEALTH
	
func damange(attack: Attack):
	health -= attack.attack_damage
	
	if health <= 0:
		get_parent()
	
