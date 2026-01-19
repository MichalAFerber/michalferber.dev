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
# Include DOCS_DIR itself to ensure docs/index.md exists (since we moved the original to ./index.md)
directories = Dir.glob("#{DOCS_DIR}/**/*").select { |f| File.directory?(f) }
directories << DOCS_DIR

directories.uniq.each do |dir|
  index_path = File.join(dir, "index.md")
  unless File.exist?(index_path)
    folder_name = File.basename(dir)
    title = titleize(folder_name)
    puts "Creating missing index for: #{folder_name}"
    File.write(index_path, "# #{title}\n")
  end
end

# 4.5 Sanitize Filenames (Spaces -> Underscores)
puts "--- Sanitizing Filenames ---"
paths_to_process = []
Find.find(DOCS_DIR) do |path|
  if File.basename(path).include?(" ")
    paths_to_process << path
  end
end

# Sort by length descending to rename deepest first
paths_to_process.sort_by { |p| -p.length }.each do |path|
  next unless File.exist?(path) 
  dir = File.dirname(path)
  base = File.basename(path)
  new_base = base.gsub(" ", "_")
  new_path = File.join(dir, new_base)
  File.rename(path, new_path)
  puts "Renamed: #{base} -> #{new_base}"
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

  # --- Attachment & Link Processing ---

  content.gsub!(/(!?\[\[(.*?)\]\])|(!?\[(.*?)\]\((.*?)\))/) do |match|
    replacement = match
    file_name = nil
    alt_text = ""
    is_embed = false
    raw_link_info = nil

    if match.start_with?('![[') || match.start_with?('[[')
      # Wiki Link
      is_embed = match.start_with?('!')
      inner = match.sub(/^!?\[\[/, '').sub(/\]\]$/, '')
      raw_path, alt = inner.split('|')
      file_name = File.basename(raw_path.strip)
      alt_text = alt || file_name
      raw_link_info = { type: :wiki, path: raw_path, alt: alt }
    elsif match =~ /!\[.*\]\(.*\)/ || match =~ /\[.*\]\(.*\)/
      # Standard Link
      is_embed = match.start_with?('!')
      if match =~ /!?\[(.*?)\]\((.*?)\)/
        alt_text = $1
        link_path = $2
        
        # Skip http/https links here (we handle them below/later)
        if link_path !~ /^http/
          file_name = File.basename(link_path)
        end
        raw_link_info = { type: :standard, path: link_path, alt: alt_text }
      end
    end

    is_attachment = false
    if file_name
      file_name = file_name.strip
      source_attachment = File.join(OBSIDIAN_ATTACHMENTS_DIR, file_name)
      
      if File.exist?(source_attachment)
        is_attachment = true
        # Sanitize spaces to underscores for destination
        sanitized_name = file_name.gsub(" ", "_")
        dest_attachment = File.join(ASSETS_ATTACHMENTS_DIR, sanitized_name)
        
        FileUtils.cp(source_attachment, dest_attachment) unless File.exist?(dest_attachment)
        # URL uses sanitized name
        new_url = "/assets/attachments/#{sanitized_name}"
        
        if is_embed
          replacement = "![#{alt_text}](#{new_url})"
        else
          replacement = "[#{alt_text}](#{new_url})"
        end
        puts "  -> Linked Attachment: #{file_name} -> #{sanitized_name}"
      end
    end

    # If NOT an attachment, sanitize spaces in local links
    if !is_attachment && raw_link_info
       target_path = raw_link_info[:path]
       # Skip absolute URLs
       unless target_path =~ /^[a-z]+:/i
          if target_path.include?(" ") || target_path.include?("%20")
             new_path = target_path.gsub(" ", "_").gsub("%20", "_")
             
             if raw_link_info[:type] == :wiki
                alt_part = raw_link_info[:alt] ? "|#{raw_link_info[:alt]}" : ""
                replacement = "#{is_embed ? '!' : ''}[[#{new_path}#{alt_part}]]"
             else
                replacement = "#{is_embed ? '!' : ''}[#{raw_link_info[:alt]}](#{new_path})"
             end
          end
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
    if folders.empty? # Root Home or Docs Root
      if path == ROOT_INDEX
        title = "Home"
        nav_order = 1
        layout = "home"
      else
        # This is docs/index.md
        title = "Docs" # Default title for /docs/
        nav_order = 2
        layout = "default"
      end
    else
      title = titleize(folders.last)
      parent = titleize(folders[-2]) if folders.length >= 2
      grand_parent = titleize(folders[-3]) if folders.length >= 3
    end
  else
    parent = titleize(folders.last) if folders.length >= 1
    grand_parent = titleize(folders[-2]) if folders.length >= 2
    
    # Special handling for children of docs root
    # If the parent is "docs" (which happens if it's in docs root), we might want to attach it to "Knowledge Base"
    # But currently 'docs' is not in the 'folders' array if relative path is 'file.md'
    # Wait, if file is docs/Applications/index.md
    # relative: Applications/index.md
    # folders: ["Applications"]
    # parent: Applications.
    # It doesn't have a grand parent.
    # The parent of "Applications" is implicitly "Docs" (Knowledge Base).
    # If we want it to show up in breadcrumbs under Knowledge Base, we need to set parent to Knowledge Base?
    # But usually just-the-docs handles this via structure.
    
    # If we want top-level folders in docs/ to list "Knowledge Base" as parent:
    if folders.length == 1
       # e.g. folders=['Applications']
       # parent is 'Applications' (for an index) or parent is 'Subject' (for a file)
       # If is_index is true: title=Applications. parent=nil (folders[-2] is nil).
       # So Applications is a top level item in the nav.
       # If we want it under "Knowledge Base", we set parent="Knowledge Base".
       parent = "Docs"
    end
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