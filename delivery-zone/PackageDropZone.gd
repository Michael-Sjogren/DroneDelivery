extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var package:RigidBody = null
onready var radius:float = $Area/CollisionShape.shape.radius
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if package:
		if package.linear_velocity.length_squared() < .01 and not package.is_connected_to_drone:
			var distance :float = package.global_transform.origin.distance_to(global_transform.origin)
			
			Globals.emit_signal("package_delivered",package.health , distance , radius)
			package.queue_free()


func _on_Area_body_entered(body):
	if body.is_in_group("Package"):
		package = body


func _on_Area_body_exited(body):
	if body.is_in_group("Package"):
		package = null
