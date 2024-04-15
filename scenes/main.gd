extends Node

@export var pipe_preload: PackedScene
@export var pause_menu_preload: PackedScene
@export var end_game_menu_preload: PackedScene
@export var main_menu_preload: PackedScene

const BASE_X_SIZE: float = 864.0
const BASE_Y_SIZE: float = 768.0

const PIPE_MINIMUN_RANGE: int = 160
const PIPE_DELAY: int = 200

var is_paused: bool = true
var is_game_over: bool = false

var score: int = 0


func _ready():
	reset()


func reset():
	if has_node('EndGameMenu'):
		get_node('EndGameMenu').queue_free()
	if has_node('PauseMenu'):
		get_node('PauseMenu').queue_free()
	if not has_node('MainMenu'):
		add_child(main_menu_preload.instantiate())

	is_paused = true
	is_game_over = false
	score = 0

	$Character.reset()

	$SpawnTimer.stop()
	$SpawnTimer.paused = true
	$SpawnTimer.start()

	_set_score_label()

func _process(delta):
	if $Character.position.y < 0:
		bird_hit()


func _input(event):
	if not has_node('MainMenu') and event.is_action_pressed('ui_cancel'):
		if is_game_over:
			return
		pause_game() if !is_paused else resume_game()

func resume_game():
	get_node('Character').resume_animation()
	$SpawnTimer.paused = false
	if has_node('PauseMenu'):
		get_node('PauseMenu').queue_free()
	is_paused = false

func pause_game():
	is_paused = true
	get_node('Character').pause_animation()
	$SpawnTimer.paused = true
	add_child(pause_menu_preload.instantiate())


func _on_spawn_timer_timeout():
	var pipe = pipe_preload.instantiate()
	
	pipe.position = Vector2(
		BASE_X_SIZE + PIPE_DELAY,
		randi_range(PIPE_MINIMUN_RANGE, $Ground.position.y - PIPE_MINIMUN_RANGE)
	)
	pipe.hit.connect(bird_hit)
	pipe.scored.connect(increase_score)
	$Pipes.add_child(pipe)

func bird_hit():
	is_game_over = true
	$Character.is_dead = true
	get_node('Character').pause_animation()

func _on_ground_hit():
	bird_hit()
	is_paused = true
	_set_game_over_menu()
	
func increase_score():
	score += 1
	_set_score_label()

func _set_score_label():
	$CanvasLayer/Container/MarginContainer/HudContainer/ScoreLabel.text = str(score)

func _set_game_over_menu():
	var save_system = SaveSystem.new()
	save_system.load_game()
	save_system.update_best_score(score)
	save_system.save_game()
	add_child(end_game_menu_preload.instantiate())
	
func start_game():
	if has_node('MainMenu'):
		get_node('MainMenu').queue_free()
	get_node('Character').resume_animation()
	$SpawnTimer.paused = false
	is_paused = false
