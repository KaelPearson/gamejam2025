extends Control

@onready var score_label: Label = $CanvasLayer/MarginContainer/GridContainer/Score
@onready var heat: ProgressBar = $CanvasLayer/Heat
@onready var air: ProgressBar = $CanvasLayer/Air

@onready var life_pool: Array[TextureRect] = [
	$CanvasLayer/MarginContainer/GridContainer2/life1,
	$CanvasLayer/MarginContainer/GridContainer2/life2,
	$CanvasLayer/MarginContainer/GridContainer2/life3,
]

var head_hurt = preload("res://Assets/dog/Dog_Head_Hit.webp")
var score_value: float = 0.0
var score_running: bool = false
var max_health: int = 3
var current_health: int = max_health

@export var heat_increase_rate: float = 1.0 
@export var air_decrease_rate: float = 1.0

func _ready() -> void:
	Globals.player_set.connect(_on_player_set)
	# Hide all children at the start
	for child in get_children():
		child.visible = false
	heat.value = 0.0
	air.value = 100.0

func start_score() -> void:
	for child in get_children():
		child.visible = true
	
	score_running = true

func stop_score() -> void:
	score_running = false

## Connect to player signals here
## Player signals cannot be set in the ready function as a player may not be set when the UI is first ready.
func _on_player_set():
	Globals.player.score_update.connect(_on_score_change)
	Globals.player.heat_update.connect(_on_heat_change)
	Globals.player.air_update.connect(_on_air_change)
	Globals.player.health_component.health_changed.connect(_on_health_changed)
	Globals.player.health_component.death.connect(stop_score)
	max_health = Globals.player.health_component.max_health
	current_health = Globals.player.health_component.current_health


func _on_heat_change(new_heat):
	if score_running:
		heat.value = clampf(new_heat, 0, 100)

func _on_air_change(new_air):
	if score_running:
		air.value = clampf(new_air, 0, 100)

func _on_score_change(new_score):
	if score_running:
		score_value = new_score
		score_label.text = str(int(new_score))

func _on_health_changed(amount):
	current_health += amount
	for health in range(max_health):
		if health >= current_health:
			life_pool[health].texture = head_hurt
