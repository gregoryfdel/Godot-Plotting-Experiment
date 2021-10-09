extends Node2D
class_name BoardGrid

var x_line_par := Vector3.ZERO
var y_line_par := Vector3.ZERO
var board_parent = null

var grid_line_color := Color(0.1, 0.1, 0.1, 0.5)
var axis_line_color := Color(0.8, 0.8, 0.8, 0.5)

var lines_node = null
var labels_node = null

static func rangef(start: float, end: float, step: float) -> Array:
	var res := Array()
	var i := start
	while i < end:
		res.push_back(i)
		i += step
	return res

func make_lines():
	var xs = rangef(x_line_par.x, x_line_par.y, x_line_par.z)
	var ys = rangef(y_line_par.x, y_line_par.y, y_line_par.z)
	var bottom_left = board_parent.board_extents[0]
	var top_right = board_parent.board_extents[1]
	
	var x_i = 0
	for x in xs:
		var new_line = BoardLine.new()
		new_line.name = "x_" + str(x_i)
		lines_node.add_child(new_line)
		# init_node(start_pt: Vector2, end_pt: Vector2, board_par)
		new_line.init_node(Vector2(x, bottom_left.y), Vector2(x, top_right.y), board_parent, grid_line_color, 1.0)
		x_i += 1
	
	var y_i = 0
	for y in ys:
		var new_line = BoardLine.new()
		new_line.name = "y_" + str(y_i)
		lines_node.add_child(new_line)
		# init_node(start_pt: Vector2, end_pt: Vector2, board_par)
		new_line.init_node(Vector2(bottom_left.x, y), Vector2(top_right.x, y), board_parent, grid_line_color, 1.0)
		y_i += 1


func add_axis(origin: Vector2):
	if self.has_node("x_axis"):
		self.get_node("x_axis").queue_free()
	
	if self.has_node("y_axis"):
		self.get_node("y_axis").queue_free()
	
	var bottom_left = board_parent.board_extents[0]
	var top_right = board_parent.board_extents[1]
	
	var x_axis = BoardLine.new()
	var y_axis = BoardLine.new()
	
	x_axis.name = "x_axis"
	y_axis.name = "y_axis"
	
	lines_node.add_child(x_axis)
	lines_node.add_child(y_axis)
	
	# init_node(start_pt: Vector2, end_pt: Vector2, board_par)
	x_axis.init_node(Vector2(origin.x, bottom_left.y), Vector2(origin.x, top_right.y), board_parent, axis_line_color, 1.5)
	y_axis.init_node(Vector2(bottom_left.x, origin.y), Vector2(top_right.x, origin.y), board_parent, axis_line_color, 1.5)

func add_labels():
	var all_lines = lines_node.get_children()
	if len(all_lines) == 0:
		return
	
	var screen_size = get_viewport().size
	for current_line in all_lines:
		var line_start = current_line.get_start().get_board_position()
		var line_end = current_line.get_end().get_board_position()
		
		var s_sp = current_line.get_start().get_position()
		var e_sp = current_line.get_end().get_position()
		if current_line.name.begins_with("x_"):
			var new_string = BoardString.new()
			var str_pos = line_start
			if min(abs(s_sp.x), abs(s_sp.x - screen_size.x)) < 10:
				continue
			new_string.name = current_line.name + "_label"
			new_string.init_node(str_pos, str(str_pos.x), board_parent)
			labels_node.add_child(new_string)
		
		if current_line.name.begins_with("y_"):
			var new_string = BoardString.new()
			var str_pos = line_end
			var screen_pos = current_line.get_end().get_position()
			if min(abs(e_sp.y), abs(e_sp.y - screen_size.y)) < 10:
				continue
			new_string.name = current_line.name + "_label"
			new_string.init_node(str_pos, str(str_pos.y), board_parent)
			new_string.set_anchor(7)
			labels_node.add_child(new_string)

func has_labels():
	if labels_node != null:
		var label_children = labels_node.get_children()
		if len(label_children) == 0:
			return false
		return true
	return false

func reset():
	for child in lines_node.get_children():
		lines_node.remove_child(child)
		child.free()
	
	for child in labels_node.get_children():
		labels_node.remove_child(child)
		child.free()

func init_node(x_setup: Vector3, y_setup: Vector3, board_par):
	x_line_par = x_setup
	y_line_par = y_setup
	board_parent = board_par
	
	lines_node = Node.new()
	lines_node.name = "lines"
	self.add_child(lines_node)
	labels_node = Node.new()
	labels_node.name = "labels"
	self.add_child(labels_node)
	
	rebuild_grid()

func rebuild_grid():
	var add_labels_later = has_labels()
	reset()
	make_lines()
	add_axis(Vector2(0.0, 0.0))
	if add_labels_later:
		add_labels()
	update()
