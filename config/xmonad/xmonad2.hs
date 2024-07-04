import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks (docks)
import XMonad.Util.Run (spawnPipe)
import System.IO (hPutStrLn, stderr)

main = xmonad $ docks $ def
   { logHook = do
        dynamicLogWithPP testLogHook
        io $ appendFile "/tmp/.xmonadLog" "logHook called\n"
   }

testLogHook :: PP
testLogHook = def
   { ppOutput = \x -> appendFile "/tmp/.xmonadLog" (x ++ "\n") }