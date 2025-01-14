extends Node2D
@onready var btn_snd = $ButtonClick
@onready var highscore_screen = $Screens/HighScores

func _process(delta):
	%NameLabel.text = Global.player_name

func _on_play_pressed():
	btn_snd.play()
	await get_tree().create_timer(0.1).timeout
	LoadManager.load_scene("res://Scenes/MainGame.tscn")
	
func _on_highscores_pressed():
	highscore_screen.visible = true
	btn_snd.play()

func _on_credits_pressed():
	btn_snd.play()
	$Screens/Credits.visible = true

func _on_bgm_finished():
	$BGM.play()

func _on_touch_screen_button_pressed():
	$ButtonClick.play()
	$Screens/SetName.visible = true
