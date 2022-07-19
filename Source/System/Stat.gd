extends Reference
class_name Stat

var _base = 0

func _init(value):
	_base = value
	val = _base

enum ModType { PRE_ADDITIVE, POST_ADDITIVE, \
	ADDITIVE_MULTIPLIER, MULTIPLICATIVE_MULTIPLIER}

var mods = {}

func affirm_mod(label, mod_type, value):
	mods[label] = {"type":mod_type, "value":value}
	recalculate()

func deny_mod(label):
	if mods.has(label):
		mods.erase(label)
	recalculate()


var val = 0

func recalculate():
	val = _base
	var post = 0
	var add_mul = 1
	var mul_mul = 1
	print(len(mods))
	for mod in mods.values():
		match(mod.type):
			ModType.PRE_ADDITIVE:
				val += mod.value
			ModType.POST_ADDITIVE:
				post += mod.value
			ModType.ADDITIVE_MULTIPLIER:
				add_mul += mod.value - 1
			ModType.MULTIPLICATIVE_MULTIPLIER:
				mul_mul *= mod.value
	val = (val * add_mul * mul_mul) + post
