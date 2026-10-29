extends Node

var staminaglobal: float = 10
var SledgeDamage := 1
var health: float = 1
var hit = false
var attacked = false
var enemy_facing = 0
var player_facing
var lilenemy_damage
var chomper_damage
var player_position = Vector2()
var level_level = 1
var fade_in = false
var player_respawn = false
var fade_out
var spawn_point = Vector2.ZERO
var saved_reset
var final_cutscene = false
var loading_fade = true
var fullscreen = true
var mastervolume = 0
var playervolume = 0
var enemiesvolume = 0
var environmentvolume = 0
var ambiencevolume = 0
var player_speed = 1
var player_scale = Vector2(1, 1)
var masterv = AudioServer.get_bus_index("Master")
var playerv = AudioServer.get_bus_index("sound effects")
var enemiesv = AudioServer.get_bus_index("Enemies")
var environmentv = AudioServer.get_bus_index("environment")
var ambiencev = AudioServer.get_bus_index("ambience")
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("full_screen"):
		if fullscreen == true:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			fullscreen = false
		if fullscreen == false:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			fullscreen = true
	remap(mastervolume, -50, 50, 3, -72)
	AudioServer.set_bus_volume_db(masterv, mastervolume)
	remap(playervolume, -50, 50, 3, -72)
	AudioServer.set_bus_volume_db(playerv, playervolume)
	remap(enemiesvolume, -50, 50, 3, -72)
	AudioServer.set_bus_volume_db(enemiesv, enemiesvolume)
	remap(environmentvolume, -50, 50, 3, -72)
	AudioServer.set_bus_volume_db(environmentv, environmentvolume)
	remap(ambiencevolume, -50, 50, 3, -72)
	AudioServer.set_bus_volume_db(ambiencev, ambiencevolume)
