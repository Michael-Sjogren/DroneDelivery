extends RigidBody
export var max_health:int = 10
var health:int
var is_connected_to_drone := false
var is_invulnerable = true
onready var package_radius:float = $Radius.shape.radius
# Called when the node enters the scene tree for the first time.
func _ready():
	
	health = max_health

func destroy():
	Globals.emit_signal("package_destroyed", max_health)
	$BreakSFX.play()
	$PackageModel.visible = false
	mode = RigidBody.MODE_STATIC
	$CollisionShape.disabled = true
	yield($BreakSFX , "finished")
	queue_free()

func _physics_process(delta):
	if health <= 0:
		destroy()


func set_is_connected_to_drone(_is_connected:bool):
	if _is_connected:
		$PickupSFX.play()
	contact_monitor = true
	is_invulnerable = true
	$InvunrabillityTimer.start()
	#contact_monitor = !_is_connected
	is_connected_to_drone = _is_connected

func _on_Package_body_entered(body):
	if not is_invulnerable:
		if not body.is_in_group("DropZone"):
			health = clamp(health - 1 , 0 , max_health)
			is_invulnerable = true
			$InvunrabillityTimer.start()
			print_debug("package hp: " , health)

func _on_InvunrabillityTimer_timeout():
	is_invulnerable = false
