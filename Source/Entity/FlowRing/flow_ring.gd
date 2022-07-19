extends Node2D

#  -------------------------------------------------------------------------
# |  MAIN                                                                   |
#  -------------------------------------------------------------------------

func _ready_flow():
	for i in range(12):
		flow[i] = 1/12.0

func _process_test_random_flow(dt):
	flow[0] = 1
	var p = 0
	p -= 12 if p >= 6 else 0
	for i in range(len(flow)):
		if i == 6 or i == 5 or i == 7:
			flow[i] = 0
			continue
		var j = i if i < 6 else 12-i
		flow[i] = 3.0/pow(2, j+1) * (randf()/3+1.0/3)
	#for i in range(0, p + (1 if p > 0 else -1), 1 if p > 0 else -1):
	#	flow[(i+12)%12] *= 0.5

func pull_to(idx, dt):
	var total = 0
	for i in range(len(flow)):
		var d = flow[i] * dt
		total += d
		flow[i] -= d
	flow[idx] += total

func _process_update_flow(dt):
	return
	var gradient = Gradient.new()
	gradient.offsets = []
	gradient.colors = []
	gradient.add_point(0, Color.white if not Global.player else Global.get_color(Global.deg_to_hue(Global.player.root), 1, 1))
	gradient.add_point(0.5/12.0, Color.white if not Global.player else Global.get_color(Global.deg_to_hue(Global.player.root), 1, 1))
	gradient.add_point(2/12.0, Color.black if not Global.player else Global.get_color(Global.deg_to_hue(Global.player.root+7), 1, 1))
	gradient.add_point(0.49999, Color.black if not Global.player else Global.get_color(Global.deg_to_hue(Global.player.root+7), 0, 0.5))
	gradient.add_point(0.50001, Color.black if not Global.player else Global.get_color(Global.deg_to_hue(Global.player.root+5), 0, 0.5))
	gradient.add_point(1-2/12.0, Color.black if not Global.player else Global.get_color(Global.deg_to_hue(Global.player.root+5), 1, 1))
	gradient.add_point(1-0.5/12.0, Color.white if not Global.player else Global.get_color(Global.deg_to_hue(Global.player.root), 1, 1))
	#print(gradient.offsets)
	#print(gradient.colors)
	$Line2D.gradient = gradient

#  -------------------------------------------------------------------------
# |  VISUALS                                                                |
#  -------------------------------------------------------------------------

export var radius = 100
export var resolution = 12

func _resolution_updated():
	$Line2D.points = []
	$Line2D.add_point(Vector2(radius, -4))
	for i in range(1, resolution):
		$Line2D.add_point(Vector2(radius, 0).rotated(i*2*PI/resolution))
	$Line2D.add_point(Vector2(radius, 4))

var flow = [0,0,0,0,0,0,0,0,0,0,0,0]

func _flow_updated():
	print(flow)
	for i in range(len(flow)):
		$Line2D.width_curve.set_point_value(i, flow[i])
	$Line2D.width_curve.set_point_value(len(flow), flow[0])
