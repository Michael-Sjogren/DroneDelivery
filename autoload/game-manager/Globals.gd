extends Node
signal show_options()
signal start_stage()
signal end_stage()

signal package_delivered(health,distance)
signal package_destroyed(max_health)
signal update_money(amount)
signal stage_completed(final_score, time)
signal stage_failed()
signal load_next_level()

var next_level:int = 0
var current_level:int = 0
var level_count:int = 0
const levels:Array = [
	preload("res://levels/TutorialLevel.tscn"),
	preload("res://levels/Level2.tscn"),
	preload("res://levels/Level3.tscn"),
	
]
func _ready():
	level_count = levels.size()
	connect("load_next_level", self , "_load_next_level" )
	
func _load_next_level():
	if not is_last_level():
		current_level = next_level
		get_tree().change_scene_to(levels[next_level])
		next_level += 1

func is_last_level() -> bool:
	return not (next_level < level_count)

func format_game_time(time:float ) -> String:
	var sec = fmod(time, 60)
	var minutes = fmod(time, 60*60) / 60
	var milli = fmod(time , 1) * 1000
	return "%02d : %02d : %03d" % [minutes, sec , milli]
