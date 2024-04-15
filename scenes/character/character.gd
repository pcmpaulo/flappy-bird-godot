extends CharacterBody2D

const INITIAL_POSITION: Vector2 = Vector2((864.0/4), (768.0/2))

const JUMP_VELOCITY: int = -400
const GRAVITY_VELOCITY: int = 800
const MAX_GRAVITY_VELOCITY: int = 800

var is_dead: bool = false

func _ready():
	reset()

func _physics_process(delta):
	# Does not process physics if the game is paused
	if get_parent().is_paused:
		return

	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY_VELOCITY * delta
		velocity.y = min(velocity.y, MAX_GRAVITY_VELOCITY)

	if not is_dead:
		set_rotation(deg_to_rad(velocity.y * 0.05))
		$AnimatedSprite2D.play('default')
	else:
		set_rotation(PI / 2)
		$AnimatedSprite2D.stop()

	move_and_slide()


func _input(event):
	if event.is_action_pressed('ui_accept') and not (
		is_dead or get_parent().is_paused or get_parent().is_game_over
		):
		velocity.y = JUMP_VELOCITY


func pause_animation():
	$AnimatedSprite2D.pause()
	
func resume_animation():
	$AnimatedSprite2D.play('default')

func reset():
	velocity = Vector2.ZERO
	position = INITIAL_POSITION
	set_rotation(0)
	is_dead = false
	
