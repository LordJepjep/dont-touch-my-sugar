extends Control

@onready var text_input = $Panel/NameInput
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _on_save_button_pressed():
	$ButtonClick.play()
	var new_name = text_input.text
	Global.player_name = new_name
	self.visible = false
	text_input.text = ""
	
func _on_close_button_pressed():
	$ButtonClick.play()
	self.visible = false
