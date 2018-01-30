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
import XMonad.Layout.IndependentScreens
import XMonad.Layout.PerWorkspace
import XMonad.Layout.ToggleLayouts
import XMonad.Actions.Plane
import XMonad.Layout.Reflect
import XMonad.Layout.ShowWName
import XMonad.Layout.Tabbed
import XMonad.Layout.Grid
import System.IO
import Data.Ratio ((%))
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import XMonad.Actions.PhysicalScreens
import Graphics.X11.ExtraTypes.XF86

--FIXME baby 1
--imLayout = withIM slackRatio $
--               reflectHoriz $
--               withIM skypeRatio
--               (Grid ||| Full ||| simpleTabbed)
--               where
--                   slackRatio = (1%7)
--                   skypeRatio = (1%6)

myModMask :: KeyMask
myModMask = mod4Mask -- 1=alt, 4=win key

myManageHook = composeAll
    [ 	className =? "gnome-screenshot" --> doCenterFloat
      , title     =? "v2.kdbx - KeePassX" --> doCenterFloat
      , title     =? "Quit GIMP" --> doCenterFloat
      , className =? "Xmessage" --> doCenterFloat
      , className =? "gitk" --> doFullFloat
      , className =? "gnome-screenshot" --> doCenterFloat
      , className =? "Firefox" --> doF(W.shift "1:web")
      , className =? "Firefox Developer Edition" --> doF(W.shift "1:web")
      , title     =? "Skype" --> doF(W.shift "9:IM")
      , className =? "" --> doF(W.shift "8:Music")
      , className =? "Slack" --> doF(W.shift "9:IM")
      , isFullscreen --> (doF W.focusDown <+> doFullFloat)
    ]

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  [ -- Shortcuts for misc programs
      ((modMask, xK_e), spawn "/usr/bin/code")
    , ((modMask, xK_f), spawn "/usr/bin/firefox")
    , ((modMask, xK_m), spawn "/usr/bin/thunderbird")
    , ((modMask, xK_k), spawn "/usr/bin/keepassx")
    , ((modMask, xK_a), spawn "/usr/bin/pavucontrol")
    , ((modMask .|. shiftMask, xK_b), spawn "/usr/bin/blueman-manager")
    , ((modMask .|. shiftMask, xK_a), spawn "XDG_CURRENT_DESKTOP=Unity gnome-control-center")
    , ((modMask .|. shiftMask, xK_x), spawn "/usr/bin/gnome-terminal")
    , ((modMask .|. shiftMask, xK_h), spawn "sudo /etc/acpi/actions/sleep.sh")
    , ((mod1Mask .|. controlMask, xK_l), spawn "i3lock -c 121212")
    , ((mod1Mask .|. controlMask, xK_space), spawn "/home/tgrk/scripts/xmonad_switch_keyboard.sh")

    -- Volume controls
    , ((0, 0x1008FF11), spawn "amixer set Master 5-")
    , ((0, 0x1008FF13), spawn "amixer set Master 5+")
    , ((0, 0x1008FF12), spawn "amixer -q -D pulse sset Master toggle")

    -- Launch dmenu
    , ((modMask, xK_p), spawn "dmenu_run")

    -- Close focused window
    , ((modMask .|. shiftMask, xK_c), kill)

     -- Rotate through the available layout algorithms
    , ((modMask, xK_space), sendMessage NextLayout)

    -- Reset the layouts on the current workspace to default
    , ((modMask .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modMask, xK_n), refresh)

    -- Move focus to the next window
    , ((modMask, xK_Tab), windows W.focusDown)

    -- Move focus to the next window
    , ((modMask, xK_j), windows W.focusDown)

    -- Move focus to the previous window
    , ((modMask, xK_k), windows W.focusUp)

    -- Move focus to the master window
    , ((modMask, xK_m), windows W.focusMaster)

    -- Swap the focused window and the master window
    , ((modMask, xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_j), windows W.swapDown)

    -- Swap the focused window with the previous window
    , ((modMask .|. shiftMask, xK_k), windows W.swapUp)

    -- Shrink the master area
    , ((modMask .|. shiftMask, xK_h), sendMessage Shrink)

    -- Expand the master area
    , ((modMask .|. shiftMask, xK_l), sendMessage Expand)

    -- Push window back into tiling
    , ((modMask, xK_t), withFocused $ windows . W.sink)

    -- Restart xmonad
    , ((modMask, xK_q), spawn "xmonad --recompile && xmonad --restart")

    , ((modMask .|. controlMask, xK_Right), planeMove (Lines 1) Circular ToRight)
    , ((modMask .|. controlMask, xK_Left),  planeMove (Lines 1) Circular ToLeft)

    -- Take a screenshot
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

    ++

    --
    -- mod-{q,w}, Switch to physical/Xinerama screens 1 or 2
    -- mod-shift-{q,w}, Move client to screen 1 or 2
    --
    [((modMask .|. mask, key), f sc)
        | (key, sc) <- zip [xK_q, xK_w] [0..]
        , (f, mask) <- [(viewScreen, 0), (sendToScreen, shiftMask)]]

main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/tgrk/.xmobarrc"
    xmonad $ defaultConfig
        { manageHook = manageDocks <+> myManageHook
                        <+> manageHook defaultConfig
--        , layoutHook = avoidStruts $ onWorkspace "9:IM" imLayout  $  layoutHook defaultConfig
        , layoutHook = avoidStruts $ layoutHook defaultConfig
        , handleEventHook = mconcat
                          [ docksEventHook
                          , handleEventHook defaultConfig ]
	, workspaces = ["1:web"] ++ map show [2..7] ++ ["8:Music", "9:IM", "10:irc"]
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
