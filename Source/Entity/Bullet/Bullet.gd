extends Node2D
class_name Bullet

export(int, 0, 12) var tone = 0

var speed = 0

func _process_movement(delta):
	position += Vector2(speed * delta, 0).rotated(rotation)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
