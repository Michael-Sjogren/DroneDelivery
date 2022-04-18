extends Node

var music_volume:float = 0
var sfx_volume:float = 0
var master_volume:float = 0
var use_fxxa = true

func _ready():
	pass

func set_anti_aliasing(on):
	ProjectSettings.set("rendering/quality/filters/use_fxaa",on)
	use_fxxa = on

func set_sfx_volume(val:float):
	var new_val = linear2db(clamp(val , 0 , 1 ))
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sfx"), new_val)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("engine_sfx"), new_val)
	sfx_volume = new_val

func set_master_volume(val:float):
	var new_val = linear2db(clamp(val , 0 , 1 ))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), new_val)
	master_volume = new_val
	
func set_music_volume(val:float):
	var new_val = linear2db(clamp(val , 0 , 1 ))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), new_val)

func get_sfx_vol() -> float:
	return db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("sfx")))

func get_master_vol() -> float:
	return db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
