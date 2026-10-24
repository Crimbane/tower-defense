extends Button

func _ready() -> void:
	pressed.connect(onButtonPressed)

func onButtonPressed() -> void:
	GameManager.waveManager.toggleAutoplay()
