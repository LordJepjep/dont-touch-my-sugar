extends Control

@onready var score_box = preload("res://Scenes/score_box.tscn")
@onready var score_container = $Panel/ScoresScrollContainer/ScoresContainer

var scores = []
# Called when the node enters the scene tree for the first time.
func _ready():
	scores = SaveLoad.return_scores()
	if scores != null:
		scores.sort_custom(func(a, b): return b["score"] - a["score"])
		add_scores()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func setup_score_box(playerName, score, kill_count, time, level, order):
	var score_box_instance = score_box.instantiate()
	var score_box_player_name = score_box_instance.get_node("%NameLabel")
	var score_box_order = score_box_instance.get_node("%OrderLabel")
	var score_box_level = score_box_instance.get_node("%LevelValue")
	var score_box_time = score_box_instance.get_node("%TimeValue")
	var score_box_killcount = score_box_instance.get_node("%KillCountValue")
	var score_box_score = score_box_instance.get_node("%ScoreValue")
	
	score_box_player_name.text = playerName
	score_box_order.text = str(order)
	score_box_level.text = str(level)
	
	score_box_killcount.text = str(kill_count)
	score_box_score.text = str(score)
	
	# format the time
	var minutes = int(time/60.0)
	var seconds = int(time) % 60
	if minutes < 10:
		minutes = str(0, minutes)
	if seconds < 10:
		seconds = str(0, seconds)
	score_box_time.text  = str(minutes,":",seconds)
	
	score_container.add_child(score_box_instance)
	
func add_scores():
	var order = 0
	for i in scores: 
		order += 1
		var player_scores = i
		var player_name = player_scores["player_name"]
		var score = player_scores["score"]
		var kill_count = player_scores["total_kill_count"]
		var time = player_scores["total_time"]
		var level = player_scores["level"]
		
		print("Player:", player_scores["player_name"])
		print("Survival Time:", player_scores["total_time"])
		print("Total Kill Count:", player_scores["total_kill_count"])
		print("Score:", player_scores["score"])
		
		setup_score_box(player_name, score, kill_count, time, level, order)
	
func _on_close_button_pressed():
	$ButtonClick.play()
	self.visible = false
