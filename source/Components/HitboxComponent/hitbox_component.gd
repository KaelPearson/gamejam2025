extends Area2D
class_name HitboxComponent;
# This is to be added to enemys and anything that can hurt the player.
# Future additions can make it so player can shoot enemies or smth like that

## Hitbox shape that defines where gets hurt. Defined per enemy therefore needs to be assigned
@export var hitbox : CollisionShape2D;

## Amt of damage this should do. Default to 1 heart
@export var attack_damage : int = 1;

func _process(delta: float) -> void:
	var bodies = get_overlapping_areas();
	for body in bodies :
		if (body is HurtboxComponent) :
			body.damage(attack_damage);
