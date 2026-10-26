extends Control

@export var towerBuyButton: Button
@export var moneyLabel: Label
@export var fpsLabel: Label
@export var towerUpgradeMenu: Control
@export var towerUpgradeMenuGrid: GridContainer
@export var nextWaveButton: Button
@export var autoplayButton: Button
@export var autoplayOnIcon: TextureRect
@export var autoplayOffIcon: TextureRect
@export var waveNumberLabel: Label
@export var nexusHealthLabel: Label
@export var escapeMenu: Control

var hideCooldown: bool = false

func _ready() -> void:
	GameManager.UIManager = self
	updateMoneyUI()
	
	hideTowerUpgradeMenu()
	
	await get_tree().create_timer(1).timeout
	autoplayButton.pressed.connect(GameManager.waveManager.toggleAutoplay)
	nextWaveButton.pressed.connect(GameManager.waveManager.startNextWaveEarly)


func _process(_delta: float) -> void:
	showFPS()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Left Click"):
		if GameManager.selectedTower != null:
			hideTowerUpgradeMenu()
			get_viewport().set_input_as_handled()

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
	if GameManager.selectedTower != null:
		GameManager.selectedTower.hideAttackRange()
	
	towerUpgradeMenu.hide()
	GameManager.selectedTower = null

func updateTowerUpgradeMenuColors() -> void:
	for button in towerUpgradeMenuGrid.get_children():
		button.updateColor()

func updateWaveNumberLabel() -> void:
	waveNumberLabel.text = "Wave:\n" + str(GameManager.waveManager.currentWave) + " / " + str(GameManager.waveManager.MAX_WAVES)

func updateNexusHealthLabel(health: int) -> void:
	nexusHealthLabel.text = str(health)

func toggleEscapeMenu() -> void:
	if escapeMenu.visible:
		escapeMenu.hide()
		get_tree().paused = false
	else:
		escapeMenu.show()
		get_tree().paused = true
