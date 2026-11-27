extends Node

@export var nwl: DictNWL
@export var other: DictOther
@export var keyboard: Keyboard
@export var output: RichTextLabel

@onready var OriginalText = output.text

func Search(toFind: String, toSearch: PackedStringArray) -> int:
	var low = 0;
	var high: int = toSearch.size() - 1
	while low <= high:
		var center = low + (high - low) / 2;
		if toSearch[center] == toFind:
			return center
		if toSearch[center] < toFind:
			low = center + 1
		else:
			high = center - 1
	return -1

func _on_keyboard_on_edit() -> void:
	var toFind = keyboard.output.text.to_lower()
	var inNWL = Search(toFind, nwl.words)
	var inOther = Search(toFind, other.words)
	output.clear()
	if inNWL >= 0:
		if inOther >= 0:
			output.add_text("SHARED! x2")
		else:
			output.add_text("BORING! x1")
	elif inOther >= 0:
		output.add_text("UNIQUE! x3")
	else:
		output.add_text("Invalid. x0")
		return
	output.newline()
	output.add_text("\"" + toFind.to_upper() + "\"")
	if inOther >= 0:
		var otherCount = other.count[inOther]
		output.add_text(" appears " + str(otherCount) + " time")
		if otherCount > 1:
			output.add_text("s")
		output.add_text(" in the original text.")
	else:
		output.add_text(" is only in the NWL dictionary...")

func _on_info_pressed() -> void:
	output.clear()
	output.add_text(OriginalText)

func _on_unique_pressed() -> void:
	output.clear()
	for word in other.words:
		if Search(word, nwl.words) == -1:
			output.add_text(word)
			output.newline()
