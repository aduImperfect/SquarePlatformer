extends RigidBody2D

@export var forward_vector : Vector2 = -global_transform.x
@export var up_vector : Vector2 = -global_transform.y

@export var up_speed : float = 0.0
@export var horiz_speed : float = 0.0

@export var no_input : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	up_speed = 20.0
	horiz_speed = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if no_input == true:
		if horiz_speed < -0.1:
			horiz_speed += _delta * 20.0
		elif  horiz_speed > 0.1:
			horiz_speed -= _delta * 20.0
		else:
			horiz_speed = 0.0
	#print(horiz_speed)

func _physics_process(_delta: float) -> void:
	position.x += _delta * horiz_speed

func _input(_event: InputEvent) -> void:
	if _event is InputEventKey and _event.keycode == KEY_LEFT:
		if _event.is_pressed():
			#print("LEFT KEY PRESSED")
			horiz_speed = -50.0
			no_input = false
		else:
			no_input = true

	if _event is InputEventKey and _event.keycode == KEY_RIGHT:
		if _event.is_pressed():
			#print("RIGHT KEY PRESSED")
			horiz_speed = 50.0
			no_input = false
		else:
			no_input = true

	#if _event is InputEventKey and _event.keycode == KEY_UP:
		#if _event.is_pressed():
			#print("UP KEY PRESSED")
			#apply_force(up_vector * up_speed)
