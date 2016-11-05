import java.io.File

class Counter(val initDirs: Int, val initFiles: Int) {
  var directories : Int = initDirs
  var files : Int = initFiles

  def incrDirs {
    directories += 1
  }

  def incrFiles {
    files += 1
  }

  def summarize {
    printf("\n%d directories, %d files\n", directories, files)
  }
}

object Tree {
  def main(args: Array[String]) {
    var directory = "."
    if (args.length > 0) directory = args(0)
    println(directory)

    val counter = new Counter(-1, 0)
    walk(new File(directory), "", counter)
    counter.summarize
  }

  def walk(directory: File, prefix: String, counter: Counter) {
    val fileList = directory.listFiles
    var prefixAddition = ""
    counter.incrDirs

    fileList.zipWithIndex.foreach { case (file, index) =>
      if (file.getName.charAt(0) != '.') {
        if (index == fileList.length - 1) {
          printf("%s└── %s\n", prefix, file.getName())
          prefixAddition = "    "
        } else {
          printf("%s├── %s\n", prefix, file.getName())
          prefixAddition = "│   "
        }

        if (file.isDirectory) {
          walk(file, prefix + prefixAddition, counter)
        } else {
          counter.incrFiles
        }
      }
    }
  }
}
