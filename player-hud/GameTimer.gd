extends Control


var time_now :int = 0.0
var seconds:int = 0
var minutes:int = 0
var time_start :int = 0

func _ready():
	Globals.connect("start_stage" , self , "_on_stage_start")
	
func _on_stage_start():
	time_start = OS.get_unix_time()

func _process(delta):
	if Globals.stage_started and not Globals.stage_failed and not Globals.stage_complete:
		time_now = OS.get_unix_time()
		var elapsed = time_now - time_start
		minutes = elapsed / 60
		var new_seconds = elapsed % 60
		if new_seconds != seconds:
			seconds = new_seconds
			var str_elapsed = "%02d : %02d" % [minutes, seconds]
			$Label.text = str_elapsed
	
