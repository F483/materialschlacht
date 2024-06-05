extends State

class_name Attack

# TODO implement ... @export var transition_when_obscured: bool = false
# TODO implement ... @export var transition_when_outranged: bool = false

var targets: Array[Node2D] = []

func enter(kwargs):
	targets = kwargs["targets"]
	%Weapon.safty = false
	# %Sprite2D.set_texture(self.owner.SPRITES["Weapon"])

func process(_delta: float):
	targets = Utils.filter_invalid(targets)
	if targets.size() == 0:
		transitioned.emit("Default", {})
	else:
		var enemy = Utils.find_closest(self.owner, targets)
		%Weapon.aim_at(enemy)

func exit():
	%Weapon.safty = true
	%Weapon.aim_at(null)
