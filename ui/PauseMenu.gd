extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("pause"):
		visible = !visible
		get_tree().paused = visible
		if visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_Resume_pressed():
	get_tree().paused = false
	hide()


func _on_Restart_pressed():
	get_tree().reload_current_scene()


func _on_Options_pressed():
	Globals.emit_signal("show_options")


func _on_MainMenu_pressed():
	get_tree().change_scene("res://ui/Menu.tscn")
