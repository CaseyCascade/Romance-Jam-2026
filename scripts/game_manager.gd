extends Node
class_name GameManager

@export var current_scene: Node3D

var pending_spawn_id := ""
	
func _ready() -> void:
	Globals.game_manager = self

func change_scene(new_scene: String, destination_id: String = "", 
				delete: bool = true, keep_running: bool = false) -> void:
	if delete:
		current_scene.queue_free()
	elif keep_running:
		current_scene.visible = false 
	else: 
		remove_child(current_scene)
	if destination_id != "": 
		pending_spawn_id = destination_id
	var new = load(new_scene).instantiate()
	add_child(new)
	current_scene = new
