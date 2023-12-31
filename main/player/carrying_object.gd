extends Node2D
@onready var player = $"../player"
@export var custom_texture:Texture2D
var is_carried:bool = false
@export var is_potion:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$image.texture = custom_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_carried:
		set_position(player.position)

func _on_area_2d_body_entered(body):
	if body == player:
		player.finds_object(self)


func _on_area_2d_body_exited(body):
	if body == player:
		if player.is_carrying == false:
			player.close_to_object = null
