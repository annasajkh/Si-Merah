extends Panel


var data = ['hai','selamat karena kamu sudah sampai disini','pasti susah untuk sampai kesini kan',
'tapi sepertinya gamenya rusak boss terakhirnya tidak datang','ya sudah hadapi ini sebagai penganti boss terakhir'
,'!','sambil kamu bertarung mari aku ceritakan sesuatu','aku punya teman yang sangat pintar','!','dia selalu baik padaku'
,'aku juga punya teman yang selalu memberi semangat','!','aku juga punya teman yang suka mengerjaiku'
,'walaupun begitu dia pintar','!','tidak sepertiku yang bodoh',
'aku merasa akan gagal di masa depan','!','aku juga binggung cita-citaku jadi apa',
'aku ini juga pemalu jadi aku tegang kalau bicara didepan banyak orang','!','itu yang membuatku jadi di bulli','HUUUUUUUUUUUUU ANAS ;(','!',
'oke segitu aja ceritaku ,selamat tinggal','!']
var index = 0
var start = true
var att_end = false
var f = false
var chat_end = false
var already_emit = false
signal finish
signal final_att
onready var RichTextLabel = $RichTextLabel
onready var text_timer = $text_timer
onready var text = $text
onready var dialog = $dialog
onready var dialog_time = $dialog_time


func _ready():
	RichTextLabel.text = data[index]

func _process(_delta):
	if chat_end && !already_emit:
		emit_signal("final_att")
		already_emit = true
	if RichTextLabel.percent_visible<1:
		RichTextLabel.percent_visible += 0.35/RichTextLabel.text.length()
		if start:
			text_timer.start()
			start = false
	else:
		text_timer.stop()

func _on_dialog_timeout():
	show()
	text.play()
	index+=1
	if data[index] != '!':
		RichTextLabel.percent_visible = 0
		RichTextLabel.text = data[index]
		if !start:
			start = true
	else:
		dialog.stop()
		hide()
		if index == 25:
			chat_end = true
			dialog_time.stop()
		else:
			dialog_time.start()
		if !f:
			emit_signal("finish")
		f = true

func _on_text_timer_timeout():
	text.play()


func _on_dialog_time_timeout():
	dialog.start()


func _on_music_timeout():
	att_end = true
