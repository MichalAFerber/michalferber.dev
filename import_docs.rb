#!/usr/bin/env ruby
require 'fileutils'
require 'pathname'
require 'find'
require 'uri'

# --- Configuration ---
SOURCE_DIR = "/Users/michal/Obsidian/Obsidian-Master/Wiki/Public"
OBSIDIAN_ATTACHMENTS_DIR = "/Users/michal/Obsidian/Obsidian-Master/Attachments"

PROJECT_ROOT = File.dirname(__FILE__)
DOCS_DIR = File.expand_path("docs", PROJECT_ROOT)
ROOT_INDEX = File.expand_path("index.md", PROJECT_ROOT)
# Target folder for attachments in the project
ASSETS_ATTACHMENTS_DIR = File.expand_path("assets/attachments", PROJECT_ROOT) 
DEFAULT_IMAGE = "/assets/images/michalferber_logo.png"

def titleize(name)
  # Preserves original casing. "GSA Manager" stays "GSA Manager".
  # "some-folder" becomes "some folder".
  name.gsub(/[-_]/, ' ')
end

unless Dir.exist?(SOURCE_DIR)
  puts "Error: Source directory not found at #{SOURCE_DIR}"
  exit 1
end

# 1. Clean Targets
puts "--- Cleaning ---"
FileUtils.rm_rf(Dir.glob("#{DOCS_DIR}/*")) if Dir.exist?(DOCS_DIR)
FileUtils.mkdir_p(DOCS_DIR)
FileUtils.rm(ROOT_INDEX) if File.exist?(ROOT_INDEX)

# Reset Assets Attachments
FileUtils.rm_rf(ASSETS_ATTACHMENTS_DIR) if Dir.exist?(ASSETS_ATTACHMENTS_DIR)
FileUtils.mkdir_p(ASSETS_ATTACHMENTS_DIR)

# 2. Copy Files
puts "--- Copying Files ---"
FileUtils.cp_r(Dir.glob("#{SOURCE_DIR}/*"), DOCS_DIR)

# 3. Move Root Index to Project Root
puts "--- Moving Root Index ---"
temp_index = File.join(DOCS_DIR, "index.md")
if File.exist?(temp_index)
  FileUtils.mv(temp_index, ROOT_INDEX)
  puts "Moved docs/index.md to ./index.md"
else
  puts "Warning: No index.md found in source root. A default one will be created/processed if missing."
end

# 4. Generate Missing Index Files
puts "--- Generating Missing Index Files ---"
Dir.glob("#{DOCS_DIR}/**/*").select { |f| File.directory?(f) }.each do |dir|
  index_path = File.join(dir, "index.md")
  unless File.exist?(index_path)
    folder_name = File.basename(dir)
    title = titleize(folder_name)
    puts "Creating missing index for: #{folder_name}"
    File.write(index_path, "# #{title}\n")
  end
end

# 5. Process Content & Attachments
puts "\n--- Processing Content ---"

files_to_process = Find.find(DOCS_DIR).to_a
files_to_process << ROOT_INDEX if File.exist?(ROOT_INDEX)

files_to_process.each do |path|
  next unless File.file?(path) && path =~ /\.md$/
  
  if path == ROOT_INDEX
    relative_path = "index.md"
    filename = "index"
    folders = []
  else
    relative_path = Pathname.new(path).relative_path_from(Pathname.new(DOCS_DIR)).to_s
    filename = File.basename(path, ".md")
    parts = relative_path.split(File::SEPARATOR)
    folders = parts[0...-1] # Folders needed for hierarchy
  end

  is_index = filename.downcase == "index"
  content = File.read(path)

  # --- Attachment Processing ---

  content.gsub!(/(!?\[\[(.*?)\]\])|(!?\[(.*?)\]\((.*?)\))/) do |match|
    replacement = match
    file_name = nil
    alt_text = ""
    is_embed = false

    if match.start_with?('![[') || match.start_with?('[[')
      # Wiki Link
      is_embed = match.start_with?('!')
      inner = match.sub(/^!?\[\[/, '').sub(/\]\]$/, '')
      raw_path, alt = inner.split('|')
      file_name = File.basename(raw_path.strip)
      alt_text = alt || file_name
    elsif match =~ /!\[.*\]\(.*\)/ || match =~ /\[.*\]\(.*\)/
      # Standard Link
      is_embed = match.start_with?('!')
      if match =~ /!?\[(.*?)\]\((.*?)\)/
        alt_text = $1
        link_path = $2
        
        # Skip http/https links here (we handle them below)
        if link_path =~ /^http/
          next match
        end
        file_name = File.basename(link_path)
      end
    end

    if file_name
      file_name = file_name.strip
      source_attachment = File.join(OBSIDIAN_ATTACHMENTS_DIR, file_name)
      
      if File.exist?(source_attachment)
        dest_attachment = File.join(ASSETS_ATTACHMENTS_DIR, file_name)
        FileUtils.cp(source_attachment, dest_attachment) unless File.exist?(dest_attachment)
        new_url = "/assets/attachments/#{URI.encode_www_form_component(file_name)}"
        
        if is_embed
          replacement = "![#{alt_text}](#{new_url})"
        else
          replacement = "[#{alt_text}](#{new_url})"
        end
        puts "  -> Linked Attachment: #{file_name}"
      end
    end
    replacement
  end

  # --- External Link Processing (New Tab) ---
  # Finds [Text](http...) and appends {: target="_blank" }
  # Note: Negative lookahead used to ensure we don't add it twice if run multiple times (though we clean target anyway)
  # Only affects non-image links.
  content.gsub!(/\[([^\]]+)\]\((http[^)]+)\)(?!.*target="_blank")/i) do |match|
    link_text = $1
    url = $2
    # Ensure it's not an image link (which starts with !) since regex above doesn't check for ! prefix explicitly
    # But since matches are greedy, we check context.
    # Simpler: Just reconstruct string with Kramdown attribute
    "[#{link_text}](#{url}){: target=\"_blank\" }"
  end

  # --- Frontmatter Processing ---
  if content =~ /\A---\s*\n.*?\n---\s*\n/m
    File.write(path, content)
    next
  end

  # --- Metadata Calculation ---
  title = if content =~ /^#\s+(.+)$/
            $1.strip
          else
            titleize(filename)
          end

  parent = nil
  grand_parent = nil
  has_children = false
  nav_order = nil
  layout = "default"
  
  if is_index
    has_children = true
    if folders.empty? # Root Home
      title = "Home"
      nav_order = 1
      layout = "home"
    else
      title = titleize(folders.last)
      parent = titleize(folders[-2]) if folders.length >= 2
      grand_parent = titleize(folders[-3]) if folders.length >= 3
    end
  else
    parent = titleize(folders.last) if folders.length >= 1
    grand_parent = titleize(folders[-2]) if folders.length >= 2
  end

  # --- Write File ---
  frontmatter = []
  frontmatter << "---"
  frontmatter << "layout: #{layout}"
  frontmatter << "title: \"#{title}\""
  frontmatter << "parent: \"#{parent}\"" if parent
  frontmatter << "grand_parent: \"#{grand_parent}\"" if grand_parent
  frontmatter << "has_children: true" if has_children
  frontmatter << "nav_order: #{nav_order}" if nav_order
  frontmatter << "---"
  frontmatter << ""

  File.write(path, frontmatter.join("\n") + "\n" + content)
  puts "Processed: #{relative_path}"
end

puts "\n--- Sync Complete ---"