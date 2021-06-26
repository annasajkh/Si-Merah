extends Control

onready var ProgressBar = $ProgressBar
onready var Coin = $Coin

func _ready():
	$TextureRect/AnimationPlayer.play("open")

func finish():
	if Player_Data.level == 8:
		if get_tree().reload_current_scene() != OK:
			pass
func _process(_delta):
	ProgressBar.value = Player_Data.cover_health
	Coin.text = String(Player_Data.coin)
	if Player_Data.end:
		ProgressBar.value = rand_range(1,100)
		Coin.text = String(int(rand_range(0,10000000)))
		$left.hide()
		$right.hide()
		$up.hide()
		$Pause.hide()
	if Player_Data.change_scene:
		$TextureRect/AnimationPlayer.play("close")
		Player_Data.change_scene = false

func _on_Pause_pressed():
	$Options.show()
	get_tree().paused = true

func _on_Resume_pressed():
	$Options.hide()
	get_tree().paused = false

func _on_Restart_pressed():
	get_tree().paused = false
	if Player_Data.level !=8:
		Player_Data.health = 0
	else:
		if get_tree().reload_current_scene() != OK:
			pass
	$Options.hide()

func _on_MainMenu_pressed():
	get_tree().paused = false
	Player_Data.health = 100
	Player_Data.die = false
	var file = File.new()
	file.open("user://save.json",File.WRITE)
	file.store_string(to_json({"lvl":Player_Data.level,"coin":Player_Data.coin}))
	file.close()
	if get_tree().change_scene("res://src/scenes/Menu.tscn") != OK:
		print('scene tidak ditemukan')
