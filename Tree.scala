import java.io.File

class Counter(val directories : Int, val files : Int) {
  var dirCount : Int = directories
  var fileCount : Int = files
}

object Tree {
  def main(args: Array[String]) {
    var directory = "."
    if (args.length > 0) directory = args(0)
    println(directory)

    val counter = new Counter(-1, 0)
    walk(new File(directory), "", counter)
    printf("\n%d directories, %d files\n", counter.dirCount, counter.fileCount)
  }

  def walk(directory : File, prefix : String, counter : Counter) {
    val fileList = directory.listFiles
    counter.dirCount += 1

    fileList.zipWithIndex.foreach { case (file, index) =>
      if (file.getName.charAt(0) != '.') {
        val (pointer : String, prefixAdd : String) =
          getDisplay(index, fileList.length - 1)

        printf("%s%s%s\n", prefix, pointer, file.getName())
        if (file.isDirectory) {
          walk(file, prefix + prefixAdd, counter)
        } else {
          counter.fileCount += 1
        }
      }
    }
  }

  def getDisplay(index : Int, last : Int) : (String, String) = index match {
    case `last` => ("└── ", "    ")
    case _ => ("├── ", "│   ")
  }
}
