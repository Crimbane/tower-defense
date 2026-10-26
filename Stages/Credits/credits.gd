extends Control

@onready var creditsText: Label = $"Made By"

func _ready() -> void:
	SoundManager.playMenuMusic()
	var screenSize = get_viewport_rect().size
	
	var target = creditsText.position.y
	creditsText.position.y = screenSize.y


	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(creditsText, "position:y", target + -140, 5.0)
	await tween.finished
	await get_tree().create_timer(8).timeout
	

func _process(_delta) -> void:
	if Input.is_action_just_pressed("Escape"):
			get_tree().quit()
