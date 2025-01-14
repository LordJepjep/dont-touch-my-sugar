class_name HurtBox
extends Area2D

signal hurt(damage)

func _init():
	collision_layer = 2
	collision_mask = 3

func _ready():
	connect("area_entered", self._on_area_entered)

func _on_area_entered(hitbox: EnemyHitBox):
	if hitbox == null:
		print("no hits")
		return
	
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
		print("taking damage")

	
				
