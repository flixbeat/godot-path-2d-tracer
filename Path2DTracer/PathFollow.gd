extends Node2D

signal game_finished

export(Array, Resource) var curve_data_resources

onready var path = $Path2D
onready var path_follow = $Path2D/PathFollow2D
onready var sprite = $Path2D/PathFollow2D/Sprite
onready var timer_complete = $TimerComplete

var _allow_move: bool
var _curve_points: PoolVector2Array
var _idx_curve: int

var _draw_color: Color
var _draw_thickness: float

func _ready():
	sprite.connect("mouse_entered", self, "_on_mouse_entered")
	sprite.connect("mouse_exited", self, "_on_mouse_exited")
	timer_complete.connect("timeout", self, "_on_timer_complete_timeout")
	_load_curve_data()

func _load_curve_data():
	if _idx_curve == curve_data_resources.size():
		emit_signal("game_finished")
		print("game finished")
		return
	
	path.curve = curve_data_resources[_idx_curve]
	
	_curve_points = path.curve.get_baked_points()
	path_follow.offset = 0
	
	_pre_draw()

func _pre_draw():
	var color = Color.blue
	color.a = 0.2
	_draw_color = color
	_draw_thickness = 3
	update()
	
func _post_draw():
	_draw_color = Color.black
	_draw_thickness = 5
	update()

func _draw():
	draw_polyline(_curve_points, _draw_color, _draw_thickness)

func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var mouse_pos = get_global_mouse_position()
		
		if _allow_move:
			path_follow.offset = path.curve.get_closest_offset(mouse_pos)
		else:
			_reset_progress()
		
		if path_follow.unit_offset == 1:
			_complete()

func _input(event):
	if event is InputEventMouseButton and !event.pressed:
		_reset_progress()

func _complete():
	set_process(false)
	set_process_input(false)
	_post_draw()
	
	timer_complete.start()
		
func _reset_progress():
	path_follow.offset = 0
	_pre_draw()

func _on_mouse_entered():
	_allow_move = true
	
func _on_mouse_exited():
	_allow_move = false;

func _on_timer_complete_timeout():
	_idx_curve += 1
	_load_curve_data()
	set_process(true)
	set_process_input(true)
