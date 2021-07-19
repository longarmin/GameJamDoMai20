extends Node

onready var dictNachbarn = {
	"Karl":{
		"Wohnung":"Wohnung2",
		"Status":"Zuhause"
	},
	"Rolgadina":{
		"Wohnung":"Wohnung6",
		"Status":"Zuhause"
	}
}
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(String(dictNachbarn.get("Karl")))
	var bla=get_keys_by_value(dictNachbarn, "Wohnung2")
	print("String(bla) = " + String(bla))
	
func get_keys_by_value(dict_to_check, val):
	var listOfKeys=[]
	#var listOfItems=dict_to_check.items()
	for item in dict_to_check:
		print("item[0]= " + str(item) + 
		" \nitem[1]= " + str(dict_to_check[item]) +
		" \ntypeof(item[0]) = " + str(typeof(item)) +
		" \ntypeof(item[1] = " + str(typeof(dict_to_check[item])))
		if typeof(dict_to_check[item]) == TYPE_DICTIONARY:
			listOfKeys.append(get_keys_by_value(dict_to_check[item], val))
		elif dict_to_check[item] == val:
			listOfKeys.append(dict_to_check[item])
	print(str(listOfKeys))
	return listOfKeys




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
