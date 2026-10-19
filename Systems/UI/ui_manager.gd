extends Control

@export var towerBuyButton: Button
@export var placementManager: Node2D
@export var moneyLabel: Label
@export var fpsLabel: Label
@export var towerUpgradeMenu: Control
@export var towerUpgradeMenuGrid: GridContainer

var hideCooldown: bool = false

func _ready() -> void:
	GameManager.UIManager = self
	updateMoneyUI()
	hideTowerUpgradeMenu()
	#towerBuyButton.pressed.connect(placementManager.startPlacement)


func _process(_delta: float) -> void:
	showFPS()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Left Click"):
		if GameManager.selectedTower != null:
			hideTowerUpgradeMenu()

func showFPS() -> void:
	fpsLabel.text = str(Engine.get_frames_per_second())

func updateMoneyUI() -> void:
	if not moneyLabel:
		return
	moneyLabel.text = str(GameManager.money)

func placeTowerUpgradeMenu() -> void:
	if towerUpgradeMenu.visible:
		hideTowerUpgradeMenu()
		return
	GameManager.selectedTower.showAttackRange()
	
	updateTowerUpgradeMenuColors()
	
	var menuOffset = Vector2(150, 630)
	
	var spawnPosition = GameManager.selectedTower.global_position - menuOffset
	if spawnPosition.x < 0:
		spawnPosition.x -= spawnPosition.x
	if spawnPosition.y < 0:
		spawnPosition.y -= spawnPosition.y
	
	towerUpgradeMenu.global_position = spawnPosition
	towerUpgradeMenu.show()

func hideTowerUpgradeMenu() -> void:
	towerUpgradeMenu.hide()
	GameManager.selectedTower = null

func updateTowerUpgradeMenuColors() -> void:
	for button in towerUpgradeMenuGrid.get_children():
		button.updateColor()
