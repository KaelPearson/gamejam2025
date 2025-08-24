extends Node

var player = null
var difficulty := 1.0
## how much difficulty increases per second
var difficulty_rate := 0.01

signal player_set

func _ready() -> void:
	player_set.connect(_on_player_set)

func _process(delta: float) -> void:
	# if a player is set that means a game is running
	if player:
		# currently difficult scales linearly
		difficulty += difficulty_rate * delta

func _on_player_set():
	difficulty = 1.0
