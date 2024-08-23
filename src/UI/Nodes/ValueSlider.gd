@tool
class_name ValueSlider
extends TextureProgressBar
## Custom node that combines the behavior of a Slider and a SpinBox.
## Initial version made by MrTriPie, has been modified by Overloaded.

enum { NORMAL, HELD, SLIDING, TYPING }

@export var editable := true:
	set(v):
		editable = v
@export var prefix: String:
	set(v):
		prefix = v
@export var suffix: String:
	set(v):
		suffix = v
## Size of additional snapping (applied in addition to Range's step).
## This should always be larger than step.
@export var snap_step := 1.0
## If snap_by_default is true, snapping is enabled when Control is NOT held (used for sliding in
## larger steps by default, and smaller steps when holding Control).
## If false, snapping is enabled when Control IS held (used for sliding in smaller steps by
## default, and larger steps when holding Control).
@export var snap_by_default := false
## If show_progress is true it will show the colored progress bar, good for values with a specific
## range. False will hide it, which is good for values that can be any number.
@export var show_progress := true
@export var show_arrows := true:
	set(v):
		show_arrows = v
@export var echo_arrow_time := 0.075
@export var global_increment_action := ""  ## Global shortcut to increment
@export var global_decrement_action := ""  ## Global shortcut to decrement

var state := NORMAL
var arrow_is_held := 0  ## Used for arrow button echo behavior. Is 1 for ValueUp, -1 for ValueDown.


func _init() -> void:
	pass
