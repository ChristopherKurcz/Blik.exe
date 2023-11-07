extends Spatial

# Nodes
export(NodePath) onready var animationPlayer = get_node(animationPlayer) as AnimationPlayer
export(NodePath) onready var audioStreamPlayer = get_node(audioStreamPlayer) as AudioStreamPlayer3D


func _on_JumpPadArea_body_entered(body):
	if body.is_in_group("Player"):
		body.linear_velocity = global_transform.basis.y * 25
		body.num_shots = 1
		animationPlayer.play("Activate")
		audioStreamPlayer.play()
		PlayerStats.num_jump_pads += 1
		
		if body.falling and global_transform.basis.y == Vector3.UP:
			body.player_fix()
