extends Node

var effect
var recording
var letter_index
# var letters = ["phi", "beta", "gamma", "mu", "lambda", "psi", "theta", "delta"]

func _ready():
	$PathA.stream = load("res://assets/audio/PathA.wav")
	$PathB.stream = load("res://assets/audio/PathB.wav")
	$PathC.stream = load("res://assets/audio/PathC.wav")
	$PathD.stream = load("res://assets/audio/PathD.wav")
	
	var rng = randf()
	
	if rng < 0.25:
		$PathA.play(0.0)
	elif 0.25 < rng < 0.50:
		$PathB.play(0.0)
	elif 0.50 < rng < 0.75:
		$PathC.play(0.0)
	else:
		$PathD.play(0.0)
	
	letter_index = "phi" #sets first letter to phi
	play_letter(letter_index)


func play_letter(letter_index):
	print(letter_index)
	start_recording()
	$PlayLetters.stream = load("res://assets/audio/" + letter_index + ".wav")
	$PlayLetters.play(0.0)


func start_recording():
	var index = AudioServer.get_bus_index("Record")
	effect = AudioServer.get_bus_effect(index, 0)
	$Timer.set_wait_time(5)
	$Timer.set_one_shot(1)
	$Timer.start()
	effect.set_recording_active(true)

func _on_Timer_timeout():
	recording = effect.get_recording()
	effect.set_recording_active(false)
	var data = recording.get_data()
	print(data)
	print(data.size())
	$AudioStreamPlayer.stream = recording
	$AudioStreamPlayer.play()
	
	var rng = randf()
	var idx = letter_index
	print(idx)
	#LAYER 1
	if idx == "phi":
		if rng < 0.6:
			letter_index = "beta"
		else:
			letter_index = "gamma"
		
	#LAYER 2
	elif idx == "beta":
		if rng < 0.6:
			letter_index = "mu"
		else:
			letter_index = "lambda"
			
	elif idx == "gamma":
		if rng < 0.5:
			letter_index = "psi"
		else:
			letter_index = "theta"
			
	#LAYER 3
	elif idx == "mu":
		letter_index = "delta"
	else:
		letter_index = "phi"
	
	play_letter(letter_index)