use std::env;
use std::fs;
use std::io;

struct Counts {
  dirs: i32,
  files: i32
}

fn walk(dir: &str, prefix: &str, counts: &mut Counts) -> io::Result<()> {
  let mut paths: Vec<_> = fs::read_dir(dir)?.map(|entry| entry.unwrap().path()).collect();
  let mut index = paths.len();

  paths.sort_by(|a, b| {
    let aname = a.file_name().unwrap().to_str().unwrap();
    let bname = b.file_name().unwrap().to_str().unwrap();
    aname.cmp(bname)
  });

  for path in paths {
    let name = path.file_name().unwrap().to_str().unwrap();
    index -= 1;

    if name.starts_with(".") {
      continue;
    }

    if path.is_dir() {
      counts.dirs += 1;
    } else {
      counts.files += 1;
    }

    if index == 0 {
      println!("{}└── {}", prefix, name);
      if path.is_dir() {
        walk(&format!("{}/{}", dir, name), &format!("{}    ", prefix), counts)?;
      }
    } else {
      println!("{}├── {}", prefix, name);
      if path.is_dir() {
        walk(&format!("{}/{}", dir, name), &format!("{}│   ", prefix), counts)?;
      }
    }
  }

  Ok(())
}

fn main() -> io::Result<()> {
  let dir = env::args().nth(1).unwrap_or(".".to_string());
  println!("{}", dir);

  let mut counts = Counts { dirs: 0, files: 0 };
  walk(&dir, "", &mut counts)?;

  println!("\n{} directories, {} files", counts.dirs, counts.files);

  Ok(())
}
