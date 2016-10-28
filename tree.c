#include <stdlib.h>
#include <string.h>

#include <stdio.h>
#include <dirent.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

char *join(const char* left, const char* right) {
  char *result = malloc(strlen(left) + strlen(right) + 1);
  strcpy(result, left);
  strcat(result, right);
  return result;
}

char *path_join(const char* directory, const char* entry) {
  char *result = malloc(strlen(directory) + strlen(entry) + 2);
  strcpy(result, directory);
  strcat(result, "/");
  strcat(result, entry);
  return result;
}

int is_dir(const char* entry) {
  struct stat entry_stat;
  stat(entry, &entry_stat);
  return S_ISDIR(entry_stat.st_mode);
}

int walk(const char* directory, const char* prefix) {
  struct dirent *file_dirent;
  DIR *dir_handle;

  dir_handle = opendir(directory);
  if (dir_handle == NULL) {
    printf("Cannot open directory \"%s\"\n", directory);
    return 1;
  }

  char *entry_name;
  char **entries = malloc(sizeof(char *) * 1000);
  int entry_count = 0;

  while ((file_dirent = readdir(dir_handle)) != NULL) {
    entry_name = file_dirent->d_name;
    if (entry_name[0] == '.') {
      continue;
    }
    entries[entry_count++] = entry_name;
  }
  closedir(dir_handle);

  int entry_idx;
  char *joined;

  for (entry_idx = 0; entry_idx < entry_count; entry_idx++) {
    joined = path_join(directory, entries[entry_idx]);

    if (entry_idx == entry_count - 1) {
      printf("%s└── %s\n", prefix, entries[entry_idx]);
      if (is_dir(joined)) {
        walk(joined, join(prefix, "    "));
      }
    } else {
      printf("%s├── %s\n", prefix, entries[entry_idx]);
      if (is_dir(joined)) {
        walk(joined, join(prefix, "│   "));
      }
    }
  }

  return 0;
}

int main(int argc, char *argv[]) {
  char* directory = ".";
  if (argc > 1) {
    directory = argv[1];
  }

  printf("%s\n", directory);
  walk(directory, "");
  return 0;
}
