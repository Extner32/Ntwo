extends Control

var gui_stack = []

func _ready():
	gb.gui_ref = self
	


func stack_append(node):
	for lower_node in gui_stack:
		lower_node.hide()
	gui_stack.append(node)
	node.show()
	
	
func stack_remove(node):
	var idx = gui_stack.find(node)
	for i in range(idx, len(gui_stack)):
		gui_stack[i].hide()
		gui_stack.pop_at(i)
	
	if idx-1 >= 0:
		gui_stack[idx-1].show()
		
