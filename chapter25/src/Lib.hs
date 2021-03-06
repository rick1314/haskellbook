{-# LANGUAGE InstanceSigs #-}

module Lib
    ( someFunc
    ) where

import Control.Monad


someFunc :: IO ()
someFunc = putStrLn "someFunc"

newtype Identity a =
    Identity { runIdentity :: a }
    deriving (Eq, Show)

newtype IdentityT f a =
    IdentityT { runIdentityT :: f a }
    deriving (Eq, Show)

instance Functor Identity where
    fmap f (Identity a) = Identity $ f a

instance (Functor m ) => Functor (IdentityT m) where
    fmap f (IdentityT fa ) = IdentityT $  f <$> fa

instance Applicative Identity where
    pure = Identity
    (Identity f) <*> (Identity a) = Identity $ f a

instance Applicative m => Applicative (IdentityT m) where
    pure  = IdentityT . pure
    (IdentityT fab ) <*> (IdentityT fa) = IdentityT (fab <*> fa )

instance (Monad m) => Monad (IdentityT m ) where
    return = pure
    (>>=) :: IdentityT m a
          -> (a -> IdentityT m b)
          -> IdentityT m b
    (IdentityT ma) >>= f =
        let
            aimb = ma >>= (runIdentityT .  f) 
        in IdentityT aimb
