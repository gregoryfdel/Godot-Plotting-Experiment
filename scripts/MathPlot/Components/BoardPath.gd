extends Node2D
class_name BoardPath

export(float) var spline_length = 0.2

onready var pt_list := []
onready var drawn_path := Curve2D.new()
onready var is_baked := false
onready var tween_list := []
onready var tween_finished := 0

static func rangef(start: float, end: float, step: float) -> Array:
	var res := Array()
	var i := start
	while i < end:
		res.push_back(i)
		i += step
	return res

func reset_tweens() -> void:
	if len(tween_list) > 0:
		for tween in tween_list:
			self.remove_child(tween)
			tween.free()
	tween_list.resize(0)

func reset():
	pt_list.resize(0)
	drawn_path.clear_points()
	is_baked = false
	reset_tweens()
	tween_finished = 0

func init_node(input_fn: FuncRef, start_x: float, end_x: float, step: float, board_par):
	reset()
	var input_xs = rangef(start_x, end_x, step)
	for in_x in input_xs:
		var in_y = input_fn.call_func(in_x)
		pt_list.append(BoardPoint.new(in_x, in_y, self, board_par))
	update()

func update_fn(new_fn: FuncRef):
	for board_pt in pt_list:
		var in_x = board_pt.get_board_x()
		board_pt.y = new_fn.call_func(in_x)
	update()

func update():
	is_baked = false
	.update()

func transition_finish():
	tween_finished += 1

func transition_fn(new_fn: FuncRef, duration: float, tween_type: int, ease_type: int):
	tween_finished = 0
	reset_tweens()
	for board_pt in pt_list:
		var in_x: float = board_pt.get_board_x()
		var old_y: float = board_pt.get_board_y()
		var new_y: float = new_fn.call_func(in_x)
		var tweener := Tween.new()
		tweener.interpolate_property(board_pt, "y", old_y, new_y, duration, tween_type, ease_type)
		self.add_child(tweener)
		tweener.connect("tween_completed", self, "transition_finish")
		tween_list.append(tweener)
	
	for tween in tween_list:
		tween.start()


func _get_draw_spline(i):
	var last_point = _get_draw_point(i - 1)
	var next_point = _get_draw_point(i + 1)
	var spline = last_point.direction_to(next_point) * spline_length
	return spline

func _get_draw_point(i):
	var point_count = drawn_path.get_point_count()
	i = wrapi(i, 0, point_count - 1)
	return drawn_path.get_point_position(i)

func straighten_draw():
	for i in drawn_path.get_point_count():
		drawn_path.set_point_in(i, Vector2())
		drawn_path.set_point_out(i, Vector2())

func smooth_draw():
	var point_count = drawn_path.get_point_count()
	for i in point_count:
		var spline = _get_draw_spline(i)
		drawn_path.set_point_in(i, -spline)
		drawn_path.set_point_out(i, spline)

func make_draw_path():
	drawn_path.clear_points()
	for pt in pt_list:
		drawn_path.add_point(pt.get_position())
	smooth_draw()
	is_baked = true

func _draw():
	if (not is_baked) or (len(tween_list) != tween_finished):
		make_draw_path()
	var points = drawn_path.get_baked_points()
	if points:
		draw_polyline(points, Color.black, 2, true)
