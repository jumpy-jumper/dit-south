extends Node2D

func _ready_global():
	Global.player = self

# Movement

var speed = Stat.new(600)

func _process_movement(delta):
	var mov = Input.get_vector(\
		"movement_x-", "movement_x+", "movement_y-", "movement_y+")

	position += speed.val * mov * delta

func _process_test(delta):
	if Input.is_action_pressed("-2"):
		speed.affirm_mod("dash", speed.ModType.ADDITIVE_MULTIPLIER, 2)
	else:
		speed.deny_mod("dash")