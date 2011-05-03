import XMonad
import qualified XMonad.StackSet as W
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Actions.Plane
 
myManageHook = composeAll 
    [ className =? "Vncviewer" --> doFloat
    , className =? "vmplayer" --> doFloat
    , className =? "Xmessage" --> doFloat
    , className =? "gnome-screenshot" --> doFloat
    , className =? "Skype" --> doF(W.shift "1:chat")
    , className =? "Pidgin" --> doF(W.shift "1:chat")
    , className =? "Evolution" --> doF(W.shift "2:mail")
    , className =? "Firefox" --> doF(W.shift "3:web")
    , className =? "Chrome" --> doF(W.shift "3:web")
    ]
 
main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/tgrk/.xmobarrc"
    xmonad $ defaultConfig
        { manageHook = manageDocks <+> myManageHook -- make sure to include myManageHook definition from above
                        <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , workspaces = ["1:chat", "2:mail", "3:web"] ++ map show [4..10]
        , logHook = dynamicLogWithPP $ xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        , modMask = mod4Mask          -- Rebind Mod to the Windows key
        , startupHook = setWMName "LG3D"
	, terminal = "gnome-terminal"
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
          
        , ((mod4Mask, xK_e), spawn "emacs")
        , ((mod4Mask, xK_f), spawn "firefox")
        , ((mod4Mask, xK_m), spawn "evolution")
        , ((mod4Mask, xK_g), spawn "gimp")
        , ((mod4Mask, xK_x), spawn "gnome-terminal")

	, ((mod4Mask, xK_Right), planeMove (Lines 1) Circular ToRight)
	, ((mod4Mask, xK_Left),  planeMove (Lines 1) Circular ToLeft)

        , ((0, xK_Print), spawn "gnome-screenshot")

        ]
