extends Area2D
class_name Spawner;

## Time between spawns
@export var spawn_time : float = 5;

## Lazy but this is not for collision but defining area to spawn unit
@export var col_shape : CollisionShape2D;

@export var to_spawn : PackedScene;

@onready var col_center_pos = col_shape.position;
@onready var col_size = col_shape.shape.extents;

var enabled = false;
func _ready() -> void:
	var spawn_timer = Timer.new();
	add_child(spawn_timer);
	spawn_timer.wait_time = spawn_time;
	spawn_timer.one_shot = false;
	spawn_timer.start()
	spawn_timer.timeout.connect(_spawn);

func _spawn() -> void :
	if (!enabled) : return;
	var rand_y = (randi() % int(col_size.y * 2));
	var spawn = to_spawn.instantiate()
	spawn.position = Vector2i(50, rand_y + (col_center_pos.y - col_size.y))
	add_child(spawn)
