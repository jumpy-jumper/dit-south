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


onready var spectrum := AudioServer.get_bus_effect_instance(0, 0)

const A4 = 440
# Return frequency magnitudes from A0 to C8
func get_frequency_magnitudes():
	var ret = []
	for i in range(12*-4, 12*4):
		var f = spectrum.get_magnitude_for_frequency_range(A4 * pow(2, (i-0.5)/12.0), A4 * pow(2, (i+0.5)/12.0), AudioEffectSpectrumAnalyzerInstance.MAGNITUDE_MAX)
		ret.append((f.x + f.y) / 2)
	return ret
