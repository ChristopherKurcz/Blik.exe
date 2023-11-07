extends Control

# Labels
export(NodePath) onready var player = get_node(player) as RigidBody
export(NodePath) onready var xLabel = get_node(xLabel) as Label
export(NodePath) onready var yLabel = get_node(yLabel) as Label
export(NodePath) onready var speedLabel = get_node(speedLabel) as Label
export(NodePath) onready var hSpeedLabel = get_node(hSpeedLabel) as Label
export(NodePath) onready var vSpeedLabel = get_node(vSpeedLabel) as Label
export(NodePath) onready var onGroundLabel = get_node(onGroundLabel) as Label
export(NodePath) onready var fallingLabel = get_node(fallingLabel) as Label
export(NodePath) onready var flyingLabel = get_node(flyingLabel) as Label
export(NodePath) onready var emotingLabel = get_node(emotingLabel) as Label
export(NodePath) onready var numShotsLabel = get_node(numShotsLabel) as Label
export(NodePath) onready var shotDelayLabel = get_node(shotDelayLabel) as Label

export(NodePath) onready var timeLabel = get_node(timeLabel) as Label
export(NodePath) onready var numJumpsLabel = get_node(numJumpsLabel) as Label
export(NodePath) onready var numCrashesLabel = get_node(numCrashesLabel) as Label
export(NodePath) onready var numJumpPadsLabel = get_node(numJumpPadsLabel) as Label
export(NodePath) onready var numSpeedBoostsLabel = get_node(numSpeedBoostsLabel) as Label
export(NodePath) onready var numDroidsLabel = get_node(numDroidsLabel) as Label
export(NodePath) onready var maxHeightLabel = get_node(maxHeightLabel) as Label


func _process(_delta):
	process_labels()
	process_stats()
	self.visible = player.debug_mode


func process_labels():
	xLabel.text = "X: "+str(player.global_translation.x)
	yLabel.text = "Y: "+str(player.global_translation.y)
	
	speedLabel.text = "Speed: " + str(player.linear_velocity.length())
	hSpeedLabel.text = "H Speed: " + str(player.linear_velocity.x)
	vSpeedLabel.text = "V Speed: " + str(player.linear_velocity.y)
	
	onGroundLabel.text = "On Ground: " + str(player.on_ground)
	fallingLabel.text = "Falling: " + str(player.falling)
	flyingLabel.text = "Flying: " + str(player.flying)
	emotingLabel.text = "Emoting: " + str(player.emoting)
	
	numShotsLabel.text = "Num Shots: "+ str(player.num_shots)
	
	shotDelayLabel.text = "Shot Delay: "+ str(player.shot_delay)


func process_stats():
	timeLabel.text = "Time Elapsed: %02d:%02d" % [PlayerStats.minutes_elapsed, PlayerStats.seconds_elapsed]
	
	numJumpsLabel.text = "Num Jumps: " + str(PlayerStats.num_jumps)
	numCrashesLabel.text = "Num Bonks: " + str(PlayerStats.num_crashes)
	numJumpPadsLabel.text = "Num Jump Pads: " + str(PlayerStats.num_jump_pads)
	numSpeedBoostsLabel.text = "Num Speed Boosts: " + str(PlayerStats.num_speed_boosts)
	numDroidsLabel.text = "Num Droids Hit: " + str(PlayerStats.num_droids)
	
	maxHeightLabel.text = "Max Height Reached: " + str(PlayerStats.highest_distance)

