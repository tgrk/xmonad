import XMonad
import qualified XMonad.StackSet as W
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Layout.IM as IM
import XMonad.Layout.Minimize
import XMonad.Layout.WindowNavigation
import System.IO
import XMonad.Layout.PerWorkspace
import XMonad.Layout.ToggleLayouts
import XMonad.Actions.Plane
import XMonad.Layout.Grid
import Data.Ratio ((%))
 
myManageHook = composeAll 
    [ className =? "Vncviewer" --> doFloat
    , className =? "vmplayer" --> doFloat
    , className =? "Xmessage" --> doFloat
    , className =? "gnome-screenshot" --> doFloat
--    , className =? "Skype" --> doF(W.shift "1:chat")
    , className =? "google-chrome" --> doF(W.shift "2:web")
    ]

-- Define the default layout
skypeLayout = IM.withIM (1%7) (IM.And (ClassName "Skype")  (Role "MainWindow")) Grid
normalLayout = windowNavigation $ minimize $ avoidStruts $ onWorkspace "1:chat" skypeLayout $ layoutHook defaultConfig
myLayout = toggleLayouts (Full) normalLayout
 
main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/wiso/.xmobarrc"
    xmonad $ defaultConfig
        { manageHook = manageDocks <+> myManageHook -- make sure to include myManageHook definition from above
                        <+> manageHook defaultConfig
--        , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , layoutHook = myLayout
        , workspaces = ["1:chat", "2:web"] ++ map show [3..9]
        , logHook = dynamicLogWithPP $ xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        , modMask = mod4Mask          -- Rebind Mod to the Windows key
        , startupHook = setWMName "LG3D"
	, terminal = "gnome-terminal"
	, normalBorderColor  = "#000000"
        , focusedBorderColor = "#666666"
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_l), spawn "xscreensaver-command -lock")
          
        , ((mod4Mask, xK_e), spawn "emacs")
        , ((mod4Mask, xK_f), spawn "google-chrome")
        , ((mod4Mask, xK_v), spawn "gnome-alsamixer")
        , ((mod4Mask, xK_x), spawn "gnome-terminal")
	, ((mod4Mask .|. shiftMask, xK_h), spawn "sudo pm-hibernate")
	, ((mod4Mask .|. shiftMask, xK_r), spawn "sudo reboot")
	, ((mod4Mask .|. shiftMask, xK_s), spawn "sudo shutdown -h now")

	, ((mod4Mask, xK_Right), planeMove (Lines 1) Circular ToRight)
	, ((mod4Mask, xK_Left),  planeMove (Lines 1) Circular ToLeft)

        , ((0, xK_Print), spawn "gnome-screenshot")

        ]
