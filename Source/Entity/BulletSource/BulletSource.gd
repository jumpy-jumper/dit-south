extends Node2D

export (int) var count = 1
export(float, 0, 360, 2) var spread : int = 0
export (bool) var aimed = 0

export(float, 100, 1000, 0.2) var speed : int = 300

func shoot():
	if aimed:
		rotation = (global_position.angle_to_point((Global.player.global_position)) + PI)  if Global.player else Vector2.DOWN
	for i in range(count):
		var bullet = Bullets.get_bullet()
		bullet.rotation = rotation + (randf() * deg2rad(spread) - deg2rad(spread)/2)
		bullet.global_position = global_position
		bullet.speed = speed
		bullet.global_scale = scale

func _ui_accept_inputted(event):
	if event.pressed:
		shoot()