--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.Run
import XMonad.Actions.CopyWindow
import Data.Monoid
import System.Exit
import System.Posix.Unistd

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import XMonad.Hooks.EwmhDesktops




------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- close focused window (keep copies)
    [ ((modm,               xK_x     ), kill1)

    -- close focused window including copies
    , ((modm .|. shiftMask, xK_x     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )
    , ((modm .|. shiftMask, xK_Tab   ), windows W.focusUp)

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Copy window to all workspaces
    , ((modm,               xK_v     ), windows copyToAll) 

    -- Remove all other copies
    , ((modm .|. shiftMask, xK_v     ),  killAllOtherCopies)

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "(xmonad --recompile && xmonad --restart) || notify-send 'Failed to compile config file.'")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]



------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = avoidStruts( smartBorders(
            myTiled |||
            {-spiral (6/7) |||-}
            Full
            ))
  where
     myTiled = Tall 1 (3/100) (1/2)

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--

main = do
myPipe <- spawnPipe "statusbar left"
host <- fmap nodeName getSystemID
xmonad $ ewmh defaultConfig {
        -- simple stuff
          focusFollowsMouse  = True,
          borderWidth        = 1,

          modMask            = mod4Mask,

  -- The default number of workspaces (virtual screens) and their names.
  -- By default we use numeric strings, but any string may be used as a
  -- workspace name. The number of workspaces is determined by the length
  -- of this list.
  --
  -- A tagging example:
  --
  -- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
  --

          workspaces         = map show [1..9],
          normalBorderColor  = "#333333",
          focusedBorderColor = "#FF0000",

        -- key bindings
          keys               = myKeys,
          mouseBindings      = myMouseBindings,

        -- hooks, layouts
          layoutHook         = myLayout,
          manageHook         = composeAll
          [
                resource  =? "desktop_window" --> doIgnore
              , resource  =? "kdesktop"       --> doIgnore
              , resource  =? "Dialog"         --> doFloat
              , className =? "Zenity"         --> doFloat
              , className =? "Wine"         --> doFloat
              , className =? "ssh-askpass-fullscreen" --> doFullFloat
              , isFullscreen --> doFullFloat
              , manageDocks
              ],
          handleEventHook    = docksEventHook <+> fullscreenEventHook,
          startupHook        = return (),
          logHook = dynamicLogWithPP $ defaultPP {
            ppOutput = hPutStrLn myPipe,
            ppCurrent = wrap " ^fg(#3465A4)" "^fg()",
            ppUrgent = wrap " ^fg(#FF0000)" "^fg()",
            ppHidden = wrap " " "",
            ppSep = "^fg(#333) | ^fg()"
          }
      }
