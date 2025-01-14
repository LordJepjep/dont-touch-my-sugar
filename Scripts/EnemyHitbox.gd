class_name EnemyHitBox
extends Area2D

var damage : float

func _ready():
	damage = owner.getDamage()
	
func _init():
	collision_layer = 3
	collision_mask = 2

