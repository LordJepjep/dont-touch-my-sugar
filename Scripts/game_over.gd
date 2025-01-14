extends Control

func _process(delta):
	$Panel/Score/ScoreValue.text = str(Global.score)

func _on_retry_button_pressed():
	$ButtonClick.play()
	SaveLoad.save_score()
	SaveLoad.load_score()
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_button_pressed():
	$ButtonClick.play()
	SaveLoad.save_score()
	SaveLoad.load_score()
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
