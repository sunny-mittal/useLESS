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
        # find_html_ids f
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
        # find_css_ids f
      end
    end
  end

  def self.get_files(file_type)
    Dir.glob(File.join '**', "*.#{file_type}")
  end

  def self.find_html_classes(file)
    file.each_line do |line|
      match = line.scan(/\s+class\s*=\s*['"]([\s*\w*\s*]*)['"]/).flatten
      match.each do |m|
        m.split(/\s+/).each do |klass|
          @html_classes << klass
        end
      end
    end
  end

  def self.find_css_classes(file)
    file.each_line do |line|
      match = line.scan(/\.(\D[\w\-]+)/).flatten
      match.each do |klass|
        @css_classes << klass
      end
    end
  end

  def self.find_unused
    symmetric_diff = (@css_classes | @html_classes) - (@css_classes & @html_classes)
    puts "The following classes are not being used:"
    symmetric_diff.to_a.each do |klass|
      puts klass
    end
  end
end
