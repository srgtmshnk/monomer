{-# LANGUAGE ExistentialQuantification #-}

module Monomer.Event.Types where

import Data.Default
import Data.Text (Text)
import Data.Map.Strict (Map)

import qualified Data.Map.Strict as M

import Monomer.Core.BasicTypes

newtype KeyCode
  = KeyCode { unKeyCode :: Int }
  deriving (Eq, Ord, Show)

data KeyStatus
  = KeyPressed
  | KeyReleased
  deriving (Show, Eq)

data Button
  = LeftBtn
  | MiddleBtn
  | RightBtn
  deriving (Show, Eq, Ord)

data ButtonState
  = PressedBtn
  | ReleasedBtn
  deriving (Show, Eq)

data WheelDirection
  = WheelNormal
  | WheelFlipped
  deriving (Show, Eq)

data ClipboardData
  = ClipboardEmpty
  | ClipboardText Text
  deriving (Eq, Show)

data SystemEvent
  = Click Point Button
  | DblClick Point Button
  | ButtonAction Point Button ButtonState Int
  | WheelScroll Point Point WheelDirection
  | KeyAction KeyMod KeyCode KeyStatus
  | TextInput Text
  | Clipboard ClipboardData
  | Focus
  | Blur
  | Enter Point
  | Move Point
  | Leave Point
  deriving (Show, Eq)

data InputStatus = InputStatus {
  _ipsMousePos :: Point,
  _ipsMousePosPrev :: Point,
  _ipsKeyMod :: KeyMod,
  _ipsKeys :: Map KeyCode KeyStatus,
  _ipsButtons :: Map Button ButtonState
} deriving (Eq, Show)

instance Default InputStatus where
  def = InputStatus {
    _ipsMousePos = Point (-1) (-1),
    _ipsMousePosPrev = Point (-1) (-1),
    _ipsKeyMod = def,
    _ipsKeys = M.empty,
    _ipsButtons = M.empty
  }

data KeyMod = KeyMod {
  _kmLeftShift :: Bool,
  _kmRightShift :: Bool,
  _kmLeftCtrl :: Bool,
  _kmRightCtrl :: Bool,
  _kmLeftAlt :: Bool,
  _kmRightAlt :: Bool,
  _kmLeftGUI :: Bool,
  _kmRightGUI :: Bool,
  _kmNumLock :: Bool,
  _kmCapsLock :: Bool,
  _kmAltGr :: Bool
} deriving (Show, Eq)

instance Default KeyMod where
  def = KeyMod {
    _kmLeftShift = False,
    _kmRightShift = False,
    _kmLeftCtrl = False,
    _kmRightCtrl = False,
    _kmLeftAlt = False,
    _kmRightAlt = False,
    _kmLeftGUI = False,
    _kmRightGUI = False,
    _kmNumLock = False,
    _kmCapsLock = False,
    _kmAltGr = False
  }
