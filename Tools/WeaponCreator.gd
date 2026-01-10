@tool
extends EditorScript

class_name WeaponCreator

var window_position: Vector2 = Vector2(640, 360)
var window_size: Vector2 = Vector2(1280, 720)

var scenes_folder: String = "res://Weapons/Scenes/"
var weapons_folder: String = "res://Weapons/Data/"
var template_weapon_path: String = "res://Weapons/Data/WeaponTemplate.tres"
var template_scene_path: String = "res://Weapons/Scenes/Template.tscn"
var template_script_path: String = "res://Weapons/Data/Weapon_Template.gd"

var window: Window
var text_edit: TextEdit

var created_weapon_data_path: String
var created_weapon_scene_path: String

func _run():
    window = Window.new()
    EditorInterface.popup_dialog(window, Rect2(window_position, window_size))

    ## Create gui
    var hbox: HBoxContainer = HBoxContainer.new()
    text_edit = TextEdit.new()
    var create_button: Button = Button.new()

    create_button.text = "Create"
    text_edit.custom_minimum_size = Vector2(300, 0)

    ## Setup scene
    hbox.add_child(text_edit)
    hbox.add_child(create_button)
    window.add_child(hbox)

    ## Connect signals

    create_button.pressed.connect(func():
        on_create_pressed()
        )

    window.close_requested.connect(func():
        window.queue_free()
    )


func on_create_pressed():
    var name = text_edit.text.to_lower()
    if !create_weapon_data(name):
        return
    
    if !create_weapon_scene(name):
        delete_resource(created_weapon_data_path)
        return

    if !create_weapon_script(name):
        delete_resource(created_weapon_data_path)
        delete_resource(created_weapon_scene_path)
        return

    window.queue_free()


func create_weapon_data(name) -> bool:
    name = name.capitalize()
    var path = weapons_folder + name + ".tres"

    ## Check for duplicate
    if FileAccess.file_exists(path):
        print("Weapon with path [", path, "] already exists")
        print("Try another name")
        return false
    
    ## Create new weapon from template
    var resource = ResourceLoader.load(template_weapon_path)

    if resource == null:
        print("Failed to load weapon template")
        print("Path: ", template_weapon_path)
        return false

    var new_weapon = resource.duplicate(true)

    new_weapon.weapon_name = name

    ## Try to save new weapon
    var err = ResourceSaver.save(new_weapon, path)

    if err != OK:
        print("Failed to save data \n", "Weapon: [",new_weapon, "]\nPath: [", path, "] \nError:", error_string(err))
        return false

    created_weapon_data_path = path
    return true


func create_weapon_scene(name) -> bool:
    name = name.capitalize()
    var path = scenes_folder + name + ".tscn"

    ## Check for duplicate
    if FileAccess.file_exists(path):
        print("Weapon scene with path [", path, "] already exists")
        print("Try another name")
        return false


    ## Load scene template
    var scene = ResourceLoader.load(template_scene_path)

    if scene == null:
        print("Failed to load scene template")
        print("Path: ", template_scene_path)

    ## Instantiate template
    var instance: Node = scene.instantiate()
    if instance == null:
        print("Failed to instantiate scene template")
        return false
    
    ## Pack into new scene
    var packed_scene = PackedScene.new()
    var err = packed_scene.pack(instance)
    if err != OK:
        print("Failed to pack scene: ", error_string(err))
        return false

    ## Try to save scene
    err = ResourceSaver.save(packed_scene, path)
    if err != OK:
        print("Failed to save scene: ", error_string(err))
        return false

    created_weapon_scene_path = path
    return true


func create_weapon_script(name) -> bool:
    var plain_name = name
    name = "Weapon_" + name.capitalize()
    var path = weapons_folder + name + ".gd"

    ## Check for duplicate
    if FileAccess.file_exists(path):
        print("Weapon script with path [", path, "] already exists")
        print("Try another name")
        return false

    ## Load template script
    var template = FileAccess.open(template_script_path, FileAccess.READ)
    if template == null:
        print("Failed to load script template")
        print("Path: ", template_script_path)

    ## Copy template content
    var content = template.get_as_text()
    template.close()

    ## Add class_name
    content = content.replace("class_name WEAPONNAME", str("class_name ", plain_name.capitalize()))

    ## Create new script file
    var file = FileAccess.open(path, FileAccess.WRITE)
    if file == null:
        print("Failed to create script")
        print("Path: ", path)
        return false
    
    ## Paste content from template
    file.store_string(content)
    file.close()

    EditorInterface.get_resource_filesystem().scan()
    return true


func delete_resource(resource_path) -> bool:
    if !FileAccess.file_exists(resource_path):
        print("File doesnt exist: ", resource_path)
        return false
    
    var err = DirAccess.remove_absolute(resource_path)
    if err != OK:
        print("Failed to delete: ", error_string(err))
        return false
    
    return true