extends KinematicBody

const MAX_SPEED = 10.0
const MAX_ANGULAR_SPEED = 0.05
const MAX_HEALTH:int = 4
export(float, 0 , 10) var angular_damping = .5
export(float, 0, 1) var linear_damping = .5
export(float, 0 , 1) var angular_rotation_speed = .5
export(float, 0 , 30) var acceleration_speed = 15
export(float , 0 , 10) var gravity_multipler = 1.0
export(float , 0 , 10) var collision_bounceback = 1.0
export (float , 0 , 1) var invincibilliy_time = .5
onready var tween := $Tween

var _health:int = MAX_HEALTH
var _input:Vector3
var _angular_velocity := Vector3.ZERO
var _velocity := Vector3.ZERO
var carried_package:RigidBody = null
var _can_take_damage = true
var _time_invincible := 0.0
var _is_alive = true
# Called when the node enters the scene tree for the first time.
func _ready():
	$CameraFollow.set_as_toplevel(true)
	

func _physics_process(delta):
	if not _is_alive:
		return
	if not _can_take_damage:
		_time_invincible = clamp(_time_invincible + delta ,  0 , invincibilliy_time)
		if _time_invincible >= invincibilliy_time:
			_can_take_damage = true

	_position_camera()
	rotate_drone(delta)
	_velocity += Vector3.DOWN * (9.8  * gravity_multipler) * delta
	var y = _velocity.y
	_velocity += global_transform.basis.z * _input.z * acceleration_speed
	_velocity.y = y
	if _input.y > 0.0:
		_velocity += Vector3.UP * acceleration_speed * 2
	elif _input.y == 0.0:
		_velocity += Vector3.UP * 9.8 * gravity_multipler * delta
	
	if _velocity.length() > MAX_SPEED:
		_velocity = _velocity.normalized() * MAX_SPEED
	if _input.length_squared() == 0.0:
		_velocity = _velocity.linear_interpolate(Vector3(rand_range(-1 , 1) , _velocity.y , rand_range(-1, 1)) * .5 , linear_damping)
	
	_velocity = move_and_slide(_velocity , Vector3.UP)
	if get_slide_count():
		_velocity = (get_slide_collision(0).normal) * collision_bounceback
		take_damage(1)
	if Input.is_action_just_pressed("drop_cargo") and is_instance_valid(carried_package):
		detach_package()
		
func rotate_drone(delta):
	_angular_velocity.y += _input.x * angular_rotation_speed * delta
	if _angular_velocity.length() > MAX_ANGULAR_SPEED:
		_angular_velocity = _angular_velocity.normalized() * MAX_ANGULAR_SPEED
	
	rotate_y(_angular_velocity.y)

	if _input.x == 0.0:
		_angular_velocity.y = move_toward(_angular_velocity.y , 0.0 , abs(_angular_velocity.y) * angular_damping * delta)
	rotation.x = lerp_angle(rotation.x , deg2rad(45 * _input.z) , 0.05)
	rotation.z = lerp_angle(rotation.z , deg2rad(45 * _input.x) , 0.05)
	orthonormalize()
	
func take_damage(dmg:int):
	print(_time_invincible)
	if not _can_take_damage:
		print("cannot take dmg")
		return
	_health = clamp(_health - dmg , 0 , MAX_HEALTH)
	$DamageEffects.get_child(_health).emitting = true
	_time_invincible = 0.0
	_can_take_damage = false
	
	if _health <= 0:
		_die()

	
func _input(event):
	if event is InputEventJoypadMotion or event is InputEventKey:
		_input = Vector3(
			Input.get_axis("right","left"),
			Input.get_axis("down","up"),
			Input.get_axis("foward","back")
		)

func _position_camera() -> void:
	var pos = global_transform.origin + Vector3.UP * .25 + global_transform.basis.z.slide(Vector3.UP) * .5
	$CameraFollow.look_at_from_position(pos, global_transform.origin + (-global_transform.basis.z.slide(Vector3.UP)).normalized(), Vector3.UP)
	
func _die():
	_is_alive = false
	axis_lock_motion_x = true
	axis_lock_motion_y = true
	axis_lock_motion_z = true
	$DamageEffects.visible = false
	$Model.visible = false
	$CollisionShape.disabled = true
	if carried_package:
		carried_package.destroy()
	if not Globals.stage_failed:
		Globals.emit_signal("stage_failed")

func detach_package():
	$PinJoint.set("nodes/node_b","")
	carried_package.set_is_connected_to_drone(false)
	yield(get_tree().create_timer(.3) , "timeout")
	carried_package = null

func _on_Area_body_entered(body:Spatial):
	if body.is_in_group("Package") and not is_instance_valid(carried_package):
		var b = body as RigidBody
		body.set_is_connected_to_drone(true)
		b.mode = RigidBody.MODE_STATIC
		b.global_transform = $PinJoint/Position3D.global_transform
		($PinJoint as Joint).set("nodes/node_b",body.get_path())
		b.mode = RigidBody.MODE_RIGID
		carried_package = b
