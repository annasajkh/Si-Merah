extends Node

var die
var health
var cover_health
var coin 
var hit
var hurt
var knockbackX 
var change_scene
var level
var end_music
var end
var level_boss
var is_enemy_red = false

func _ready():
	end = false
	die = false
	health = 100
	cover_health = 100
	coin = 0
	hit = false
	hurt = false
	knockbackX = [0,0]
	change_scene = false
	level = 1
	end_music = false
	level_boss = 1

func _process(delta):
	if cover_health > health:
		cover_health -= delta * 100
	if cover_health < health:
		cover_health += delta * 100
