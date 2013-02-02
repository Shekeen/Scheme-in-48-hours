module Main where

import Control.Monad
import Control.Monad.Error
import Text.ParserCombinators.Parsec hiding (spaces)
import System.Environment
import System.IO

import Scheme.Aux
import Scheme.Parser
import Scheme.Values

readExpr :: String -> ThrowsError LispVal
readExpr input = case parse parseExpr "lisp" input of
         Left err -> throwError $ Parser err
         Right val -> return val

flushStr :: String -> IO ()
flushStr str = putStr str >> hFlush stdout

readPrompt :: String -> IO String
readPrompt prompt = flushStr prompt >> getLine

evalString :: Env -> String -> IO String
evalString env expr = runIOThrows $ liftM show $ (liftThrows $ readExpr expr) >>= eval env

evalAndPrint :: Env -> String -> IO ()
evalAndPrint env expr = evalString env expr >>= putStrLn

runOne :: String -> IO ()
runOne expr = primitiveBindings >>= flip evalAndPrint expr

runRepl :: IO ()
runRepl = primitiveBindings >>= until_ (== "quit") (readPrompt "Lisp> ") . evalAndPrint

main = do
     args <- getArgs
     case length args of
          0 -> runRepl
          1 -> runOne $ args !! 0
          otherwise -> putStrLn "Program takes only 0 or 1 argument"