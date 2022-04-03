extends Panel

var number=-1 setget set_number
var marked=false

func set_number(n):
	number=n
	if number==-1:
		$CenterContainer/Label.text=""
		return
	$CenterContainer/Label.text=str(number)

func mark():
	if not marked:
		set_modulate(Color("#999999"))
		marked=true
	else:
		set_modulate(Color("ffffff"))
		marked=false

