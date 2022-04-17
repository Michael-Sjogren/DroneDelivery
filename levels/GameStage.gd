extends Spatial

var stage_complete = false
var stage_failed = false
var stage_started = false

var packages_delivered:int = 0
var package_count = 0
var start_package_count = 0
var time_start:int = -1
var delivery_accuracy:float = 0.0

func _ready():
	Globals.connect("package_delivered",self,"_on_package_delivered")
	Globals.connect("package_destroyed",self,"_on_package_destroyed")
	Globals.connect("start_stage",self,"_on_start_stage")
	Globals.emit_signal("start_stage")
	
func _on_start_stage():
	reset()
	time_start = OS.get_unix_time()
	stage_started = true
	start_package_count = get_tree().get_nodes_in_group("Package").size()
	package_count = start_package_count


func reset():
	stage_started = false
	stage_complete = false
	stage_failed = false
	package_count = 0
	packages_delivered = 0

func _on_package_destroyed(max_health):
	package_count -= 1
	if package_count <= 0:
		Globals.emit_signal("end_stage")
		Globals.emit_signal("stage_failed")
func _on_package_delivered(health:int, distance_from_center:float , radius:float):
	delivery_accuracy += (1-distance_from_center/radius)
	packages_delivered += 1
	if packages_delivered >= package_count:
		delivery_accuracy /= start_package_count
		var time = Globals.get_game_time(time_start)
		Globals.emit_signal("end_stage")
		Globals.emit_signal("stage_completed" , calculate_final_score() , time )
		
func calculate_final_score() -> int:
	var min_score = 0
	var max_score = 5
	if packages_delivered == start_package_count:
		min_score = 3
	return  int( clamp( (delivery_accuracy * 2) + min_score , min_score , max_score ))
