extends Node2D

signal loading_screen_has_full_coverage

@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@onready var progressBar : TextureProgressBar = $Panel/TextureProgressBar

func _update_progress_bar(new_value: float):
	progressBar.set_value_no_signal(new_value * 100)
	$Panel/ProgressLabel.text = str(int(new_value * 100)) + "%"
	
func _start_outro_animation():
	print("Starting outro")
	animationPlayer.play("end_load")
	await Signal(animationPlayer, "animation_finished")
	print("Loading screen should be dead now")
	self.queue_free()
	

