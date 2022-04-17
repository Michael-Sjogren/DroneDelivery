extends Node

signal start_stage()
signal end_stage()

signal package_delivered(health,distance)
signal package_destroyed(max_health)
signal update_money(amount)
signal stage_completed(final_score, time_string)
signal stage_failed()

func get_game_time(start:int ) -> String:
	var time_now = OS.get_unix_time()
	var elapsed = time_now - start
	var minutes = elapsed / 60
	var new_seconds = elapsed % 60
	return "%02d : %02d" % [minutes, new_seconds]
