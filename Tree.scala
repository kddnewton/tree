import java.io.File

case class Counter(dirs : Int = 0, files : Int = 0) {
  def summarize {
    println(s"\n$dirs directories, $files files")
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
    val lastChild = fileList.lastOption

    fileList.dropRight(1).foreach { node => newCounter = traverse(false, prefix, newCounter, node) }
    lastChild.foreach { node => newCounter = traverse(true, prefix, newCounter, node) }

    newCounter
  }

  def traverse(isLast : Boolean, prefix : String, counter : Counter, node : File) : Counter = {
    val (pointer : String, prefixAdd : String) =
      if (isLast) ("└── ", "    ")
      else        ("├── ", "│   ")

    println(s"$prefix$pointer${node.getName}")
    if (node.isDirectory) {
      walk(node, s"$prefix$prefixAdd", counter.copy(dirs = counter.dirs + 1))
    } else {
      counter.copy(files = counter.files + 1)
    }
  }
}
