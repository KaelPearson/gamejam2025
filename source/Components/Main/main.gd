extends Node

## Determines how fast projectiles should be speeding up
@export var increase_speed_amt : float = 1;

## Menu Container
@export var menu_ui : Control;
var menu_visible : bool = true;

func _unhandled_key_input(event: InputEvent) -> void:
	if (menu_visible) :
		_hide_main_menu();
	
	
func _hide_main_menu() -> void :
	menu_visible = false;
	while (menu_ui.position.y < 1000) :
		menu_ui.position.y -= 40;
		await get_tree().create_timer(.01).timeout 
