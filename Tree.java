import java.io.File;
import java.util.Arrays;

public class Tree {
  private int dirCount;
  private int fileCount;

  public static void main(String[] args) {
    String directory = ".";
    if (args.length > 0) {
      directory = args[0];
    }
    (new Tree()).print(directory);
  }

  public Tree() {
    this.dirCount = 0;
    this.fileCount = 0;
  }

  public void print(String directory) {
    System.out.println(directory);
    walk(new File(directory), "");
    System.out.println("\n" + this.dirCount + " directories, " + this.fileCount + " files");
  }

  private void register(File file) {
    if (file.isDirectory()) {
      this.dirCount += 1;
    } else {
      this.fileCount += 1;
    }
  }

  private void walk(File folder, String prefix) {
    File file;
    File[] fileList = folder.listFiles();
    Arrays.sort(fileList);

    for (int index = 0; index < fileList.length; index++) {
      file = fileList[index];
      if (file.getName().charAt(0) == '.') {
        continue;
      }
      register(file);

      if (index == fileList.length - 1) {
        System.out.println(prefix + "└── " + file.getName());
        if (file.isDirectory()) {
          walk(file, prefix + "    ");
        }
      } else {
        System.out.println(prefix + "├── " + file.getName());
        if (file.isDirectory()) {
          walk(file, prefix + "│   ");
        }
      }
    }
  }
}
