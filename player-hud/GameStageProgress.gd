extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("package_delivered", self , "_on_package_delivered" )

func _on_package_delivered(health:int, distance:float , radius:float):
	$Panel/VBoxContainer/Distance.text = "%d.1m" % distance
	$AnimationPlayer.play("ShowMessage")
