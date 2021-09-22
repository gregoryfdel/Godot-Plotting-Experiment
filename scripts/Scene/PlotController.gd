extends Node2D

func _ready():
	$AddBtn.connect("button_up",self, "add_sine")
	$RemoveBtn.connect("button_up", self, "remove_sine")
	$ChangeExtentBtn.connect("button_up", self, "change_extent")
	$ToCosBtn.connect("button_up", self, "modify_fn")
	$AddGrid.connect("button_up", self, "add_grid")

func sine(in_x: float):
	return sin(in_x)

func cosine(in_x: float):
	return cos(in_x)

func add_sine():
	var sine_ref = funcref(self, "sine")
	$MathBoard.add_fn("sin_fn", sine_ref, -2, 2, 0.1)

func remove_sine():
	$MathBoard.remove_fn("sin_fn")

func change_extent():
	$MathBoard.set_extents(Vector2(-2, -2), Vector2(2, 2))

func modify_fn():
	var cosine_ref = funcref(self, "cosine")
	$MathBoard.transform_fn("sin_fn", cosine_ref, 5.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

func add_grid():
	$MathBoard.add_grid(Vector3(-3.0, 3.0, 0.25), Vector3(-3.0, 3.0, 0.25))
