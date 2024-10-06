extends Node

signal hand_slot_changed(data: InventorySlotData)
signal accessed_inventory_changed(inventory: InventoryContainer)

var hand_slot: InventorySlotData = null:
	set(value):
		hand_slot = value
		hand_slot_changed.emit(hand_slot)

var accessed_inventory: InventoryContainer = null:
	set(value):
		accessed_inventory = value
		accessed_inventory_changed.emit(accessed_inventory)
		

var player_inventory: InventoryContainer = null
