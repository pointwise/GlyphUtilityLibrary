#############################################################################
#
# (C) 2021 Cadence Design Systems, Inc. All rights reserved worldwide.
#
# This sample script is not supported by Cadence Design Systems, Inc.
# It is provided freely for demonstration purposes only.
# SEE THE WARRANTY DISCLAIMER AT THE BOTTOM OF THIS FILE.
#
#############################################################################

package require PWI_Glyph

# path to GUL folder:
set guldir [file dirname [info script]]
set utildir [file join $guldir ".."]
source [file join $utildir "version.glf"]
# ----------------------------------------------------

gul::ApplicationReset

# ************ guiutil proc tests ************

# ---------------- GUIenable ------------------
puts "GUIenable"

gul::GUIenable

puts "--------------"
#-------------------------------------------------

# ---------------- GUIcreateLabelFrame ------------------
puts "GUIcreateLabelFrame"

set lframe [gul::GUIcreateLabelFrame "win" [list -padx 5]]
puts $lframe

puts "--------------"
#-------------------------------------------------

# ---------------- GUIplaceWindow ------------------
puts "GUIplaceWindow"

gul::GUIplaceWindow .

puts "--------------"
#-------------------------------------------------
# ---------------- GUIbusy ------------------
puts "GUIbusy"

gul::GUIbusy {
  for {set k 1} {$k < 100} {incr k} {
    puts "$k"
  }
}

puts "--------------"
#-------------------------------------------------

# ---------------- GUIgeomFileBrowse ------------------
puts "GUIgeomFileBrowse"

set targetFile [gul::GUIgeomFileBrowse]
puts $targetFile

puts "--------------"
#-------------------------------------------------

# ---------------- GUIhasInteractMode ------------------
puts "GUIhasInteractMode"
puts [gul::GUIhasInteractMode]
puts "--------------"
#-------------------------------------------------

# ---------------- GUIinteractionMode ------------------
puts "GUIinteractionMode"
gul::GUIinteractionMode
puts "--------------"
#-------------------------------------------------

# ---------------- GUItextInsert ------------------
puts "GUItextInsert"

set msgBox [text .f -width 60 -height 10 -state normal]
pack $msgBox
gul::GUItextInsert "Insert this line" $msgBox

puts "--------------"
#-------------------------------------------------

# ---------------- GUIupdate ------------------
puts "GUIupdate"

gul::GUIupdate

puts "--------------"
#-------------------------------------------------

exit

#############################################################################
#
# This file is licensed under the Cadence Public License Version 1.0 (the
# "License"), a copy of which is found in the included file named "LICENSE",
# and is distributed "AS IS." TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE
# LAW, CADENCE DISCLAIMS ALL WARRANTIES AND IN NO EVENT SHALL BE LIABLE TO
# ANY PARTY FOR ANY DAMAGES ARISING OUT OF OR RELATING TO USE OF THIS FILE.
# Please see the License for the full text of applicable terms.
#
#############################################################################
