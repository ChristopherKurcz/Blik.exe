extends Sprite3D

# Nodes
export(NodePath) onready var oopsSprite = get_node(oopsSprite) as Sprite3D


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		if body.linear_velocity.y < -12 or body.falling:
			oopsSprite.visible = true
			yield(get_tree().create_timer(3.0), "timeout")
			oopsSprite.visible = false
