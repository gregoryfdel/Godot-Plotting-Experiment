extends Reference
class_name BoardPoint

enum position_type {BOARD, GLOBAL}

var x setget set_x, get_x
var y setget set_y, get_y

var parent_bd = null
var parent_component = null

var is_baked = false

func _init(in_x: float, in_y: float, parent_comp, parent_board) -> void:
	x = in_x
	y = in_y
	parent_component = parent_comp
	parent_bd = parent_board
	
	parent_bd.connect("board_updated", self, "board_change")

func board_to_global(in_pt: Vector2) -> Vector2:
	var global_position: Vector2 = parent_bd.scale * in_pt
	global_position = global_position + parent_bd.translation
	return global_position

func set_x(in_value: float) -> void:
	x = in_value
	parent_component.update()

func set_y(in_value: float) -> void:
	y = in_value
	parent_component.update()

func set_board_position(new_v: Vector2) -> void:
	x = new_v.x
	y = new_v.y
	parent_component.update()

func get_board_position() -> Vector2:
	return Vector2(x, y)

func get_board_x() -> float:
	return x
	
func get_board_y() -> float:
	return y

func get_position() -> Vector2:
	return board_to_global(Vector2(x, y))

func get_x() -> float:
	return get_position().x

func get_y() -> float:
	return get_position().y

func global_sq_distance(test_pt: Vector2, pos_type: int) -> float:
	var global_pos = test_pt
	if (pos_type == position_type.BOARD):
		global_pos = board_to_global(test_pt)
	return self.get_position().distance_squared_to(global_pos)

func board_change() -> void:
	parent_component.update()
