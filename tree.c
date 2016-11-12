#include <stdlib.h>
#include <string.h>

#include <stdio.h>
#include <dirent.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

typedef struct counter {
  int dir_count;
  int file_count;
} counter_t;

counter_t* counter_build(void) {
  counter_t *counter = (counter_t *) malloc(sizeof(counter_t));
  counter->dir_count = 0;
  counter->file_count = 0;
  return counter;
}

void counter_incr_dirs(counter_t *counter) {
  counter->dir_count += 1;
}

void counter_incr_files(counter_t *counter) {
  counter->file_count += 1;
}

void counter_free(counter_t *counter) {
  free(counter);
}

void bubble_sort(int size, char **entries) {
  int x_idx;
  int y_idx;
  char *swap;

  for (x_idx = 0; x_idx < size; x_idx++) {
    for (y_idx = 0; y_idx < size - 1; y_idx++) {
      if (strcmp(entries[y_idx], entries[y_idx + 1]) > 0) {
        swap = entries[y_idx];
        entries[y_idx] = entries[y_idx + 1];
        entries[y_idx + 1] = swap;
      }
    }
  }
}

int dir_entry_count(const char* directory) {
  DIR *dir_handle = opendir(directory);
  if (dir_handle == NULL) {
    printf("Cannot open directory \"%s\"\n", directory);
    return -1;
  }

  int count = 0;
  struct dirent *file_dirent;
  char *entry_name;

  while ((file_dirent = readdir(dir_handle)) != NULL) {
    entry_name = file_dirent->d_name;
    if (entry_name[0] == '.') {
      continue;
    }
    count++;
  }

  closedir(dir_handle);
  return count;
}

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

int walk(const char* directory, const char* prefix, counter_t* counter) {
  int entry_count = dir_entry_count(directory);
  if (entry_count == -1) {
    return -1;
  }
  int entry_idx = 0;

  struct dirent *file_dirent;
  DIR *dir_handle = opendir(directory);

  char *entry_name;
  char **entries = malloc(sizeof(char *) * entry_count);
  counter_incr_dirs(counter);

  while ((file_dirent = readdir(dir_handle)) != NULL) {
    entry_name = file_dirent->d_name;
    if (entry_name[0] == '.') {
      continue;
    }
    entries[entry_idx++] = entry_name;
  }
  closedir(dir_handle);
  bubble_sort(entry_count, entries);

  char *full_path;
  char *prefix_ext;
  char *pointer;

  for (entry_idx = 0; entry_idx < entry_count; entry_idx++) {
    if (entry_idx == entry_count - 1) {
      pointer = "└── ";
      prefix_ext = "    ";
    } else {
      pointer = "├── ";
      prefix_ext = "│   ";
    }

    printf("%s%s%s\n", prefix, pointer, entries[entry_idx]);
    full_path = path_join(directory, entries[entry_idx]);

    if (is_dir(full_path)) {
      prefix_ext = join(prefix, prefix_ext);
      walk(full_path, prefix_ext, counter);
      free(prefix_ext);
    } else {
      counter_incr_files(counter);
    }

    free(full_path);
  }

  free(entries);
  return 0;
}

int main(int argc, char *argv[]) {
  char* directory = ".";
  if (argc > 1) {
    directory = argv[1];
  }
  printf("%s\n", directory);

  counter_t *counter = counter_build();
  walk(directory, "", counter);

  printf("\n%d directories, %d files\n", counter->dir_count - 1, counter->file_count);
  counter_free(counter);
  return 0;
}
