extends Node2D
class_name BoardGrid

var x_line_par := Vector3.ZERO
var y_line_par := Vector3.ZERO
var board_parent = null

var grid_line_color := Color(0.1, 0.1, 0.1, 0.5)
var axis_line_color := Color(0.8, 0.8, 0.8, 0.5)

var axis_lines = {'x': null, 'y': null}

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
	for x in xs:
		var new_line = BoardLine.new()
		self.add_child(new_line)
		# init_node(start_pt: Vector2, end_pt: Vector2, board_par)
		new_line.init_node(Vector2(x, bottom_left.y), Vector2(x, top_right.y), board_parent, grid_line_color, 1.0)
	for y in ys:
		var new_line = BoardLine.new()
		self.add_child(new_line)
		# init_node(start_pt: Vector2, end_pt: Vector2, board_par)
		new_line.init_node(Vector2(bottom_left.x, y), Vector2(top_right.x, y), board_parent, grid_line_color, 1.0)

func reset():
	for child in self.get_children():
		self.remove_child(child)
		child.free()

func init_node(x_setup: Vector3, y_setup: Vector3, board_par):
	x_line_par = x_setup
	y_line_par = y_setup
	board_parent = board_par
	
	rebuild_grid()

func rebuild_grid():
	reset()
	make_lines()
	add_axis(Vector2(0.0, 0.0))
	update()


func add_axis(origin: Vector2):
	for axis_line in axis_lines.values():
		if axis_line != null:
			remove_child(axis_line)
			axis_line.free()
			axis_line = null
	
	var bottom_left = board_parent.board_extents[0]
	var top_right = board_parent.board_extents[1]
	
	var x_axis = BoardLine.new()
	var y_axis = BoardLine.new()
	
	self.add_child(x_axis)
	self.add_child(y_axis)
	
	# init_node(start_pt: Vector2, end_pt: Vector2, board_par)
	x_axis.init_node(Vector2(origin.x, bottom_left.y), Vector2(origin.x, top_right.y), board_parent, axis_line_color, 1.5)
	y_axis.init_node(Vector2(bottom_left.x, origin.y), Vector2(top_right.x, origin.y), board_parent, axis_line_color, 1.5)
