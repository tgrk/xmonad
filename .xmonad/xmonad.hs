import XMonad
import qualified XMonad.StackSet as W
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.IM as IM
import XMonad.Layout.Minimize
import XMonad.Layout.WindowNavigation
import System.IO
import XMonad.Layout.PerWorkspace
import XMonad.Layout.ToggleLayouts
import XMonad.Actions.Plane
import XMonad.Layout.Grid
import Data.Ratio ((%))
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import XMonad.Actions.PhysicalScreens

myModMask :: KeyMask
myModMask = mod1Mask
 
myManageHook = composeAll 
    [ 	className =? "gnome-screenshot" --> doCenterFloat
      , isFullscreen --> (doF W.focusDown <+> doFullFloat)
    ]

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    [   ((modMask, xK_e), spawn "/usr/bin/emacs")
      , ((modMask, xK_f), spawn "google-chrome")
      , ((modMask, xK_x), spawn "gnome-terminal")
      , ((modMask, xK_m), spawn "thunderbird")
      , ((modMask .|. shiftMask, xK_c), kill)
      , ((modMask .|. shiftMask, xK_r), spawn "sudo reboot")
      , ((modMask .|. shiftMask, xK_s), spawn "sudo shutdown -h now")

      -- launch dmenu
    , ((modMask,               xK_p     ), spawn "dmenu_run")
 
    -- launch gmrun
    , ((modMask .|. shiftMask, xK_p     ), spawn "gmrun")
 
    -- close focused window
    , ((modMask .|. shiftMask, xK_c     ), kill)
 
     -- Rotate through the available layout algorithms
    , ((modMask,               xK_space ), sendMessage NextLayout)
 
    --  Reset the layouts on the current workspace to default
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
 
    -- Resize viewed windows to the correct size
    , ((modMask,               xK_n     ), refresh)
 
    -- Move focus to the next window
    , ((modMask,               xK_Tab   ), windows W.focusDown)
 
    -- Move focus to the next window
    , ((modMask,               xK_j     ), windows W.focusDown)
 
    -- Move focus to the previous window
    , ((modMask,               xK_k     ), windows W.focusUp  )
 
    -- Move focus to the master window
    , ((modMask,               xK_m     ), windows W.focusMaster  )
 
    -- Swap the focused window and the master window
    , ((modMask,               xK_Return), windows W.swapMaster)
 
    -- Swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  )
 
    -- Swap the focused window with the previous window
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    )
 
    -- Shrink the master area
    , ((modMask,               xK_h     ), sendMessage Shrink)
 
    -- Expand the master area
    , ((modMask,               xK_l     ), sendMessage Expand)
 
    -- Push window back into tiling
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink)

    -- Restart xmonad
    , ((modMask              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

      , ((modMask .|. controlMask, xK_Right), planeMove (Lines 1) Circular ToRight)
      , ((modMask .|. controlMask, xK_Left),  planeMove (Lines 1) Circular ToLeft)

      , ((modMask, xK_s), spawn "gnome-screenshot")
      , ((0, xK_Print), spawn "gnome-screenshot") 
    ]
    ++
 
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/wiso/.xmobarrc"
    xmonad $ defaultConfig
        { manageHook = manageDocks <+> myManageHook -- make sure to include myManageHook definition from above
                        <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , workspaces = map show [1..10]
        , logHook = dynamicLogWithPP $ xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        , modMask = myModMask
        , startupHook = setWMName "LG3D"
	, terminal = "gnome-terminal"
	, normalBorderColor  = "#000000"
        , focusedBorderColor = "#666666"
        , keys = myKeys
        }
