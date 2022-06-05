extends Node
class_name QuestGenerator

export var iQuestGeneratorTime: int = 5
var questGeneratorTimer: Timer
export var bTargetDumps: bool = true
export var bTargetFlats: bool = false
export var bTargetBewohner: bool = false

onready var aRandDump = get_tree().get_nodes_in_group("dumps")

func _ready():
    questGeneratorTimer = Timer.new()
    questGeneratorTimer.name = "questGeneratorTimer"
    add_child(questGeneratorTimer)

func generate_quest(targetDumps = bTargetDumps, targetFlats = bTargetFlats, targetBewohner = bTargetBewohner) -> AIQuest:
    var randomTargets: Array = []
    if targetDumps:
        randomTargets.append(aRandDump[randi() % aRandDump.size()])
    if targetFlats:
        var aRandFlat = get_tree().get_nodes_in_group("flats")
        randomTargets.append(aRandFlat[randi() % aRandFlat.size()])
    if targetBewohner:
        var aRandBewohner = get_tree().get_nodes_in_group("Bewohner")
        randomTargets.append(aRandBewohner[randi() % aRandBewohner.size()])
    var quest = AIQuest.new(randomTargets[randi() % randomTargets.size()], 10)
    return quest