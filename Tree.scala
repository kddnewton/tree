import java.io.File

case class Counter(directories : Int = 0, files : Int = 0) {
  def summarize {
    println(s"\n${directories - 1} directories, $files files")
  }
}

object Tree {
  def main(args: Array[String]) {
    val directory = args.headOption.getOrElse(".")
    println(directory)
    walk(new File(directory), "", Counter()).summarize
  }

  def walk(directory : File, prefix : String, counter : Counter) : Counter = {
    val fileList = directory.listFiles
    var newCounter = counter.copy()

    fileList.zipWithIndex.foreach { case (file, index) =>
      if (file.getName()(0) != '.') {
        val (pointer : String, prefixAdd : String) = getDisplay(index, fileList.length - 1)

        println(s"$prefix$pointer${file.getName}")
        newCounter = if (file.isDirectory) {
          walk(file, prefix + prefixAdd, newCounter)
        } else {
          newCounter.copy(files = newCounter.files + 1)
        }
      }
    }

    newCounter.copy(directories = newCounter.directories + 1)
  }

  def getDisplay(index : Int, last : Int) : (String, String) = index match {
    case `last` => ("└── ", "    ")
    case _ => ("├── ", "│   ")
  }
}
