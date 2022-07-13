extends Control

func _ready_global():
	Global.cutscene = self

# Events

var events = []
var cur_event = 0

func _ready_events():
	add_events($Events)

func add_events(node):
	if node.get_child_count() > 0:
		for c in node.get_children():
			add_events(c)
	else:
		events.append(node)

var waiting_for_user := false
var wait_t = 0

func _process_events(delta):
	if not waiting_for_user and wait_t <= 0:
		if cur_event >= len(events):
			queue_free()
			print("Goodbye")
		else:
			events[cur_event].execute()
			print("[" + str(cur_event) + "] Triggered event: ", events[cur_event].name)
			wait_t = events[cur_event].wait
			if wait_t:
				print("Waiting for " + str(wait_t) + "s...")
			waiting_for_user =  events[cur_event].wait_for_input
			if waiting_for_user:
				print("Waiting for input...")
			cur_event += 1
	wait_t -= delta

# Loading

func _ready_load():
	yield(get_tree(), "idle_frame")

func load_to_idx(idx):
	for i in range(idx - cur_event):
		events[cur_event].execute()
		print("[" + str(cur_event) + "] Triggered event: ", events[cur_event].name)
		cur_event += 1
		waiting_for_user = events[cur_event].wait_for_input

# Saving

func _process_furthest_reached(delta):
	Global.savedata.set_value("cutscene_progress", name, max(Global.savedata.get_value("cutscene_progress", name, 0), cur_event))

# Textbox

func _ready_textbox():
	$Textbox/Text.text = ""

var chars = 0
func _process_textbox(delta):
	if chars < len($Textbox/Text.text):
		chars += Global.settings.get_value("cutscene", "text_speed", 50) * delta
		if chars >= len($Textbox/Text.text):
			advance_grace = Global.settings.get_value("cutscene", "advance_grace", 0.2)
	$Textbox/Text.visible_characters = round(chars)
	$Textbox/Text.modulate = Color.white if (Global.savedata.get_value("cutscene_progress", name, 0) <= cur_event) else Global.settings.get_value("cutscene", "read_text_color", Color.lightblue)
	$Textbox/Arrow.visible = $Textbox/Text.percent_visible >= 1
	advance_grace -= delta

var advance_grace = 0	# prevents the user from
						# advancing textbox when they meant to fast-forward text

func _advance_inputted(event):
	if not event.pressed:
		if waiting_for_user:
			if $Textbox/Text.percent_visible < 1 or advance_grace >= 0:
				chars = len($Textbox/Text.text)
				advance_grace = 0
			else:
				waiting_for_user = false
				if wait_t > 0 and Global.settings.get_value("cutscene", "allow_skipping_wait", false):
					wait_t = 0

var skip_t = 0
func _process_skip(delta):
	if Input.is_action_pressed("skip"):
		if Global.savedata.get_value("cutscene_progress", name, 0) > cur_event or Global.settings.get_value("cutscene", "skip_unread", false):
			if skip_t < 0:
				waiting_for_user = false
				wait_t = 0
				skip_t = Global.settings.get_value("cutscene", "skip_delay", 0.05)
			var objects = [self, $Textbox, Song.stream]
			for obj in objects:
				Global.finish_all_tweens(obj)
			chars = len($Textbox/Text.text)
	skip_t -= delta

func set_textbox(text, final):
	$Textbox/Text.text = text
	chars = 0
	$Textbox/Arrow.rect_rotation = 90 if final else 0
