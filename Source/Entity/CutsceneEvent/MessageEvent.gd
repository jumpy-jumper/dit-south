extends CutsceneEvent

export var speaker = ""
export(String, MULTILINE) var message = ""

func execute():
	Global.cutscene.set_textbox(message)