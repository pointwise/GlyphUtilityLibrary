
# Module: GUI Utilities

# Group: Utilities

###############################################################
# Proc: GUIbusy
#   Makes the GUI unresponsive while a set of commands is 
#   executed, and changes the cursor to the system's "busy"
#   cursor.
#
# Parameters:
#   cmds - Commands to be executed
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > gul::GUIbusy {
#         for {set k 1} {$k < 10000} {incr k} {
#           puts $k
#         }
#       }
#
#   Glyph 1 Output
#     > 1
#     > 2
#      ...
#     > 9999
#   Glyph 2 Output
#     > 1
#     > 2
#      ...
#     > 9999
#
###############################################################
proc GUIbusy {cmds} {}

###############################################################
# Proc: GUIplaceWindow
#   Places an existing window in a specified location on the screen.
#
# Parameters:
#   w      - Frame to move
#   region - String indicating the area of the screen to place the window.
#            Any concatenation of the strings "left", "right", "top",
#            "bottom". Other input will cause the window to be placed
#            in the screen center. If only one region is specified, 
#            the window will be placed in the center of that region
#            (e.g., "left" centers the window at the midpoint of the left
#            screen edge).
#   parent - Parent of frame w
#   xoff   - x offset between frame and original location
#   yoff   - y offset between frame and original location
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > gul::GUIcenterWindow . "top left" "" 100 200
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     > 
#
###############################################################
proc GUIplaceWindow {w {region "left"} {parent ""} {xoff "0"} {yoff "0"}} {}

######################################################################
#  Proc: GUIcreateLabelFrame
#    Create a fancy label frame widget.
#
# Parameters:
#   w    - Window name.
#   args - List of two element lists.
#          Each two element list consists of a tag and a value where
#          tag must be < "font" | "text" | "padx" | "pady" | "ipadx" |
#          "ipady" | "bd" | "relief" >.
#
# Returns:
#   The new label frame widget.
#
# Example:
#   Code
#     > set lframe [gul::GUIcreateLabelFrame "win" [list -padx 5]]
#       puts $lframe
#
#   Glyph 1 Output
#     > .win.f.f
#   Glyph 2 Output
#     > .win.f.f
#
######################################################################
proc GUIcreateLabelFrame {w args} {}

###############################################################
# Proc: GUIenable
#   Enable tk GUI.
#
# Parameters:
#   None
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > gul::GUIenable
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc GUIenable { } {}

###############################################################
# Proc: GUIgeomFileBrowse
#   Use browser to select a CAD geometry file and open it.
#
# Parameters:
#   None
#
# Returns:
#   Selected file.
#
# Example:
#   Code
#     > set targetFile [gul::GUIgeomFileBrowse]
#       puts $targetFile
#
#   Glyph 1 Output
#     > /home/GridgenV15/examples/tutorial/747/747_new.iges
#   Glyph 2 Output
#     > /home/PointwiseV17.0R1/examples/cad/iges/piston1.igs
#
###############################################################
proc GUIgeomFileBrowse {} {}

###############################################################
# Proc: GUIhasInteractMode
#   Determine if display interaction is mode based.
#
# Parameters:
#
# Returns:
#   Boolean.
#
# Example:
#   Code
#     > gul::GUIhasInteractMode
#
#   Glyph 1 Output
#     > 1
#   Glyph 2 Output
#     > 0
#
###############################################################
proc GUIhasInteractMode { } {}

###############################################################
# Proc: GUIinteractionMode
#   Enter display interaction mode. Note: not implemented 
#   for Glyph 2
#
# Parameters:
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > gul::GUIinteractionMode
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc GUIinteractionMode { } {}

###############################################################
# Proc: GUItextInsert
#   Inserts a line of text into a specified text field if 
#   possible and to the message window otherwise.
#
# Parameters:
#   line - Line of text to be inserted.
#   msgBox - Text field in which to insert the line.
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > set msgBox [text .f -width 60 -height 10 -state normal]
#       pack $msgBox
#       gul::GUItextInsert "Insert this line" $msgBox
#
#   Glyph 1 Output
#     > 
#   Glyph 2 Output
#     > 
#
###############################################################
proc GUItextInsert {line msgBox} {}

###############################################################
# Proc: GUIupdate
#   Update 3D display. Note: Not implemented for Glyph 1.
#
# Parameters:
#   None
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > gul::GUIupdate
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc GUIupdate { } {}

