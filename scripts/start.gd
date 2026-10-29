extends Node2D
var last_button
var last_last_button
var secret_step = 0
@onready var background: Sprite2D = $background
@onready var timer: Timer = $Timer
@onready var settings_screen: Sprite2D = $Settings_screen
@onready var button_pressed: AudioStreamPlayer2D = $button_pressed
@onready var volume_screen: Sprite2D = $Settings_screen/volume_screen
@onready var masterslider: HSlider = $Settings_screen/volume_screen/ScrollContainer/VBoxContainer/masterslider
@onready var playerslider: HSlider = $Settings_screen/volume_screen/ScrollContainer/VBoxContainer/playerslider
@onready var enemiesslider: HSlider = $Settings_screen/volume_screen/ScrollContainer/VBoxContainer/enemiesslider
@onready var environmentslider: HSlider = $Settings_screen/volume_screen/ScrollContainer/VBoxContainer/environmentslider
@onready var ambienceslider: HSlider = $Settings_screen/volume_screen/ScrollContainer/VBoxContainer/ambienceslider
@onready var secret_: TextureButton = $"Control/secret?"
@onready var gpu_particles_2d_2: GPUParticles2D = $Control/GPUParticles2D2
@onready var gpu_particles_2d: GPUParticles2D = $Control/GPUParticles2D
@onready var secret_menu: Sprite2D = $secret_menu

func _ready() -> void:
	masterslider.value = Global.mastervolume
	playerslider.value = Global.playervolume
	enemiesslider.value = Global.enemiesvolume
	environmentslider.value = Global.environmentvolume
	ambienceslider.value = Global.ambiencevolume
	secret_.visible = false
func _physics_process(_delta: float) -> void:

	Global.mastervolume = masterslider.value
	Global.playervolume = playerslider.value
	Global.enemiesvolume = enemiesslider.value
	Global.environmentvolume = environmentslider.value
	Global.ambiencevolume = ambienceslider.value
	if Input.is_action_just_pressed("up"):
		if secret_step != 0 or 1:
			secret_step = 0
		if secret_step == 0:
			secret_step = 1
		if last_button == "up" and secret_step == 1:
			secret_step = 2
		last_last_button = last_button
		last_button = "up"


	if Input.is_action_just_pressed("down"):
		if secret_step > 3 or secret_step == 1:
			secret_step = 0
			print("happened")
		if last_last_button == "up" and last_button == "up" and secret_step == 2:
			secret_step = 3
		if last_last_button == "up" and  last_button == "down" and secret_step == 3:
			secret_step = 4
		last_last_button = last_button
		last_button = "down"



	if Input.is_action_just_pressed("left"):
		if secret_step > 6 or secret_step == 1 or secret_step == 2 or secret_step == 3 or secret_step == 5:
			secret_step = 0
		if last_last_button == "down" and last_button == "down" and secret_step == 4:
			secret_step = 5
		if last_last_button == "left" and last_button == "right" and secret_step == 6:
			secret_step = 7
		last_last_button = last_button
		last_button = "left"


	if Input.is_action_just_pressed("right"):
		if secret_step > 7 or secret_step == 1 or secret_step == 2 or secret_step == 3 or secret_step == 4 or secret_step == 6:
			secret_step = 0
		if last_last_button == "down" and last_button == "left" and secret_step == 5:
			secret_step = 6
		if last_last_button == "right" and last_button == "left" and secret_step == 7:
			secret_step = 8
		last_last_button = last_button
		last_button = "right"


	if Input.is_action_just_pressed("b"):
		if secret_step > 9 or secret_step < 8:
			secret_step = 0
		if last_last_button == "left" and last_button == "right" and secret_step == 8:
			secret_step = 9
		last_last_button = last_button
		last_button = "b"
	if Input.is_action_just_pressed("a"):
		if secret_step > 10 or secret_step < 9:
			secret_step = 0
		if last_last_button == "right" and last_button == "b" and secret_step == 9:
			secret_step = 10
		last_last_button = last_button
		last_button = "a"
func _on_credits_pressed() -> void:
	background.visible = true
	button_pressed.play()

func _on_credit_exit_pressed() -> void:
	background.visible = false
	button_pressed.play()

func _on_start_pressed() -> void:
	if secret_step != 10:
		timer.start()
		button_pressed.play()
		Global.spawn_point = SaveLoad.contents_to_save.player_respawn
		Global.level_level = Global.level_level - 1
		get_tree().change_scene_to_file("res://scenes/loading_screen.tscn")
	if secret_step == 10:
		secret_step = 11
		print("finished!")
		secret_.visible = true
		gpu_particles_2d.emitting = true
		gpu_particles_2d_2.emitting = true
func _on_timer_timeout() -> void:
	print("something worekd")

func _on_quit_pressed() -> void:
	button_pressed.play()
	get_tree().quit()


func _on_settings_exit_pressed() -> void:
	settings_screen.visible = false
	volume_screen.visible = false
	button_pressed.play()

func _on_settings_pressed() -> void:
	settings_screen.visible = true
	button_pressed.play()

func _on_load_pressed() -> void:
	SaveLoad._load()
	Global.spawn_point = SaveLoad.contents_to_save.player_respawn
	Global.level_level = SaveLoad.contents_to_save.level
	Global.health = SaveLoad.contents_to_save.health
	button_pressed.play()


func _on_volume_pressed() -> void:
	button_pressed.play()
	volume_screen.visible = true


func _on_volume_exit_pressed() -> void:
	button_pressed.play()
	volume_screen.visible = false


func _on_secret_pressed() -> void:
	secret_menu.visible = true
	button_pressed.play()

func _on_secret_exit_pressed() -> void:
	secret_menu.visible = false
	button_pressed.play()


func _on_one_button_pressed() -> void:
	Global.level_level = 1
	button_pressed.play()

func _on_two_button_pressed() -> void:
	Global.level_level = 2
	button_pressed.play()

func _on_three_button_pressed() -> void:
	Global.level_level = 3
	button_pressed.play()

func _on_mystery_button_pressed() -> void:
	Global.player_scale = Vector2(0.5, 0.5)
	Global.player_speed = 2
	button_pressed.play()
