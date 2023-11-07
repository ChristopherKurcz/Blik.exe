extends Node

var secretSave = {
	"04" : "positionX",
	"19" : "positionY",
	"16" : "velocityX",
	"08" : "velocityY",
	"13" : "falling",
	"18" : "flying",
	"11" : "num_shots",
	# Stats
	"15" : "num_jumps",
	"14" : "num_crashes",
	"12" : "num_jump_pads",
	"02" : "num_speed_boosts",
	"09" : "num_droids",
	"07" : "highest_distance",
	# Dialogue
	"10" : "playerProgress",
	"17" : "amateurScore1",
	"01" : "amateurScore2",
	"20" : "amateurScore3",
	"23" : "amateurScore4",
	"22" : "amateurScore5",
	# Time
	"03" : "time_elapsed",
	# Settings
	"05" : "cursorSize",
	"06" : "textSpeed",
	"21" : "soundVolume"
	}


func _ready():
	load_game()


func get_saveData():
	var saveData = {
		# Player Data
		"04" : PlayerStats.positionX, # Vector2 is not supported by JSON
		"19" : PlayerStats.positionY,
		"16" : PlayerStats.velocityX,
		"08" : PlayerStats.velocityY,
		"13" : PlayerStats.falling,
		"18" : PlayerStats.flying,
		"11" : PlayerStats.num_shots,
		# Stats
		"15" : PlayerStats.num_jumps,
		"14" : PlayerStats.num_crashes,
		"12" : PlayerStats.num_jump_pads,
		"02" : PlayerStats.num_speed_boosts,
		"09" : PlayerStats.num_droids,
		"07" : PlayerStats.highest_distance,
		# Dialogue
		"10" : PlayerStats.playerProgress,
		"17" : PlayerStats.amateurScore1,
		"01" : PlayerStats.amateurScore2,
		"20" : PlayerStats.amateurScore3,
		"23" : PlayerStats.amateurScore4,
		"22" : PlayerStats.amateurScore5,
		# Time
		"03" : PlayerStats.time_elapsed,
		# Settings
		"05" : PlayerStats.cursorSize,
		"06" : PlayerStats.textSpeed,
		"21" : PlayerStats.soundVolume
		}
	return saveData

func get_resetSaveData():
	var saveData = {
		# Player Data
		"04" : 0, # Vector2 is not supported by JSON
		"19" : 1,
		"16" : 0,
		"08" : 0,
		"13" : false,
		"18" : false,
		"11" : 1,
		# Stats
		"15" : 0,
		"14" : 0,
		"12" : 0,
		"02" : 0,
		"09" : 0,
		"07" : 0,
		# Dialogue
		"10" : 0,
		"17" : 0,
		"01" : 0,
		"20" : 0,
		"23" : 0,
		"22" : 0,
		# Time
		"03" : 0,
		# Settings
		"05" : PlayerStats.cursorSize,
		"06" : PlayerStats.textSpeed,
		"21" : PlayerStats.soundVolume
	}
	return saveData


func save_game():
	var saveGame = File.new()
	saveGame.open("user://blikSaveGame.save", File.WRITE)
	var saveData = get_saveData()
	saveGame.store_line(to_json(saveData))
	saveGame.close()


func load_game():
	var saveGame = File.new()
	if not saveGame.file_exists("user://blikSaveGame.save"):
		save_game()
		print("new save made in %appdata%/Godot/app_userdata/Blik.exe")
		return # Error! We don't have a save to load.

	saveGame.open("user://blikSaveGame.save", File.READ)
	
	var current_line = parse_json(saveGame.get_line())
	for i in current_line.keys():
		PlayerStats.set(secretSave[i], current_line[i])
	
	saveGame.close()


func reset_progress():
	var saveGame = File.new()
	saveGame.open("user://blikSaveGame.save", File.WRITE)
	var saveData = get_resetSaveData()
	saveGame.store_line(to_json(saveData))
	saveGame.close()
	load_game()
