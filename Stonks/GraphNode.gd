extends GraphNode

@onready var graphTimer: Timer = $"GraphTimer" 
signal graphTimerSignal

func plotPoint():
    pass

func graphTimerTimeout():
    graphTimerSignal.emit()

# Called when the node enters the scene tree for the first time.
func _ready():
    graphTimer.timeout.connect(graphTimerTimeout)


