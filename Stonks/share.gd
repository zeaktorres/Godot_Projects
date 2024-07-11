class_name Share

var sellValue: int
var shareOwner: Owner

func _init(newValue: int, newShareOwner: Owner):
	shareOwner = newShareOwner
	sellValue = newValue 
	pass

func purchase(newOwner: Owner):
	shareOwner = newOwner

func sell(newOwner: Owner):
	shareOwner = newOwner

func auction(newValue: int):
	sellValue = newValue
