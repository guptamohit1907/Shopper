require 'xcodeproj'

PROJECT_PATH = File.expand_path('../Shopper/Shopper.xcodeproj', __FILE__)
project = Xcodeproj::Project.open(PROJECT_PATH)

target = project.targets.first
phase  = target.source_build_phase

# PBXFileSystemSynchronizedRootGroup projects auto-include files.
# Remove every explicit PBXBuildFile entry that was added manually
# to the Compile Sources phase (they cause duplicate-build-file warnings).
before = phase.files.count
phase.files.to_a.each do |build_file|
  ref = build_file.file_ref
  # Keep only entries whose file_ref is a PBXFileSystemSynchronizedRootGroup
  # or one of its children — anything else is an explicit duplicate we created.
  unless ref.is_a?(Xcodeproj::Project::Object::PBXFileSystemSynchronizedRootGroup)
    phase.files.delete(build_file)
  end
end
after = phase.files.count
puts "Removed #{before - after} explicit build-file entries (file-system sync handles inclusion)."

project.save
puts "Done."
