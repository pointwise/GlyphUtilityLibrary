#
# Proprietray software product of Pointwise, Inc.
# Copyright (c) 1995-2013 Pointwise, Inc.
# All rights reserved.
#
# This sample Glyph script is not supported by Pointwise, Inc.
# It is provided freely for demonstration purposes only.
# SEE THE WARRANTY DISCLAIMER AT THE BOTTOM OF THIS FILE.
#

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

#
# DISCLAIMER:
# TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, POINTWISE DISCLAIMS
# ALL WARRANTIES, EITHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED
# TO, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE, WITH REGARD TO THIS SCRIPT.  TO THE MAXIMUM EXTENT PERMITTED BY
# APPLICABLE LAW, IN NO EVENT SHALL POINTWISE BE LIABLE TO ANY PARTY FOR
# ANY SPECIAL, INCIDENTAL, INDIRECT, OR CONSEQUENTIAL DAMAGES WHATSOEVER
# (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF BUSINESS
# INFORMATION, OR ANY OTHER PECUNIARY LOSS) ARISING OUT OF THE USE OF OR
# INABILITY TO USE THIS SCRIPT EVEN IF POINTWISE HAS BEEN ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGES AND REGARDLESS OF THE FAULT OR NEGLIGENCE OF
# POINTWISE.
#
