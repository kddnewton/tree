<?php
class Tree {
  private $dirCount;
  private $fileCount;

  public function __construct() {
    $this->dirCount = 0;
    $this->fileCount = 0;
  }

  public function summary() {
    return $this->dirCount . " directories, " . $this->fileCount . " files";
  }

  public function walk($directory, $prefix = "") {
    $filepaths = scandir($directory);

    foreach($filepaths as $index => $filepath) {
      if($filepath[0] == ".") {
        continue;
      }
      $absolute = join("/", array($directory, $filepath));
      $this->register($absolute);

      if($index == count($filepaths) - 1) {
        echo $prefix, "└── ", $filepath, "\n";
        if(is_dir($absolute)) {
          $this->walk($absolute, $prefix . "    ");
        }
      } else {
        echo $prefix, "├── ", $filepath, "\n";
        if(is_dir($absolute)) {
          $this->walk($absolute, $prefix . "│   ");
        }
      }
    }
  }

  private function register($filepath) {
    if(is_dir($filepath)) {
      $this->dirCount += 1;
    } else {
      $this->fileCount += 1;
    }
  }
}

$tree = new Tree();
$directory = ".";
if(count($argv) > 1) {
  $directory = $argv[1];
}

echo $directory, "\n";
$tree->walk($directory);
echo "\n", $tree->summary(), "\n";
?>
