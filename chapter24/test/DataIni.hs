{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Applicative
import Data.ByteString (ByteString)
import Data.Char (isAlpha)
import Data.Map (Map)
import qualified Data.Map as M
import Data.Text (Text)
import qualified Data.Text.IO as TIO
import Test.Hspec
import Text.RawString.QQ
import Text.Trifecta
import IniParser


main :: IO ()
main = hspec $ do
         describe "Assignment Parsing" $
               it "can parse a simple assignment" $ do
                 let m = parseByteString parseAssignment mempty assignmentEx
                     r' = maybeSuccess m
                 print m
                 r' `shouldBe` Just ("woot" , "1")
         describe "Header Parsing" $
               it "can parse a simple header " $ do
                 let m = parseByteString parseHeader mempty headerEx
                     r' = maybeSuccess m
                 print m
                 r' `shouldBe` Just (Header "blah")
         describe "Comment parsing"$
               it "can skip a comment before a number" $ do
                 let p = skipComments >> parseHeader
                     i = "; woot\n[blah]"
                     m = parseByteString p mempty i
                     r' = maybeSuccess m
                 print m
                 r' `shouldBe` Just (Header "blah")
         describe "Section parsing" $
               it "Can parse a simple section" $ do
                 let m = parseByteString parseSection mempty sectionEx
                     r' = maybeSuccess m
                     states = M.fromList [("Chris", "Texas")]
                     expected' = Just (Section (Header "states") states)
                 print m
                 r' `shouldBe` expected'
         describe "INI parsing" $
               it "Can parse multiple sections" $ do
                 let m = parseByteString parseIni mempty sectionEx''
                     r' = maybeSuccess m
                     sectionValues = M.fromList [("alias", "claw"),
                                                 ("host", "wikipedia.org")]
                     whatisitValues = M.fromList [("red", "intoothandclaw")]
                     expectedList = [(Header "section",
                                             sectionValues),
                                     (Header "whatisit",
                                             whatisitValues)]
                     expected' = Just (Config
                                       (M.fromList expectedList))
                 print m
                 r' `shouldBe` expected'
