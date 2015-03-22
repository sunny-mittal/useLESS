require 'set'

class Unused
  def self.unused
    collect_from_html
    collect_from_css
    find_unused
  end

  def self.collect_from_html
    @html_classes = Set.new
    @html_ids = Set.new
    html_files = get_files 'html'
    html_files.each do |file|
      File.open file, 'r' do |f|
        find_html_classes f
        find_html_ids f
      end
    end
  end

  def self.collect_from_css
    @css_classes = Set.new
    @css_ids = Set.new
    css_files = get_files 'css'
    css_files.each do |file|
      File.open file, 'r' do |f|
        find_css_classes f
        find_css_ids f
      end
    end
  end

  def self.get_files(file_type)
    Dir.glob(File.join '**', "*.#{file_type}")
  end

  def self.find_html_classes(file)
    file.each_line do |line|
      match = line.scan(/\s+class\s*=\s*['"]([\s*[\w\-]*\s*]*)['"]/).flatten
      match.each do |m|
        m.split(/\s+/).each do |klass|
          @html_classes << klass
        end
      end
    end
  end

  def self.find_html_ids(file)
    file.each_line do |line|
      match = line.scan(/\s+id\s*=\s*['"]([\s*[\w\-]*\s*]*)['"]/).flatten
      match.each do |m|
        m.split(/\s+/).each do |id|
          @html_ids << id
        end
      end
    end
  end

  def self.find_css_classes(file)
    file.each_line do |line|
      match = line.scan(/\.(\b\D[\w\-]+)/).flatten
      match.each do |klass|
        @css_classes << klass
      end
    end
  end

  def self.find_css_ids(file)
    file.each_line do |line|
      match = line.scan(/\#(\b\D[\w\-]+)/).flatten
      match.each do |id|
        @css_ids << id
      end
    end
  end

  def self.find_unused
    unused_classes = (@css_classes | @html_classes) - (@css_classes & @html_classes)
    unused_ids = (@css_ids | @html_ids) - (@css_ids & @html_ids)
    puts "The following classes are not being used:"
    unused_classes.to_a.each { |klass| puts klass }
    puts "The following IDs are not being used:"
    unused_ids.to_a.each { |id| puts id }
  end
end

Unused.unused
