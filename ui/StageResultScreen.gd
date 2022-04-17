extends Control

onready var result_message_lbl:Label = $MarginContainer/Panel/ResultMessage
const stage_failed_message = "Stage Failed"
const stage_complete_message = "Stage Completed!"
func _ready():
	hide()
	Globals.connect("stage_completed",self , "_on_stage_complete")
	Globals.connect("stage_failed",self , "_on_stage_failed")


func _on_stage_complete(final_score:int, time:String):
	result_message_lbl.text = stage_complete_message
	$MarginContainer/Panel/ButtonContainer/RetryBtn.grab_focus()
	$MarginContainer/Panel/ScoreVBox/Score/ScoreLbl2.text = str(final_score)
	$MarginContainer/Panel/ScoreVBox/Time/ScoreLbl2.text = time
	$AnimationPlayer.play("ShowResultScreen")

func _on_stage_failed():
	$MarginContainer/Panel/ButtonContainer/RetryBtn.grab_focus()	
	result_message_lbl.text = stage_failed_message
	$MarginContainer/Panel/ScoreVBox/Score/ScoreLbl2.text = str(0)
	$MarginContainer/Panel/ScoreVBox/Time/ScoreLbl2.text = "DNF"
	$AnimationPlayer.play("ShowResultScreen")
	yield($AnimationPlayer ,"animation_finished")

func _on_RetryBtn_pressed():
	$AnimationPlayer.play_backwards("ShowResultScreen")
	yield($AnimationPlayer ,"animation_finished")
	get_tree().reload_current_scene()


func _on_MainMenu_pressed():
	$AnimationPlayer.play_backwards("ShowResultScreen")
	yield($AnimationPlayer ,"animation_finished")
	get_tree().change_scene("res://ui/Menu.tscn")


func _on_NextStageBtn_pressed():
	pass
