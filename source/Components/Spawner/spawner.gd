extends Area2D
class_name Spawner;

## Time between spawns
@export var spawn_time : float = 5;

## Lazy but this is not for collision but defining area to spawn unit
@export var col_shape : CollisionShape2D;

@export var to_spawn : Array[PackedScene];

@onready var col_center_pos = col_shape.position;
@onready var col_size = col_shape.shape.extents;
@onready var spawn_timer = Timer.new();

var enabled = false;
func _ready() -> void:
	add_child(spawn_timer);
	spawn_timer.wait_time = spawn_time;
	spawn_timer.one_shot = false;
	spawn_timer.start()
	spawn_timer.timeout.connect(_spawn);

func _spawn() -> void :
	if (!enabled) : return;
	var rand_y = randi_range(0, col_size.y);
	var arr_num = randi_range(0, to_spawn.size()-1);
	var spawn = to_spawn[arr_num].instantiate()
	spawn.global_position = global_position + Vector2(0, rand_y)
	get_parent().add_child(spawn)

func _process(delta: float) -> void:
	spawn_timer.wait_time = spawn_time / Globals.difficulty
