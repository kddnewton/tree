#!/usr/bin/env ruby

Counter =
  Struct.new(:dirs, :files) do
    def index(filepath)
      File.directory?(filepath) ? self.dirs += 1 : self.files += 1
    end

    def output
      "\n#{dirs} directories, #{files} files"
    end
  end

def tree(counter, directory, prefix = '')
  filepaths = Dir[File.join(directory, '*')]

  filepaths.each_with_index do |filepath, index|
    counter.index(filepath)
    relative = File.basename(filepath)

    if index == filepaths.length - 1
      puts "#{prefix}└── #{relative}"
      tree(counter, filepath, "#{prefix}    ")
    else
      puts "#{prefix}├── #{relative}"
      tree(counter, filepath, "#{prefix}│   ")
    end
  end
end

directory = ARGV.first || '.'
puts directory

counter = Counter.new(0, 0)
tree(counter, directory)
puts counter.output
