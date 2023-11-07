extends Control

# Variables
var gamePaused
# Nodes
export(NodePath) onready var buttonAudio = get_node(buttonAudio) as AudioStreamPlayer
export(NodePath) onready var player = get_node(player) as RigidBody
# File Paths
var cursors = [load("res://Assets/Dum/DumMouseSmall.png"),
			load("res://Assets/Dum/DumMouse.png"),
			load("res://Assets/Dum/DumMouseLarge.png"),
			load("res://Assets/Dum/DumMouseExtraLarge.png"),
			load("res://Assets/Dum/DumCrosshairSmall.png"),
			load("res://Assets/Dum/DumCrosshair.png"),
			load("res://Assets/Dum/DumCrosshairLarge.png"),
			load("res://Assets/Dum/DumCrosshairExtraLarge.png"),]


func _ready():
	hide_pause_menu()
	gamePaused = false


func _process(_delta):
	process_input()


func process_input():
	if Input.is_action_just_pressed("pause_game") and not gamePaused:
		pause_game()
	elif Input.is_action_just_pressed("pause_game") and gamePaused:
		resume_game()


func pause_game():
	show_pause_menu()
	player.player_save()
	get_tree().paused = true
	gamePaused = true


func resume_game():
	get_tree().paused = false
	gamePaused = false
	hide_pause_menu()


func quit_game():
	get_tree().quit()


func go_to_menu():
	get_tree().paused = false
	var _error = get_tree().change_scene("res://Scenes/MainMenuScene.tscn")


func show_pause_menu():
	Input.set_custom_mouse_cursor(cursors[PlayerStats.cursorSize],0,Vector2(0,0))
	self.visible = true


func hide_pause_menu():
	set_crosshair()
	self.visible = false


func set_crosshair():
	var crosshairCenters = [14,17.5,24.5,35]
	var crosshairCenter = Vector2(crosshairCenters[PlayerStats.cursorSize],crosshairCenters[PlayerStats.cursorSize])
	Input.set_custom_mouse_cursor(cursors[PlayerStats.cursorSize+4],0, crosshairCenter)


func _on_ResumeButton_pressed():
	resume_game()


func _on_MenuButton_pressed():
	go_to_menu()


func _on_ExitButton_pressed():
	SaveGame.save_game()
	quit_game()


func _on_button_hover():
	buttonAudio.play()
