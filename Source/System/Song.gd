extends Node


const SONGS = {
	"Boundless Color in Erratic World" : preload("res://Assets/BGM/boundless_color_f#m.wav"),
	"Word of Weakness" : preload("res://Assets/BGM/word_of_weakness.wav"),
	"Distant Touch" : preload("res://Assets/BGM/distant_touch.wav"),
}

onready var stream := $AudioStreamPlayer

func change_bgm(bgm, crossfade_out = 0.25, crossfade_in = 0):
	var old = stream

	stream = stream.duplicate()
	stream.stream = bgm if bgm == null else SONGS[bgm]
	stream.volume_db = -80
	stream.autoplay = false
	add_child(stream)

	Global.tween(old, "volume_db", \
		old.volume_db, -80, crossfade_out, Tween.TRANS_QUAD)
	
	stream.play()
	Global.tween(stream, "volume_db", \
		-80, 0, crossfade_in, Tween.TRANS_QUAD)

	if bgm != null:
		$CanvasLayer/Notification/Label.text = bgm
		$CanvasLayer/Notification/AnimationPlayer.stop()
		$CanvasLayer/Notification/AnimationPlayer.play("enter")

	print(crossfade_out)

	yield(get_tree().create_timer(crossfade_out), "timeout")
	old.queue_free()