#import <Foundation/Foundation.h>

@interface Tree : NSObject

- (NSString *)summary;
- (void)walk:(NSString *)directory withPrefix:(NSString *)prefix;

@end

@implementation Tree

int directoryCount = 0;
int fileCount = 0;

- (NSString *)summary {
  return [NSString stringWithFormat:@"%d directories, %d files", directoryCount, fileCount];
}

- (void)walk:(NSString *)directory withPrefix:(NSString *)prefix {
  NSError **error;
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSArray *paths = 
    [[[fileManager contentsOfDirectoryAtPath:directory error:error] sortedArrayUsingSelector:@selector(compare:)]
      filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT SELF beginswith[c] '.'"]];

  NSUInteger idx;
  for (idx = 0; idx < [paths count]; idx++) {
    NSString *path = [paths objectAtIndex:idx];
    NSString *connector;
    NSString *joiner;

    if (idx == [paths count] - 1) {
      connector = @"└── ";
      joiner = @"    ";
    } else {
      connector = @"├── ";
      joiner = @"│   ";
    }

    NSString *absolute = [NSString stringWithFormat:@"%@/%@", directory, path];
    NSString *output = [NSString stringWithFormat:@"%@%@%@", prefix, connector, [path lastPathComponent]];
    printf("%s\n", [output UTF8String]);

    BOOL isDir;
    [fileManager fileExistsAtPath:absolute isDirectory:&isDir];

    if (isDir) {
      directoryCount += 1;
      [self walk:absolute withPrefix:[NSString stringWithFormat:@"%@%@", prefix, joiner]];
    } else {
      fileCount += 1;
    }
  }
}

@end

int main(int argc, char *argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSString *directory = argc > 1 ? [NSString stringWithUTF8String:argv[1]] : @".";
  printf("%s\n", [directory UTF8String]);

  Tree *tree = [[Tree alloc] init];
  [tree walk:directory withPrefix:@""];

  printf("\n%s\n", [[tree summary] UTF8String]);
  [pool drain];

  return 0;
}
