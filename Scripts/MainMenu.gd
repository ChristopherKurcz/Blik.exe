extends Control

# Nodes
export(NodePath) onready var optionsMenu = get_node(optionsMenu) as Control
export(NodePath) onready var statsMenu = get_node(statsMenu) as Control
export(NodePath) onready var creditsMenu = get_node(creditsMenu) as Control
export(NodePath) onready var buttonAudio = get_node(buttonAudio) as AudioStreamPlayer
# File Paths
var cursors = [load("res://Assets/Dum/DumMouseSmall.png"),
			load("res://Assets/Dum/DumMouse.png"),
			load("res://Assets/Dum/DumMouseLarge.png"),
			load("res://Assets/Dum/DumMouseExtraLarge.png")]
var button_sfx = [load("res://Assets/audio/kenney interface sounds/glass_006.ogg"),
				load("res://Assets/audio/kenney interface sounds/bong_001.ogg"),
				load("res://Assets/audio/kenney interface sounds/drop_003.ogg")]


func _ready():
	PlayerStats.inGame = false
	update_cursor()
	self.visible = true


func update_cursor():
	Input.set_custom_mouse_cursor(cursors[PlayerStats.cursorSize],0,Vector2(0,0))


func play_sound(soundNum):
	buttonAudio.set_stream(button_sfx[soundNum])
	buttonAudio.play()


func _on_StartButton_pressed():
	PlayerStats.inGame = true
	play_sound(0)
	var _error = get_tree().change_scene("res://Scenes/MainGame.tscn")


func _on_OptionsButton_pressed():
	play_sound(0)
	self.visible = false
	optionsMenu.visible = true


func _on_CreditsButton_pressed():
	play_sound(0)
	self.visible = false
	creditsMenu.visible = true


func _on_StatsButton_pressed():
	play_sound(0)
	self.visible = false
	statsMenu.update_stat_labels()
	statsMenu.visible = true


func _on_ExitButton_pressed():
	SaveGame.save_game()
	get_tree().quit()


func _on_button_hover():
	if buttonAudio.get_stream() != button_sfx[0] or !buttonAudio.playing:
		play_sound(1)



