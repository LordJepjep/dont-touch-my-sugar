extends Area2D

@export_enum("Cooldown", "HitOnce", "DisableHitbox") var hurtBoxType = 0

@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableTimer

var hit_once_array = []

signal hurt(damage)

func _on_area_entered(area):	
	if area.is_in_group("attack"):
		if not area.get("damage") == null:
			print("attack detected")
			match hurtBoxType:
				0: #cooldown
					collision.call_deferred("set", "disabled", true)
					disableTimer.start()
				1: #hitOnce
					if hit_once_array.has(area) == false:
						hit_once_array.append(area)
						if area.has_signal("remove_from_array"):
							if not area.is_connected("remove_from_array", Callable(self,"remove_from_list")):
								area.connect("remove_from_array", Callable(self, "remove_from_list"))
					else:
						return
				2: #disableHitBox
					if area.has_method("tempDisable"):
						area.tempDisable()
			var damage = area.damage
			emit_signal("hurt", damage)
			if area.has_method("enemy_hit"):
				area.enemy_hit(1)

func remove_from_list(object):
	if hit_once_array.has(object):
		hit_once_array.erase(object)

func _on_disable_timer_timeout():
	collision.call_deferred("set", "disabled", false)