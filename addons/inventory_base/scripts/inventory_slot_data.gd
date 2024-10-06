#@tool
class_name InventorySlotData
extends Resource

@export var item: InventoryItem = null
	#set(value):
		#item = value
		#changed.emit()
@export var amount: int = 0
	#set(value):
		#amount = value
		#changed.emit()
