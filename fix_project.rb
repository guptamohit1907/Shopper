require 'xcodeproj'

PROJECT_PATH = File.expand_path('../Shopper/Shopper.xcodeproj', __FILE__)
SOURCE_ROOT  = File.expand_path('../Shopper/Shopper', __FILE__)

project = Xcodeproj::Project.open(PROJECT_PATH)
target  = project.targets.first

# ── 1. Remove ALL duplicates from compile sources ─────────────────────────────
phase = target.source_build_phase
seen  = {}
phase.files.to_a.each do |f|
  key = f.file_ref&.real_path&.to_s
  next if key.nil?
  if seen[key]
    puts "Removing duplicate: #{File.basename(key)}"
    phase.files.delete(f)
  else
    seen[key] = true
  end
end

# ── 2. Add SplashView.swift if not already in project ─────────────────────────
splash_path = File.join(SOURCE_ROOT, 'SplashView.swift')
already_ref = project.files.find { |f| f.real_path.to_s == splash_path }
if already_ref
  # Ensure it's in the compile phase
  unless phase.files.any? { |f| f.file_ref == already_ref }
    phase.add_file_reference(already_ref)
    puts "Added SplashView.swift to compile phase."
  else
    puts "SplashView.swift already in compile phase."
  end
else
  main_group = project.main_group.children.find { |g| g.name == 'Shopper' } || project.main_group
  file_ref = main_group.new_file(splash_path)
  phase.add_file_reference(file_ref)
  puts "Added SplashView.swift to project + compile phase."
end

project.save
puts "Done."
