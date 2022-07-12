tool
extends CutsceneEvent

export var bgm := ""
export var crossfade := 0.0

func execute():
	.execute()
	Song.change_bgm(bgm if bgm != "" else null, crossfade)