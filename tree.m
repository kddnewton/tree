#import <Foundation/Foundation.h>

@interface Tree : NSObject

@property int directoryCount;
@property int fileCount;

- (NSString *) summary;
- (void) walk:(NSURL *) directory withPrefix:(NSString *) prefix;

@end

@implementation Tree

- (BOOL) isDirectory:(NSURL *) url {
  NSNumber *isDirectory;
  BOOL success = [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];

  return success && [isDirectory boolValue];
}

- (NSString *) summary {
  return [NSString stringWithFormat:@"%d directories, %d files", self.directoryCount, self.fileCount];
}

- (void) walk:(NSURL *) directory withPrefix:(NSString *) prefix {
  NSMutableArray<NSURL *> *urls = 
    (NSMutableArray<NSURL *> *)[[NSFileManager defaultManager] contentsOfDirectoryAtURL:directory
                                                             includingPropertiesForKeys:@[]
                                                                                options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                                  error:nil];

  [urls sortUsingComparator:^NSComparisonResult(NSURL* left, NSURL* right) {
    return [[left lastPathComponent] compare:[right lastPathComponent]];
  }];

  [urls enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSURL *url = (NSURL *) obj;
    BOOL isDir = [self isDirectory: url];

    if (isDir) {
      self.directoryCount += 1;
    } else {
      self.fileCount += 1;
    }

    NSString *connector;
    NSString *joiner;

    if (idx == [urls count] - 1) {
      connector = @"└── ";
      joiner = @"    ";
    } else {
      connector = @"├── ";
      joiner = @"│   ";
    }

    printf("%s%s%s\n", [prefix UTF8String], [connector UTF8String], [[url lastPathComponent] UTF8String]);

    if (isDir) {
      [self walk:url withPrefix:[NSString stringWithFormat:@"%@%@", prefix, joiner]];
    }
  }];
}

@end

int main (int argc, char *argv[]) {
  NSString *directory = @".";

  if (argc > 1) {
    directory = @(argv[1]);
  }

  printf("%s\n", [directory UTF8String]);

  Tree *tree = [[Tree alloc] init];
  [tree walk:[NSURL fileURLWithPath:directory] withPrefix:@""];

  printf("\n%s\n", [[tree summary] UTF8String]);
}
