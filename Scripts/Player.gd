extends KinematicBody

# Movement constants
var max_fall_speed = 20
var h_acceleration = 20
var gravity = 20
var jump_force = 10
var shot_force = 10
var max_shots = 2
# Vectors
var aim_direction = Vector3()
var velocity = Vector3()
# Variables
var on_ground
var on_left_wall
var on_right_wall
var on_ceiling
var falling
var num_shots
var last_collider
# Nodes
export(NodePath) onready var shootAudio = get_node(shootAudio) as AudioStreamPlayer3D
export(NodePath) onready var crashAudio = get_node(crashAudio) as AudioStreamPlayer3D
export(NodePath) onready var sprite = get_node(sprite) as Sprite3D
export(NodePath) onready var groundCheck = get_node(groundCheck) as RayCast
export(NodePath) onready var leftWallCheck = get_node(leftWallCheck) as RayCast
export(NodePath) onready var rightWallCheck = get_node(rightWallCheck) as RayCast
export(NodePath) onready var ceilingCheck = get_node(ceilingCheck) as RayCast
# File Paths
var shot_sfx = [load("res://Assets/audio/kenney interface sounds/drop_003.ogg"),
				load("res://Assets/audio/kenney interface sounds/drop_002.ogg")]
var crash_sfx = [load("res://Assets/audio/kenney_impact-sounds/footstep_concrete_000.ogg"),
				load("res://Assets/audio/kenney_impact-sounds/footstep_concrete_001.ogg"),
				load("res://Assets/audio/kenney_impact-sounds/footstep_concrete_002.ogg"),
				load("res://Assets/audio/kenney_impact-sounds/footstep_concrete_003.ogg"),
				load("res://Assets/audio/kenney_impact-sounds/footstep_concrete_004.ogg")]
# Debug
var exit_on_escape = false
var debug_mode = true
var debug_move_speed = 7
var num_crash = 0



func _process(_delta):
	if exit_on_escape and Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	if Input.is_action_just_pressed("debug_mode_toggle"):
		debug_mode = not debug_mode



func _physics_process(delta):
	process_collisions()
	process_player_movement(delta)
	
	if Input.is_action_just_pressed("move_shoot"):
		process_shooting()
		
	if debug_mode:
		process_debug_movement()
	
	# set player's movement
	velocity.z = 0
	velocity = move_and_slide(velocity, Vector3.UP)



func process_player_movement(delta):
	# set player's horizontal velocity
	var h_velocity = velocity
	h_velocity = h_velocity.linear_interpolate(Vector3.ZERO, h_acceleration * delta * 0.1)
	velocity.x = h_velocity.x
	
	# removes very very small horizontal movements
	if abs(velocity.x) < 0.01:
		velocity.x = 0
	
	# set the vertical velocity
	velocity.y -= gravity * delta
	velocity.y = max(velocity.y, -max_fall_speed)



func process_shooting():
	set_aim_direction()
	if on_ground:
		num_shots = 1
		velocity -= aim_direction * shot_force
		shootAudio.set_stream(shot_sfx[0])
		shootAudio.play()
	elif not on_ground and num_shots < max_shots:
		num_shots += 1
		velocity -= aim_direction * shot_force
		shootAudio.set_stream(shot_sfx[1])
		shootAudio.play()



func set_aim_direction():
	# set the player's aim direction
	var player_pos = get_viewport().get_camera().unproject_position(self.transform.origin)
	var mouse_pos = get_viewport().get_mouse_position()
	var aim_direction_2D = (player_pos - mouse_pos).normalized()
	aim_direction.x = -aim_direction_2D.x
	aim_direction.y = aim_direction_2D.y
	aim_direction = aim_direction.normalized()



func process_collisions():
	on_ground = groundCheck.is_colliding()
	on_left_wall = leftWallCheck.is_colliding()
	on_right_wall = rightWallCheck.is_colliding()
	on_ceiling = ceilingCheck.is_colliding()
	
	if get_slide_count() > 0:
		var collision = get_slide_collision(0)
		if velocity.length() > 5:
			last_collider = collision.collider.name
			falling = true
			player_crash()
	
	if on_ground:
		falling = false
		sprite.modulate = Color.white
		num_shots = 0



func process_debug_movement():
	var debug_move_direction = Vector3()
	var debug_moving = false
	
	if Input.is_action_pressed("debug_move_up"):
		debug_move_direction += Vector3.UP
		debug_moving = true
	if Input.is_action_pressed("debug_move_left"):
		debug_move_direction += Vector3.LEFT
		debug_moving = true
	if Input.is_action_pressed("debug_move_right"):
		debug_move_direction += Vector3.RIGHT
		debug_moving = true
	
	if debug_moving:
		velocity = debug_move_direction.normalized() * debug_move_speed
	
	if Input.is_action_just_released("debug_move_left") or Input.is_action_just_released("debug_move_right"):
		velocity.x = 0



func player_crash():
	falling = true
	sprite.modulate = Color.red
	
	crashAudio.set_stream(crash_sfx[rand_range(0,5)])
	crashAudio.play()
