extends Node

var nexus: Node = null
var UIManager: Node = null
var selectedTower: Node2D = null

const START_MONEY = 10000

var money: int = START_MONEY

var arrowTowerCost = 50
var fireTowerCost = 100
var iceTowerCost = 100
var cannonTowerCost = 200

var leftTierCosts: Array[int] = [30, 60, 120]
var middleTierCosts: Array[int] = [25, 50, 100]
var rightTierCosts: Array[int] = [20, 40, 80]

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
