extends RigidBody

# File Paths
var materials = [load("res://Materials/WhiteGrid.tres"),
			load("res://Materials/GreenGrid.tres"),
			load("res://Materials/BlueGrid.tres"),
			load("res://Materials/OrangeGrid.tres"),
			load("res://Materials/PinkGrid.tres"),
			load("res://Materials/PurpleGrid.tres"),
			load("res://Materials/RedGrid.tres")]


func _ready():
	randomize()
	create_mesh()


func create_mesh():
	var block = MeshInstance.new()
	block.transform.origin = Vector3.ZERO
	block.mesh = CubeMesh.new()
	block.set_surface_material(0,get_material())
	var blockSize = randi()%12+3
	block.mesh.size = Vector3(blockSize,blockSize,blockSize)
	add_child(block)


func get_material():
	if randi()%2 == 0:
		return materials[0]
	else:
		return materials[randi()%6+1]


func _on_Timer_timeout():
	queue_free()
