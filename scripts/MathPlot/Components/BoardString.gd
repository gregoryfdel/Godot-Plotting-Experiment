extends Node2D
class_name BoardString

enum AnchorTypes {
	BottomLeft = 0,
	BottomCenter = 1,
	BottomRight = 2,
	TopRight = 3,
	TopCenter = 4,
	TopLeft = 5,
	Left = 6,
	Right = 7
}

var held_str: String = ""
var str_pos = null

var font = null
var color: Color = Color.white
var anchor = AnchorTypes.BottomLeft

func _ready():
	var label = Label.new()
	font = label.get_font("")
	label.queue_free()

func init_node(in_str_pos: Vector2, in_str: String, parent_board):
	str_pos = BoardPoint.new(in_str_pos.x, in_str_pos.y, self, parent_board)
	held_str = in_str
	update()

func set_font(in_font_path: String):
	font.font_data = load(in_font_path)
	update()

func set_size(in_size: int):
	font.size = in_size
	update()

func set_color(in_color: Color):
	color = in_color
	update()

func set_x(in_x: float):
	str_pos.x = in_x
	update()
	
func set_y(in_y: float):
	str_pos.y = in_y
	update()
	
func set_anchor(in_anchor: int):
	anchor = in_anchor
	update()

func _draw():
	var str_size = font.get_string_size(held_str)
	var new_pos = str_pos.get_position()
	match anchor:
		AnchorTypes.BottomCenter:
			new_pos += Vector2(-str_size.x/2, 0)
		AnchorTypes.BottomRight:
			new_pos += Vector2(-str_size.x, 0)
		AnchorTypes.TopRight:
			new_pos += Vector2(-str_size.x, str_size.y)
		AnchorTypes.TopCenter:
			new_pos += Vector2(-str_size.x/2, str_size.y)
		AnchorTypes.TopLeft:
			new_pos += Vector2(0, str_size.y)
		AnchorTypes.Left:
			new_pos += Vector2(0, str_size.y/2)
		AnchorTypes.Right:
			new_pos += Vector2(-str_size.x, str_size.y/2)
	
	draw_string(font, new_pos, held_str, color)

