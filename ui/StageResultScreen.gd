extends Control

onready var result_message_lbl:Label = $MarginContainer/Panel/ResultMessage
const stage_failed_message = "Stage Failed"
const stage_complete_message = "Stage Completed!"
func _ready():
	hide()
	Globals.connect("stage_completed",self , "_on_stage_complete")
	Globals.connect("stage_failed",self , "_on_stage_failed")


func _on_stage_complete():
	result_message_lbl.text = stage_complete_message
	$MarginContainer/Panel/ButtonContainer/RetryBtn.grab_focus()
	$MarginContainer/Panel/ScoreVBox/Score/ScoreLbl2.text = str(Globals.calculate_final_score())
	show()

func _on_stage_failed():
	result_message_lbl.text = stage_failed_message
	show()

func _on_RetryBtn_pressed():
	get_tree().reload_current_scene()


func _on_MainMenu_pressed():
	get_tree().change_scene("res://ui/Menu.tscn")


func _on_NextStageBtn_pressed():
	pass
