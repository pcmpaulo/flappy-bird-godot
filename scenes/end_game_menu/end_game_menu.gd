extends CanvasLayer

@onready var badge_icon = $MarginContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer2/MarginContainer/TextureRect
@onready var score_label = $MarginContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Score

const golden_medal = preload('res://assets/medals/golden_medal_template.png')
const silver_medal = preload('res://assets/medals/silver_medal_template.png')
const copper_medal = preload('res://assets/medals/copper_medal_template.png')

func _ready():
	var save_system = SaveSystem.new()
	save_system.load_game()
	score_label.text = str(save_system.best_score)
	if save_system.best_score < 10:
		badge_icon.texture = copper_medal
	elif save_system.best_score < 50:
		badge_icon.texture = silver_medal
	else:
		badge_icon.texture = golden_medal

func _on_restart_pressed():
	for pipe in get_parent().get_node('Pipes').get_children():
		pipe.queue_free()
	get_parent().reset()
