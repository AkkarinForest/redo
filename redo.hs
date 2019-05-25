import System.Directory (renameFile, removeFile)
import System.Process (shell, createProcess, waitForProcess)
import System.Environment (getArgs)
import System.Exit (ExitCode(..))
import System.IO (stderr, hPutStrLn)

main :: IO ()
main = do
  args <- getArgs
  mapM_ redo args

redo :: String -> IO ()
redo target = do
  let tmp = target ++ "---redoing"
  (_,_,_,ph) <- createProcess $ shell $ "sh " ++ target ++ ".do - - " ++ tmp ++ " > " ++ tmp
  exit <- waitForProcess ph
  case exit of
    ExitSuccess -> do renameFile tmp target
    ExitFailure code -> do hPutStrLn stderr $ "Error. Exited with: " ++ show code
                           removeFile tmp
