use std::env;

fn main() {
  let dir = env::args().nth(1).unwrap_or(".".to_string());
}
