extends CharacterBody2D
@export var move_speed:int = 400
@export var jump_speed:int = 50
@export var gravity:float = 50
var jump_strength:float = 0

@export var jump_strength_sustain:float = 25
@export var jump_strength_burst:float = 800

var air_lock:float = 0

var left_input_buffer:bool = false
var jumps:int = 2
const MAX_JUMPS = 2

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
	
	#flex keyboard input
	if Input.is_action_pressed("left") and Input.is_action_pressed("right"):
		if left_input_buffer:
			input_dir = 1
		else:
			input_dir = -1
	else:
		if input_dir > 0:
			left_input_buffer = false
		elif input_dir < 0:
			left_input_buffer = true
	
	#handle movement relative to airtimeqqqqqqq
	if is_on_floor():
		velocity.x = input_dir * move_speed
	else:
		velocity.x = air_lock + (input_dir * move_speed/2)
		clamp(velocity.x,-move_speed,move_speed)
		
	if is_on_wall() or is_on_floor():
		jumps = MAX_JUMPS
	
	print(jumps)
	if Input.is_action_just_pressed("jump") and jumps > 1:
		jump_strength = -jump_strength_burst
		if  is_on_wall_only():
			velocity.x = -velocity.x
		else:
			jumps -= 1
		air_lock = velocity.x
	elif Input.is_action_pressed("jump"):
		jump_strength -= jump_strength_sustain

