extends State

class_name Defend

func enter(kwargs):
	%Weapon.safty = false
	# %Sprite2D.set_texture(self.owner.SPRITES["Weapon"])

func process(_delta: float):
	var enemies = %Weapon.find_targetable_enemies()
	if enemies.size() == 0:
		transitioned.emit("Default", {})
	else:
		var enemy = Utils.find_closest(self.owner, enemies)
		%Weapon.aim_at(enemy)

func exit():
	%Weapon.safty = true
	%Weapon.aim_at(null)
