extends CharacterBody2D

@export var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var up_speed : float = 0.0
@export var horiz_speed : float = 0.0

@export var max_up_speed : float = 0.0
@export var max_horiz_speed : float = 0.0

@export var up_speed_dec : float = 0.0
@export var horiz_speed_dec : float = 0.0

@export var up_speed_min : float = 0.0
@export var horiz_speed_min : float = 0.0

@export var up_speed_min_diff : float = 0.0
@export var horiz_speed_min_diff : float = 0.0

@export var no_input : bool = false
@export var is_jumping : bool = false
@export var grounded : bool = true

@export var playerStartPos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	up_speed = 0.0
	horiz_speed = 0.0
	max_up_speed = 500.0
	max_horiz_speed = 250.0
	up_speed_dec = 100.0
	horiz_speed_dec = 100.0
	up_speed_min = 0.0
	horiz_speed_min = 0.0
	up_speed_min_diff = 0.1
	horiz_speed_min_diff = 0.1
	no_input = false
	is_jumping = false
	grounded = true
	playerStartPos = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if no_input == true:
		if horiz_speed < -horiz_speed_min_diff:
			horiz_speed += _delta * horiz_speed_dec
		elif  horiz_speed > horiz_speed_min_diff:
			horiz_speed -= _delta * horiz_speed_dec
		else:
			horiz_speed = horiz_speed_min

	if is_jumping == true && grounded == true:
		up_speed = max_up_speed
		grounded = false
	elif grounded == false:
		if up_speed > up_speed_min_diff:
			up_speed -= _delta * up_speed_dec
		else:
			up_speed = up_speed_min

	_player_death()

func _physics_process(_delta: float) -> void:
	position.x += _delta * horiz_speed
	position.y -= _delta * up_speed

	if not is_on_floor():
		grounded = false
		velocity.y += gravity * _delta
	else:
		grounded = true
		up_speed = up_speed_min

	move_and_slide()

func _input(_event: InputEvent) -> void:
	if _event is InputEventKey and _event.keycode == KEY_LEFT:
		if _event.is_pressed():
			horiz_speed = -max_horiz_speed
			no_input = false
		else:
			no_input = true

	if _event is InputEventKey and _event.keycode == KEY_RIGHT:
		if _event.is_pressed():
			horiz_speed = max_horiz_speed
			no_input = false
		else:
			no_input = true

	if _event is InputEventKey and ((_event.keycode == KEY_UP) || (_event.keycode == KEY_SPACE)):
		if _event.is_pressed():
			is_jumping = true
		else:
			is_jumping = false

func _player_death() -> void:
	if position.y > 150.0:
		position = playerStartPos
		up_speed = 0.0
		horiz_speed = 0.0
		no_input = false
		is_jumping = false
		grounded = true
