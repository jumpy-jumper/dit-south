extends Control


onready var song = $"../.."
var magnitudes = [0,0,0,0,0,0,0,0,0,0,0,0]
func _process(dt):
	if recording:
		var mags = song.get_frequency_magnitudes()
		var p = []
		for i in range(len(mags)):
			magnitudes[i%12] += mags[i] * dt
			$Handles.get_child(i%12).get_child(i/12.0).modulate.a = (magnitudes[i%12])
		for i in range(12):
			p.append(Vector2(i*40, pow(magnitudes[i],1)*1000))
		$Graph.points = p
var recording = false

func _0_inputted(event):
	recording = event.pressed
	if not recording:
		magnitudes = [0,0,0,0,0,0,0,0,0,0,0,0]
