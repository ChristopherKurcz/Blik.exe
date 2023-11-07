extends RigidBody

# Constants
var crash_speed = 0
var shot_force = 20
var max_shots = 2
var emote_distance = 25
var shot_delay = 0
# Vectors
var aim_direction = Vector3()
var prev_velocity = Vector3()
# Variables
var falling
var flying
var on_ground
var num_shots = 1
var shot_waiting = false
var fall_time = 0.0
export(bool) var emoting = false
# Nodes
export(NodePath) onready var shootAudio = get_node(shootAudio) as AudioStreamPlayer3D
export(NodePath) onready var crashAudio = get_node(crashAudio) as AudioStreamPlayer3D
export(NodePath) onready var sprite = get_node(sprite) as Sprite3D
export(NodePath) onready var animationPlayer = get_node(animationPlayer) as AnimationPlayer
export(NodePath) onready var groundCheck1 = get_node(groundCheck1) as RayCast
export(NodePath) onready var groundCheck2 = get_node(groundCheck2) as RayCast
export(NodePath) onready var groundCheck3 = get_node(groundCheck3) as RayCast
export(NodePath) onready var resetTimer = get_node(resetTimer) as Timer
export(NodePath) onready var respawnPoint = get_node(respawnPoint) as Position3D
# File Paths
var sprites = [load("res://Assets/Dum/DumPlayer.png"),
				load("res://Assets/Dum/DumPlayerFly.png"),
				load("res://Assets/Dum/DumPlayerDead.png")]
var shot_sfx = [load("res://Assets/audio/kenney interface sounds/drop_003.ogg"),
				load("res://Assets/audio/kenney interface sounds/drop_002.ogg")]
var crash_sfx = [load("res://Assets/audio/kenney_impact-sounds/footstep_concrete_000.ogg"),
				load("res://Assets/audio/kenney_impact-sounds/footstep_concrete_001.ogg"),
				load("res://Assets/audio/kenney_impact-sounds/footstep_concrete_002.ogg"),
				load("res://Assets/audio/kenney_impact-sounds/footstep_concrete_003.ogg"),
				load("res://Assets/audio/kenney_impact-sounds/footstep_concrete_004.ogg")]
# Debug
var exit_on_escape = false
var debug_mode = false
var debug_move_speed = 7
var num_crash = 0


func _ready():
	player_load()
	emoting = false


func _process(_delta):
	if exit_on_escape and Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	if Input.is_action_just_pressed("debug_mode_toggle"):
		debug_mode = not debug_mode


func _physics_process(delta):
	prev_velocity = linear_velocity
	shot_delay -= delta
	process_collisions(delta)
	process_input()
	process_sprite()
	process_stats()
	if debug_mode:
		process_debug_movement()


func process_collisions(delta):
	on_ground = groundCheck1.is_colliding() or groundCheck2.is_colliding() or groundCheck3.is_colliding()
	
	if on_ground:
		num_shots = 1
		flying = false
		if falling and prev_velocity.length() < 0.01 and resetTimer.get_time_left() == 0:
			resetTimer.start()
	
	if falling:
		fall_time += delta
	else:
		fall_time = 0.0
	
	# out of bounds respawn
	if abs(global_translation.x) > 15 or global_translation.y < -3:
		player_respawn()


func process_input():
	if Input.is_action_just_pressed("move_shoot") and not falling:
		if shot_delay <= 0:
			process_shooting()
			shot_delay = 0.1
			shot_waiting = false
		else:
			shot_waiting = true
	
	if shot_waiting and shot_delay <= 0 and not falling:
		process_shooting()
		shot_delay = 0.1
		shot_waiting = false


func process_shooting():
	if set_aim_direction():
		if on_ground:
			player_shoot(shot_sfx[0])
		elif not on_ground and num_shots < max_shots:
			num_shots += 1
			flying = true
			player_shoot(shot_sfx[1])


func player_shoot(soundPath):
	apply_central_impulse(aim_direction * shot_force)
	
	shootAudio.set_stream(soundPath)
	shootAudio.play()
	
	PlayerStats.num_jumps += 1


func process_sprite():
	sprite.modulate = Color.white
	
	if linear_velocity.x < -0.07:
		sprite.flip_h = true
	elif linear_velocity.x > 0.07:
		sprite.flip_h = false
	
	if falling:
		sprite.modulate = Color.lightcoral
		sprite.texture = sprites[2]
	elif flying:
		sprite.texture = sprites[1]
	elif not emoting:
		sprite.texture = sprites[0]


func process_stats():
	PlayerStats.highest_distance = max(PlayerStats.highest_distance, int(global_translation.y))


func set_aim_direction():
	# set the player's aim direction
	var player_pos = get_viewport().get_camera().unproject_position(self.transform.origin)
	var mouse_pos = get_viewport().get_mouse_position()
	var aim_direction_2D = (player_pos - mouse_pos)
	
	if linear_velocity.length() > 1 or (aim_direction_2D.length() > emote_distance):
		aim_direction_2D = aim_direction_2D.normalized()
		aim_direction.x = -aim_direction_2D.x
		aim_direction.y = aim_direction_2D.y
		aim_direction = -aim_direction.normalized()
		return true
	else:
		animationPlayer.play("Emote")
		return false


func player_crash():
	falling = true
	PlayerStats.num_crashes += 1


func player_fix():
	falling = false


func player_respawn():
	linear_velocity = Vector3.ZERO
	global_translation = respawnPoint.global_translation


func _on_RigidPlayer_body_entered(_body):
	crashAudio.set_stream(crash_sfx[rand_range(0,5)])
	crashAudio.play()
	
	if not on_ground and prev_velocity.length() >= crash_speed:
		player_crash()


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
		linear_velocity = debug_move_direction * debug_move_speed
	
	if Input.is_action_just_released("debug_move_left") or Input.is_action_just_released("debug_move_right"):
		linear_velocity.x = 0


func _on_ResetTimer_timeout():
	if prev_velocity.length() < 0.01:
		player_fix()


func player_load():
	linear_velocity = Vector3(PlayerStats.velocityX, PlayerStats.velocityY, 0)
	global_translation = Vector3(PlayerStats.positionX, PlayerStats.positionY, 0)
	falling = PlayerStats.falling
	flying = PlayerStats.flying
	num_shots = PlayerStats.num_shots

func player_save():
	PlayerStats.velocityX = linear_velocity.x
	PlayerStats.velocityY = linear_velocity.y
	PlayerStats.positionX = global_translation.x
	PlayerStats.positionY = global_translation.y
	PlayerStats.falling = falling
	PlayerStats.flying = flying
	PlayerStats.num_shots = num_shots

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		player_save()
		SaveGame.save_game()
		get_tree().quit()

