extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("package_delivered", self , "_on_package_delivered" )

func _on_package_delivered(health:int, distance:float , radius:float):
	var ratio:float =  abs((distance / radius))
	print("distance", distance , "ratio", ratio)
	var feedback_message = "Ok,"
	if ratio <= 0.2:
		feedback_message = "Perfect!"
	elif ratio > 0.21 and ratio <= .4:
		feedback_message = "Great!"
	elif ratio > 0.41 and ratio <= .6:
		feedback_message = "Good."
	elif ratio > 0.61 and ratio <= .8:
		feedback_message = "Ok."
	elif ratio > 0.81 and ratio <= 1:
		feedback_message = "Eh..."
	distance = clamp(distance , 0 , radius)
	$Panel/VBoxContainer/Label.text = feedback_message
	$Panel/VBoxContainer/Distance.text = "%.1f m from center!" % distance
	$AnimationPlayer.play("ShowMessage")
