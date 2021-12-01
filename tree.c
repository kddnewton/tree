#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <dirent.h>

typedef struct counter {
  size_t dirs;
  size_t files;
} counter_t;

typedef struct entry {
  char *name;
  int is_dir;
  struct entry *next;
} entry_t;

int walk(const char* directory, const char* prefix, counter_t *counter) {
  entry_t *head = NULL, *current, *iter;
  size_t size = 0, index;

  struct dirent *file_dirent;
  DIR *dir_handle;

  char *full_path, *segment, *pointer, *next_prefix;

  dir_handle = opendir(directory);
  if (!dir_handle) {
    fprintf(stderr, "Cannot open directory \"%s\"\n", directory);
    return -1;
  }

  counter->dirs++;

  while ((file_dirent = readdir(dir_handle)) != NULL) {
    if (file_dirent->d_name[0] == '.') {
      continue;
    }

    current = malloc(sizeof(entry_t));
    current->name = strcpy(malloc(strlen(file_dirent->d_name) + 1), file_dirent->d_name);
    current->is_dir = file_dirent->d_type == DT_DIR;
    current->next = NULL;

    if (head == NULL) {
      head = current;
    } else if (strcmp(current->name, head->name) < 0) {
      current->next = head;
      head = current;
    } else {
      for (iter = head; iter->next && strcmp(current->name, iter->next->name) > 0; iter = iter->next);

      current->next = iter->next;
      iter->next = current;
    }

    size++;
  }

  closedir(dir_handle);
  if (!head) {
    return 0;
  }

  for (index = 0; index < size; index++) {
    if (index == size - 1) {
      pointer = "└── ";
      segment = "    ";
    } else {
      pointer = "├── ";
      segment = "│   ";
    }

    printf("%s%s%s\n", prefix, pointer, head->name);

    if (head->is_dir) {
      full_path = malloc(strlen(directory) + strlen(head->name) + 2);
      sprintf(full_path, "%s/%s", directory, head->name);

      next_prefix = malloc(strlen(prefix) + strlen(segment) + 1);
      sprintf(next_prefix, "%s%s", prefix, segment);

      walk(full_path, next_prefix, counter);
      free(full_path);
      free(next_prefix);
    } else {
      counter->files++;
    }

    current = head;
    head = head->next;

    free(current->name);
    free(current);
  }

  return 0;
}

int main(int argc, char *argv[]) {
  char* directory = argc > 1 ? argv[1] : ".";
  printf("%s\n", directory);

  counter_t counter = {0, 0};
  walk(directory, "", &counter);

  printf("\n%zu directories, %zu files\n",
    counter.dirs ? counter.dirs - 1 : 0, counter.files);
  return 0;
}
