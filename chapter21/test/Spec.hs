{-# LANGUAGE FlexibleContexts #-}
module Spec where

import Test.QuickCheck.Checkers
import Test.QuickCheck.Classes
import Test.QuickCheck
import Test.Hspec
import ChapterExercises

instance Eq a => EqProp (Identity a)  where
  (=-=) = eq
instance Arbitrary a => Arbitrary (Identity a) where
  arbitrary = Identity <$> arbitrary
ident  = undefined :: Identity (Int, Int , [Int])

instance Eq a => EqProp (Constant a b)  where
  (=-=) = eq
instance Arbitrary a => Arbitrary (Constant a b) where
  arbitrary = Constant <$> arbitrary
constant = undefined :: Constant Int (Int, Int , [Int])

instance Eq a => EqProp (Optional a)  where
  (=-=) = eq
instance Arbitrary a => Arbitrary (Optional a) where
  arbitrary = frequency [(1, Yep <$> arbitrary), (1, return Nada)]
opt   = undefined :: Optional (Int, Int , [Int])

instance Arbitrary a => Arbitrary (List a) where
  arbitrary = frequency [(3, Cons <$> arbitrary <*> arbitrary), (1, return Nil)]
list   = undefined :: List (Int, Int , [Int])

take' :: Int -> List a -> List a
take' 0 _ = Nil
take' _ Nil = Nil
take' n (Cons h t) = Cons h $ take' (n - 1) t

instance Eq a => EqProp (List a) where
  xs =-= ys = xs' `eq` ys'
     where xs' = take' 300 xs
           ys' = take' 300 ys

three   = undefined :: Three Int Int (Int, Int , [Int])
three'   = undefined :: Three' Int  (Int, Int , [Int])
s = undefined :: S [] (Int, Int , [Int])
instance (Arbitrary a, Arbitrary b , Arbitrary c) => Arbitrary (Three a b c) where
  arbitrary = Three <$> arbitrary <*> arbitrary <*> arbitrary

instance (Arbitrary a, Arbitrary b ) => Arbitrary (Three' a b) where
  arbitrary = Three' <$> arbitrary <*> arbitrary <*> arbitrary

instance (Eq a, Eq b ) => EqProp (Three' a b ) where
   (=-=) = eq

instance (Eq a, Eq (n a)) => EqProp (S n a) where
   (=-=) = eq

instance (Eq a, Eq b , Eq c) => EqProp (Three a b c) where
   (=-=) = eq

instance (Arbitrary a, Functor n, Arbitrary (n a)) => (Arbitrary (S n a)) where
  arbitrary =  S <$> arbitrary <*> arbitrary

main :: IO()
main = do
  quickBatch $ traversable ident
  quickBatch $ traversable constant
  quickBatch $ traversable opt
  quickBatch $ functor list
  quickBatch $ monoid list
  quickBatch $ applicative list
  quickBatch $ traversable list
  quickBatch $ traversable three
  quickBatch $ functor three'
  quickBatch $ traversable three'
  quickBatch $ functor s
  quickBatch $ traversable s