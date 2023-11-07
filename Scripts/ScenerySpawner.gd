extends Spatial

var block = preload("res://Scenes/MMSceneryBlock.tscn")


func _ready():
	create_scenery_block()


func _on_Timer_timeout():
	create_scenery_block()


func create_scenery_block():
	var newBlock = block.instance()
	newBlock.translation = Vector3((randi()%50-25),30,-25)
	newBlock.rotation_degrees = Vector3((randi()%360),(randi()%360),(randi()%360))
	add_child(newBlock)
