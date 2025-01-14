extends Control

func _on_close_button_pressed():
	$ButtonClick.play()
	self.visible = false
