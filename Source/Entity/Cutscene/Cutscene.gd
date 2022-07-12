extends Control

onready var events = $Events.get_children()
var cur_event = 0
var waiting_for_user := false
var wait_t = 0

func _ready_global():
	Global.cutscene = self

func _process_events(delta):
	if not waiting_for_user and wait_t <= 0:
		if cur_event >= len(events):
			queue_free()
			print("Goodbye")
		else:
			events[cur_event].execute()
			print("Triggered event: ", events[cur_event].name)
			wait_t = events[cur_event].wait
			if wait_t:
				print("Waiting for " + str(wait_t) + "s...")
			waiting_for_user =  events[cur_event].wait_for_input
			if waiting_for_user:
				print("Waiting for input...")
			cur_event += 1
	wait_t -= delta

# Textbox

func _ready_textbox():
	$Textbox/Text.text = ""

var chars = 0
func _process_textbox(delta):
	$Textbox/Text.visible_characters = round(chars)
	if chars >= 0:
		chars += 50 * delta

func _advance_inputted(event):
	if not event.pressed and waiting_for_user:
		if $Textbox/Text.percent_visible < 1:
			chars = -1
		else:
			waiting_for_user = false

func set_textbox(text):
	$Textbox/Text.text = text
	chars = 0
