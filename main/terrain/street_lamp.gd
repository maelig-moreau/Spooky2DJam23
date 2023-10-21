extends Node2D
@onready var player = $"../player"
@export var dark_zone:Node
var is_lit:bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func lightup():
	is_lit = true
	var children = dark_zone.get_children()
	for i in children.size():
		children[i].visible = false

func _on_area_2d_body_entered(body):
	if body == player and is_lit == false:
		player.close_to_lamp = self


func _on_area_2d_body_exited(body):
	player.close_to_lamp = null
