extends Control

@onready var score_label: Label = $CanvasLayer/MarginContainer/GridContainer/Score
@onready var heat: ProgressBar = $CanvasLayer/Heat
@onready var air: ProgressBar = $CanvasLayer/Air


var score_value: float = 0.0
var score_running: bool = false
var heat_value: float = 0.0    
var air_value: float = 100.0  

@export var heat_increase_rate: float = 1.0 
@export var air_decrease_rate: float = 1.0

func _ready() -> void:
	# Hide all children at the start
	for child in get_children():
		child.visible = false
	heat.value = heat_value 
	air.value = air_value

func _process(delta: float) -> void:
	if score_running:
		score_value += 10 * delta  
		score_label.text = str(int(score_value))
		
	#for heat
	heat_value += heat_increase_rate * delta
	heat_value = min(heat_value, 100)  
	heat.value = heat_value
	
	#for air
	air_value -= air_decrease_rate * delta
	air_value = max(air_value, 0)
	air.value = air_value

func start_score() -> void:
	for child in get_children():
		child.visible = true
	score_running = true
	score_value = 0 
	  
	heat_value = 0
	heat.value = heat_value
	
	air_value = 100
	air_value = air_value

func stop_score() -> void:
	score_running = false
