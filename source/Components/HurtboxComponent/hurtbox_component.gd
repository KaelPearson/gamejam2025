extends Area2D
class_name HurtboxComponent;

## Area where we get hurt. Assigned per inst
@export var hurtbox : CollisionShape2D;

## Players health_component
@export var health_component : HealthComponent;

func damage (attack_damage : int) :
	if (health_component) :
		health_component.damage(attack_damage);
