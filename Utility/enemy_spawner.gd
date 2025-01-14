extends Node2D

@export var spawns: Array[SpawnInfo] = []
@onready var sugar = get_tree().get_first_node_in_group("sugar_group")
@onready var main = get_tree().get_first_node_in_group("main")
var time = 0

signal enemy_dead(xp)

func _on_timer_timeout():
	time+=1
	var enemy_spawns = spawns
	for i in enemy_spawns:
		if time >= i.time_start and time <= i.time_end:
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter +=1
			else:
				i.enemy_spawn_delay = 0
				var new_enemy= i.enemy
				var counter = 0
				while counter < i.enemy_num:
					var enemy_spawn = new_enemy.instantiate()
					enemy_spawn.connect("enemy_dead", self._on_enemy_dead)
					enemy_spawn.global_position = get_random_position()
					enemy_spawn.initStats()
					add_child(enemy_spawn)
					counter+=1

func get_random_position():
	var viewport_rect = get_viewport_rect()
	var random_x = randf_range(viewport_rect.position.x + 50, viewport_rect.size.x - 50)
	var random_y = viewport_rect.size.y + 200
	return Vector2(random_x, random_y)

func _on_enemy_dead(xp, kill_counter):
	enemy_dead.emit(xp, kill_counter)

