extends Spatial

# Constants
var acceleration = 20
var camera_height = 1.5
var camera_distance = 15
var camera_fov = 45
var max_target_distance = 3
# Nodes
export(NodePath) onready var target = get_node(target) as RigidBody
export(NodePath) onready var camera = get_node(camera) as Camera
# Vectors
var position = Vector3()
var target_pos = Vector3()
var current_pos = Vector3()


func _ready():
	transform.origin.y = PlayerStats.positionY
	camera.transform.origin.y = camera_height
	camera.transform.origin.z = camera_distance
	camera.fov = camera_fov


func _physics_process(delta):
	process_movement(delta)


func process_movement(delta):
	target_pos = target.translation
	current_pos = transform.origin
	
	if abs(current_pos.y - target_pos.y) > 0.05:
		current_pos = current_pos.linear_interpolate(target_pos, acceleration * delta * 0.1 * abs(current_pos.y - target_pos.y))
	
	transform.origin.y = current_pos.y
