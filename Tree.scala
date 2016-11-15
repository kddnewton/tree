import java.io.File

case class Counter(dirs: Int = 0, files: Int = 0) {
  def summarize {
    println(s"\n$dirs directories, $files files")
  }
}

object Tree {
  def main(args: Array[String]) {
    val root = args.headOption.getOrElse(".")
    println(root)
    walk(new File(root), "", Counter()).summarize
  }

  private def walk(node: File, prefix: String, counter: Counter): Counter = {
    val fileList  = node.listFiles.filter(child => child.getName()(0) != '.').sorted
    val lastChild = fileList.lastOption
    val memo      = (counter /: fileList.dropRight(1))(process(prefix, "├── ", "│   "))
    (memo /: lastChild)(process(prefix, "└── ", "    "))
  }

  private def process(prefix: String, pointer: String, prefixAdd: String)(counter: Counter, node: File): Counter = {
    println(s"$prefix$pointer${node.getName}")
    if (node.isDirectory) {
      walk(node, s"$prefix$prefixAdd", counter.copy(dirs = counter.dirs + 1))
    } else {
      counter.copy(files = counter.files + 1)
    }
  }
}
