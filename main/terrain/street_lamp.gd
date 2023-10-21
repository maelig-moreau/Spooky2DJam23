extends Node2D
@onready var player = $"../player"
@export var darkness:Array
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func lightup():
	for i in darkness.size():
		get_node(darkness[i]).visible = false

func _on_area_2d_body_entered(body):
	if body == player:
		player.lamp_contact(self)
