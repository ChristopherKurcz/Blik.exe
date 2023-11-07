extends Control

# Nodes
export(NodePath) onready var mainMenu = get_node(mainMenu) as Control

func _ready():
	self.visible = false


func _on_BackButton_pressed():
	mainMenu.play_sound(0)
	self.visible = false
	mainMenu.visible = true
