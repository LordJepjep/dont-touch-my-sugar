extends CharacterBody2D
class_name Enemy
@export var resource: EnemyResourceBase

@onready var enemyAnim = $AnimatedSprite2D
@onready var playerStats = get_tree().get_first_node_in_group("main")
@onready var hit_flash_anim_player = $HitFlashAnimationPlayer
@onready var hurt_sfx = $AudioStreamPlayer2D
@onready var hit_box = $HitBox/CollisionShape2D

var target: SugarTarget

var stun_fx = preload("res://Scenes/stun.tscn")
var crit_fx = preload("res://Scenes/crit.tscn")
var stun_anim
var death_anim = preload("res://Scenes/Enemy Scenes/ant_death_splash.tscn")
var hand_death_anim = preload("res://Scenes/Enemy Scenes/hand_death.tscn")
var isDead = false
var distanceLimit: float = 200.0
var hasReachedDistanceLimit: bool = false

var is_outside

# Player Effects
var player_damage
var critical_chance: float
var critical_damage_percentage

var knockback_displacement
var isKnocked = false
var isStunned = false

var stun_duration 
var poison_damage
var poison_duration


# Enemy Stats
var max_health: float
var health: float
var speed: float
var damage: float
var spawn_cost: int
var xp: int
var kill_counter: int

signal remove_from_array(object)
signal enemy_dead(xp, kill_counter)
#var drag_timer: Timer
#var isDragging = false
#var drag_start: Vector2 = Vector2.ZERO
#var drag_time: float = 2.0

func initStats():
	max_health = resource.max_health
	health = max_health
	speed = resource.speed 
	damage = resource.damage
	spawn_cost = resource.spawn_cost
	xp = resource.xp
	kill_counter = 1


func _ready():
	if(enemyAnim != null):
		enemyAnim.play("walk")
	player_damage = playerStats.attack_damage
	
	# setups the stun animation by hiding it
	stun_anim = stun_fx.instantiate()
	add_child(stun_anim)
	stun_anim.hide()

func _process(delta):
	# constantly updates the position of the stun fx to the enemy's position
	if is_instance_valid(stun_anim):
			stun_anim.global_position = global_position + Vector2(0, -20)
	
func _physics_process(delta):
	if target == null:
		target = get_tree().get_nodes_in_group("sugar_group")[0]
	else:
		if isStunned or isDead:
			velocity = Vector2.ZERO
		else:
			
			var distance_to_target = global_position.distance_to(target.global_position)
			if distance_to_target <= 100:
				rotation = lerp_angle(-rotation, position.angle_to_point(target.global_position), 0.1)
				velocity = Vector2.ZERO
				enemyAnim.stop()
			if not hasReachedDistanceLimit:
				velocity = Vector2(0,-1) * speed * delta
				if self.position.y <= target.position.y + distanceLimit:
					hasReachedDistanceLimit = true
			else:
				hasReachedDistanceLimit = true
				velocity = position.direction_to(target.position) * speed * delta
				rotation = lerp_angle(-rotation, position.angle_to_point(target.global_position), 0.1)
		if isKnocked:
			print("Enemy being displaced")
			velocity = knockback_displacement * (speed * 2) * delta
			print("Enemy displaced")
			isKnocked = false
		move_and_slide()

func stun(get_stun_duration):
	
	if isStunned == false:
		stun_duration = get_stun_duration
		isStunned = true
		enemyAnim.pause()
		hit_box.disabled = true
		await get_tree().create_timer(0.2).timeout
		
		stun_anim.global_position = global_position + Vector2(0, -20)
		stun_anim.scale = enemyAnim.scale
		if is_in_group("hand"):
			stun_anim.scale *= 5
			
		stun_anim.show()
		stun_anim.playSnd()
		
		await get_tree().create_timer(stun_duration).timeout
		
		stun_anim.hide()
		enemyAnim.play()
		hit_box.disabled = false
		isStunned = false
	else:
		print("Already stunned")
		

func displace(displacement):
	isKnocked = true
	knockback_displacement = displacement
	print("Enemy Displaced True")
	
func _on_touch_screen_button_pressed():
	hurt_sfx.play()
	take_damage()
	if playerStats.hasStun:
		stun(playerStats.stun_duration)

func _on_hurt_box_hurt(dmg):
	print("Toothpick Damage: ", dmg)
	if health >= 0:
		health -= dmg
		hit_flash_anim_player.play("hit_flash")
		hurt_sfx.play()
	if health <= 0:
		emit_signal("remove_from_array", self)
		die()
	
func take_surrounding_damage(dmg):	
	print("Ant Surrounding Damage: ",dmg)
	if health >= 0:
		health -= dmg
		hit_flash_anim_player.play("hit_flash")
		hurt_sfx.play()
	if health <= 0:
		die()
	
func take_damage():
	player_damage = playerStats.attack_damage
	critical_chance = playerStats.critical_chance
	critical_damage_percentage = playerStats.critical_damage_percentage
	var applied_damage = player_damage
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var crit_chance = rng.randf()
	if(crit_chance <= critical_chance):
		$crit_snd.play()
		play_crit_fx()
		print("Crit damage: ", (critical_damage_percentage * player_damage))
		applied_damage += (critical_damage_percentage * player_damage)
	
	print("Ant Damaged: ",applied_damage)
	if health >= 0:
		health -= applied_damage
		#print(health)
	if health <= 0:
		die()
	hit_flash_anim_player.play("hit_flash")

# plays the crit animation for 0.3s then disappears
func play_crit_fx():
	print("CRIT FX")
	var crit_anim = crit_fx.instantiate()
	crit_anim.global_position = global_position
	crit_anim.scale = enemyAnim.scale
	if is_in_group("hand"):
		crit_anim.scale *= 5
		
	add_child(crit_anim)
	await get_tree().create_timer(0.3).timeout
	crit_anim.queue_free()
	
func die():
	isDead = true
	emit_signal("enemy_dead", xp, kill_counter)
	var enemy_death
	if is_in_group("hand"):
		enemy_death = hand_death_anim.instantiate()
	else:
		enemy_death = death_anim.instantiate()
	enemy_death.scale = enemyAnim.scale
	enemy_death.global_position = global_position
	get_parent().call_deferred("add_child", enemy_death)
	queue_free()
	
func getDamage():
	return damage
	
func getSpawnCost():
	return spawn_cost
	
func upgrade_attack():
	pass


	
