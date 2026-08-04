extends Control
class_name DialogueManager

@onready var author_label = $AuthorBox/RichTextLabel
@onready var message_label = $MessageBox/RichTextLabel

#TODO Is this working

var message: Array[String]
var message_playing := false
var dialogue_active := false

func _ready() -> void:
	EventBus.begin_dialogue.connect(_on_begin_dialogue)

func _on_begin_dialogue(track: DialogueTrack):
	if dialogue_active: return
	dialogue_active = true
	author_label.text = track.author
	message = track.messages.duplicate()
	if message.is_empty(): return
	visible = true
	await play_line(message[0])
	message.remove_at(0)
	
func _process(_delta: float) -> void:
	if not self.visible or message_playing: return
	if Input.is_action_just_pressed("Select"):
		if not message.is_empty():
			await play_line(message[0])
			message.remove_at(0)
		else: 
			end_message()
		
func play_line(line:String) -> void:
	if line.is_empty(): return
	message_playing = true
	message_label.text = ""
	for character in line:
		message_label.text += line[0]
		line = line.erase(0)
		await get_tree().create_timer(0.015).timeout
	message_playing = false
		
func end_message():
	dialogue_active = false
	visible = false
	message_label.text = ""
	author_label.text = ""
	await get_tree().process_frame
	EventBus.end_dialogue.emit()
