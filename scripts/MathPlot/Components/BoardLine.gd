extends Node2D
class_name BoardLine

var line_color = Color.black
var line_width = 2.0

onready var tween_list := []
onready var tween_finished := 0

var pt_holder = {"start": null, "end": null}

func reset_tweens() -> void:
	if len(tween_list) > 0:
		for tween in tween_list:
			self.remove_child(tween)
			tween.free()
	tween_list.resize(0)

func reset():
	pt_holder['start'] = null
	pt_holder['end'] = null
	reset_tweens()
	tween_finished = 0

func init_node(start_pt: Vector2, end_pt: Vector2, board_par, line_c = Color.black, line_w = 2.0):
	reset()
	pt_holder['start'] = BoardPoint.new(start_pt.x, start_pt.y, self, board_par)
	pt_holder['end'] = BoardPoint.new(end_pt.x, end_pt.y, self, board_par)
	
	line_color = line_c
	line_width = line_w
	update()

func transition_finish():
	tween_finished += 1

func transition_pts(new_start_pt: Vector2, new_end_pt: Vector2, duration: float, tween_type: int, ease_type: int):
	tween_finished = 0
	reset_tweens()
	var old_start_pt: Vector2 = pt_holder['start'].get_board_position()
	var old_end_pt: Vector2 = pt_holder['end'].get_board_position()
	if pt_holder['start'].global_sq_distance(new_start_pt, BoardPoint.position_type.BOARD) > 0.1:
		var tweener := Tween.new()
		tweener.interpolate_method(pt_holder['start'], "set_board_position", old_start_pt, new_start_pt, duration, tween_type, ease_type)
		self.add_child(tweener)
		tweener.connect("tween_completed", self, "transition_finish")
		tween_list.append(tweener)
	
	if pt_holder['end'].global_sq_distance(new_end_pt, BoardPoint.position_type.BOARD) > 0.1:
		var tweener := Tween.new()
		tweener.interpolate_method(pt_holder['end'], "set_board_position", old_end_pt, new_end_pt, duration, tween_type, ease_type)
		self.add_child(tweener)
		tweener.connect("tween_completed", self, "transition_finish")
		tween_list.append(tweener)
	
	for tween in tween_list:
		tween.start()

func _draw():
	if (pt_holder['start'] != null) and (pt_holder['end'] != null):
		var start: Vector2 = pt_holder['start'].get_position()
		var end: Vector2 = pt_holder['end'].get_position()
		draw_line(start, end, line_color, line_width, true)
