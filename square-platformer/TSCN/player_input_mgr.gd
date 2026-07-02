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
@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var WALL_SLIDE_SPEED = 100.0
@export var WALL_JUMP_PUSHBACK = 400.0
# --- Wall Jump Mechanics ---
@export var wall_jump_lock_timer = 0.0
@export var WALL_JUMP_LOCK_TIME = 0.10 # Time in seconds player control is locked

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
		velocity.y += gravity * _delta

	if wall_jump_lock_timer > 0:
		wall_jump_lock_timer -= _delta

	# 1. Handle Wall Sliding
	if is_on_wall() and not is_on_floor() and velocity.y > 0:
		velocity.y = min(velocity.y, WALL_SLIDE_SPEED)

	# 2. Handle Jumping
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif is_on_wall() and not is_on_floor():
			# Wall Jump: Use wall normal to push away
			velocity.x = get_wall_normal().x * WALL_JUMP_PUSHBACK
			velocity.y = JUMP_VELOCITY
			wall_jump_lock_timer = WALL_JUMP_LOCK_TIME

	# 3. Handle Horizontal Movement (with control lock)
	if wall_jump_lock_timer <= 0:
		var direction = Input.get_axis("ui_left", "ui_right")
		velocity.x = direction * SPEED
	else:
		# Air control during wall jump lock (optional, keeps inertia)
		velocity.x = move_toward(velocity.x, 0, 50)

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

	if _event is InputEventKey and _event.keycode == KEY_UP:
		if _event.is_pressed():
			is_jumping = true
		else:
			is_jumping = false
	
	if _event is InputEventKey and _event.keycode == KEY_SPACE:
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
