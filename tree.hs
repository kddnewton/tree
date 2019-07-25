import Data.List
import System.Directory

putEntryInit entry = putStrLn $ "├── " ++ entry

putEntryLast entry = putStrLn $ "└── " ++ entry

recurEntry prefix entry = putStrLn entry

walk dir = do
  entries <- getDirectoryContents dir
  let filtered = sort . filter (not . isPrefixOf ".") $ entries

  mapM_ putEntryInit . init $ filtered
  -- mapM_ recurEntry("│   ") . init $ filtered

  putEntryLast . last $ filtered
  recurEntry "    " . last $ filtered

main = walk "."


-- println(s"$prefix$pointer${node.getName}")
-- if (node.isDirectory) {
--   walk(node, s"$prefix$prefixAdd", counter.copy(dirs = counter.dirs + 1))
-- } else {
--   counter.copy(files = counter.files + 1)
-- }
-- "│   "
-- "    "
