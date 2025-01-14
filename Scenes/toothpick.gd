extends Area2D

var level
var hp = 1
var speed = 100
var damage = 1
var knock_amount = 0
var attack_size = 1.0

var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("sugar_group")
@onready var playerStats = get_tree().get_first_node_in_group("main")
@onready var vis = $VisibleOnScreenNotifier2D

signal remove_from_array(object)

func _ready():
	$shoot_snd.play()
	level = playerStats.toothpick_level
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(135)
	match level:
		1:
			hp = 1
			speed = 100
			knock_amount = 0
			attack_size = 1.125
		2:
			hp = 1
			speed = 125
			knock_amount = 10
			attack_size = 1.25
		3:
			hp = 2
			speed = 150
			knock_amount = 25
			attack_size = 1.375
		4:
			hp = 2
			speed = 175
			knock_amount = 50
			attack_size = 1.50
		5:
			hp = 3
			speed = 200
			knock_amount = 100
			attack_size = 1.625
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1,1)*attack_size, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()

func _process(delta):
	if vis.is_on_screen() == false:
		emit_signal("remove_from_array", self)
		queue_free()

func _physics_process(delta):
	position += angle * speed * delta
	
func enemy_hit(charge = 1):
	
	hp -= charge
	if hp <= 0:
		$break_sfx.play()
		emit_signal("remove_from_array", self)
		queue_free()
	else:
		$hit_snd.play()

func _on_timer_timeout():
	emit_signal("remove_from_array", self)
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("enemy_group"):
		var enemy = body
		displaceEnemy(enemy)
		if playerStats.hasToothpickStun:
			print("Toothpick Stunned Enemy")
			enemy.stun(playerStats.stun_duration)

func displaceEnemy(enemy):
	enemy.displace(Vector2(0, knock_amount))
