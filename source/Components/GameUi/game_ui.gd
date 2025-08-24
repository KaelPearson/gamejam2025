extends Control

@onready var score_label: Label = $CanvasLayer/MarginContainer/GridContainer/Score
@onready var heat: ProgressBar = $CanvasLayer/Heat
@onready var air: ProgressBar = $CanvasLayer/Air
@onready var finalscore: Label = $GameOver/MarginContainer2/GridContainer/finalscore
@onready var game_over: CanvasLayer = $GameOver
@onready var quotes: Label = $GameOver/MarginContainer/quotes

@onready var life_pool: Array[TextureRect] = [
	$CanvasLayer/MarginContainer/GridContainer2/life1,
	$CanvasLayer/MarginContainer/GridContainer2/life2,
	$CanvasLayer/MarginContainer/GridContainer2/life3,
]

var dog_quotes := [
	"Stay pawsitive — you’ll fetch victory next time!",
	"Don’t roll over yet, give it another try!",
	"Every dog has its day… and yours is coming.",
	"Keep barking up that tree — you’re close!",
	"Paw-sitively sure you’ll do better on the next run.",
	"Ruff game… were you even trying?",
	"You just let the tail wag the dog!",
	"That was a dog-gone disaster.",
	"Yikes, that performance was un-fur-gettable (in the worst way).",
	"Sit. Stay. Respawn."
]

func show_random_quote() -> void:
	var random_index = randi() % dog_quotes.size()
	quotes.text = '"' + dog_quotes[random_index] + '"'

const head_hurt = preload("res://Assets/ui/dead.png")
const head_full = preload("res://Assets/ui/alive.png")
@onready var highscore: Label = $GameOver/MarginContainer2/GridContainer/highscore

var score_value: float = 0.0
var score_running: bool = false
var max_health: int = 3
var current_health: int = max_health

func _ready() -> void:
	Globals.player_set.connect(_on_player_set)
	# Hide all children at the start
	for child in get_children():
		child.visible = false
	heat.value = 0.0
	air.value = 100.0
	show_random_quote()

func start_score() -> void:
	for child in get_children():
		child.visible = true
	game_over.visible = false
	
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

func _on_health_changed(current_health_amt):
	# just need to make this work...
	if (current_health_amt > current_health) :
		for health in range(max_health):
			if health <= current_health:
				life_pool[health].texture = head_full
		
	current_health = current_health_amt
	for health in range(max_health):
		if health >= current_health:
			life_pool[health].texture = head_hurt
		
			 
	if current_health <= 0:
		stop_score()
		game_over.visible = true
		finalscore.text = str(int(score_value))
		_update_highscore()
		
func _update_highscore() -> void:
	if score_value > Globals.high_score:
		Globals.high_score = score_value
	highscore.text = str(int(Globals.high_score))
