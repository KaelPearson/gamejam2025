extends CharacterBody2D
class_name Player

@export var heat_time : float = 1;
@export var oxy_time : float = 1;
@export var score_time: float = 1.0

var coins : int = 0;
var heat := 0.0
var air := 100.0
var score := 0.0
@onready var lives :int = $HealthComponent.current_health
@onready var health_component :HealthComponent = $HealthComponent
@onready var movement_component := $MovementComponent

var in_air := true
var is_dead := false

@onready var board := $Board
@onready var body := $Body
@onready var head := %Head

@onready var debug := $debug

@onready var hurt_sfx := $HurtSFX
@onready var death_sfx := $DeathSFX
@onready var hurt_sfx_underwater := $HurtSFXUnderwater
@onready var death_sfx_underwater := $DeathSFXUnderwater

@onready var water_enter_sfx := $WaterEnter
@onready var water_exit_sfx := $WaterExit


var head_appearance := {
	'default': preload("res://Assets/dog/Dog_Head_Default.png"),
	'air_1': preload("res://Assets/dog/Dog_Head_Air_1.png"),
	'air_2': preload("res://Assets/dog/Dog_Head_Air_2.png"),
	'hot_1': preload("res://Assets/dog/Dog_Head_Hot_1.png"),
	'hot_2': preload("res://Assets/dog/Dog_Head_Hot_2.png"),
	'hurt': preload("res://Assets/dog/Dog_Head_Hit.webp"),
}

var body_appearance := {
	'stand': preload("res://Assets/dog/Dog_Body_1.png"),
	'transition': preload("res://Assets/dog/Dog_Body_2.png"),
	'crouch': preload("res://Assets/dog/Dog_Body_3.png"),
	'up': preload("res://Assets/dog/Dog_Body_Up.webp"),
	'down': preload("res://Assets/dog/Dog_Body_Down.webp"),
}

var board_appearance := {
	'default': preload("res://Assets/board/Board.png"),
	'effects_1': preload("res://Assets/board/Board_Effects_1.png"),
	'effects_2': preload("res://Assets/board/Board_Effects_2.png"),
}

var hurt_sounds := {
	'above_water': preload("res://Assets/sfx/dog_hurt.wav"),
	'below_water': preload("res://Assets/sfx/dog_hurt_undewater.wav"),
}

var death_sounds := {
	'above_water': preload("res://Assets/sfx/death_howl.wav"),
	'below_water': preload("res://Assets/sfx/death_howl_underwater.wav"),
}

var splash_scene := preload("res://Components/particles/splash_particles.tscn")

## switch to "Air"/"Water"
signal switch(type: String)

## signal for when coins are updated for UI to attach to
signal coin_update(new_coins : int);
signal score_update(new_score: int);
signal heat_update(new_heat : float);
signal air_update(new_air : float);

func _ready() -> void:
	Globals.player = self
	Globals.player_set.emit()
	health_component.health_changed.connect(_on_health_changed)
	health_component.death.connect(_on_death)
	var parent := get_parent()
	if parent.in_air_area:
		parent.in_air_area.area_entered.connect(_on_air_area_entered)
		parent.in_air_area.area_exited.connect(_on_air_area_exited)

func _process(delta: float) -> void:
	debug.text = "Health: %d\nHeat: %.0f\nAir: %.0f\nScore: %d" % [lives, heat, air, score]
	# don't check anything if dead
	if is_dead:
		return
	
	if in_air:
		check_heat()
	else:
		check_air()
	
	check_velocity()
	check_bubbles()
	add_overtimes(delta);


func check_heat() -> void:
		if head.texture == head_appearance['hurt']:
			return
		if heat > 80:
			head.texture = head_appearance['hot_2']
		elif heat > 50:
			head.texture = head_appearance['hot_1']
		else:
			head.texture = head_appearance['default']
		

func check_air() -> void:
		if head.texture == head_appearance['hurt']:
				return
		if air < 20:
			head.texture = head_appearance['air_2']
		elif air < 50:
			head.texture = head_appearance['air_1']
		else:
			head.texture = head_appearance['default']

func check_velocity() -> void:
	if velocity.y > 250:
		if in_air:
			body.texture = body_appearance["down"]
		else:
			body.rotation = deg_to_rad(15.0)
		board.rotation = deg_to_rad(15.0)
		
	elif velocity.y < -250:
		if in_air:
			body.texture = body_appearance["up"]
		else:
			body.rotation = deg_to_rad(-15.0)
		board.rotation = deg_to_rad(-15.0)
	else:
		if in_air:
			body.texture = body_appearance["stand"]
		else:
			body.rotation = deg_to_rad(0.0)
		board.rotation = deg_to_rad(0.0)

func check_bubbles() -> void:
	if movement_component.space_held:
		$BubbleParticles.emitting = true
		if !$BubbleParticles/BubbleSound.playing || $BubbleParticles/BubbleSound.get_playback_position() > 0.1:		
			$BubbleParticles/BubbleSound.play()
	else:
		$BubbleParticles.emitting = false

func change_zone() -> void:
	var transition_time := 0.25
	var effects_1_offset := 64
	var effects_2_offset := 22
	if in_air:
		movement_component.switch_zone("Air");
		# coming down from the air
		board.texture = board_appearance["effects_1"]
		board.position.x += effects_1_offset
		water_exit_sfx.play()
	else: 
		movement_component.switch_zone("Water");
		# coming up from the water
		board.texture = board_appearance["effects_2"]
		board.position.x += effects_2_offset
		water_enter_sfx.play()
	transition()
	var splash_instance = splash_scene.instantiate()
	splash_instance.global_position = global_position
	get_parent().add_child(splash_instance)
	splash_instance.emitting = true
	await get_tree().create_timer(transition_time).timeout
	splash_instance.emitting = false
	# this state should now be the opposite of what it was before
	board.texture = board_appearance["default"]
	if in_air:
		board.position.x -= effects_1_offset
		stand()
	else:
		board.position.x -= effects_2_offset
		crouch()

func transition() -> void:
	if is_dead:
		return
	body.texture = body_appearance["transition"]
	head.position = Vector2(13.0, -85.0)
	body.rotation = deg_to_rad(30.0)
	body.position = Vector2(-36.0, -74)
	board.position = Vector2(-28.0, -10.5)

func stand() -> void:
	if is_dead:
		return
	body.texture = body_appearance["stand"]
	head.position = Vector2(13.0, -88.5)
	body.position = Vector2(-21.0, -67.5)
	body.rotation = 0.0
	board.position = Vector2(-28.0, -10.5)


func crouch() -> void:
	if is_dead:
		return
	body.texture = body_appearance["crouch"]
	head.position = Vector2(70.0, -70.5)
	body.position = Vector2(-42.0, -39.0)
	body.rotation = 0.0
	board.position = Vector2(-28.0, -10.5)


func _on_air_area_entered(body):
	if body.get_parent() is Player:
		switch.emit("Air")
		in_air = true
		change_zone()

func _on_air_area_exited(body):
	if body.get_parent() is Player:
		switch.emit("Water")
		in_air = false
		change_zone()

func add_air(air_amt : int) -> void :
	air = clamp(air + air_amt, 0, 100);
	air_update.emit(air);

func add_heat(heat_amt : int) -> void :
	heat = clamp(heat + heat_amt, 0, 100);
	heat_update.emit(heat);

func add_coins(coin_amt : int) -> void :
	coins += coin_amt;
	score += 20 * Globals.difficulty
	score_update.emit(score)
	coin_update.emit(coins);

## + heat when above - oxygen when below
func add_overtimes(delta : float) -> void :
	if (in_air) :
		heat_time = clampf(heat_time + (1 * delta), 1.0, 5)
		oxy_time = 1
		heat += delta * heat_time;
		if heat > 100.0:
			health_component.damage(1)
			heat = 0.0
		heat_update.emit(heat)
	else :
		heat_time = 1
		oxy_time = clampf(oxy_time + (2 * delta), 1.0, 3)
		air -= delta * oxy_time;
		if air < 0.0:
			health_component.damage(1)
			air = 100.0
		air_update.emit(air)
	score +=  delta * score_time * Globals.difficulty
	score_update.emit(score)


func _on_hurtbox_component_collect(heat_amt: float, air_amt: float, coin_amt: int, life_amt : int) -> void:
	if (heat_amt):
		add_heat(heat_amt);
	if (air_amt) :
		add_air(air_amt);
	if (coin_amt) :
		add_coins(coin_amt);
	if (life_amt) : 
		health_component.heal(life_amt);

func _on_health_changed(health_amount):
	lives += health_amount
	if lives > 0:
		if in_air:
			hurt_sfx.play()
		else:
			hurt_sfx_underwater.play()
	if health_amount < 0:
		head.texture = head_appearance["hurt"]
		await get_tree().create_timer(0.5).timeout
		head.texture = head_appearance["default"]

func _on_death():
	if is_dead:
		return
	is_dead = true
	movement_component.can_move = false
	$HurtboxComponent.monitorable = false
	body.global_position = global_position
	var tween = create_tween()
	tween.parallel().tween_property(body, "rotation", deg_to_rad(-720 * 3), 3)
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT).tween_property(body, "global_position:y", global_position.y - 300, 0.5)
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN).tween_property(body, "global_position:y", 1800, 2.5)
	if in_air:
		death_sfx.play()
		await death_sfx.finished
	else:
		death_sfx_underwater.play()
		await death_sfx_underwater.finished
