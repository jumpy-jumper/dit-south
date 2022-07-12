extends Node

const SONGS = {
	"Boundless Color in Erratic World" : preload("res://Assets/BGM/boundless_color_f#m.wav"),
	"Word of Weakness" : preload("res://Assets/BGM/word_of_weakness.wav"),
	"Distant Touch" : preload("res://Assets/BGM/distant_touch.wav"),
}

onready var stream := $AudioStreamPlayer

func change_bgm(bgm, crossfade = 0):
	var old = stream

	stream = stream.duplicate()
	stream.stream = bgm if bgm == null else SONGS[bgm]
	stream.volume_db = -80
	add_child(stream)
	stream.play()

	Global.tween(stream, "volume_db", \
		-80, 0, crossfade)
	Global.tween(old, "volume_db", \
		old.volume_db, -80, crossfade)

	if bgm != null:
		$CanvasLayer/Notification/Label.text = bgm
		$CanvasLayer/Notification/AnimationPlayer.play("enter")

	yield(get_tree().create_timer(crossfade), "timeout")
	old.queue_free()

func _ui_right_input(event):
	if event.pressed:
		change_bgm("Boundless Color in Erratic World")

func _ui_down_input(event):
	if event.pressed:
		change_bgm(null, 1.5)

func _ui_left_input(event):
	if event.pressed:
		change_bgm("Distant Touch")
