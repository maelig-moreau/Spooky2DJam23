extends Node2D
@export var seek:Node
@export var seek_image:Texture2D
@onready var player = $"../player"

# Called when the node enters the scene tree for the first time.
func _ready():
	$NpcBubble/seek_texture.texture = seek_image


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	if area.get_parent() == seek and player.firefly.visible == false:
		player.firefly.visible = true
		$NpcBubble.visible = false
		area.get_parent().queue_free()
