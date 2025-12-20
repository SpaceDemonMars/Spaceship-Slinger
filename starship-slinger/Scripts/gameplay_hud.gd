extends CanvasLayer

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

func setTimer(time: float):
	@warning_ignore("integer_division")
	var minutes := int(time)/60 
	time -= (60*minutes)
	var m = "%d" % minutes
	var s = "%.2f" % time
	timeLabel.text = m + ':' + s


#Score
