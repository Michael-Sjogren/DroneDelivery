extends Spatial
export var min_time_seconds_for_max_score:float = 25.0
var stage_complete = false
var stage_failed = false
var stage_started = false
var final_time = ""
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
	time_start = 0.0
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
	Globals.emit_signal("end_stage")
	Globals.emit_signal("stage_failed")

func _on_package_delivered(health:int, distance_from_center:float , radius:float):
	delivery_accuracy += (1-distance_from_center/radius)
	packages_delivered += 1
	if packages_delivered >= package_count:
		delivery_accuracy /= start_package_count
		final_time = get_tree().get_nodes_in_group("GameTimer")[0].get_time()
		Globals.emit_signal("end_stage")
		Globals.emit_signal("stage_completed" , calculate_final_score() , final_time )

func calculate_final_score() -> float:
	var min_score = 0
	var max_score = 5
	min_score = 2
	if min_time_seconds_for_max_score > final_time:
		min_score += 2
	
	print_debug(delivery_accuracy)
	if delivery_accuracy > .9:
		min_score += 1
	return clamp( delivery_accuracy + min_score , 0 , max_score )


func _on_KillZone_body_entered(body):
	if body.is_in_group("Package"):
		body.destroy()
