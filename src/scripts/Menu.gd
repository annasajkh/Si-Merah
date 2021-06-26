extends Control



func _ready():
	var file = File.new()
	if file.file_exists("user://save.json"):
		file.open("user://save.json",File.READ)
		var save_file = parse_json(file.get_as_text())
		Player_Data.level = save_file.lvl
		Player_Data.coin = save_file.coin
		file.close()

func _process(delta):
	$Camera2D/ConfirmationDialog.rect_global_position = Vector2($Camera2D.position.x-235,$Camera2D.position.y)
	$Camera2D.position.x+=50*delta
func _on_Play_pressed():
	$Music.stop()
	if get_tree().change_scene("res://src/scenes/Level "+ String(Player_Data.level)+".tscn") != OK:
		print('scene tidak ditemukan')

func _on_About_pressed():
	if get_tree().change_scene("res://src/scenes/About.tscn") != OK:
		print('scene tidak ditemukan')

func _on_Quit_pressed():
	get_tree().quit()

func _on_Reset_pressed():
	$Camera2D/ConfirmationDialog.popup()


func _on_ConfirmationDialog_confirmed():
	var file = File.new()
	file.open("user://save.json",File.WRITE)
	file.store_string(to_json({"lvl":1,"coin":0}))
	file.close()
	if file.file_exists("user://save.json"):
		file.open("user://save.json",File.READ)
		var save_file = parse_json(file.get_as_text())
		Player_Data.level = save_file.lvl
		Player_Data.coin = save_file.coin
		file.close()

