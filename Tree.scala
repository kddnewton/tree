import java.io.File

case class Counter(dirs : Int = 0, files : Int = 0) {
  def summarize {
    println(s"\n${dirs - 1} directories, $files files")
  }
}

object Tree {
  def main(args: Array[String]) {
    val directory = args.headOption.getOrElse(".")
    println(directory)
    walk(new File(directory), "", Counter()).summarize
  }

  def walk(node : File, prefix : String, counter : Counter) : Counter = {
    var newCounter = counter.copy()
    val fileList = node.listFiles.filter(child => child.getName()(0) != '.').sorted

    fileList.zipWithIndex.foreach { case (file, index) =>
      val (pointer : String, prefixAdd : String) = getDisplay(index, fileList.length - 1)

      println(s"$prefix$pointer${file.getName}")
      newCounter = if (file.isDirectory) {
        walk(file, prefix + prefixAdd, newCounter)
      } else {
        newCounter.copy(files = newCounter.files + 1)
      }
    }

    newCounter.copy(dirs = newCounter.dirs + 1)
  }

  def getDisplay(index : Int, last : Int) : (String, String) = index match {
    case `last` => ("└── ", "    ")
    case _ => ("├── ", "│   ")
  }
}
