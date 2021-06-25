using System;
using System.IO;

namespace treeCMD
{
    public static class Count
    {
        public static int Dirs = 0;
        public static int Files = 0;
    }

    class Program
    {
        static void Main(string[] args)
        {
            string defaultPath = Directory.GetCurrentDirectory();
            Console.WriteLine(defaultPath);
            DirectoryInfo directory = new DirectoryInfo(defaultPath);
            Walk(directory, string.Empty);
            Console.WriteLine($"\n{Count.Dirs} diretories, {Count.Files} files");

            // Debug
            // Console.ReadLine();
        }

        static void Walk(DirectoryInfo directoryInfo, string prefix)
        {

            
            FileInfo[] fileInfos = directoryInfo.GetFiles();

            for(int index = 0; index < fileInfos.Length; index++)
            {
                FileInfo file = fileInfos[index];
                if(file.Name[0] != '.')
                {
                    
                    bool lastFile = index == fileInfos.Length - 1;
                    string[] parts = new string[2];
                    if(lastFile)
                    {
                        parts[0] = "└── ";
                        parts[1] = "    ";
                    } else
                    {
                        parts[0] = "├── ";
                        parts[1] = "│   ";
                    }

                    Console.WriteLine($"{prefix}{parts[0]}{file.Name}");
                    Count.Files++;
                }
            }

            DirectoryInfo[] directoryInfos = directoryInfo.GetDirectories();

            for(int index = 0; index < directoryInfos.Length; index++)
            {
                DirectoryInfo directory = directoryInfos[index];

                if(directory.Name[0] != '.')
                {
                    bool lastFile = index == directoryInfos.Length - 1;
                    string[] parts = new string[2];
                    if (lastFile)
                    {
                        parts[0] = "└── ";
                        parts[1] = "    ";
                    }
                    else
                    {
                        parts[0] = "├── ";
                        parts[1] = "│   ";
                    }

                    Console.WriteLine($"{prefix}{parts[0]}{directory.Name}");

                    Count.Dirs++;
                    Walk(directory, $"{prefix}{parts[1]}");
                }
            }


        }

    }
}
