#@tool
extends Button


const BUTTON_BACKGROUND = preload("uid://dnks7we1bvg17")

const ICON_TEXTURE: Dictionary[String, CompressedTexture2D] = {
	ARROW = preload("uid://ycypt7ywptfh"),
	FIRE = preload("uid://d1dpyd3gpr4jg"),
	ICE = preload("uid://xvn050hxkt2d"),
	CANNON = preload("uid://b3xyiytg4ylhq"),
}

const TOWER_SCENES: Dictionary[String, PackedScene] = {
	ARROW = preload("uid://bghlwrvg8h01x"),
	FIRE = preload("uid://d21cd6rl6j76n"),
	ICE = preload("uid://kx0msk5dsok3"),
	CANNON = preload("uid://7tfgc51ngohn"),
}

enum TowerSprite {
	Arrow,
	Fire,
	Ice,
	Cannon
}

@export var towerSprite = TowerSprite.Arrow:
	set(value):
		towerSprite = value
		updateIcon()

@export var cost: int = 10:
	set(value):
		cost = value

@onready var buttonIcon: TextureRect = $Icon
@onready var dropShadow: TextureRect = $Icon/DropShadow




func _ready() -> void:
	pressed.connect(_on_shape_button_press)
	updateIcon()
	#if not Engine.is_editor_hint():
		#updateVisibility()

func _process(_delta: float) -> void:
	#updateVisibility()
	pass
func updateIcon() -> void:
	if not buttonIcon or not dropShadow:
		return
	buttonIcon.texture = ICON_TEXTURE[TowerSprite.find_key(towerSprite).to_upper()]
	dropShadow.texture = ICON_TEXTURE[TowerSprite.find_key(towerSprite).to_upper()]

func updateVisibility() -> void:
	if towerSprite :#<= GameManager.StateInfo[GameManager.currentState].HighestUnlockedShapeButton:
		show()
	else:
		hide()
	

func _on_shape_button_press() -> void:
	print("button pressed")
	
	var keyName = TowerSprite.find_key(towerSprite).to_upper()
	var towerScene = TOWER_SCENES[keyName]
	
	var placementScript = get_tree().get_first_node_in_group("Placement Manager")
	
	placementScript.startPlacement(towerScene)
