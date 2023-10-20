extends CharacterBody2D
@export var move_speed:int = 400
@export var jump_speed:int = 50
var on_air:bool = false
@export var gravity:float = 50
var jump_strength:float = 0

@export var jump_strength_sustain:float = 20
@export var jump_strength_burst:float = 1600

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	velocity.y = jump_strength
	jump_strength += gravity
	get_input()
	move_and_slide()
		
func get_input():
	# take horizontal input
	var input_dir = Input.get_axis("left","right")
	velocity.x = input_dir * move_speed
	if Input.is_action_just_pressed("jump"):
		jump_strength = -jump_strength_burst
	elif Input.is_action_pressed("jump"):
		jump_strength -= jump_strength_sustain

