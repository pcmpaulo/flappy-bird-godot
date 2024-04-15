extends Node

class_name SaveSystem

var save_file_path: String = 'user://savegame.save'

var best_score: int = 0

func save_game():
	var save_game = FileAccess.open(save_file_path, FileAccess.WRITE)
	var json_string = JSON.stringify({'best_score': best_score})
	save_game.store_line(json_string)

func load_game():
	if not FileAccess.file_exists(save_file_path):
		return # Error! We don't have a save to load.

	var save_game = FileAccess.open(save_file_path, FileAccess.READ)
	var json_string = save_game.get_line()

	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return

	# Get the data from the JSON object
	var node_data = json.get_data()
	best_score = node_data.get('best_score')

func update_best_score(score):
	best_score = max(best_score, score)
