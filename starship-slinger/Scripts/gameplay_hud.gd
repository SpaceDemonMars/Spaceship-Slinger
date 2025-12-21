extends CanvasLayer

@onready var warningPopup = $WarningWindow #hook for playspace

@onready var fuelBar = $FuelGuage
@onready var delayedFuelBar = $FuelGuage/UsedFuel
@onready var delayTimer = $FuelGuage/UsageDelay
var fuel = 0 

#Fuel Bar
func setFuel(new_fuel):
	var prev_fuel = fuel
	fuel = min(fuelBar.max_value, new_fuel)
	fuelBar.value = fuel
	#possible use queue_free on bar when empty
	if fuel < prev_fuel:
		delayTimer.start()
	else:
		delayedFuelBar.value = fuel
	
func init_fuel(_f):
	fuelBar = $FuelGuage
	delayedFuelBar = $FuelGuage/UsedFuel
	delayTimer = $FuelGuage/UsageDelay
	fuel = _f
	fuelBar.max_value = fuel
	fuelBar.value = fuel
	delayedFuelBar.max_value = fuel
	delayedFuelBar.value = fuel

func _on_usage_delay_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(delayedFuelBar, "value", fuelBar.value, .8).set_ease(Tween.EASE_OUT)


#Timer
@onready var timeLabel = $ScoreTimeContainer/Timer

func setTimer(time: float = 0.0):
	timeLabel.text = GameManager.utilConvertTimetoString(time)


#Score
@onready var scoreLabel = $ScoreTimeContainer/Score

func setScore():
	scoreLabel.text = "%d" % GameManager.totalScore


#Health
@onready var healthBar = $Health
@onready var delayedHealth = $Health/DelayedHealth
@onready var timerHealth = $Health/TimerHealth
var health = 0 

func setHP():
	var prev_health = health
	health = min(healthBar.max_value, GameManager.activeLevel.player.health)
	healthBar.value = health
	#possible use queue_free on bar when empty
	if health < prev_health:
		timerHealth.start()
	else:
		delayedHealth.value = health
	
func init_HP():
	healthBar = $Health
	delayedHealth = $Health/DelayedHealth
	timerHealth = $Health/TimerHealth
	health = GameManager.activeLevel.player.health
	healthBar.max_value = health
	healthBar.value = health
	delayedHealth.max_value = health
	delayedHealth.value = health

func _on_timer_health_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(delayedHealth, "value", healthBar.value, .8).set_ease(Tween.EASE_OUT)



#General
func _ready():
	setScore()
