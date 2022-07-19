extends Node2D


export var _max_hp = 15000
var max_hp = Stat.new(_max_hp)

var hp: int = _max_hp

func take_damage(amount):
    hp = max(0, hp - amount)

func get_percentage():
    return float(hp)/max_hp.val