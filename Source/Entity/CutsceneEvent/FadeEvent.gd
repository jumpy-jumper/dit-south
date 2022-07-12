extends CutsceneEvent

enum Fade {FADE_IN=0, FADE_OUT=1}
export (Fade) var fade := Fade.FADE_IN

enum Duration {INSTANT=0, SONIC=1, FAST=2, NORMAL=3, SLOW=4, VERY_SLOW=5}
export (Duration) var duration := Duration.NORMAL

func execute():
	var t = [0, 0.25, 0.5, 1, 2, 4][duration]
	Global.tween(Global.cutscene, "modulate:a", \
		0 if fade == Fade.FADE_IN else 1, 1 if fade == Fade.FADE_IN else 0, t)
	wait += t
