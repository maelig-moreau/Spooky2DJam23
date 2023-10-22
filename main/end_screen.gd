extends Control
var good_ending = preload("res://images/other/bg_goodending.png")
var bad_ending = preload("res://images/other/bg_badending.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	var string = ""
	
	string = string + "Score : " + str(Quest.score) + "/400\n"
	if Quest.score <= 100:
		$TextureRect.texture = bad_ending
		string = "\nBAD ENDING\n" + string
	elif Quest.score == 400:
		$TextureRect.texture = good_ending
		string = "\nGOOD ENDING\n" + string
	else:
		string = "\nGame Finished\n" + string
		string = string + "\nDo not petrify anyone to get perfect score\n"
		
	string = string + "\nSpeedrun time : " + ("%0.3f" % Quest.stopwatch)
	
	#centering
	#string = "[center]" + string
	#string = string + " [/center]"
	$label.text = string


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
