extends CharacterBody2D

#@export var forward_vector : Vector2 = global_transform.x
#@export var up_vector : Vector2 = -global_transform.y

@export var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var up_speed : float = 0.0
@export var horiz_speed : float = 0.0

@export var no_input : bool = false
@export var is_jumping : bool = false
@export var grounded : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	up_speed = 0.0
	horiz_speed = 0.0
	no_input = false
	is_jumping = false
	grounded = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if no_input == true:
		if horiz_speed < -0.1:
			horiz_speed += _delta * 100.0
		elif  horiz_speed > 0.1:
			horiz_speed -= _delta * 100.0
		else:
			horiz_speed = 0.0

	if is_jumping == true && grounded == true:
		up_speed = 500.0
		grounded = false
	elif grounded == false:
		if up_speed > 0.1:
			up_speed -= _delta * 100.0
		else:
			up_speed = 0.0

	#print(up_speed)

func _physics_process(_delta: float) -> void:
	position.x += _delta * horiz_speed
	position.y -= _delta * up_speed

	if not is_on_floor():
		grounded = false
		velocity.y += gravity * _delta
	else:
		grounded = true
		up_speed = 0.0

	move_and_slide()

func _input(_event: InputEvent) -> void:
	if _event is InputEventKey and _event.keycode == KEY_LEFT:
		if _event.is_pressed():
			#print("LEFT KEY PRESSED")
			horiz_speed = -250.0
			no_input = false
		else:
			no_input = true

	if _event is InputEventKey and _event.keycode == KEY_RIGHT:
		if _event.is_pressed():
			#print("RIGHT KEY PRESSED")
			horiz_speed = 250.0
			no_input = false
		else:
			no_input = true

	if _event is InputEventKey and _event.keycode == KEY_UP:
		if _event.is_pressed():
			is_jumping = true
		else:
			is_jumping = false
