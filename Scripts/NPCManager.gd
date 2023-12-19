extends Node

# Variables
var textSpeed = 0.03
var readTimePerChar = 0.08
var textDisplay
var currentDialogue
var currentMessage
var currentChar
var currentBot
var dialogueActive = false #set to true to disable dialogue
var randomCharPool = "QWERTYUIOPASDFGHJKLZXCVBNM1234567890!@#$%^&*()<>?\/[]{}+=!@#$%^&*()<>?\/[]{}+="
# Nodes
export(NodePath) onready var dialogueHUD = get_node(dialogueHUD) as Control
export(NodePath) onready var dialogueLabel = get_node(dialogueLabel) as RichTextLabel
export(NodePath) onready var dialogueFace = get_node(dialogueFace) as TextureRect
export(NodePath) onready var nextCharTimer = get_node(nextCharTimer) as Timer
export(NodePath) onready var nextMessageTimer = get_node(nextMessageTimer) as Timer
export(NodePath) onready var dialogueAudio = get_node(dialogueAudio) as AudioStreamPlayer
export(NodePath) onready var dumBot1Signal = get_node(dumBot1Signal) as AnimatedSprite3D
export(NodePath) onready var dumBot2Signal = get_node(dumBot2Signal) as AnimatedSprite3D
export(NodePath) onready var dumBot3Signal = get_node(dumBot3Signal) as AnimatedSprite3D
export(NodePath) onready var dumBot4Signal = get_node(dumBot4Signal) as AnimatedSprite3D
#export(NodePath) onready var dumBot5Signal = get_node(dumBot5Signal) as AnimatedSprite3D
# Scripts
var dialogue = preload("dialogue.gd").new()
# File Paths
var dialogue_sfx = [preload("res://Assets/audio/kenney interface sounds/confirmation_001.ogg"),
					preload("res://Assets/audio/kenney interface sounds/question_002.ogg")]


func _ready():
	pass


func start_dialogue(dialogueArray):
	dialogueActive = true
	
	set_face_color(currentBot)
	show_signal_sprite(currentBot)
	dialogueHUD.show()
	
	textSpeed = 0.03 if PlayerStats.textSpeed == 0 else 0.01
	readTimePerChar = 0.08 if PlayerStats.textSpeed == 0 else 0.04
	
	currentDialogue = dialogueArray
	currentMessage = 0
	currentChar = len(currentDialogue[currentMessage]) if PlayerStats.textSpeed == 2 else 0
	textDisplay = randomize_text(currentDialogue[currentMessage], currentChar)
	
	dialogueAudio.set_stream(dialogue_sfx[0])
	nextCharTimer.set_wait_time(textSpeed)
	nextCharTimer.start()


func end_dialogue():
	dialogueAudio.set_stream(dialogue_sfx[1])
	dialogueAudio.play()
	nextCharTimer.stop()
	nextMessageTimer.stop()
	dialogueHUD.hide()
	hide_signal_sprites()
	dialogueActive = false


func randomize_text(message, startPos):
	var result = message
	for i in range(startPos, len(message)):
		if result[i] != " ":
			result[i] = randomCharPool[randi()%len(randomCharPool)]
	return result


func set_face_color(botNum):
	if botNum == 1:
		dialogueFace.modulate = Color.white
	if botNum == 2:
		dialogueFace.modulate = Color("ff93f7")
	if botNum == 3:
		dialogueFace.modulate = Color("1bd977")
	if botNum == 4:
		dialogueFace.modulate = Color("a863de")
	if botNum == 5:
		dialogueFace.modulate = Color("1b96d9")


func show_signal_sprite(botNum):
	if botNum == 1:
		dumBot1Signal.play()
		dumBot1Signal.show()
	if botNum == 2:
		dumBot2Signal.play()
		dumBot2Signal.show()
	if botNum == 3:
		dumBot3Signal.play()
		dumBot3Signal.show()
	if botNum == 4:
		dumBot4Signal.play()
		dumBot4Signal.show()
#	if botNum == 5:
#		dumBot5Signal.play()
#		dumBot5Signal.show()

func hide_signal_sprites():
	dumBot1Signal.stop()
	dumBot1Signal.hide()
	dumBot2Signal.stop()
	dumBot2Signal.hide()
	dumBot3Signal.stop()
	dumBot3Signal.hide()
	dumBot4Signal.stop()
	dumBot4Signal.hide()
#	dumBot5Signal.stop()
#	dumBot5Signal.hide()


func _on_nextCharTimer_timeout():
	textDisplay = randomize_text(currentDialogue[currentMessage], currentChar)
	dialogueLabel.set_text(textDisplay)
	
	if currentChar == 0 or PlayerStats.textSpeed == 2:
		dialogueAudio.play()
	
	if currentChar < len(currentDialogue[currentMessage]):
		currentChar += 1
	else:
		nextCharTimer.stop()
		nextMessageTimer.set_wait_time(max(2,readTimePerChar * len(currentDialogue[currentMessage])))
		nextMessageTimer.start()


func _on_nextMessageTimer_timeout():
	if currentMessage < len(currentDialogue) - 1:
		currentMessage += 1
		currentChar = len(currentDialogue[currentMessage]) if PlayerStats.textSpeed == 2 else 0
		textDisplay = ""
		nextCharTimer.start()
	else:
		end_dialogue()


func _on_DB1AmateurArea_body_entered(body):
	if not dialogueActive and body.is_in_group("Player"):
		PlayerStats.amateurScore1 += 1
		currentBot = 1
		
		if PlayerStats.playerProgress == 0:
			start_dialogue(dialogue.initDialogue)
			PlayerStats.playerProgress = 1
		elif PlayerStats.amateurScore1 == 20:
			start_dialogue(dialogue.helpDialogue1)
		elif body.falling and body.fall_time > 1:
			start_dialogue(["Oops!"])


func _on_DB2AmateurArea_body_entered(body):
	if not dialogueActive and body.is_in_group("Player"):
		PlayerStats.amateurScore2 += 1
		currentBot = 2
		
		if PlayerStats.playerProgress <= 1:
			start_dialogue(dialogue.section2Dialogue)
			PlayerStats.playerProgress = 2
		elif PlayerStats.amateurScore2 == 10:
			start_dialogue(dialogue.helpDialogue2)
		elif body.falling and body.fall_time > 1:
			start_dialogue(["Oops!"])


func _on_DB3AmateurArea_body_entered(body):
	if not dialogueActive and body.is_in_group("Player"):
		PlayerStats.amateurScore3 += 1
		currentBot = 3
		
		if PlayerStats.playerProgress <= 2:
			start_dialogue(dialogue.section3Dialogue)
			PlayerStats.playerProgress = 3
		elif PlayerStats.amateurScore3 == 20:
			start_dialogue(dialogue.helpDialogue3)
		elif body.falling and body.fall_time > 1:
			start_dialogue(["Oops!"])


func _on_DB4AmateurArea_body_entered(body):
	if not dialogueActive and body.is_in_group("Player"):
		PlayerStats.amateurScore3 += 1
		currentBot = 4
		
		if PlayerStats.playerProgress <= 3:
			start_dialogue(dialogue.section4Dialogue)
			PlayerStats.playerProgress = 4
		elif PlayerStats.amateurScore3 == 10:
			start_dialogue(dialogue.helpDialogue4)
		elif body.falling and body.fall_time > 1:
			start_dialogue(["Oops!"])


func _on_DB5AmateurArea_body_entered(body):
	if not dialogueActive and body.is_in_group("Player"):
		PlayerStats.amateurScore3 += 1
		currentBot = 5
		
		if PlayerStats.playerProgress <= 4:
			start_dialogue(dialogue.section5Dialogue)
			PlayerStats.playerProgress = 5
		elif PlayerStats.amateurScore3 == 20:
			start_dialogue(dialogue.helpDialogue5)
		elif body.falling and body.fall_time > 1:
			start_dialogue(["Oops!"])
