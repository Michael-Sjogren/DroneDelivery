extends Control


func _ready():
	$Panel/VBoxContainer/StartBtn.grab_focus()



func _on_StartBtn_pressed():
	Globals.next_level = 0
	Globals.current_level = 0
	Globals._load_next_level()


func _on_OptionsBtn_pressed():
	Globals.emit_signal("show_options")


func _on_QuitBtn_pressed():
	get_tree().quit(0)
