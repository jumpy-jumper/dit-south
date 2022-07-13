extends Node

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# 																					#
# 		SETTINGS																	#
# 																					#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

var settings := ConfigFile.new()
var savedata := ConfigFile.new()

func _ready_userdata():
	settings.load("user://settings.cfg")
	savedata.load("user://save0.dit")

func _exit_tree():
	settings.save("user://settings.cfg")
	savedata.save("user://save0.dit")


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# 																					#
# 		GLOBALS 																	#
# 																					#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

var cutscene = null

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# 																					#
# 		HELPERS 																	#
# 																					#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

var _tween_cache: = {}

func tween(object, property, initial, final, duration, trans = Tween.TRANS_LINEAR, override=true):
	if not _tween_cache.has(object):
		_tween_cache[object] = {}
	elif _tween_cache[object].has(property):
		if not override:
			return
		var tween : Tween = _tween_cache[object][property]
		if is_instance_valid(tween):
			tween.stop_all()
			tween.queue_free()
	var tween := Tween.new()
	add_child(tween)
	tween.interpolate_property(object, property, initial, final, duration, \
		Tween.TRANS_LINEAR, Tween.EASE_IN)
	_tween_cache[object][property] = tween
	tween.start()

	yield(tween, "tween_all_completed")

	if _tween_cache.has(object):
		if not is_instance_valid(object):
			_tween_cache.erase(object)
		else:
			if _tween_cache[object].has(property) \
				and _tween_cache[object][property] == tween\
				and is_instance_valid(tween):
					_tween_cache[object][property].queue_free()
					_tween_cache[object].erase(property)
			if _tween_cache[object].empty():
				_tween_cache.erase(object)

func finish_all_tweens(object):
	if _tween_cache.has(object):
		for property in _tween_cache[object]:
			_tween_cache[object][property].seek(_tween_cache[object][property].get_runtime())

func finish_tween(object, property):
	if _tween_cache.has(object) and _tween_cache[object].has(property):
		_tween_cache[object][property].seek(_tween_cache[object][property].get_runtime())

func stop_all_tweens(object):
	if _tween_cache.has(object):
		for property in _tween_cache[object]:
			if is_instance_valid(property):
				_tween_cache[property].stop_all()
				_tween_cache[property].queue_free()
	_tween_cache.erase(object)

func stop_tween(object, property):
	if _tween_cache.has(object) and _tween_cache[object].has(property):
			if is_instance_valid(property):
				_tween_cache[property].stop_all()
				_tween_cache[property].queue_free()
			_tween_cache[object].erase(property)

var _clerps = {}

func clerp(object, property, final, speed, override = true):
	if not _clerps.has(object):
		_clerps[object] = {}
	_clerps[object][property] = [final, speed, false]

func clerp_angle(object, property, final, speed, override = true):
	if not _clerps.has(object):
		_clerps[object] = {}
	_clerps[object][property] = [final, speed, true]

func _process_clerps(dt):
	pass
