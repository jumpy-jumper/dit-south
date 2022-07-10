extends Node2D

var node

func _ready_node():
	print('readied!')
	node = randf()

func _node_updated():
	print("New value for {node}: ", node)

func _node_updated2():
	print("ECHOOO: New value for {node}: ", node)

func _ui_right_input(event):
	node = randf()
