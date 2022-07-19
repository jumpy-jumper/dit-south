extends Node2D

func _ready_global():
	Global.player = self

# Movement

var speed = Stat.new(600)

func _process_movement(delta):
	var mov = Input.get_vector(\
		"movement_x-", "movement_x+", "movement_y-", "movement_y+")

	position += speed.val * mov * delta

# Health

func _process_update_health(delta):
	$UI/Panel/HPBar.value = $Health.get_percentage() * 100
	$UI/Panel/HPValue.text = str($Health.hp) + " / " + str($Health.max_hp.val)

# Development testing

func _process_test(delta):
	if Input.is_action_pressed("-2"):
		speed.affirm_mod("dash", speed.ModType.ADDITIVE_MULTIPLIER, 2)
	else:
		speed.deny_mod("dash")
	if Input.is_action_just_pressed("2"):
		$Health.take_damage(2000+randf()*200)
