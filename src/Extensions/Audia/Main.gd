extends Node

# some references to nodes that will be created later
var music_list_container_dialog: Window
var exporter_id: int
var menu_id: int

# This script acts as a setup for the extension
func _enter_tree() -> void:
	# add a test panel as a tab  (this is an example) the tab is located at the same
	# place as the (Tools tab) by default
	music_list_container_dialog = preload(
		"res://src/Extensions/Audia/Elements/MusicListContainer.tscn"
	).instantiate()

#	ExtensionsApi.panel.add_node_as_tab(music_list_container_dialog)
	ExtensionsApi.dialog.get_dialogs_parent_node().add_child(music_list_container_dialog)
	menu_id = ExtensionsApi.menu.add_menu_item(ExtensionsApi.menu.WINDOW, "Audia", self)

	var info := {
		"extension": ".png",
		"description": "Shotcut"
	}
	var export_tab := ExtensionsApi.export.ExportTab.IMAGE
	exporter_id = ExtensionsApi.export.add_export_option(info, self, export_tab, false)


func menu_item_clicked():
	music_list_container_dialog.popup_centered()


func override_export(data: Dictionary):
	# set variables
	var dir_path: String
	var project = data["project"]
	var project_maker = load("res://src/Extensions/Audia/Classes/ShotcutMaker.gd").new()
	var moved_audios := []
	var p_size: Vector2

	# obtaining audios used in project
	var audio_tags := {}
	for child in music_list_container_dialog.get_node("MusicListContainer").list.get_children():
		var dict = child.serialize()
		var tag = dict["identifier"]
		var path = dict["path"]
		if !tag in audio_tags.keys():
			audio_tags[tag] = path

	# save pngs
	for image_idx in data["processed_images"].size():
		var save_path = data["export_paths"][image_idx]
		var image: Image = data["processed_images"][image_idx].image
		var duration = data["processed_images"][image_idx].duration
		image.save_png(save_path)
		# set the dir path and project size (one time setup)
		if !dir_path:
			dir_path = save_path.replace(save_path.get_file(), "")
			p_size = image.get_size()

		# check if audio is to be played for this frame
		for tag in project.animation_tags:
			if tag.name in audio_tags.keys() and tag.from == image_idx + 1:  # Audio Detected
				var audio_path: String = audio_tags[tag.name]
				var new_name = str(tag.name, ".", audio_path.get_extension())
				var new_path: String = dir_path.path_join(new_name)
				# calculate duration for audio
				var end_time := 0.0
				for frame_idx in range(tag.from - 1, tag.to):
					var frame = project.frames[frame_idx]
					var audio_duration = frame.duration * (1.0 / project.fps)
					end_time += audio_duration
				# if audio wasn't moved to aseet folder yet then move it there
				if !new_path in moved_audios:
					DirAccess.copy_absolute(audio_path, new_path)
					moved_audios.append(new_path)
				project_maker.add_item_to_playlist(new_path, end_time)
		project_maker.add_item_to_playlist(data["export_paths"][image_idx], duration)
	# Now Compile all this information into a ShotCut project
	project_maker.compile(p_size)
	return true


func _exit_tree() -> void:  # Extension is being uninstalled or disabled
	# remember to remove things that you added using this extension
#	ExtensionsApi.panel.remove_node_from_tab(music_list_container_dialog)
	ExtensionsApi.menu.remove_menu_item(ExtensionsApi.menu.WINDOW, menu_id)
	music_list_container_dialog.queue_free()
	ExtensionsApi.export.remove_export_option(exporter_id)
