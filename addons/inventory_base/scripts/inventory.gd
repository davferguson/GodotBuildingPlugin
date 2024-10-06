#@tool
class_name Inventory
extends Resource

@export var items: Array[InventorySlotData] = []:
	set(value):
		#print("inventory: set_inventory")
		items = value
		#for item: InventorySlotData in items:
			#if item != null:
				#if not item.changed.is_connected(emit_changed):
					#item.changed.connect(emit_changed)
		#changed.emit()

func add_item(slot_data: InventorySlotData) -> InventorySlotData:
	for index in items.size():
		if slot_data == null:
			return null
		if items[index] == null:
			continue
		if items[index].item == slot_data.item:
			if items[index].amount < items[index].item.max_stack:
				var total_amount = items[index].amount + slot_data.amount
				if total_amount <= items[index].item.max_stack:
					items[index].amount = total_amount
					return null
				else:
					items[index].amount = items[index].item.max_stack
					slot_data.amount = total_amount - items[index].amount
	var empty_index = find_first_empty_slot()
	while empty_index != -1:
		if slot_data.amount <= slot_data.item.max_stack:
			items[empty_index] = slot_data
			return null
		else:
			var new_slot_data = InventorySlotData.new()
			new_slot_data.item = slot_data.item
			new_slot_data.amount = slot_data.item.max_stack
			items[empty_index] = new_slot_data
			slot_data.amount -= new_slot_data.amount
		empty_index = find_first_empty_slot()
	return slot_data

func find_first_empty_slot() -> int:
	for index in items.size():
		if items[index] == null:
			return index
	return -1

func combine_slot(index: int):
	#print("double clisk: ", items[index])
	if items[index] == null:
		return
	else:
		var slot_data: InventorySlotData = items[index]
		items[index] = null
		for i in items.size():
			if slot_data.amount == slot_data.item.max_stack:
				break
			if items[i] != null:
				if items[i].item == slot_data.item:
					var total_amount = items[i].amount + slot_data.amount
					if total_amount <= slot_data.item.max_stack:
						slot_data.amount = total_amount
						items[i] = null
					else:
						slot_data.amount = slot_data.item.max_stack
						items[i].amount = total_amount - slot_data.amount
		items[index] = slot_data
