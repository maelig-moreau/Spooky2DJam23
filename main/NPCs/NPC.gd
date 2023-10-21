extends Node2D
@export var seek:Node
@export var seek_image:Texture2D
@onready var player = $"../player"
var happy:bool = false
var has_firefly:bool = true
var stone_texture = preload("res://images/NPCs/NPC_stone.png")
var petrified:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$NpcBubble/seek_texture.texture = seek_image
	$Glow.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	if area.get_parent() == seek and petrified == false :
		$NpcBubble.visible = false
		area.get_parent().queue_free()
		player.is_carrying = false
		happy = true
		if player.firefly.visible == false:
			player.firefly.visible = true
			has_firefly = false
		else:
			$Glow.visible = true
	elif area.get_parent().is_potion:
		player.can_petrify = self


func _on_area_2d_body_entered(body):
	if body == player and (happy or petrified) and player.firefly.visible == false and has_firefly:
		player.firefly.visible = true
		has_firefly = false
		$Glow.visible = false

func petrify():
	petrified = true
	$NpcBubble.visible = false
	$sprite.texture = stone_texture
	if player.firefly.visible == false:
		player.firefly.visible = true
		has_firefly = false
	else:
		$Glow.visible = true


func _on_area_2d_area_exited(area):
	player.can_petrify = null
