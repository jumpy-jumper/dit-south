extends CutsceneEvent

export var wait_for_fade = true

enum Fade {FADE_IN=0, FADE_OUT=1}
export (NodePath) onready var node_to_fade = get_node(node_to_fade)
export (Fade) var fade := Fade.FADE_IN

enum Duration {INSTANT=0, SONIC=1, FAST=2, NORMAL=3, SLOW=4, VERY_SLOW=5}
export (Duration) var duration := Duration.NORMAL


func _ready():
	if node_to_fade and fade==Fade.FADE_IN:
		node_to_fade.modulate.a = 0

func execute():
	var t = [0, 0.25, 0.5, 1, 2, 4][duration]
	Global.tween(node_to_fade if node_to_fade else Global.cutscene, "modulate:a", \
		0 if fade == Fade.FADE_IN else 1, 1 if fade == Fade.FADE_IN else 0, t)
	if wait_for_fade:
		wait += t
