extends Area2D

@onready var sprite = $Sprite2D

const SCROLL_SPEED: int = 200

var scroll: int = 0

signal hit


func _process(delta):
	if get_parent().is_paused or get_parent().is_game_over:
		return
	
	scroll += SCROLL_SPEED * delta
	if scroll >= get_parent().BASE_X_SIZE:
		scroll = 0
	
	position.x = -scroll
	


func _on_body_entered(body):
	hit.emit()
