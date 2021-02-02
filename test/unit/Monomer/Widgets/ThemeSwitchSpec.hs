{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Monomer.Widgets.ThemeSwitchSpec (spec) where

import Control.Lens ((&), (^.), (.~), (?~))
import Data.Default
import Data.Text (Text)
import Test.Hspec

import qualified Data.Sequence as Seq

import Monomer.Core
import Monomer.Core.Combinators
import Monomer.Event
import Monomer.TestUtil
import Monomer.TestEventUtil
import Monomer.Widgets.Label
import Monomer.Widgets.Stack
import Monomer.Widgets.ThemeSwitch

import qualified Monomer.Lens as L

spec :: Spec
spec = describe "Theme Switch" $ do
  switchTheme
  getSizeReq

switchTheme :: Spec
switchTheme = describe "switchTheme" $ do
  it "should return different sizes when theme changes" $ do
    sizeReqW1 `shouldBe` sizeReqW2
    sizeReqH1 `shouldBe` sizeReqH2
    sizeReqW1 `shouldNotBe` sizeReqW3
    sizeReqH1 `shouldNotBe` sizeReqH3

  where
    wenv = mockWenvEvtUnit ()
      & L.theme .~ theme1
    theme1 :: Theme = def
    theme2 :: Theme = def
      & L.basic . L.labelStyle . L.padding ?~ padding 10
    node = hstack [
        label "Test",
        label "Test",
        themeSwitch theme2 (label "Test")
      ]
    newNode = nodeInit wenv node
    inst = widgetSave (newNode ^. L.widget) wenv newNode
    child1 = Seq.index (inst ^. L.children) 0
    child2 = Seq.index (inst ^. L.children) 1
    child3 = Seq.index (inst ^. L.children) 2
    childReq ch = (ch ^. L.info . L.sizeReqW, ch ^. L.info . L.sizeReqH)
    (sizeReqW1, sizeReqH1) = childReq child1
    (sizeReqW2, sizeReqH2) = childReq child2
    (sizeReqW3, sizeReqH3) = childReq child3

getSizeReq :: Spec
getSizeReq = describe "getSizeReq" $ do
  it "should return same reqW as child node" $
    tSizeReqW `shouldBe` lSizeReqW

  it "should return same reqH as child node" $
    tSizeReqH `shouldBe` lSizeReqH

  where
    wenv = mockWenvEvtUnit ()
    lblNode = label "Test label"
    (lSizeReqW, lSizeReqH) = nodeGetSizeReq wenv lblNode
    (tSizeReqW, tSizeReqH) = nodeGetSizeReq wenv (themeSwitch def lblNode)