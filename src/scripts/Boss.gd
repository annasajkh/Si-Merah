extends Node

export (PackedScene) var buk
export (PackedScene) var senso


var restart = false
var level = [103,81,38]
var l = 1
var final_att = false
var i
var annas_left = false
var set_dialog = false
var blink = false
var is_blink = false
var s = false
var ground = 1
onready var time = $time
onready var cloud = $"Player/ParallaxBackground/Clouds"
onready var panel = $root/Panel
onready var camera = $Camera2D
onready var enemies = $Enemies

func _ready():
	randomize()
	VisualServer.set_default_clear_color(Color(0,231,255,255))
	Player_Data.level_boss = 1
	Player_Data.health = 100
	Player_Data.die = false
	Player_Data.hit = false
	Player_Data.hurt = false
	Player_Data.knockbackX = [0,0]
	time.wait_time = level[l-1]
	if Player_Data.level_boss>1:
		panel.get_node("dialog").stop()
		panel.hide()
		$spawn.start()
		time.start()

func _process(_delta):
	if annas_left:
		$root.position.y+=5
	if !s && Player_Data.die:
		$spawn.wait_time+=0.06
		s = true
	if !restart && Player_Data.die:
		time.stop()
		time.wait_time = level[Player_Data.level_boss-1]
		time.start()
		restart = true
	if !Player_Data.die:
		s = false
	if Player_Data.health == 100:
		restart = false
	if Player_Data.end:
		camera.offset = Vector2(rand_range(-200,200),rand_range(-200,200))


func _on_Panel_finish():
	$spawn.start()
	time.start()


func _on_spawn_timeout():
	
	if Player_Data.is_enemy_red && Player_Data.level_boss == 1:
		Player_Data.is_enemy_red = false 
	if time.time_left > 81 && time.time_left < 102:
		if !set_dialog:
			panel.get_node("dialog_time").wait_time = 4
			panel.get_node("dialog").wait_time = 9
			set_dialog = true
		i = buk.instance()
		i.speed_down = 4.5
		i.damage = 25
		i.position = Vector2(rand_range(60,940),60)
		enemies.add_child(i)
	elif time.time_left > 38 && time.time_left < 76:
		Player_Data.level_boss = 2
		l = 2
		i = senso.instance()
		i.damage = 15
		i.position = Vector2(971,440)
		i.speed = 8
		enemies.add_child(i)
	elif time.time_left < 35:
		if !$root/Panel.att_end:
			l = 2
			i = senso.instance()
			i.position = Vector2(971,430)
			i.speed = 8
			i.damage = 1
			enemies.add_child(i)
			i = buk.instance()
			i.speed_down = 6
			i.damage = 1.5
			i.position = Vector2(rand_range(60,940),60)
			enemies.add_child(i)

func _on_Panel_final_att():
	$EndMusic.stop()
	$root/Label.text = 'Annas'
	final_att = true
	$spawn.stop()
	annas_left = true
	$root/Annas/CPUParticles2D.emitting = true
	$end.start()

func _on_end_timeout():
	$Player/Music.play()
	$Player/Music.pitch_scale = 15
	Player_Data.end = true
	$close.start()

func _on_close_timeout():
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
	get_tree().quit()


func _on_night_timeout():
	$blink.start()


func _on_blink_timeout():
	if !is_blink:
		$blink_time.start()
		is_blink = true
	if !blink:
		VisualServer.set_default_clear_color(Color.black)
		cloud.modulate = Color.red
		blink = true
	else:
		VisualServer.set_default_clear_color(Color(0,231,255,255))
		cloud.modulate = Color.white
		blink = false


func _on_blink_time_timeout():
	$blink.stop()


func _on_change_ground_color_timeout():
	$blink2.start()


func _on_blink2_timeout():
	if ground == 1:
		$Player/ParallaxBackground/ParallaxLayer2/Sprite.modulate = Color.red
		$Player/ParallaxBackground/ParallaxLayer2/Sprite/AnimationPlayer.play("shake")
	elif ground == 2:
		$Player/ParallaxBackground/ParallaxLayer4/Sprite.modulate = Color.red
		$Player/ParallaxBackground/ParallaxLayer4/Sprite/AnimationPlayer.play("shake1")
	elif ground == 3:
		$Player/ParallaxBackground/ParallaxLayer/Sprite.modulate = Color.red
		$Player/ParallaxBackground/ParallaxLayer/Sprite/AnimationPlayer.play("shake")
	elif ground == 4:
		$block.modulate = Color.red
		enemies.modulate = Color.red
		Player_Data.is_enemy_red = true
	else:
		$blink2.stop()
	ground+=1
