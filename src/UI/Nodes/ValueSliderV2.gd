@tool
class_name ValueSliderV2
extends HBoxContainer
## A class that combines two ValueSlider nodes, for easy usage with Vector2 values.
## Also supports aspect ratio locking.

signal value_changed(value: Vector2)
signal ratio_toggled(button_pressed: bool)

@export var editable := true:
	set(val):
		editable = val
@export var value := Vector2.ZERO:
	set(val):
		value = val
@export var min_value := Vector2.ZERO:
	set(val):
		min_value = val
@export var max_value := Vector2(100.0, 100.0):
	set(val):
		max_value = val
@export var step := 1.0:
	set(val):
		step = val
@export var allow_greater := false:
	set(val):
		allow_greater = val
@export var allow_lesser := false:
	set(val):
		allow_lesser = val
@export var show_ratio := false:
	set(val):
		show_ratio = val
@export var grid_columns := 1:
	set(val):
		grid_columns = val
@export var slider_min_size := Vector2(32, 24):
	set(val):
		slider_min_size = val
@export var snap_step := 1.0:
	set(val):
		snap_step = val
@export var snap_by_default := false:
	set(val):
		snap_by_default = val
@export var prefix_x := "X:":
	set(val):
		prefix_x = val
@export var prefix_y := "Y:":
	set(val):
		prefix_y = val
@export var suffix_x := "":
	set(val):
		suffix_x = val
@export var suffix_y := "":
	set(val):
		suffix_y = val

var ratio := Vector2.ONE
var _locked_ratio := false
var _can_emit_signal := true


func get_sliders() -> Array[ValueSlider]:
	return []


func press_ratio_button(pressed: bool) -> void:
	return
