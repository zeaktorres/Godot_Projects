extends Node2D
class_name StockHandler

var stocks = []

# Called when the node enters the scene tree for the first time.
func _ready():
    stocks.append(Stock.new('GMEE'))
