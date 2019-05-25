import System.Process (shell, createProcess, waitForProcess)
import System.Environment (getArgs)

main :: IO ()
main = do
  args <- getArgs
  mapM_ redo args

redo :: String -> IO ()
redo target = do
  (_,_,_,ph) <- createProcess $ shell $ "sh " ++ target ++ ".do"
  _ <- waitForProcess ph
  return ()
