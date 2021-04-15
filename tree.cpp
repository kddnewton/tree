#include <algorithm>
#include <filesystem>
#include <iostream>
#include <string>
#include <vector>

using namespace std;
namespace fs = filesystem;

class Tree {
  private:
    size_t dirs = 0;
    size_t files = 0;

    vector<string> inner_pointers = { "├── ", "│   " };
    vector<string> final_pointers = { "└── ", "    " };

  public:
    void walk(string directory, string prefix) {
      vector<fs::directory_entry> entries;

      for (const auto &entry : fs::directory_iterator(directory)) {
        if (entry.path().filename().string()[0] != '.') {
          entries.push_back(entry);
        }
      }

      sort(entries.begin(), entries.end(), [](const fs::directory_entry &left, const fs::directory_entry &right) -> bool {
        return left.path().filename() < right.path().filename();
      });

      for (size_t index = 0; index < entries.size(); index++) {
        fs::directory_entry entry = entries[index];
        vector<string> pointers = index == entries.size() - 1 ? final_pointers : inner_pointers;

        cout << prefix << pointers[0] << entry.path().filename().string() << endl;

        if (!entry.is_directory()) {
          files++;
        } else {
          dirs++;
          walk(entry.path(), prefix + pointers[1]);
        }
      }
    }

    void summary() {
      cout << "\n" << dirs << " directories," << " " << files << " files" << endl;
    }
};

int main(int argc, char *argv[]) {
  Tree tree;
  string directory = argc == 1 ? "." : argv[1];

  cout << directory << endl;
  tree.walk(directory, "");
  tree.summary();

  return 0;
}
