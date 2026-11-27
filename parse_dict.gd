extends Node

func ParseNWL():
	var file = FileAccess.open("res://NWL2023.txt", FileAccess.READ)
	var output = "extends Node\nclass_name DictNWL\nvar words:PackedStringArray = [\n"
	while not file.eof_reached():
		var word = file.get_line()
		if word.length() > 1 and word.length() <= 15:
			output += "\"" + word + "\",\n"
	output += "]"
	var fileOut = FileAccess.open("res://dictionary_nwl.gd", FileAccess.WRITE)
	fileOut.store_string(output)

func ParseOther():
	var file = FileAccess.open("res://RomeoJuliette.txt", FileAccess.READ)
	var dictionary: Dictionary = {}
	# "[^a-zA-Z]" implies all letters not between a-z or A-Z
	var onlyLetters = RegEx.create_from_string("[^a-zA-Z]")
	while not file.eof_reached():
		var line = file.get_line().to_lower()
		var words = line.split(" ", false)
		for word in words:
			if word.contains("'") or word.contains("-"):
				continue
			word = onlyLetters.sub(word, "", true)
			if word.length() <= 1 or word.length() > 15:
				continue
			if dictionary.has(word):
				dictionary[word] += 1
			else:
				dictionary[word] = 1
	var output = "extends Node\nclass_name DictOther\nvar words:PackedStringArray = [\n"
	var keys: PackedStringArray = dictionary.keys()
	keys.sort()
	for key in keys:
		output += "\"" + key + "\",\n"
	output += "]\nvar count:PackedInt32Array = [\n"
	for key in keys:
		output += "\"" + str(dictionary[key]) + "\",\n"
	output += "]"
	var fileOut = FileAccess.open("res://dictionary_other.gd", FileAccess.WRITE)
	fileOut.store_string(output)

func _ready() -> void:
	#ParseNWL()
	ParseOther()
