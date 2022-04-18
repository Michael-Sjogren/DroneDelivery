extends Control

onready var result_message_lbl:Label = $MarginContainer/Panel/ResultMessage
var stage_failed_message := "Stage Failed"
var stage_complete_message := "Stage Completed!"
func _ready():
	hide()
	Globals.connect("stage_completed",self , "_on_stage_complete")
	Globals.connect("stage_failed",self , "_on_stage_failed")
	if Globals.is_last_level():
		$MarginContainer/Panel/ButtonContainer/NextStageBtn.disabled = true
		stage_complete_message = "Last Stage Completed! Thanks for playing my game!"

func _on_stage_complete(final_score:int, time:float):
	result_message_lbl.text = stage_complete_message
	$MarginContainer/Panel/ButtonContainer/RetryBtn.grab_focus()
	$MarginContainer/Panel/ScoreVBox/Score/ScoreLbl2.text = str(final_score) + " / 5"
	$MarginContainer/Panel/ScoreVBox/Time/ScoreLbl2.text = Globals.format_game_time(time)
	$AnimationPlayer.play("ShowResultScreen")

func _on_stage_failed():
	$MarginContainer/Panel/ButtonContainer/NextStageBtn.disabled = true
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
	Globals.emit_signal("load_next_level")
