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

func _advance_inputted(event):
	if not event.pressed:
		waiting_for_user = false
		wait_t = 0
