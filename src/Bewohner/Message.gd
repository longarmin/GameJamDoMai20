class_name Message

var iStatus: int
var sContent: String
var emitter: Node
var dParams: Dictionary


func _init(status, content, emitterNode, params = {}):
	iStatus = status
	sContent = content
	emitter = emitterNode
	dParams = params
