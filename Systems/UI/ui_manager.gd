extends Control

@export var towerBuyButton: Button
@export var placementManager: Node2D
@export var moneyLabel: Label
@export var towerUpgradeMenu: Control

func _ready() -> void:
	GameManager.UIManager = self
	updateMoneyUI()
	hideTowerUpgradeMenu()
	#towerBuyButton.pressed.connect(placementManager.startPlacement)


func _process(_delta: float) -> void:
	pass


func updateMoneyUI() -> void:
	if not moneyLabel:
		return
	moneyLabel.text = str(GameManager.money)

func placeTowerUpgradeMenu() -> void:
	if towerUpgradeMenu.visible:
		towerUpgradeMenu.hide()
		GameManager.selectedTower = null
		return
	GameManager.selectedTower.showAttackRange()
	
	var menuOffset = Vector2(85, 310)
	towerUpgradeMenu.global_position = GameManager.selectedTower.global_position - menuOffset
	towerUpgradeMenu.show()

func hideTowerUpgradeMenu() -> void:
	towerUpgradeMenu.hide()
	GameManager.selectedTower = null
