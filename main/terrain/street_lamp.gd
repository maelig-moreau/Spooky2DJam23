extends Node2D
@onready var player = $"../player"
@export var dark_zone:Node
@export var shared_dark:Array[NodePath]
var is_lit:bool = false
var dim:float = 1.0
# Called when the node enters the scene tree for the first time.
func _ready():
	$Glow.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_lit:
		dim -= 0.005
		reduce_alpha(dim)

func lightup():
	$Glow.visible = true
	is_lit = true
	$StreetLamp.texture = load("res://images/terrain/street_lamp_lit.png")
	$AudioStreamPlayer2D.play()

func reduce_alpha(value:float):
	var children = dark_zone.get_children()
	for i in children.size():
		children[i].modulate.a = value
		
	for i in shared_dark.size():
		get_node(shared_dark[i]).modulate.a = value

func _on_area_2d_body_entered(body):
	if body == player and is_lit == false:
		player.close_to_lamp = self


func _on_area_2d_body_exited(body):
	player.close_to_lamp = null
