extends Node

# Player Data
var positionX: float = 0 # Vector2 is not supported by JSON
var positionY: float = 1
var velocityX: float = 0
var velocityY: float = 0
var falling: bool = false
var flying: bool = false
var num_shots: int = 1
# Stats
var num_jumps: int = 0
var num_crashes: int = 0
var num_jump_pads: int = 0
var num_speed_boosts: int = 0
var num_droids: int = 0
var highest_distance: float = 0.0
# Dialogue
var playerProgress: int = 0
var amateurScore1: int = 0
var amateurScore2: int = 0
var amateurScore3: int = 0
var amateurScore4: int = 0
var amateurScore5: int = 0
# Time
var time_elapsed: float = 0.0
var hours_elapsed: float = 0
var minutes_elapsed: float = 0
var seconds_elapsed: float = 0
#var milliseconds_elapsed = 0.0
# Settings
var cursorSize: int = 0
var textSpeed: int = 0
var soundVolume: float = 1

# extra
var inGame = false


func _process(delta):
	if inGame:
		time_elapsed += delta
	update_times()


func update_times():
	hours_elapsed = time_elapsed / 3600
	minutes_elapsed = (fmod(time_elapsed, 3600)) / 60
	seconds_elapsed = fmod(time_elapsed, 60)
	#milliseconds_elapsed = fmod(time_elapsed, 1) * 100


func reset():
	pass
