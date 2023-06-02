const std = @import("std");

const stdout = std.io.getStdOut().writer();
const stderr = std.io.getStdErr().writer();

const Counter = struct {
  dirs: usize,
  files: usize,
};

pub fn walk(allocator: std.mem.Allocator, directory: []const u8, prefix: []const u8, counter: *Counter) !void {
  var dir = std.fs.cwd().openIterableDir(directory, .{}) catch {
    try stderr.print("cannot open directory \"{s}\"", .{ directory });
    return;
  };
  defer dir.close();
  
  var it = dir.iterate();
  var dirent_list = std.ArrayList(std.fs.IterableDir.Entry).init(allocator);
  defer {
    for (dirent_list.items) |entry| {
      allocator.free(entry.name);
    }
    dirent_list.deinit();
  }
  while (try it.next()) |entry| {
    if (entry.name[0] != '.') {
      var dest = try allocator.alloc(u8, entry.name.len);
      std.mem.copy(u8, dest, entry.name);
      try dirent_list.append(.{ .name = dest, .kind = entry.kind });
    }
  }

  std.mem.sort(std.fs.IterableDir.Entry, dirent_list.items, {}, struct {
    fn f(_: void, a: std.fs.IterableDir.Entry, b: std.fs.IterableDir.Entry) bool {
      return std.mem.lessThan(u8, a.name, b.name);
    }
  }.f);

  for (dirent_list.items, 0..) |entry, i| {
    var header = "├── ";
    var postprefix: [*:0]const u8 = "│   ";
    if (i == dirent_list.items.len - 1) {
      header = "└── ";
      postprefix = "    ";
    }

    try stdout.print("{s}{s}{s}\n", .{ prefix, header, entry.name });
    if (entry.kind == std.fs.File.Kind.directory) {
      counter.dirs += 1;
      const new_directory = try std.fs.path.join(allocator, &.{ directory, entry.name });
      defer allocator.free(new_directory);
      const new_prefix = try std.mem.concat(allocator, u8, &.{ prefix, std.mem.span(postprefix) });
      defer allocator.free(new_prefix);
      try walk(allocator, new_directory, new_prefix, counter);
    } else {
      counter.files += 1;
    }
  }
}

pub fn main() !u8 {
  var gpa = std.heap.GeneralPurposeAllocator(.{}){};
  const allocator = gpa.allocator();

  const args = try std.process.argsAlloc(allocator);
  defer std.process.argsFree(allocator, args);
 
  const directory = if (args.len > 1) args[1] else ".";
  try stdout.print("{s}\n", .{ directory }); 

  var counter = Counter { .dirs = 0, .files = 0 };
  try walk(allocator, directory, "", &counter);

  try stdout.print("\n{} directories, {} files\n", .{ counter.dirs, counter.files });
  return 0;
}

