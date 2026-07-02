extends RigidBody2D

@export var forward_vector : Vector2 = -global_transform.x
@export var up_vector : Vector2 = -global_transform.y

@export var up_speed : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	up_speed = 20.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(_event: InputEvent) -> void:
	if _event is InputEventKey and _event.keycode == KEY_LEFT:
		if _event.is_pressed():
			print("LEFT KEY PRESSED")
			apply_impulse(-forward_vector)

	if _event is InputEventKey and _event.keycode == KEY_RIGHT:
		if _event.is_pressed():
			print("RIGHT KEY PRESSED")
			apply_impulse(forward_vector)

	if _event is InputEventKey and _event.keycode == KEY_UP:
		if _event.is_pressed():
			print("UP KEY PRESSED")
			apply_impulse(up_vector * up_speed)
