extends PanelContainer

@export var costLabel: Label
@export var textLabel: Label
@export var functionLabel: Label

@onready var parent = self.get_parent()
@onready var positionParent = parent.get_parent().get_parent()

var tower = null

func _ready() -> void:
	hide()
	
	parent.mouse_entered.connect(onMouseEntered)
	parent.mouse_exited.connect(onMouseExited)

func _process(_delta: float) -> void:
	if visible:
		size = Vector2(234, 162)
		global_position = positionParent.global_position + Vector2(65,65)
		
		tower = GameManager.selectedTower
		if tower == null:
			return
		
		updateTooltip()

func onMouseEntered() -> void:
	show()

func onMouseExited() -> void:
	hide()

func updateTooltip() -> void:
	var pathIndex: int = parent.upgradePath
	var pathName: String = parent.UpgradePath.keys()[pathIndex]
	var tier: int = parent.upgradeTier
	
	var cost: int = getUpgradeCost(pathName, tier)
	
	costLabel.show()
	textLabel.show()
	functionLabel.show()
	
	costLabel.text = "Cost: " + str(cost)
	
	var title: String = ""
	var currentValue
	var nextValue
	
	var upgradeData: Dictionary = GameManager.TOWER_UPGRADES[tower.towerType][pathName]
	
	match tower.towerType:
		"Arrow":
			match pathName:
				"Left":
					title = "Damage Upgrade"
					currentValue = tower.damage
					if tier == 4:
						nextValue = tower.damage + upgradeData["tier4"]
					else:
						nextValue = tower.damage + upgradeData["damageIncrease"]
				"Middle":
					title = "Fire Rate Upgrade"
					currentValue = tower.fireRate
					if tier == 4:
						nextValue = tower.fireRate * upgradeData["tier4"]
					else:
						nextValue = tower.fireRate * upgradeData["fireRateIncreaseMultiplier"]
				"Right":
					title = "Range Upgrade"
					currentValue = tower.attackRange
					if tier == 4:
						nextValue = tower.attackRange * upgradeData["tier4"]
					else:
						nextValue = tower.attackRange * upgradeData["rangeIncreaseMultiplier"]
		"Slime":
			match pathName:
				"Left":
					title = "Slow Strength Upgrade"
					currentValue = (1.0 - tower.slimeSlowPercent) * 100
					if tier == 4:
						nextValue = currentValue + upgradeData["tier4Tooltip"]
					else:
						nextValue = currentValue + upgradeData["slowIncreasePercentTooltip"]
				"Middle":
					title = "Fire Rate Upgrade"
					currentValue = tower.fireRate
					if tier == 4:
						nextValue = tower.fireRate * upgradeData["tier4"]
					else:
						nextValue = tower.fireRate * upgradeData["fireRateIncreaseMultiplier"]
				"Right":
					title = "Range Upgrade"
					currentValue = tower.attackRange
					if tier == 4:
						nextValue = tower.attackRange * upgradeData["tier4"]
					else:
						nextValue = tower.attackRange * upgradeData["rangeIncreaseMultiplier"]
		"Cannon":
			match pathName:
				"Left":
					title = "Explosion Size Upgrade"
					currentValue = tower.cannonExplosionSize.x
					if tier == 4:
						nextValue = tower.cannonExplosionSize.x + upgradeData["tier4Tooltip"]
					else:
						nextValue = tower.cannonExplosionSize.x + upgradeData["explosionSizeIncreaseTooltip"]
				"Middle":
					title = "Fire Rate Upgrade"
					currentValue = tower.fireRate
					if tier == 4:
						nextValue = tower.fireRate * upgradeData["tier4"]
					else:
						nextValue = tower.fireRate * upgradeData["fireRateIncreaseMultiplier"]
				"Right":
					title = "Range Upgrade"
					currentValue = tower.attackRange
					if tier == 4:
						nextValue = tower.attackRange * upgradeData["tier4"]
					else:
						nextValue = tower.attackRange * upgradeData["rangeIncreaseMultiplier"]
	
	textLabel.text = title
	
	if tower.towerType == "Slime" and pathName == "Left":
		currentValue = str(snapped(currentValue , 0), "%")
		nextValue = str(snapped(nextValue , 0), "%")
	elif currentValue is float:
		currentValue = str(snapped(currentValue, 0.01))
		nextValue = str(snapped(nextValue, 0.01))
	else:
		currentValue = str(currentValue)
		nextValue = str(nextValue)
	
	
	var purchaseHistoryIndex: int = tier - 1
	var purchasedPath: String = tower.upgradePurchaseHistory[purchaseHistoryIndex]
	
	if purchasedPath == pathName:
		functionLabel.text = "Purchased\n Current value: " + currentValue
		costLabel.hide()
	elif purchasedPath != "None":
		functionLabel.modulate = Color.FIREBRICK
		functionLabel.text = "Locked\nAnother path was chosen for this tier"
		costLabel.hide()
	elif tier == tower.currentTier + 1:
		functionLabel.text = "Current value: " + currentValue + "\nNext: " + nextValue
	else:
		functionLabel.text =  "Current: " + currentValue


func getUpgradeCost(pathName, tier) -> int:
	var index: int = tier - 1
	
	match pathName:
		"Left":
			return tower.leftTierCosts[index]
		"Middle":
			return tower.middleTierCosts[index]
		"Right":
			return tower.rightTierCosts[index]
	
	return 0
