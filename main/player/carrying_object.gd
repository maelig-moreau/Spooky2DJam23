extends Node2D
@onready var player = $"../player"
var is_carried:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print(player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_carried:
		set_position(player.position)


func _on_area_2d_body_entered(body):
	player.finds_object(self)
