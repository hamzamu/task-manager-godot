extends Control

var arr = [1,2,10,4,5]
var random = int(rand_range(1,600))


# Called when the node enters the scene tree for the first time.
func _ready():
	print(random);
	for i in arr:
		print(str(i))
		create_label(i)
	pass # Replace with function body.


func create_label(i):
	var my_label_node = Label.new()
	$VBoxContainer/HBoxContainer2/HSplitContainer/Panel2/tasks.add_child(my_label_node)
	#(self)
	my_label_node.set_owner(self)
	my_label_node.set_text('Text' + str(i))
	#my_label_node.set_position(Vector2(150,150))
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

