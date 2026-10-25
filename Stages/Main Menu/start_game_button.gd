extends Button



func _ready() -> void:
	pressed.connect(toMainMenu)
	
	mouse_entered.connect(SoundManager.playButtonHoverSound)


func toMainMenu() -> void:
	SoundManager.playButtonClickSound()
	GameManager.startRun()
	SoundManager.playRandomTrack()
	
	get_tree().change_scene_to_file(GameManager.GAME)
