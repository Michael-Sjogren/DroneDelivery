extends RigidBody
export var max_health:int = 10
var health:int
var is_connected_to_drone := false
var is_invulnerable = true
var is_destroyed = false
onready var package_radius:float = $Radius.shape.radius
# Called when the node enters the scene tree for the first time.
func _ready():
	
	health = max_health

func destroy():
	is_destroyed = true
	Globals.emit_signal("package_destroyed", max_health)
	$BreakSFX.pitch_scale = .6
	$BreakSFX.play()
	$PackageModel.visible = false
	mode = RigidBody.MODE_STATIC
	$Explostion.emitting = true
	yield($BreakSFX , "finished")
	queue_free()

func _physics_process(delta):
	if (health <= 0 or global_transform.origin.y < -100) and not is_destroyed:
		destroy()


func set_is_connected_to_drone(_is_connected:bool):
	if is_connected_to_drone:
		is_invulnerable = true
		$InvunrabillityTimer.start()
	else:
		$PickupSFX.pitch_scale = .5
		$PickupSFX.play()
	contact_monitor = true

	#contact_monitor = !_is_connected
	is_connected_to_drone = _is_connected

func _on_Package_body_entered(body):
	if not is_invulnerable:
		if not body.is_in_group("DropZone"):
			health = clamp(health - 1 , 0 , max_health)
			if health > 0:
				is_invulnerable = true
				$InvunrabillityTimer.start()
				$BreakSFX.pitch_scale = 2
				$BreakSFX.play()
func _on_InvunrabillityTimer_timeout():
	is_invulnerable = false
