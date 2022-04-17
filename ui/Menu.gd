extends Control


func _ready():
	$Panel/VBoxContainer/StartBtn.grab_focus()



func _on_StartBtn_pressed():
	get_tree().change_scene("res://levels/GameStage.tscn")


func _on_OptionsBtn_pressed():
	pass # Replace with function body.


func _on_QuitBtn_pressed():
	get_tree().quit(0)
