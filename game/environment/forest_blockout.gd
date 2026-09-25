class_name ForestBlockout
extends Node3D

const COMMON_TREE_SCENE := preload("res://assets/third_party/quaternius_stylized_nature/glTF/CommonTree_1.gltf")
const TWISTED_TREE_SCENE := preload("res://assets/third_party/quaternius_stylized_nature/glTF/TwistedTree_2.gltf")
const ROCK_SCENE := preload("res://assets/third_party/quaternius_stylized_nature/glTF/Rock_Medium_1.gltf")
const FERN_SCENE := preload("res://assets/third_party/quaternius_stylized_nature/glTF/Fern_1.gltf")
const GRASS_SCENE := preload("res://assets/third_party/quaternius_stylized_nature/glTF/Grass_Common_Short.gltf")
const BUSH_SCENE := preload("res://assets/third_party/quaternius_stylized_nature/glTF/Bush_Common.gltf")

var _sway_groups: Array[Node3D] = []
var _water_material: StandardMaterial3D
var _time := 0.0

const TRUNK_COLOR := Color(0.20, 0.115, 0.07)
const BARK_LIGHT := Color(0.31, 0.19, 0.10)
const MOSS_COLOR := Color(0.22, 0.43, 0.20)
const LEAF_DARK := Color(0.08, 0.24, 0.16)
const LEAF_MID := Color(0.14, 0.38, 0.22)
const LEAF_LIGHT := Color(0.29, 0.52, 0.25)


func _ready() -> void:
	_build_forest_layers()
	_build_gameplay_dressing()
	_build_water_feature()
	_build_asset_preview_grove()


func _process(delta: float) -> void:
	_time += delta
	for index in _sway_groups.size():
		var foliage := _sway_groups[index]
		foliage.rotation.z = sin(_time * (0.65 + index % 4 * 0.08) + index * 0.73) * 0.025
	if _water_material:
		_water_material.uv1_offset.x = fmod(_time * 0.025, 1.0)
		_water_material.uv1_offset.y = fmod(_time * 0.055, 1.0)


func _build_forest_layers() -> void:
	# Repeated silhouettes give the blockout foreground, midground and background
	# depth without committing the project to a production asset pack.
	for index in 18:
		var x := -18.0 + index * 6.0
		var z := -8.5 - float(index % 3) * 3.2
		var height := 8.0 + float((index * 7) % 5)
		_add_tree(Vector3(x, -0.2, z), height, 0.75, LEAF_DARK, false)
	for index in 15:
		var x := -14.0 + index * 7.0
		var z := -3.8 - float(index % 2) * 1.4
		var height := 6.0 + float((index * 5) % 4)
		_add_tree(Vector3(x, -0.1, z), height, 0.58, LEAF_MID, true)
	# The camera-side layer is intentionally sparse. It should frame the route and
	# create parallax without repeatedly hiding the player or landing surfaces.
	for index in 6:
		var x := -18.0 + index * 20.0
		var z := 6.8 + float(index % 2) * 1.0
		var height := 11.5 + float((index * 3) % 3)
		_add_tree(Vector3(x, -0.4, z), height, 0.46, LEAF_DARK, true)


func _build_gameplay_dressing() -> void:
	var moss_material := _material(MOSS_COLOR, 0.95)
	var stone_material := _material(Color(0.20, 0.25, 0.21), 0.9)
	var earth_material := _material(Color(0.16, 0.115, 0.075), 1.0)
	var bark_material := _material(BARK_LIGHT, 1.0)
	var moss_caps := [
		[Vector3(-10, 0.035, 0), Vector3(16, 0.07, 4.05)],
		[Vector3(7, 0.035, 0), Vector3(10, 0.07, 4.05)],
		[Vector3(14, 1.735, 0), Vector3(4.55, 0.07, 4.05)],
		[Vector3(19, 3.435, 0), Vector3(3.25, 0.07, 4.05)],
		[Vector3(24, 5.335, 0), Vector3(4.55, 0.07, 4.05)],
		[Vector3(49, 2.835, 0), Vector3(10, 0.07, 4.05)],
		[Vector3(55, 5.135, 0), Vector3(3.25, 0.07, 4.05)],
		[Vector3(60, 7.335, 0), Vector3(3.25, 0.07, 4.05)],
		[Vector3(68, 0.035, 0), Vector3(16, 0.07, 4.05)],
	]
	for cap in moss_caps:
		_add_box(cap[0], cap[1], moss_material)

	_dress_ground_bank(Vector3(-10, -0.48, 0), 16.0, earth_material, stone_material, moss_material)
	_dress_ground_bank(Vector3(7, -0.48, 0), 10.0, earth_material, stone_material, moss_material)
	_dress_log(Vector3(14, 1.4, 0), 4.5, bark_material, moss_material)
	_dress_log(Vector3(19, 3.1, 0), 3.2, bark_material, moss_material)
	_dress_log(Vector3(24, 5.0, 0), 4.5, bark_material, moss_material)
	_dress_ground_bank(Vector3(49, 2.32, 0), 10.0, earth_material, stone_material, moss_material)
	_dress_log(Vector3(55, 4.8, 0), 3.2, bark_material, moss_material)
	_dress_log(Vector3(60, 7.0, 0), 3.2, bark_material, moss_material)
	_dress_ground_bank(Vector3(68, -0.48, 0), 16.0, earth_material, stone_material, moss_material)

	for position in [Vector3(-5, 0.3, 1.2), Vector3(3.2, 0.35, -1.3), Vector3(12.2, 1.8, -1.2), Vector3(50.5, 3.2, 1.3), Vector3(70, 0.4, -1.3)]:
		_add_rock(position, stone_material, moss_material)

	for position in [Vector3(-13, 0.1, 1.6), Vector3(-2, 0.1, -1.6), Vector3(9, 0.1, 1.6), Vector3(47, 2.9, -1.6), Vector3(66, 0.1, 1.6), Vector3(73, 0.1, -1.6)]:
		_add_fern(position)


func _dress_ground_bank(center: Vector3, width: float, earth_material: Material, stone_material: Material, moss_material: Material) -> void:
	# The original box remains the collision-bearing core. Overlapping low-poly
	# forms hide its ruler-straight edge and establish a soft woodland silhouette.
	var pieces := int(width / 1.55) + 1
	for index in pieces:
		var ratio := float(index) / maxf(float(pieces - 1), 1.0)
		var x := center.x - width * 0.5 + ratio * width
		var wobble := sin(index * 2.17 + center.x) * 0.12
		var scale_value := Vector3(1.05 + float(index % 3) * 0.18, 0.62 + float(index % 2) * 0.12, 2.0)
		var material := earth_material if index % 3 else stone_material
		_add_sphere(Vector3(x, center.y + wobble, center.z), scale_value, material)
		if index % 2 == 0:
			_add_sphere(Vector3(x, center.y + 0.55 + wobble, center.z), Vector3(scale_value.x * 0.82, 0.12, 1.65), moss_material)


func _dress_log(center: Vector3, length: float, bark_material: Material, moss_material: Material) -> void:
	var log_mesh := CylinderMesh.new()
	log_mesh.top_radius = 0.46
	log_mesh.bottom_radius = 0.52
	log_mesh.height = length
	log_mesh.radial_segments = 10
	var log := MeshInstance3D.new()
	log.mesh = log_mesh
	log.position = center
	log.rotation_degrees.z = 90.0
	log.material_override = bark_material
	add_child(log)

	# A broken branch and irregular moss clumps stop each log reading as a tube.
	var branch_mesh := CylinderMesh.new()
	branch_mesh.top_radius = 0.08
	branch_mesh.bottom_radius = 0.15
	branch_mesh.height = 0.9
	branch_mesh.radial_segments = 7
	var branch := MeshInstance3D.new()
	branch.mesh = branch_mesh
	branch.position = center + Vector3(-length * 0.18, 0.35, -0.25)
	branch.rotation_degrees = Vector3(28.0, 0.0, -38.0)
	branch.material_override = bark_material
	add_child(branch)
	for index in 4:
		var x_offset := -length * 0.36 + index * length * 0.24
		_add_sphere(center + Vector3(x_offset, 0.48, -0.06 + index % 2 * 0.12), Vector3(length * 0.14, 0.10, 0.42), moss_material)


func _build_water_feature() -> void:
	_water_material = _material(Color(0.10, 0.40, 0.45, 0.78), 0.28, true)
	_water_material.metallic = 0.15
	_add_box(Vector3(35.5, -2.25, -0.5), Vector3(28.0, 0.18, 8.0), _water_material)
	_add_box(Vector3(39.0, 3.1, -5.2), Vector3(5.5, 10.5, 0.18), _water_material)

	var mist_material := _material(Color(0.72, 0.88, 0.82, 0.18), 0.1, true)
	for index in 5:
		var mist := _add_sphere(Vector3(36.0 + index * 1.5, -1.65 + index % 2 * 0.25, -2.2), Vector3(2.3, 0.55, 1.2), mist_material)
		_sway_groups.append(mist)


func _build_asset_preview_grove() -> void:
	# A compact representative area near the start lets us judge the pack in the
	# actual game before replacing the full procedural blockout.
	_add_asset(COMMON_TREE_SCENE, Vector3(-13.5, 0.0, -3.2), Vector3.ONE * 1.05, 0.15)
	_add_asset(COMMON_TREE_SCENE, Vector3(-4.0, 0.0, -4.2), Vector3.ONE * 0.82, -0.55)
	_add_asset(TWISTED_TREE_SCENE, Vector3(5.0, 0.0, -6.0), Vector3.ONE * 0.48, 0.32)
	_add_asset(ROCK_SCENE, Vector3(-6.0, 0.0, -1.35), Vector3.ONE * 0.62, -0.25)
	_add_asset(ROCK_SCENE, Vector3(1.8, 0.0, 1.25), Vector3(0.42, 0.58, 0.50), 0.65)
	_add_asset(BUSH_SCENE, Vector3(-1.0, 0.0, -1.45), Vector3.ONE * 0.82, 0.18)
	_add_asset(BUSH_SCENE, Vector3(8.8, 0.0, 1.35), Vector3.ONE * 0.68, -0.35)
	_add_asset(FERN_SCENE, Vector3(-11.0, 0.0, 1.45), Vector3.ONE * 0.22, 0.2)
	_add_asset(FERN_SCENE, Vector3(5.5, 0.0, -1.5), Vector3.ONE * 0.18, -0.6)
	for index in 7:
		_add_asset(GRASS_SCENE, Vector3(-12.0 + index * 3.2, 0.02, -1.65 + index % 2 * 3.2), Vector3.ONE * (0.65 + index % 3 * 0.10), index * 0.7)


func _add_asset(scene: PackedScene, position: Vector3, scale_value: Vector3, yaw: float) -> Node3D:
	var instance := scene.instantiate() as Node3D
	instance.position = position
	instance.scale = scale_value
	instance.rotation.y = yaw
	add_child(instance)
	return instance


func _add_tree(position: Vector3, height: float, width: float, leaf_color: Color, animated: bool) -> void:
	var tree := Node3D.new()
	tree.position = position
	add_child(tree)

	var trunk_mesh := CylinderMesh.new()
	trunk_mesh.top_radius = width * 0.62
	trunk_mesh.bottom_radius = width
	trunk_mesh.height = height
	trunk_mesh.radial_segments = 7
	var trunk := MeshInstance3D.new()
	trunk.mesh = trunk_mesh
	trunk.position.y = height * 0.5
	trunk.rotation.y = position.x * 0.17
	trunk.material_override = _material(TRUNK_COLOR.lerp(BARK_LIGHT, fmod(abs(position.x), 5.0) / 8.0), 1.0)
	tree.add_child(trunk)

	var crown := Node3D.new()
	crown.position.y = height * 0.78
	tree.add_child(crown)
	for index in 4:
		var offset := Vector3((index % 2 * 2 - 1) * width * 1.15, (index / 2) * height * 0.12, (index % 3 - 1) * width * 0.75)
		_add_sphere_to(crown, offset, Vector3(width * 2.4, height * 0.20, width * 2.0), _material(leaf_color.lightened(index * 0.035), 0.92))
	if animated:
		_sway_groups.append(crown)


func _add_rock(position: Vector3, stone_material: Material, moss_material: Material) -> void:
	var rock := _add_sphere(position, Vector3(1.25, 0.65, 0.85), stone_material)
	rock.rotation = Vector3(0.0, position.x * 0.31, 0.12)
	_add_sphere(position + Vector3(-0.12, 0.45, 0.0), Vector3(0.9, 0.13, 0.62), moss_material)


func _add_fern(position: Vector3) -> void:
	var fern := Node3D.new()
	fern.position = position
	add_child(fern)
	var material := _material(LEAF_LIGHT, 0.95)
	for index in 5:
		var blade := _add_box_to(fern, Vector3.ZERO, Vector3(0.12, 1.15, 0.08), material)
		blade.position.y = 0.52
		blade.rotation.z = -0.85 + index * 0.425
		blade.rotation.y = index * 1.31
	_sway_groups.append(fern)


func _add_box(position: Vector3, size: Vector3, material: Material) -> MeshInstance3D:
	return _add_box_to(self, position, size, material)


func _add_box_to(parent: Node, position: Vector3, size: Vector3, material: Material) -> MeshInstance3D:
	var mesh := BoxMesh.new()
	mesh.size = size
	var instance := MeshInstance3D.new()
	instance.mesh = mesh
	instance.position = position
	instance.material_override = material
	parent.add_child(instance)
	return instance


func _add_sphere(position: Vector3, scale_value: Vector3, material: Material) -> MeshInstance3D:
	return _add_sphere_to(self, position, scale_value, material)


func _add_sphere_to(parent: Node, position: Vector3, scale_value: Vector3, material: Material) -> MeshInstance3D:
	var mesh := SphereMesh.new()
	mesh.radius = 1.0
	mesh.height = 2.0
	mesh.radial_segments = 12
	mesh.rings = 6
	var instance := MeshInstance3D.new()
	instance.mesh = mesh
	instance.position = position
	instance.scale = scale_value
	instance.material_override = material
	parent.add_child(instance)
	return instance


func _material(color: Color, roughness: float, transparent := false) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness
	if transparent:
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
	return material
