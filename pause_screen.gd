extends Control

var score = Global.score

func _ready():
	pass # Replace with function body.

func _process(delta):
	score = Global.score
	$Panel/Score/ScoreValue.text = str(score)

func _on_retry_button_pressed():
	$ButtonClick.play()
	SaveLoad.save_score()
	SaveLoad.load_score()
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = false
	self.visible = false
	get_tree().reload_current_scene()

func _on_quit_button_pressed():
	$ButtonClick.play()
	SaveLoad.save_score()
	#SaveLoad.load_score()
	await get_tree().create_timer(0.1).timeout
	self.visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _on_unpause_button_pressed():
	$ButtonClick.play()
	self.visible = false
	get_tree().paused = false
	

