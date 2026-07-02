extends Node2D

const PLAYER_SCENE = preload("res://TSCN/player.tscn")
const BACKGROUND_SCENE = preload("res://TSCN/background.tscn")
const GROUND_SCENE = preload("res://TSCN/ground.tscn")

@export var groundMaxNum : int = 0
@export var groundCount : int = 0
@export var groundArr : Array[Node2D] = []

@export var xBeginOffset : float = 0.0
@export var yBeginOffset : float = 0.0
@export var xOffset : float = 0.0
@export var yOffset : float = 0.0

@export var xBackCenter : float = 0.0
@export var yBackCenter : float = 0.0

@export var xPCenter : float = 0.0
@export var yPCenter : float = 0.0

@export var playerNode : Node2D
@export var backgroundNode : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	groundMaxNum = 40
	groundCount = 0

	xBeginOffset = 0.0
	yBeginOffset = 600.0
	xOffset = 40.0
	yOffset = 0.0

	xBackCenter = 550.0
	yBackCenter = 350.0

	xPCenter = 50.0
	yPCenter = 550.0

	_spawn_background()
	_spawn_ground()
	_spawn_player()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _spawn_background() -> void:
	var background_instance = BACKGROUND_SCENE.instantiate()
	background_instance.global_position.x = xBackCenter
	background_instance.global_position.y = yBackCenter
	add_child(background_instance)
	backgroundNode = background_instance

func _spawn_ground() -> void:
	var ground_instance
	for k in groundMaxNum:
		if k >= 15 && k < 20:
			continue

		ground_instance = GROUND_SCENE.instantiate()
		ground_instance.global_position.x = xBeginOffset + (k * xOffset)
		ground_instance.global_position.y = yBeginOffset
		add_child(ground_instance)
		groundArr.append(ground_instance)
		groundCount += 1

func _spawn_player() -> void:
	var player_instance = PLAYER_SCENE.instantiate()
	player_instance.global_position.x = xPCenter
	player_instance.global_position.y = yPCenter
	add_child(player_instance)
	playerNode = player_instance
