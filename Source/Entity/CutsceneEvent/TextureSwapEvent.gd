tool
extends CutsceneEvent


export (NodePath) onready var node_to_swap = get_node(node_to_swap)
export (Texture) var texture = null
enum Duration {INSTANT=0, SONIC=1, FAST=2, NORMAL=3, SLOW=4, VERY_SLOW=5}
export (Duration) var duration := Duration.NORMAL
export var wait_until_finished = false

func execute():
	.execute()
	var node2 = node_to_swap.duplicate()
	node_to_swap.get_parent().add_child(node2)
	node_to_swap.texture = texture
	var t = [0, 0.25, 0.5, 1, 2, 4][duration]
	Global.tween(node2, "modulate:a", 1, 0, t)
	yield(get_tree().create_timer(t), "timeout")
	node2.queue_free()
	wait += t if wait_until_finished else 0
