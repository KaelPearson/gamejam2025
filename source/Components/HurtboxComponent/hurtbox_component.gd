extends Area2D
class_name HurtboxComponent;

## Area where we get hurt. Assigned per inst
@export var hurtbox : CollisionShape2D;

signal collect (heat_amt : float, air_amt : float, coin_amt : int, life_amt : int);

## Players health_component
@export var health_component : HealthComponent;

func damage (attack_damage : int) :
	if (health_component) :
		health_component.damage(attack_damage);

func collect_to_player (heat_amt : float, air_amt : float, coin_amt : int, life_amt : int) :
	collect.emit(heat_amt, air_amt, coin_amt, life_amt);
