extends Node

@export var musicPlayer: AudioStreamPlayer

@export var buttonClickSound: AudioStreamPlayer2D
@export var buttonHoverSound: AudioStreamPlayer2D
@export var buildSound: AudioStreamPlayer2D
@export var arrowShootSound: AudioStreamPlayer2D
@export var arrowImpactSound: AudioStreamPlayer2D
@export var flamethrowerSound: AudioStreamPlayer2D
@export var slimeShootSound: AudioStreamPlayer2D
@export var slimeImpactSound: AudioStreamPlayer2D
@export var cannonShootSound: AudioStreamPlayer2D
@export var cannonImpactSound: AudioStreamPlayer2D
@export var nextWaveButtonSound: AudioStreamPlayer2D
@export var startWaveSound: AudioStreamPlayer2D
@export var loseHealthSound: AudioStreamPlayer2D
@export var purchaseUpgradeSound: AudioStreamPlayer2D
@export var noMoneySound: AudioStreamPlayer2D
@export var gameOverSound: AudioStreamPlayer2D
@export var sandwormDeathSound: AudioStreamPlayer2D
@export var scorpionDeathSound: AudioStreamPlayer2D
@export var boarDeathSound: AudioStreamPlayer2D
@export var lizardDeathSound: AudioStreamPlayer2D

@export var menuMusic: AudioStream
@export var gameMusic1: AudioStream
@export var gameMusic2: AudioStream
@export var gameMusic3: AudioStream
@export var gameMusic4: AudioStream
@export var creditsMusic: AudioStream

var gameMusicTracks: Array[AudioStream] = []

var masterVolume: float = 1.0
var musicVolume: float = 1.0
var sfxVolume: float = 1.0

func _ready() -> void:
	musicPlayer.finished.connect(onGameMusicFinished)
	gameMusicTracks = [gameMusic1, gameMusic2, gameMusic3, gameMusic4]
	
	playMenuMusic()
	
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
	
	playRandomTrack()

func playRandomTrack() -> void:
	var randomTrack = gameMusicTracks.pick_random()
	musicPlayer.stream = randomTrack
	musicPlayer.play()

func playButtonClickSound() -> void:
	buttonClickSound.play()
func playButtonHoverSound() -> void:
	buttonHoverSound.play()
func playbuildSound() -> void:
	buildSound.play()
func playArrowShootSound() -> void:
	arrowShootSound.play()
func playArrowImpactSound() -> void:
	arrowImpactSound.play()
func playFlamethrowerSound() -> void:
	flamethrowerSound.play()
func stopFlamethrowerSound() -> void:
	flamethrowerSound.stop()
func playSlimeShootSound() -> void:
	slimeShootSound.play()
func playSlimeImpactSound() -> void:
	slimeImpactSound.play()
func playCannonShootSound() -> void:
	cannonShootSound.play()
func playCannonImpactSound() -> void:
	cannonImpactSound.play()
func playNextWaveButtonSound() -> void:
	nextWaveButtonSound.play()
func playStartWaveSound() -> void:
	startWaveSound.play()
func playLoseHealthSound() -> void:
	loseHealthSound.play()
func playPurchaseUpgradeSound() -> void:
	purchaseUpgradeSound.play()
func playnoMoneySound() -> void:
	noMoneySound.play()
func playGameOverSound() -> void:
	gameOverSound.play()
func playSandwormDeathSound() -> void:
	sandwormDeathSound.play()
func playScorpionDeathSound() -> void:
	scorpionDeathSound.play()
func playBoarDeathSound() -> void:
	boarDeathSound.play()
func playLizardDeathSound() -> void:
	lizardDeathSound.play()

func updateSoundVolumeVariables(busName: String, soundValue: float) -> void:
	match busName:
		"Master":
			masterVolume = soundValue
		"Music":
			musicVolume = soundValue
		"SFX":
			sfxVolume = soundValue
