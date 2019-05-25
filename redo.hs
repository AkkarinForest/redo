import System.Directory (renameFile, removeFile, doesFileExist)
import System.Environment (getArgs)
import System.Exit (ExitCode(..))
import System.IO (hPutStrLn, stderr, IOMode(..), openFile, hClose)
import System.Process (createProcess, waitForProcess, shell, CreateProcess(..), StdStream(..))

main :: IO ()
main = do
    args <- getArgs
    mapM_ redo args

redo :: String -> IO ()
redo target = do
    let tmp = target ++ "---redoing"
        stdOutTmp = target ++ "---redoing-out"
        script = "sh " ++ target ++  ".do - - " ++ tmp
    hStdOut <- openFile stdOutTmp WriteMode
    (_, _, _, ph) <- createProcess (shell script) { std_out = UseHandle hStdOut }
    exit <- waitForProcess ph
    hClose hStdOut
    doesExist <- doesFileExist tmp
    case exit of
        ExitSuccess ->
            if doesExist then do
                renameFile tmp target
                removeFile stdOutTmp
            else
                renameFile stdOutTmp target

        ExitFailure code -> do
            hPutStrLn stderr $
                "Redo script exited with non-zero exit code: " ++ show code
            if doesExist then do
                removeFile tmp
                removeFile stdOutTmp
            else
                removeFile stdOutTmp

