extends Node2D

class_name ShockWave

@onready var stats = get_tree().get_first_node_in_group("main")
@onready var timer = $Timer
@onready var sprite
@onready var detector
var duration = 0.75
var direction = Vector2.ZERO

signal knockEnemy(displacement: Vector2)

func _ready():
	timer.connect("timeout", self.queue_free)
	timer.start(duration)
	$snd.play()
	
func _on_enemy_detector_body_entered(body):
	if body.is_in_group("enemy_group"):
		var enemy = body
		var player_damage = stats.attack_damage
		var shockwave_damage = player_damage * stats.shockwave_damage_percent
		enemy.take_surrounding_damage(shockwave_damage)
		enemy.displace(Vector2(0, stats.shockwave_displacement))
		if stats.isStunAOE:
			enemy.stun(stats.stun_duration)

	
func setSize(size):
	sprite = $Sprite
	var new_size = size
	detector = $EnemyDetector/CollisionShape2D
	detector.shape.radius = new_size
	var sprite_width = sprite.sprite_frames.get_frame_texture("shockwave", 0).get_width()
	var sprite_height = sprite.sprite_frames.get_frame_texture("shockwave", 0).get_height()
	sprite.scale = Vector2((new_size*2) / sprite_width, (new_size*2) / sprite_height)
