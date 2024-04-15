extends Area2D

const SCROLL_SPEED: int = 200

var scroll: int = 0

signal hit
signal scored

func _process(delta):
	var main = get_parent().get_parent()
	if main.is_paused or main.is_game_over:
		return
	
	position.x -= SCROLL_SPEED * delta
	if position.x + get_parent().get_parent().PIPE_DELAY < 0:
		queue_free()
	
	position.x -= scroll


func _on_body_entered(body):
	hit.emit()


func _on_score_area_body_entered(body):
	scored.emit()
