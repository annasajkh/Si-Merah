extends KinematicBody2D


var velocity = Vector2.ZERO
var speed = 200
var up = Vector2.UP
var jump_height = 550
var gravity = 20
onready var camera = $Camera2D

func _ready():
	if Player_Data.level != 8:
		$Music.play()
	if Player_Data.end_music:
		Player_Data.end_music = false
	if Player_Data.die:
		Player_Data.die = false

func _physics_process(_delta):
	if Player_Data.end_music && $Music.volume_db != 0:
		$Music.volume_db -= 0.3
	if Player_Data.hit:
		$Hit.play()
		$Hurt.play("hurt")
		$hit.start()
		Player_Data.hurt = true
		Player_Data.hit = false
	if Input.is_action_pressed("right") && !Player_Data.die:
		$body.flip_h = false
		$body/AnimationPlayer.playback_speed = 5
		$body/AnimationPlayer.play("idle")
		velocity.x = speed 
	elif Input.is_action_pressed("left") && !Player_Data.die:
		$body.flip_h = true
		$body/AnimationPlayer.playback_speed = 5
		$body/AnimationPlayer.play("idle")
		velocity.x = -speed
	else:
		$body/AnimationPlayer.playback_speed = 1
		$body/AnimationPlayer.play("idle")
		$eyeright/AnimationPlayer.play("idle")
		$eyeleft/AnimationPlayer.play("idle")
		velocity.x = 0
	if Input.is_action_pressed("up") && is_on_floor() && !Player_Data.die:
		$Jump.play()
		velocity.y = -jump_height
	if position.y>600 && !Player_Data.die:
		$Hurt.stop()
		$Hit.stop()
		Player_Data.health = 0
		Player_Data.cover_health = 0
		$Die.play()
		$die.start()
		$DieAnim.play("die")
		Player_Data.die = true
	if Player_Data.health<=0 && !Player_Data.die:
		if Player_Data.level == 8:
			$ParallaxBackground2/CanvasLayer/Control/TextureRect/AnimationPlayer.play("close")
		$Hurt.stop()
		$Hit.stop()
		$Die.play()
		$die.start()
		$DieParticles.emitting = true
		$DieAnim.play("die")
		Player_Data.die = true
	if Player_Data.knockbackX[0]>0:
		velocity.x+=Player_Data.knockbackX[0]
		Player_Data.knockbackX[0]+=-Player_Data.knockbackX[1]
	if Player_Data.knockbackX[0]<0:
		velocity.x+=Player_Data.knockbackX[0]
		Player_Data.knockbackX[0]+=Player_Data.knockbackX[1]
	velocity.y += gravity
	velocity = move_and_slide(velocity,up)

func _on_hit_timeout():
	Player_Data.hurt = false

func _on_die_timeout():
	$Die.stop()
	$DieParticles.emitting = false
	$DieAnim.stop(true)
	Player_Data.health = 100
	$respawn.start()
	position = $"../RespawnPosition".position
	camera.smoothing_enabled = true
	$RespawnAnim.play("respawn")

func _on_respawn_timeout():
	camera.smoothing_enabled = false
	Player_Data.die = false
	Player_Data.hit = false
	Player_Data.hurt = false
	Player_Data.knockbackX = [0,0]
