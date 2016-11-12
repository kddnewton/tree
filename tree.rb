#!/usr/bin/env ruby

Tree = Struct.new(:dirs, :files) do
  def walk(directory)
    puts directory
    recurse(directory)
    puts "\n#{dirs} directories, #{files} files"
  end

  private

  def recurse(directory, prefix = '')
    filepaths = Dir[File.join(directory, '*')]
    last_idx  = filepaths.length - 1

    filepaths.sort.each_with_index do |filepath, idx|
      File.directory?(filepath) ? self.dirs += 1 : self.files += 1
      pointer, preadd = (idx == last_idx) ? ['└── ', '    '] : ['├── ', '│   ']

      puts "#{prefix}#{pointer}#{File.basename(filepath)}"
      recurse(filepath, "#{prefix}#{preadd}") if File.directory?(filepath)
    end
  end
end

Tree.new(0, 0).walk(ARGV.first || '.')
