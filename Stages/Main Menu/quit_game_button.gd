extends Button



func _ready() -> void:
	pressed.connect(quitGame)
	
	mouse_entered.connect(SoundManager.playButtonHoverSound)


func quitGame() -> void:
	SoundManager.playButtonClickSound()
	#GameManager.saveGame()
	#GameManager.saveSettings()
	
	get_tree().quit()
