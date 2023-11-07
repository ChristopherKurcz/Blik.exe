extends PathFollow

var speed = 3
var current_offset = 0

func _ready():
	pass

func _physics_process(delta):
	current_offset += delta * speed
	set_offset(current_offset)
