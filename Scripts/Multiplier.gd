extends Spatial


# Nodes
export(NodePath) onready var audioStreamPlayer = get_node(audioStreamPlayer) as AudioStreamPlayer3D


func _on_MultiplierArea_body_entered(body):
	if body.is_in_group("Player"):
		body.linear_velocity = body.linear_velocity + (body.linear_velocity.normalized() * 10)
		audioStreamPlayer.play()
		PlayerStats.num_speed_boosts += 1
