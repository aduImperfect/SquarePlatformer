extends RigidBody2D

#@export var forward_vector : Vector2 = global_transform.x
#@export var up_vector : Vector2 = -global_transform.y

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
			horiz_speed += _delta * 20.0
		elif  horiz_speed > 0.1:
			horiz_speed -= _delta * 20.0
		else:
			horiz_speed = 0.0

	if is_jumping == true && grounded == true:
		up_speed = 300.0
		grounded = false
	elif grounded == false:
		if up_speed > 0.1:
			up_speed -= _delta * 200.0
		else:
			up_speed = 0.0

	#print(up_speed)

func _physics_process(_delta: float) -> void:
	position.x += _delta * horiz_speed
	position.y -= _delta * up_speed


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

	if _event is InputEventKey and _event.keycode == KEY_UP:
		if _event.is_pressed():
			is_jumping = true
		else:
			is_jumping = false

func _on_body_entered(_body: Node) -> void:
	if _body.get_groups()[0] == "GROUND":
		print("I AM ON THE GROUND AGAIN!")
		grounded = true
		up_speed = 0.0

func _on_body_exited(_body: Node) -> void:
	if _body.get_groups()[0] == "GROUND":
		print("UP I GO!!")
		grounded = false
