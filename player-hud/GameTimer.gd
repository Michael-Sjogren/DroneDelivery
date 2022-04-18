extends Control



var time_start :float = 0
var time_passed :float = 0.0
var running = false

func _ready():
	add_to_group("GameTimer")
	Globals.connect("start_stage" , self , "_on_stage_start")
	Globals.connect("end_stage" , self , "_on_stage_end")

func _on_stage_end():
	running = false

func _on_stage_start():
	time_start = 0
	running = true
	print("start")

func get_time() -> float:
	return time_passed

func _process(delta):
	if running:
		time_passed += delta
		$Label.text = Globals.format_game_time(time_passed)


