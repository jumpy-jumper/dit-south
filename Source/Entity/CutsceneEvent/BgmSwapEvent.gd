tool
extends CutsceneEvent


enum Duration {INSTANT=0, SONIC=1, FAST=2, NORMAL=3, SLOW=4, VERY_SLOW=5}

export var bgm := ""
export (Duration) var crossfade_out := Duration.FAST
export (Duration) var crossfade_in := Duration.INSTANT

func execute():
	.execute()
	crossfade_in = [0, 0.25, 0.5, 1, 2, 4][crossfade_in]
	crossfade_out = [0, 0.25, 0.5, 1, 2, 4][crossfade_out]
	Song.change_bgm(bgm if bgm != "" else null, crossfade_out, crossfade_in)
