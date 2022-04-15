extends Node

signal start_stage()
signal end_stage()
signal package_delivered(health,distance)
signal package_destroyed(max_health)
signal update_money(amount)
signal stage_completed()
signal stage_failed()

var stage_complete = false
var stage_failed = false
var stage_started = false

var packages_delivered:int = 0
var package_count = 0
var start_package_count = 0
var time_start:int = -1
var time_end:int = -1
var delivery_accuracy:float = 0.0

func _ready():
	self.connect("package_delivered",self,"_on_package_delivered")
	self.connect("package_destroyed",self,"_on_package_destroyed")
	self.connect("start_stage",self,"_on_start_stage")
	self.connect("stage_completed",self,"_on_stage_completed")
	self.connect("stage_failed",self,"_on_stage_failed")

func _on_start_stage():
	reset()
	stage_started = true
	start_package_count = get_tree().get_nodes_in_group("Package").size()
	package_count = start_package_count
func _on_stage_completed():
	print("stage complete")
	if not stage_failed:
		stage_complete = true

func _on_stage_failed():
	if not stage_complete:
		stage_failed = true
		print("stage failed")

func reset():
	stage_started = false
	stage_complete = false
	stage_failed = false
	package_count = 0
	packages_delivered = 0

func _on_package_destroyed(max_health):
	package_count -= 1
	if package_count <= 0:
		emit_signal("stage_failed")

func _on_package_delivered(health:int, distance_from_center:float , radius:float):
	delivery_accuracy += (1-distance_from_center/radius)
	packages_delivered += 1
	if packages_delivered >= package_count:
		delivery_accuracy /= start_package_count
		emit_signal("stage_completed")
		print_debug("final score :", str(calculate_final_score()) + "/ 5")

func calculate_final_score() -> int:
	var min_score = 0
	var max_score = 5
	if packages_delivered == start_package_count:
		min_score = 3
	return  int( clamp( (delivery_accuracy * 2) + min_score , min_score , max_score ))
