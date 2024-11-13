-- [https://github.com/haskell/haskell-language-server/issues/236#issuecomment-864827647]
-- [https://github.com/haskell/haskell-language-server/issues/2932#issuecomment-1139531151]
-- [https://github.com/haskell/haskell-language-server/issues/2932]
-- [https://github.com/haskell/haskell-language-server/issues/236]

module Main where

-- IMPORTS
import XMonad
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig
import XMonad.Util.Ungrab
import XMonad.Util.Run
import XMonad.Prompt
import XMonad.Prompt.Ssh
import XMonad.Hooks.DynamicIcons
--Layouts
import XMonad.Layout
import XMonad.Layout.Accordion
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.BorderResize
import XMonad.Layout.Circle
import XMonad.Layout.Grid
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.Hidden
import XMonad.Layout.LayoutHints
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LayoutScreens
import XMonad.Layout.Magnifier
import XMonad.Layout.NoBorders (noBorders, smartBorders)
import XMonad.Layout.PerScreen
import XMonad.Layout.PositionStoreFloat (positionStoreFloat)
import XMonad.Layout.Reflect
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.TwoPane
import XMonad.Layout.WindowArranger
import XMonad.Layout.ResizableTile
import XMonad.Layout.ResizableThreeColumns

import XMonad.Actions.Warp (warpToWindow)
import XMonad.Actions.WorkspaceNames

import XMonad.Actions.DynamicProjects   -- TODO: Look into adding this
import XMonad.Actions.DynamicWorkspaceGroups

--Xmobar Integration Requirements
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName

import Data.Monoid
import Data.Maybe
import Data.Ratio
import System.IO
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- Polybar
import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8
import XMonad.Layout.Dwindle (Dwindle(Spiral))
import Data.ByteString.Char8 (split)
import Data.List (splitAt, intercalate, concat)
import Codec.Binary.UTF8.Generic (take)
import XMonad.Util.Loggers (loadAvg, padL, logCmd, logCurrentOnScreen, logTitleOnScreen, logWhenActive)
import XMonad.Actions.PhysicalScreens (getScreen)
import XMonad.Util.WorkspaceCompare (getSortByXineramaPhysicalRule, getSortByXineramaRule)
import XMonad.Layout.NoFrillsDecoration (noFrillsDeco)
import XMonad.Prompt.Layout (layoutPrompt)
import XMonad.Layout.MultiToggle (HCons)
import Graphics.X11 (xK_backslash)

-- The default xrandr monitor layout to load on start/refresh
myScreenLayout = "~/.screenlayout/battery.sh"
-- myScreenLayout = ""

borderRed = "#f43e5c"
borderGrey = "#1e1e2e"

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
-- See [https://stackoverflow.com/a/60683742] for using Nerd Font icons
myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

myIcons :: Query [String]
myIcons = composeAll [
        className =? "firefox" --> appIcon "\xfb6e"
    ]

------------------------------------------------------------------------
-- KEY BINDINGS: Add, modify or remove key bindings here.

-- Perform an operation then warp the mouse to the current active window
-- thenMouseWarp operation = sequence_ [operation, warpToWindow (1%1) (1%1)]
thenMouseWarp = id

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $ [

    ---------- AUDIO/MUSIC ----------

    -- See [https://superuser.com/a/389829]
    -- For key codes, use `xev` and look in `/usr/include/X11/keysymdef.h` [https://unix.stackexchange.com/a/264551]

    -- toggle system volume mute
      ((0,0x1008ff12), spawn "amixer set Master toggle")
    -- system volume down
    , ((0,0x1008ff11), spawn "amixer sset Master 2%-")
    -- system volume up
    , ((0,0x1008ff13), spawn "amixer sset Master 2%+")
    -- headset next song
    , ((0,0x1008ff17), spawn "playerctl next")
    -- headset prev song
    , ((0,0x1008ff16), spawn "playerctl previous")
    -- headset fast forward
    , ((0,0x1008ff97), spawn "playerctl position 1.5+")
    -- headset rewind
    , ((0,0x1008ff3e), spawn "playerctl position 1.5-")
    -- headset play/pause song
    , ((0,0x1008ff14), spawn "playerctl play-pause")
    -- headset play/pause song
    , ((0,0x1008ff31), spawn "playerctl play-pause")


    ---------- KEYBOARD BRIGHTNESS ----------

    -- keyboard brightness down
    , ((0,0x1008ff06), spawn "sudo su -c 'rogauracore brightness 0'") -- TODO: Work out how to do this with root priviledges
    -- keyboard brightness up
    , ((0,0x1008ff05), spawn "sudo su -c 'rogauracore brightness 2'") -- TODO: Same as above

    -- hide focused window
    , ((modm, xK_BackSpace), withFocused hideWindow)
    -- unhide last hidden window
    , ((modm .|. shiftMask, xK_BackSpace), popNewestHiddenWindow)
    -- rename current workspace
    , ((modm .|. shiftMask,xK_z), renameWorkspace def)
    -- warp mouse to active window
    , ((modm,xK_z), warpToWindow (1%2) (1%2))
    -- launch screenshot utility
    , ((0, xK_Print), spawn "flameshot launcher")


    ---------- LAUNCH APPLICATIONS ----------

    -- launch a terminal
    , ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    -- launch themed rofi
    , ((modm,xK_p), spawn "rofi -show drun -monitor -4")
    -- capture area screenshot
    , ((modm .|. shiftMask, xK_s), spawn "flameshot gui")
    -- firefox normal tab
    , ((modm, xK_bracketleft), spawn "firefox")
    -- firefox incognito tab
    , ((modm .|. shiftMask, xK_bracketleft), spawn "firefox --private-window")
    -- launch yazi
    , ((modm, xK_o), spawn "kitty 'yazi'")
    -- launch dmenu
    , ((modm .|. shiftMask, xK_p), spawn "dmenu_run -p 'ᐒ' -fn 'Fira Code:pixelsize=14' -sb '#f43e5c' -sf '#1e1e2e' -nb '#1e1e2e' -nf '#bac2de'")


    ---------- LAYOUTS ----------

    -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)
    -- Simulate selecting the previous layout by going to the next one n-1 times
    , ((modm .|. controlMask, xK_space), sequence_ $ replicate 5 $ sendMessage NextLayout)
    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)


    ---------- LAYOUT GROUPS ----------
    -- TODO
    , ((modm, xK_n), promptWSGroupAdd def "Add Group: ")
    , ((modm, xK_g), promptWSGroupView def "Go to group: ")
    , ((modm, xK_d), promptWSGroupForget def "Forget group: ")

    ---------- WINDOW MANAGEMENT ----------

    -- Resize viewed windows to the correct size
    , ((modm .|. shiftMask, xK_backslash), spawn "slock")
    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)
    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)
    -- Move focus to the next window
    , ((modm,               xK_j     ), thenMouseWarp $ windows W.focusDown)
    -- Move focus to the previous window
    , ((modm,               xK_k     ), thenMouseWarp $ windows W.focusUp)
    -- Move focus to the master window
    , ((modm,               xK_m     ), thenMouseWarp $ windows W.focusMaster)
    -- Swap the focused window and the master window
    , ((modm,               xK_Return), thenMouseWarp $ windows W.swapMaster)
    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), thenMouseWarp $ windows W.swapDown)
    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), thenMouseWarp $ windows W.swapUp)
    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)
    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)
    -- BSP expand/shrink
    , ((modm .|. controlMask, xK_j     ), sendMessage $ ExpandTowards D)
    , ((modm .|. controlMask, xK_k     ), sendMessage $ ExpandTowards U)
    , ((modm .|. controlMask, xK_h     ), sendMessage $ ExpandTowards L)
    , ((modm .|. controlMask, xK_l     ), sendMessage $ ExpandTowards R)
    -- Shrink the master area
    , ((modm .|. shiftMask, xK_h     ), sendMessage MirrorShrink)
    -- Expand the master area
    , ((modm .|. shiftMask, xK_l     ), sendMessage MirrorExpand)
    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)
    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))


    ---------- UTILITIES ----------

    -- refresh to default layout (just laptop monitor)
    , ((modm .|. shiftMask, xK_u), spawn  "~/.screenlayout/default.sh ; xmonad --restart; nitrogen --restore")
    -- refresh to 2 monitor layout
    , ((modm,               xK_u), spawn myScreenLayout)
    -- lock the screen
    , ((modm .|. shiftMask, xK_c), kill)
    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io $ exitWith ExitSuccess)
    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --restart; polybar-msg cmd restart")

    ---------- REMOVED ----------

    -- show layout prompt (Module not fully functional)
    -- , ((modm, xK_semicolon), layoutPrompt def)

    -- split screen into two (broken on multimonitor setup)
    -- , ((modm, xK_slash), layoutScreens 2 (Mirror $ TwoPane 0.5 0.5))
    -- undo split screen
    -- , ((modm .|. shiftMask, xK_slash), rescreen)

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also [https://xmonad.github.io/xmonad-docs/xmonad-contrib/XMonad-Hooks-DynamicLog.html#v:statusBar]
    -- , ((modm              , xK_b     ), sequence_ [spawn "polybar-msg cmd toggle", sendMessage ToggleStruts])

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    -- , ((modm .|. shiftMask, xK_slash ), spawn "echo \"Help dialog has been removed\" | xmessage -file -bg '#1c1e26' -fg '#f43e5c'")

    ]

    ++
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- MOUSE BINDINGS: Default actions bound to mouse events
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), \w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster)

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), \w -> focus w >> windows W.shiftMaster)

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), \w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster)
    ]

------------------------------------------------------------------------
-- LAYOUTS: Specify and transform layouts by modifying these values
-- Use 'mod-shift-space' after restarting xmonad to update to latest layout settings.

-- mySpacing = smartSpacing 10
mySpacing :: l a -> ModifiedLayout Spacing l a
-- mySpacing = spacingRaw True (Border (2*i) i 0 i) True (Border i i i 0) True
mySpacing = spacingRaw False (Border halfS halfS halfS halfS) False (Border s s s s) True
    where
        s = 4
        halfS = s `div` 2

myLayout = ifWider 1280 horizLayout vertLayout
    where
    horizLayout = renamed [CutWordsLeft 1] $ hiddenWindows $
        tiled |||
        mirrorTiled |||
        full |||
        threeCol |||
        bsp
    vertLayout  = renamed [CutWordsLeft 1] $ hiddenWindows $
        renamed [Replace "3Rw"] (reflectVert $ Mirror threeCol) |||
        mirrorTiled |||
        full |||
        renamed [Replace "BSP"] (Mirror bsp)

    tiled = --magnifiercz windowMag $
        renamed [Replace "Tll"] $
        avoidStruts $
        mySpacing $
        ResizableTall nmaster delta ratio []

    mirrorTiled =
        renamed [Replace "MTl"] $
        avoidStruts $
        mySpacing $
        Mirror $
        ResizableTall nmaster delta ratio []
    
    full =
        renamed [Replace "Fll"] $
        noBorders $
        Full

    threeCol = --magnifiercz windowMag $
        renamed [Replace "3Cl"] $
        avoidStruts $
        mySpacing $
        ResizableThreeColMid nmaster delta ratio []

    -- spir =
    --     renamed [Replace "Spr"] $
    --     avoidStruts $
    --     mySpacing $
    --     spiralWithDir East CCW (6/7)

    bsp =
        renamed [Replace "BSP"] $
        avoidStruts $
        mySpacing $
        emptyBSP

    nmaster  = 1        -- The default number of windows in the master pane
    ratio    = 2/3      -- The default proportion of the screen occupied by the master pane
    delta    = 3/100    -- The percentage of the screen to increment by when resizing panes
    windowGap = 10      -- Amount of pixels gap between each window
    windowMag = 1       -- Scale factor for the window currently in focus

------------------------------------------------------------------------
-- WINDOW RULES:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll [
        className =? "MPlayer"        --> doFloat,
        className =? "Trayer"         --> doIgnore,
        className =? "Gimp"           --> doFloat,
        resource  =? "desktop_window" --> doIgnore,
        resource  =? "kdesktop"       --> doIgnore
    ]

------------------------------------------------------------------------
-- EVENT HANDLING
-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
-- myEventHook = mempty

removePrefix :: String -> String -> String
removePrefix prefix str = if Prelude.take prefixLen str == prefix then drop prefixLen str else str
    where prefixLen = length prefix

-- See [https://youtu.be/d1KWL2MKXZw?t=333] for polybar configuration
-- See [https://xmonad.github.io/xmonad-docs/xmonad-contrib/XMonad-Hooks-StatusBar-PP.html] for params
myLogHook :: D.Client -> PP
myLogHook dbus = def {
    ppOutput =  dbusOutput dbus,
    ppCurrent = wrap "[%{F#f43e5c}" "%{F-}]",
    ppVisible = wrap "%{F#9399b2}[" "]%{F-}",
    ppUrgent =  wrap "(%{F#f43e5c}" "%{F-})",
    ppHidden =  wrap "%{F#585b70}" "%{F-}",
    -- ppHiddenNoWindows
    -- ppLayout =  removePrefix "Spacing " . removePrefix "Hidden ",
    ppTitle =   const "",
    ppSep =     " : ",
    ppSort =    getSortByXineramaRule
    -- ppExtras = [logWhenActive 1 $ logCmd "date +%s%N"]
}

debugLogHook :: PP
debugLogHook = def {
    ppOutput = appendFile "/tmp/xmonadLog"
}

-- Emit a DBus signal on log updates
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = let
        objectPath = D.objectPath_ "/org/xmonad/Log"
        interfaceName = D.interfaceName_ "org.xmonad.Log"
        memberName = D.memberName_ "Update"
        signal = D.signal objectPath interfaceName memberName
        signalBody = [D.toVariant $ UTF8.decodeString str]
    in D.emit dbus $ signal { D.signalBody = signalBody }

mkDbusClient :: IO D.Client
mkDbusClient = do
    dbus <- D.connectSession
    D.requestName dbus (D.busName_ "org.xmonad.Log") opts
    return dbus
    where
        opts = [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

------------------------------------------------------------------------
-- STARTUP HOOK
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.

myStartupHook = do
    spawnOnce "nitrogen --restore" -- Sets the wallpaper
    spawnOnce myScreenLayout
    -- setWMName "xm1ad"

    -- XMonad does not support reparenting, so Java Swing apps can break
    -- See [https://stackoverflow.com/a/30742663]
    -- and [https://askubuntu.com/a/1258681]
    setWMName "LG3D" -- We need this or Java Swing applications break (e.g. Android Studio)

------------------------------------------------------------------------
-- The 'def' record update overrides the defaults specified in xmonad/XMonad/Config.hs
main :: IO ()
-- main = xmonad . ewmh =<< xmobar myConfig

main = do
    dbus <- mkDbusClient

    -- ewmh :: XConfig a -> XConfig a
    -- xmonad :: XConfig a -> IO ()
    xmonad $ ewmh $ docks $ def {
        terminal = "kitty",
        normalBorderColor = borderGrey,
        focusedBorderColor = borderRed,
        borderWidth = 3,
        workspaces = myWorkspaces,

        -- Input
        modMask = mod4Mask,
        focusFollowsMouse = False,
        clickJustFocuses = True,
        keys = myKeys,
        mouseBindings = myMouseBindings,

        -- Hooks
        manageHook = myManageHook,
        layoutHook = myLayout,
        startupHook = myStartupHook,
        -- handleEventHook = mempty,
        handleEventHook = fullscreenEventHook,

        -- logHook :: X ()
        -- dynamicLogWithPP :: PP -> X ()
        -- workspaceNamesPP :: PP -> X PP
        -- myLogHook :: D.Client -> PP
        -- dbus :: D.Client

        -- TODO: Rename workspaces
        -- See [https://www.reddit.com/r/xmonad/comments/34w02a/interactive_workspace_rename_in_xmonad]
        -- and [https://unix.stackexchange.com/questions/217213/getting-xmonad-to-show-name-of-current-workspace-in-xmobar]
        -- logHook = dynamicLogWithPP $ myLogHook dbus
        -- logHook = dynamicLogWithPP debugLogHook
        logHook = workspaceNamesPP >> dynamicLogWithPP $ myLogHook dbus
    }