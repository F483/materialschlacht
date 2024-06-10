extends Marker2D

class_name Spawner

@export var disabled: bool = false
@export var extra_rotation: float = 0.0
@export var extra_scale: float = 1.0

const RESOURCES = {
    "SmokeExplosion": preload("res://effects/smoke_explosion/smoke_explosion.tscn"),
    "MuzzleFlash": preload("res://effects/muzzle_flash/muzzle_flash.tscn")
}

@export_enum("SmokeExplosion", "MuzzleFlash") var scene_name: String = "SmokeExplosion"

func trigger():
    if not disabled:
        var scene = RESOURCES[scene_name].instantiate()
        get_parent().get_parent().add_child(scene)
        scene.global_position = global_position
        scene.rotation += extra_rotation
        scene.scale.x *= extra_scale
        scene.scale.y *= extra_scale
        return scene
    return null
