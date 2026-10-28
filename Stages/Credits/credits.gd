extends Control

@onready var creditsText: Label = $"Made By"
@onready var anyKeyText: Label = %AnyKeyLabel
var creditsFinished: bool = false

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
	await get_tree().create_timer(2).timeout
	anyKeyText.visible = true
	creditsFinished = true


func _process(_delta: float) -> void:
	if Input.is_anything_pressed() and creditsFinished:
		get_tree().change_scene_to_file(GameManager.MAIN_MENU)
