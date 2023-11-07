extends Spatial

# Nodes
export(NodePath) onready var audioStreamPlayer = get_node(audioStreamPlayer) as AudioStreamPlayer3D


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		var knockback = -(self.global_transform.origin - body.global_transform.origin).normalized()
		knockback.z = 0
		body.linear_velocity = knockback * 12
		body.player_crash()
		audioStreamPlayer.play()
		PlayerStats.num_droids += 1
