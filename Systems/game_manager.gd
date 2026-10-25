extends Node


const GAME: String = "res://Stages/Game/desert_map.tscn"
const MAIN_MENU: String = "res://Stages/Main Menu/main_menu.tscn"

var nexus: Node = null
var UIManager: Node = null
var waveManager: Node = null
var selectedTower: Node2D = null

const START_MONEY = 10000
var moneyMultiplier: int = 2

var money: int = START_MONEY

var arrowTowerCost = 20
var fireTowerCost = 50
var slimeTowerCost = 35
var cannonTowerCost = 100

var leftTierCosts: Array[int] = [30, 60, 120, 180]
var middleTierCosts: Array[int] = [25, 50, 100, 150]
var rightTierCosts: Array[int] = [20, 40, 80, 120]

const TOWER_UPGRADES = {
	"Arrow": {
		"Left":{
			"damageIncrease": 10,
			"tier4": 20
		},
		"Middle":{
			"fireRateIncreaseMultiplier": 0.75,
			"tier4": 0.5
		},
		"Right":{
			"rangeIncreaseMultiplier": 1.15,
			"tier4": 1.3
		}
	},
	"Fire": {
		"Left":{
			"damageIncrease": 1,
			"tier4": 2
		},
		"Middle":{
			"fireRateIncreaseMultiplier": 0.8,
			"tier4": 0.6
		},
		"Right":{
			"rangeIncreaseMultiplier": 1.15,
			"tier4": 1.3
		}
	},
	"Slime": {
		"Left":{
			"slowIncreasePercent": 0.10,
			"tier4": 0.20,
			
			"slowIncreasePercentTooltip": 10,
			"tier4Tooltip": 20
		},
		"Middle":{
			"fireRateIncreaseMultiplier": 0.75,
			"tier4": 0.5
		},
		"Right":{
			"rangeIncreaseMultiplier": 1.1,
			"tier4": 1.2
		}
	},
	"Cannon": {
		"Left":{
			"explosionSizeIncrease": Vector2(1, 1),
			"tier4": Vector2(2, 2),
			
			"explosionSizeIncreaseTooltip": 1,
			"tier4Tooltip": 2
		},
		"Middle":{
			"fireRateIncreaseMultiplier": 0.9,
			"tier4": 0.8
		},
		"Right":{
			"rangeIncreaseMultiplier": 1.15,
			"tier4": 1.3
		}
	}
}

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		get_tree().quit()


func increaseMoney(amount: int) -> void:
	money += amount
	UIManager.updateMoneyUI()

func removeMoney(amount: int) -> void:
	money -= amount
	UIManager.updateMoneyUI()

func startRun() -> void:
	money = START_MONEY
