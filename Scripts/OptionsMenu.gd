extends Control

# Variables
var audioBusName = "Master"
onready var busNum = AudioServer.get_bus_index(audioBusName)
var canPlaySound = false
# Nodes
export(NodePath) onready var mainMenu = get_node(mainMenu) as Control
export(NodePath) onready var cursorButton = get_node(cursorButton) as Button
export(NodePath) onready var textSpeedButton = get_node(textSpeedButton) as Button
export(NodePath) onready var volumeSlider = get_node(volumeSlider) as HSlider


func _ready():
	self.visible = false
	volumeSlider.value = PlayerStats.soundVolume
	update_cursor_button()
	update_text_speed_button()
	canPlaySound = true


func update_cursor_button():
	if PlayerStats.cursorSize == 0:
		cursorButton.text = "Cursor Size: Small"
	elif PlayerStats.cursorSize == 1:
		cursorButton.text = "Cursor Size: Medium"
	elif PlayerStats.cursorSize == 2:
		cursorButton.text = "Cursor Size: Large"
	elif PlayerStats.cursorSize == 3:
		cursorButton.text = "Cursor Size: Extra Large"

func update_text_speed_button():
	if PlayerStats.textSpeed == 0:
		textSpeedButton.text = "Text Speed: Default"
	elif PlayerStats.textSpeed == 1:
		textSpeedButton.text = "Text Speed: Fast"
	elif PlayerStats.textSpeed == 2:
		textSpeedButton.text = "Text Speed: Instant"


func _on_CursorButton_pressed():
	if canPlaySound: mainMenu.play_sound(0)
	PlayerStats.cursorSize = (PlayerStats.cursorSize + 1) % 4
	mainMenu.update_cursor()
	update_cursor_button()


func _on_TextSpeedButton_pressed():
	if canPlaySound: mainMenu.play_sound(0)
	PlayerStats.textSpeed = (PlayerStats.textSpeed + 1) % 3
	update_text_speed_button()


func _on_BackButton_pressed():
	if canPlaySound: mainMenu.play_sound(0)
	self.visible = false
	mainMenu.visible = true


func _on_VolumeSlider_value_changed(value):
	if canPlaySound: mainMenu.play_sound(2)
	PlayerStats.soundVolume = value
	AudioServer.set_bus_volume_db(busNum, linear2db(value))



