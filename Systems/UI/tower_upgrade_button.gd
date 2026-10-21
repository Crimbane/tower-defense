extends Button

#@export_enum(
	#"Left", "Middle", "Right") var upgradePath: String = "Right"

enum UpgradePath {
	Left,
	Middle,
	Right
}

@export var upgradePath = UpgradePath.Left:
	set(value):
		upgradePath = value
		if is_node_ready():
			updateIcon()

@export_range(
	1, 4 , 1) var upgradeTier: int = 1

const ICON_TEXTURE: Dictionary[String, CompressedTexture2D] = {
	LEFT = preload("uid://6asst08vlprb"),
	MIDDLE = preload("uid://f33ovxvcyajm"),
	RIGHT = preload("uid://1elfyko80ywj")
}

@onready var buttonIcon: TextureRect = $Icon

var purchased: bool = false


func _ready() -> void:
	pressed.connect(onButtonPress)
	updateIcon()
	updateColor()


func onButtonPress() -> void:
	if GameManager.selectedTower != null:
		if purchased == false:
			var pathString: String = UpgradePath.keys()[upgradePath]
			GameManager.selectedTower.upgradeTower(pathString, upgradeTier)
	

func updateIcon() -> void:
	if not buttonIcon:
		return
	
	var pathIndex: int = upgradePath
	var pathName: String = UpgradePath.keys()[pathIndex]
	buttonIcon.texture = ICON_TEXTURE[pathName.to_upper()]

func updateColor() -> void:
	var tower = GameManager.selectedTower
	if not tower:
		return
	
	var buttonTier = upgradeTier
	
	var pathString: String = UpgradePath.keys()[upgradePath]
	#var towerPathTier: int = tower.get(pathString.to_lower() + "Tier")
	
	var activeTierPath: String = tower.upgradePurchaseHistory[buttonTier -1]
	
	if activeTierPath == pathString:
		buttonIcon.modulate = Color(0.5, 1.0, 0.5)
		purchased = true
	
	elif activeTierPath != "None":
		buttonIcon.modulate = Color.DARK_RED
		purchased = false
	elif buttonTier == tower.currentTier + 1:
		buttonIcon.modulate = Color.WHITE
		purchased = false
	
	else:
		buttonIcon.modulate = Color(0.5,0.5,0.5)
		purchased = false
