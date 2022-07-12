extends Node
class_name Notifier


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# 																					#
# 		So it's really tiring to keep going back to the beginning of a file every	#
# 	time I want to add a new function to _process() etc, so this streamlines that   #
# 	(I'll find out about the consequences).											#
# 																					#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


var on_ready := []
var on_process := []
var on_physics_process := []
var on_input := {}
var on_updated := {}

onready var dad := get_parent()

func _ready():
	var method_list := dad.get_method_list()
	method_list.sort()
	var rx := RegEx.new()

	var expr := ["^_ready_(.+)", "^_process_(.+)", "^_physics_process_(.+)"]
	for i in range(len(expr)):
		rx.compile(expr[i])
		for fun in method_list:
			var result = rx.search(fun.name)
			if result:
				get(["on_ready", "on_process", "on_physics_process"][i]).append(fun.name)

	expr = ["^_(.+)_inputted", "^_(.+)_updated"]
	for i in range(len(expr)):
		rx.compile(expr[i])
		for fun in method_list:
			var result := rx.search(fun.name)
			if result:
				var property := result.get_string(1)
				if not get(["on_input", "on_updated"][i]).has(property):
					get(["on_input", "on_updated"][i])[property] = []
				get(["on_input", "on_updated"][i])[property].append(fun.name)

	for fun in on_ready:
		dad.call(fun)
	for funcs in on_updated.values():
		for fun in funcs:
			dad.call(fun)
	initialize_state()

func _process(delta):
	for fun in on_process:
		dad.call(fun, delta)
	recalculate_state()

func _physics_process(delta):
	for fun in on_physics_process:
		dad.call(fun, delta)

func _input(event):
	for action in on_input.keys():
		if event.is_action(action):
			for fun in on_input[action]:
				dad.call(fun, event)

#  -------------------------
# |  PROPERTY WATCHERS      |
#  -------------------------

var last_state := {}

func initialize_state():
	for property in on_updated.keys():
		last_state[property] = dad.get(property)
		if last_state[property] is Array or last_state[property] is Dictionary:
			last_state[property] = last_state[property].hash()
		if last_state[property] is Stat:
			last_state[property] = last_state[property].val

func recalculate_state():
	var properties_changed = {}
	for property in on_updated.keys():
		var value = dad.get(property)
		var hsh = value
		if value is Array or value is Dictionary:
			hsh = value.hash()
		if value is Stat:
			hsh = value.val
		if hsh != last_state[property]:
			last_state[property] = hsh
			properties_changed[property] = value

	for property in properties_changed.keys():
		for fun in on_updated[property]:
			dad.call(fun)
