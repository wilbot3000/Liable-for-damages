extends CanvasLayer
var test = Global.staminaglobal

@onready var stamina_bar: TextureProgressBar = $"stamina bar"

@onready var loading_fade: Sprite2D = $loading_fade
@onready var hurt_sprite: Sprite2D = $hurt_sprite
@onready var death_timer: Timer = $death_timer
@onready var blackout: Sprite2D = $blackout
@onready var reset_timer: Timer = $reset_timer
@onready var buttons: Control = $blackout/Buttons
@onready var button_timer: Timer = $button_timer
@onready var saved_: Label = $"saved!"
@onready var saved_timer: Timer = $saved_timer
@onready var menu_screen: Sprite2D = $menu_screen
@onready var button_pressed: AudioStreamPlayer2D = $button_pressed
@onready var volume: TextureButton = $menu_screen/volume
@onready var volume_screen: Sprite2D = $menu_screen/volume_screen
@onready var masterslider: HSlider = $menu_screen/volume_screen/ScrollContainer/VBoxContainer/masterslider
@onready var playerslider: HSlider = $menu_screen/volume_screen/ScrollContainer/VBoxContainer/playerslider
@onready var enemiesslider: HSlider = $menu_screen/volume_screen/ScrollContainer/VBoxContainer/enemiesslider
@onready var environmentslider: HSlider = $menu_screen/volume_screen/ScrollContainer/VBoxContainer/environmentslider
@onready var ambienceslider: HSlider = $menu_screen/volume_screen/ScrollContainer/VBoxContainer/ambienceslider
var masterv = AudioServer.get_bus_index("Master")

var fade_to_black = 0
var fade_level = 1
var fade_out = true
var blackout_now = false
var can_black = true
var stop_fade
var can_start_save = true
#@onready var stamina_level: Label = $Stamina_level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	masterslider.value = Global.mastervolume
	playerslider.value = Global.playervolume
	enemiesslider.value = Global.enemiesvolume
	environmentslider.value = Global.environmentvolume
	ambienceslider.value = Global.ambiencevolume
	saved_.visible = false
	buttons.visible = false
	stamina_bar.value = stamina_bar.max_value
	hurt_sprite.visible = false
	blackout.visible = false
	fade_out = Global.loading_fade
	volume_screen.hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	Global.mastervolume = masterslider.value
	Global.playervolume = playerslider.value
	Global.enemiesvolume = enemiesslider.value
	Global.environmentvolume = environmentslider.value
	Global.ambiencevolume = ambienceslider.value
	if Global.saved_reset == true:
		saved_.visible = true
		startsave()
	if Global.health == 3:
		hurt_sprite.visible = false
	if Global.health == 2:
		hurt_sprite.visible = true
		hurt_sprite.self_modulate = Color(1,1,1,.5)
	if Global.health == 1:
		hurt_sprite.visible = true
		hurt_sprite.self_modulate = Color(1,1,1,.8)
	if Global.health <= 0:
		hurt_sprite.self_modulate = Color(1,1,1,1)
	if Global.health <= 0 and can_black == true:
		death_timer.start()
		can_black = false
	stamina_bar.value = Global.staminaglobal
	if fade_out:
		fade_level = move_toward(fade_level, 0, delta * .75)
		loading_fade.self_modulate = Color(1.0, 1.0, 1.0, fade_level)
	if fade_level <= 0:
		fade_out = false
	if Global.fade_in == true:
		fade_level = move_toward(fade_level, 1, delta * .75)
		loading_fade.self_modulate = Color(1.0, 1.0, 1.0, fade_level)
	


	if Global.fade_out == true:
		stop_fade = true
		fade_to_black = move_toward(fade_to_black, 0, delta * 1.2)
		blackout.modulate = Color(1,1,1,fade_to_black)
	if stop_fade == true and fade_to_black <= 0:
		stop_fade = false
	if blackout_now == true and fade_to_black >= .9 and stop_fade:
		blackout_now = false
	if blackout_now == true:
		blackout.visible = true
		fade_to_black = move_toward(fade_to_black, 1, delta)
		blackout.modulate = Color(1,1,1,fade_to_black)


	if Input.is_action_just_pressed("menu"):
		menu_screen.visible = true
		Engine.time_scale = 0.0000000001
		AudioServer.set_bus_mute(masterv, true)
func _on_death_timer_timeout() -> void:
	blackout_now = true
	button_timer.start()

func _on_game_spawn_pressed() -> void:
	Global.player_respawn = true
	reset_timer.start()
	blackout_now = false
	buttons.visible = false
func _on_reset_timer_timeout() -> void:
	can_black = true
	Global.fade_out = false


func _on_button_timer_timeout() -> void:
	buttons.visible = true


func _on_saved_timer_timeout() -> void:
	Global.saved_reset = false
	saved_.visible = false
	can_start_save = true
func startsave():
	if can_start_save:
		saved_timer.start()
		can_start_save = false


func _on_settings_exit_pressed() -> void:
	menu_screen.visible = false
	Engine.time_scale = 1
	button_pressed.play()
	AudioServer.set_bus_mute(masterv, false)

func _on_save_pressed() -> void:
	SaveLoad.contents_to_save.player_respawn = Global.spawn_point
	SaveLoad.contents_to_save.level = Global.level_level
	SaveLoad.contents_to_save.health = Global.health
	SaveLoad.contents_to_save.mastervolume = Global.mastervolume
	SaveLoad.contents_to_save.playervolume = Global.playervolume
	SaveLoad.contents_to_save.enemiesvolume = Global.enemiesvolume
	SaveLoad.contents_to_save.environmentvolume = Global.environmentvolume
	SaveLoad.contents_to_save.ambiencevolume = Global.ambiencevolume
	SaveLoad._save()
	button_pressed.play()
func _on_title_pressed() -> void:
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scenes/start.tscn")
	button_pressed.play()

func _on_game_exit_pressed() -> void:
	Global.health = 3
	SaveLoad.contents_to_save.health = Global.health
	SaveLoad._save()
	get_tree().change_scene_to_file("res://scenes/start.tscn")
	button_pressed.play()


func _on_volume_pressed() -> void:
	volume_screen.show()


func _on_volume_exit_pressed() -> void:
	volume_screen.hide()
