extends Button



func _ready() -> void:
	pressed.connect(toMainMenu)
	
	#mouse_entered.connect(SoundManager.playMenuButtonHoverSound)


func toMainMenu() -> void:
	#SoundManager.playMenuButtonClickSound()
	
	get_tree().change_scene_to_file(GameManager.GAME)
