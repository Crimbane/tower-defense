extends Node

@export var musicPlayer: AudioStreamPlayer

@export var oneSound: AudioStreamPlayer2D
@export var twoSound: AudioStreamPlayer2D
@export var threeSound: AudioStreamPlayer2D
@export var fourSound: AudioStreamPlayer2D
@export var fiveSound: AudioStreamPlayer2D
@export var sixSound: AudioStreamPlayer2D
@export var sevenSound: AudioStreamPlayer2D
@export var eightSound: AudioStreamPlayer2D
@export var nineSound: AudioStreamPlayer2D

@export var menuMusic: AudioStream
@export var gameMusic1: AudioStream
@export var gameMusic2: AudioStream
@export var gameMusic3: AudioStream
@export var bossMusic: AudioStream
@export var creditsMusic: AudioStream

var gameMusicTracks: Array[AudioStream] = []

var masterVolume: float = 1.0
var musicVolume: float = 1.0
var sfxVolume: float = 1.0

func _ready() -> void:
	musicPlayer.finished.connect(onGameMusicFinished)
	gameMusicTracks = [gameMusic1, gameMusic2, gameMusic3]
	
	var masterBusIndex = AudioServer.get_bus_index("Master")
	var musicBusIndex = AudioServer.get_bus_index("Music")
	var sfxBusIndex = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(masterBusIndex, linear_to_db(masterVolume))
	AudioServer.set_bus_volume_db(musicBusIndex, linear_to_db(musicVolume))
	AudioServer.set_bus_volume_db(sfxBusIndex, linear_to_db(sfxVolume))

func stopMusic():
	musicPlayer.stop()
	musicPlayer.stream = null

func playMenuMusic():
	if musicPlayer.stream == menuMusic:
		return
	print("Playing Menu Music")
	musicPlayer.stream = menuMusic
	musicPlayer.play()

func playBossMusic():
	musicPlayer.stream = bossMusic
	musicPlayer.play()

func playCreditsMusic():
	musicPlayer.pitch_scale = 1.0
	if musicPlayer.stream == creditsMusic:
		return
	print("Playing Credits Music")
	musicPlayer.stream = creditsMusic
	musicPlayer.play()

func onGameMusicFinished() -> void:
	if musicPlayer.stream == menuMusic:
		musicPlayer.play()
		print("Playing Menu Music")
		return
	
	if musicPlayer.stream == bossMusic:
		musicPlayer.play()
		return
	
	playRandomTrack()

func playRandomTrack() -> void:
	var randomTrack = gameMusicTracks.pick_random()
	musicPlayer.stream = randomTrack
	musicPlayer.play()

func playOneSound() -> void:
	oneSound.play()

func updateSoundVolumeVariables(busName: String, soundValue: float) -> void:
	match busName:
		"Master":
			masterVolume = soundValue
		"Music":
			musicVolume = soundValue
		"SFX":
			sfxVolume = soundValue
