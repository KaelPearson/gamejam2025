extends Node

var player_scene = preload("res://Entities/Player/player.tscn")


## Menu Container
@export var menu_ui : Control;
var menu_visible : bool = true;

@onready var in_air_area : Area2D = $InAirArea
@onready var despawner: Area2D = $Despawner
@onready var spawners := [
	$AirEnemySpawner,
	$GroundEnemySpawner,
	$AirConsumableSpawner,
]


func _ready() -> void:
	despawner.area_entered.connect(_on_despawner_entered)
	for spawner in spawners:
		spawner.enabled = false

func _unhandled_key_input(event: InputEvent) -> void:
	if (menu_visible) :
		_hide_main_menu();
		_spawn_player()
		for spawner in spawners:
			spawner.enabled = true
	
	
func _hide_main_menu() -> void :
	menu_visible = false;
	while (menu_ui.position.y < 1000) :
		menu_ui.position.y -= 40;
		await get_tree().create_timer(.01).timeout 


func _spawn_player() -> void:
	var player_instance = player_scene.instantiate()
	add_child(player_instance)
	player_instance.global_position.y = 850
	player_instance.velocity.y = -750
	var tween = create_tween()
	tween.tween_property(player_instance, "global_position:x", 350, 1.0)


func _on_despawner_entered(area):
	if area is Consumable:
		area.queue_free()
	else:
		area.get_parent().queue_free()
