extends Button

@export_enum(
	"Left", "Middle", "Right") var upgradePath: String = "Right"

@export_enum(
	"1", "2", "3", "4") var upgradeTier: String = "1"

func _ready() -> void:
	pressed.connect(onButtonPress)


func onButtonPress() -> void:
	if GameManager.selectedTower != null:
		GameManager.selectedTower.upgradeTower(upgradePath, upgradeTier)
	

func updateColor() -> void:
	var tower = GameManager.selectedTower
	if not tower:
		return
	
