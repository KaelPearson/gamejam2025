extends Area2D
class_name Consumable

@export var coin_amt : int = 0;
@export var heat_amt : float = 0.0;
@export var air_amt : float = 0.0;
@export var life_amt : int = 0;

@onready var pickup_sfx := $PickupSFX
@onready var pickup_sfx_underwater := $PickupSFXUnderwater

func _ready() -> void:
	area_entered.connect(_area_entered)

#func play_one_shot(stream: AudioStream, position: Vector2 = Vector2.ZERO):
	#var player = AudioStreamPlayer2D.new()  # or AudioStreamPlayer2D for 2D games
	#player.stream = stream
	#player.transform.origin = position
	#get_tree().current_scene.add_child(player)
	#player.play()
	#player.connect("finished", Callable(player, "queue_free"), CONNECT_ONE_SHOT)
var air = false;
func _area_entered(_area: Area2D) -> void :
	var bodies = get_overlapping_areas();
	for body in bodies :
		
		if (body is air_area) :
			air = true;
		if (body is HurtboxComponent) :
			body.collect_to_player(heat_amt, air_amt, coin_amt, life_amt);
			#play_one_shot($PickupSFX.stream, $PickupSFX.position)
			$Sprite.hide()
			if (air) :
				$PickupSFX.play()
				await pickup_sfx.finished
			else :
				$PickupSFXUnderwater.play()
				await pickup_sfx_underwater.finished
				
			queue_free();
			
			
