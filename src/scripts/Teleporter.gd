extends Area2D

export var scene = ""

func _on_Teleporter_body_entered(body):
	if body.name == "Player":
		Player_Data.change_scene = true
		Player_Data.end_music = true
		Player_Data.die = true
		$change_scene.start()

func _on_change_scene_timeout():
	Player_Data.health = 100
	Player_Data.cover_health = 100
	Player_Data.level+=1
	var file = File.new()
	file.open("user://save.json",File.WRITE)
	file.store_string(to_json({"lvl":Player_Data.level,"coin":Player_Data.coin}))
	file.close()
	if get_tree().change_scene("res://src/scenes/"+scene+".tscn") != OK:
		print('scene tidak ditemukan')
