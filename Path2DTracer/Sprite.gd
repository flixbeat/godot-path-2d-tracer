extends Sprite

signal mouse_entered
signal mouse_exited

onready var area = $Area2D

func _ready():
	area.connect("mouse_entered", self, "_on_mouse_entered")
	area.connect("mouse_exited", self, "_on_mouse_exited")

func _on_mouse_entered():
	emit_signal("mouse_entered")
	
func _on_mouse_exited():
	emit_signal("mouse_exited")
