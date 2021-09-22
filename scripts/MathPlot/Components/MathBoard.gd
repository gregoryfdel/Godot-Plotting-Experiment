extends ColorRect
class_name MathBoard

var board_extents := [Vector2(-1.0,-1.0), Vector2(1.0,1.0)]
var translation := Vector2.ZERO
var scale := Transform2D(Vector2.ZERO, Vector2.ZERO, Vector2.ZERO)
var scale_inverse := Transform2D(Vector2.ZERO, Vector2.ZERO, Vector2.ZERO)
var board_size := Vector2.ZERO

var draw_plots := {}
var grid_node = null

func _ready():
	var start_size = self.rect_size
	self.set_size(start_size)

func set_size(input_size: Vector2, keep_margins: bool=false) -> void:
	.set_size(input_size, keep_margins)
	scale.x.x = (input_size.x/(board_extents[1].x - board_extents[0].x))
	scale.y.y = -(input_size.y/(board_extents[1].y - board_extents[0].y))
	translation = scale*Vector2(board_extents[0].x, board_extents[1].y) * -1.0
	scale_inverse = scale.affine_inverse()

func set_extents(bottom_left: Vector2, top_right: Vector2):
	board_extents[0] = bottom_left
	board_extents[1] = top_right
	var cur_size = self.rect_size
	self.set_size(cur_size)
	for child in draw_plots.values():
		child.update()
	
	if grid_node != null:
		grid_node.rebuild_grid()

func add_fn(path_name: String, input_fn: FuncRef, start_x: float, end_x: float, step: float):
	if not draw_plots.has(path_name):
		var new_path = BoardPath.new()
		add_child(new_path)
		draw_plots[path_name] = new_path
		new_path.init_node(input_fn, start_x, end_x, step, self)

func remove_fn(path_name: String):
	if draw_plots.has(path_name):
		var working_plt = draw_plots[path_name]
		working_plt.free()
		draw_plots.erase(path_name)

func transform_fn(path_name: String, new_fn: FuncRef, duration: float, tween_type: int, ease_type: int):
	if draw_plots.has(path_name):
		var working_plt = draw_plots[path_name]
		working_plt.transition_fn(new_fn, duration, tween_type, ease_type)

func add_grid(x_setup: Vector3, y_setup: Vector3):
	if grid_node != null:
		grid_node.reset()
		self.remove_child(grid_node)
		grid_node.free()
	
	var new_grid = BoardGrid.new()
	self.add_child(new_grid)
	self.move_child(new_grid, 0)
	grid_node = new_grid
	new_grid.init_node(x_setup, y_setup, self)
