class_name Stock
var value: int = -1
var recentSells: Array = []
var tracker: Array = []
var name: String

func calculateValue(newSoldValue: int):
	recentSells.append(newSoldValue)
	recentSells.sort()
	var medianPlace: int = int(len(recentSells) / 2)
	value = recentSells[medianPlace]

func saveValueAtTime():
	tracker.append(ValueAndTime.new(value, Time.get_ticks_msec()))

func _ready(soldStock: Signal):
	soldStock.connect(calculateValue)

func _init(newName: String):
	name = newName
