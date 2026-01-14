extends CanvasLayer

@onready var fuel_label: Label = $MarginContainer/CenterContainer/FuelLabel

func update_fuel(amt):
	fuel_label.text = "Fuel: " + str(amt)
