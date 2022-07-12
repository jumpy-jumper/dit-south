tool
extends CutsceneEvent

export var bgm := ""
export var crossfade_in := 0.0
export var crossfade_out := 0.25

func execute():
	.execute()
	Song.change_bgm(bgm if bgm != "" else null, crossfade_out, crossfade_in)
