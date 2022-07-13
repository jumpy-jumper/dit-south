extends Node2D

func _ready_global():
	Global.player = self

# Movement

var speed = 600

func _physics_process_movement(delta):
	var mov = Input.get_vector(\
		"movement_x-", "movement_x+", "movement_y-", "movement_y+")

	position += speed * mov * delta