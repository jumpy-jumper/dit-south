extends CutsceneEvent

export var speaker = ""
export(String, MULTILINE) var message = ""
export var final = false

func execute():
	Global.cutscene.set_textbox(message, final)