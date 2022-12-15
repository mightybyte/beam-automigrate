{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Test.Database.Beam.AutoMigrate.Arbitrary where

import qualified Data.Text.Lazy as TL
import Test.QuickCheck
import Text.Pretty.Simple (pShowNoColor)

newtype Pretty a = Pretty {unPretty :: a} deriving (Eq, Arbitrary)

instance Show a => Show (Pretty a) where
  show = TL.unpack . pShowNoColor . unPretty

-- | Drop-in replacement for \"QuickCheck\"'s '(===)' which pretty-prints the output.
infix 4 ===

(===) :: (Eq a, Show a) => a -> a -> Property
x === y =
  counterexample (pretty x ++ interpret res ++ pretty y) res
  where
    pretty :: Show a => a -> String
    pretty = TL.unpack . pShowNoColor
    res = x == y
    interpret True = " == "
    interpret False = " /= "
