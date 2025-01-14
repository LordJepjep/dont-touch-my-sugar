extends Node

var score = Global.score
var total_kill_count = Global.total_kill_count
var total_time = Global.total_time
var player_name = Global.player_name
var level = Global.level
var scores = []
var score_path = "user://scores.json"
var file


func _process(delta):
	score = Global.score
	total_kill_count = Global.total_kill_count
	total_time = Global.total_time
	player_name = Global.player_name
	level = Global.level

func save_score():
	get_scores()

	if score >= 10:
		scores.append({
			"player_name": player_name,
			"score": score,
			"total_kill_count": total_kill_count,
			"total_time": total_time,
			"level": level
		})
		scores.sort_custom(func(a, b): return b["score"] - a["score"])
		file = FileAccess.open(score_path, FileAccess.WRITE)
		file.store_string(JSON.stringify(scores))
		file.close()
		print("Finished updating/adding player score...")

func get_scores():
	print("Getting scores")
	if FileAccess.file_exists(score_path):
		file = FileAccess.open(score_path, FileAccess.READ)
		var file_content = file.get_as_text()
		scores = JSON.parse_string(file_content)
		scores.sort_custom(func(a, b): return b["score"] - a["score"])
		file.close()
		print("Got the scores!")
	else:
		print("No scores file!")

func return_scores():
	print("Getting scores")
	if FileAccess.file_exists(score_path):
		file = FileAccess.open(score_path, FileAccess.READ)
		var file_content = file.get_as_text()
		var scores = JSON.parse_string(file_content)
		scores.sort_custom(func(a, b): return b["score"] - a["score"])
		return scores
		file.close()
		print("Got the scores!")
	else:
		print("No scores file!")

func load_score():
	get_scores()
	for i in scores:
		var player_scores = scores[i]
		print("Player:", player_scores["player_name"])
		print("Survival Time:", player_scores["total_time"])
		print("Total Kill Count:", player_scores["total_kill_count"])
		print("Score:", player_scores["score"])
		


		
	
	
