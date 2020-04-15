extends Control
var path = "user://data.json"
var path2 = "res://data.json"
# Setting default path
var current_path = path

var tasks;
var tasksTemplate = [
	{
		"task":"Your first task",
		"done": false
	}
]

#### App is ready ####
func _ready():
	read_file()
	renderTasks()
	pass

#### renderTasks ####
func renderTasks():
	# tasks || data
	if tasks == null:
		tasks = tasksTemplate
	for task in tasks:
		create_task_element(task)
	return
	
#### Create a task element ####
func create_task_element(task):
	var vh = HBoxContainer.new()
	vh.set_name(str(task.task))
	var checkbox = CheckBox.new()
	checkbox.set_text(str(task.task))
	var delete = Button.new()
	delete.set_name('delete')
	delete.set_text("x")
	vh.add_child(delete)
	vh.add_child(checkbox)	
	$ScrollContainer/tasks.add_child(vh)	
	# If Task is pressed
	if task.done == true:
		checkbox.pressed = true
	if checkbox.pressed:
		print("Checked: "+ str(task.task));
	checkbox.connect("toggled", self, "button_toggled", [task.task])
	delete.connect("pressed", self, "delete_clicked", [task.task])
	pass
	
#### Delete Task ####
func delete_clicked(s):
	print("deleting:", s)
	for i in tasks:
		if i.task == s:
			get_tree().get_root().find_node(str(s), true, false).queue_free()
			tasks.erase(i)
			save_file(tasks)			
			print("Task found", tasks)
	pass



#### Updated ####
func button_toggled(toggled, target):
	print("Button Clicked for: ", str(target))
	findTaskUpdate(tasks,target)
	if toggled == true:
		print("Button is pressed")		
	else:
		print("Button is released")
	pass

##### FindTaskUpdate
func findTaskUpdate(list, item):
	for i in list:
		if i.task == item:
			if i.done == false:
				i.done = true
			else:
				i.done = false
			print("Task Updated", i.task , ": ", i.done)
			save_file(tasks)
			return i 
	pass
##### SET NEW TASK
func newTask(task):
	tasks.append({"task":task, "done":false})
	create_task_element({"task":task, "done":false})
	save_file(tasks)
	print(tasks)
	pass
##### Input: Clear
func _on_setTask_focus_entered():
	clearInput()
	pass # Replace with function body.
##### Input: Text
func _on_setTask_gui_input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ENTER:
			var task = $setTask.text
			if 	$setTask.get_text().length() >  2:
				print("Ready",$setTask.get_text().length())
				newTask(task)
				clearInput()
	pass
#######################################
##### Clear Input
func clearInput():
	$setTask.text = str("")
	pass
#####################################################
func read_file():
	var file = File.new();	
	if not file.file_exists(current_path):
		print("File Does not exist")
		save_file(tasks)		
	file.open(current_path, file.READ)
	var fileData = file.get_as_text()
	var json = parse_json(fileData)
	tasks = json
	print("JSON ready: ",json)
	return json
#####################################################
func save_file(data):
	var file = File.new();	
	file.open(current_path, File.WRITE)
	file.store_line(to_json(data))
	file.close()
	return
#####################################################
