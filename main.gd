extends Node

var letter_index
var tracknr
var letters = {"phi" : "φ" , "beta" : "β", "gamma" : "γ" , "mu" : "μ", "lambda" : "λ" , "psi" : "ψ", "theta" : "θ", "delta" : "δ"}
var index = AudioServer.get_bus_index("Record")
var effect = AudioServer.get_bus_effect(index, 0)

func _ready():
	$AudioStreamRecord.stop()
	init()


func init():
	var rng = randf()
	print(rng)
	
	$Timer2.set_wait_time(10)
	$Timer2.set_one_shot(1)
	$Timer2.start()
	
	if rng < 0.25:
		$PathA.play()
		tracknr = 1
	elif rng > 0.25 && rng < 0.50:
		$PathB.play()
		tracknr = 2
	elif rng > 0.50 && rng < 0.75:
		$PathC.play()
		tracknr = 3
	else:
		$PathD.play()
		tracknr = 4

func _on_Timer2_timeout():
	letter_index = "phi" #sets first letter to phi
	play_letter(letter_index)



func play_letter(letter_index):
	print(letter_index)
	start_recording()
	$AnimationPlayer.play("letras")
	$Text.set_text(letters.get(letter_index))
	$PlayLetters.stream = load("res://assets/audio/" + letter_index + ".wav")
	$PlayLetters.play(0.0)


func start_recording():
	var index = AudioServer.get_bus_index("Record")
	var effect = AudioServer.get_bus_effect(index, 0)
	AudioServer.set_bus_mute ( index, true )
	$AudioStreamRecord.play()
	$Timer.set_wait_time(56)
	$Timer.set_one_shot(1)
	$Timer.start()	
	$Timer3.set_wait_time(5)
	$Timer3.set_one_shot(1)
	$Timer3.start()
	effect.set_recording_active(true)


func _on_Timer3_timeout():
	AudioServer.set_bus_mute ( index, false)
	var index = AudioServer.get_bus_index("Record")
	var effect = AudioServer.get_bus_effect(index, 0)
	var recording = effect.get_recording()
	effect.set_recording_active(false)
	var data = recording.get_data()
	print(data.size())
	$AudioStreamPlayer.stream = recording
	recording.save_to_wav("res://recording"+ String(OS.get_unix_time()) + ".wav")
	$AudioStreamRecord.stop()
	$AudioStreamPlayer.play()
	
func _on_Timer_timeout():	
	var idx = letter_index
	#$AudioStreamPlayer.stop()
	
	#LAYER 1
	if tracknr == 1:
		if idx == "phi":
			letter_index = "beta"
			
		#LAYER 2
		elif idx == "beta":
			letter_index = "mu"
			
		#LAYER 3
		elif idx == "mu":
			letter_index = "gamma"
			
		elif idx == "gamma":
			letter_index = "theta"
			
		elif idx == "theta":
			letter_index = "psi"
			
		elif idx == "psi":
			letter_index = "lambda"
			
		elif idx == "lambda":
			letter_index = "delta"
	else:
		letter_index = letters.keys()[randi() % letters.keys().size()-1]
		
	
	play_letter(letter_index)

func _on_PathA_finished():
	init()

func _on_PathB_finished():
	init()

func _on_PathC_finished():
	init()

func _on_PathD_finished():
	init()
