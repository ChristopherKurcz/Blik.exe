extends Control

# Nodes
export(NodePath) onready var mainMenu = get_node(mainMenu) as Control
export(NodePath) onready var timeLabel = get_node(timeLabel) as Control
export(NodePath) onready var maxHeightLabel = get_node(maxHeightLabel) as Control
export(NodePath) onready var jumpsLabel = get_node(jumpsLabel) as Control
export(NodePath) onready var crashesLabel = get_node(crashesLabel) as Control
export(NodePath) onready var jumpPadsLabel = get_node(jumpPadsLabel) as Control
export(NodePath) onready var multipliersLabel = get_node(multipliersLabel) as Control
export(NodePath) onready var droidsLabel = get_node(droidsLabel) as Control


func _ready():
	self.visible = false


func update_stat_labels():
	timeLabel.text = "in game time: %02d:%02d:%02d" % [PlayerStats.hours_elapsed, PlayerStats.minutes_elapsed, PlayerStats.seconds_elapsed]
	maxHeightLabel.text = "record height = " + str(PlayerStats.highest_distance)
	jumpsLabel.text = "number of signals sent = " + str(PlayerStats.num_jumps)
	crashesLabel.text = "number of crashes = " + str(PlayerStats.num_crashes)
	jumpPadsLabel.text = "number of jump pads = " + str(PlayerStats.num_jump_pads)
	multipliersLabel.text = "number of speed boosts = " + str(PlayerStats.num_speed_boosts)
	droidsLabel.text = "number of spoko droids hit = " + str(PlayerStats.num_droids)
	
	jumpPadsLabel.visible = (PlayerStats.num_jump_pads > 0)
	multipliersLabel.visible = (PlayerStats.num_speed_boosts > 0)
	droidsLabel.visible = (PlayerStats.num_droids > 0)


func _on_BackButton_pressed():
	mainMenu.play_sound(0)
	self.visible = false
	mainMenu.visible = true


func _on_ResetButton_pressed():
	SaveGame.reset_progress()
	PlayerStats.update_times()
	update_stat_labels()
