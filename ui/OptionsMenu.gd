extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var sfx_vol_slider:Slider = $Panel/Holder/Volume/Sfx/SFXVolume
onready var master_vol_slider:Slider = $Panel/Holder/Volume/Master/MasterVolume
onready var use_fxxa_check:CheckBox = $Panel/Holder/Graphics/AACheck

	
func _ready():
	Globals.connect("show_options",self,"show_options")
	sfx_vol_slider.value = Settings.get_sfx_vol()
	master_vol_slider.value = Settings.get_master_vol()
	use_fxxa_check.pressed = Settings.use_fxxa
	
func show_options():
	show()

func _on_SFXVolume_value_changed(value:float):
	Settings.set_sfx_volume(value)


func _on_MasterVolume_value_changed(value:float):
	Settings.set_master_volume(value)


func _on_AACheck_toggled(button_pressed:bool):
	Settings.set_anti_aliasing(button_pressed)


func _on_Back_pressed():
	hide()
