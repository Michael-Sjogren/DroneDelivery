extends Control



var time_start :int = 0
var running = false

func _ready():
	Globals.connect("start_stage" , self , "_on_stage_start")
	Globals.connect("end_stage" , self , "_on_stage_end")

func _on_stage_end():
	running = false

func _on_stage_start():
	time_start = OS.get_unix_time()
	running = true
	print("start")

func _physics_process(delta):
	if running:
		$Label.text = Globals.get_game_time(time_start)


