extends Node2D

var bullet_template = preload("res://Source/Entity/Bullet/Bullet.tscn")

func get_bullet() -> Bullet:
	var ret = bullet_template.instance()
	add_child(ret)
	return ret