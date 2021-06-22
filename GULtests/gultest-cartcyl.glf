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

# path to GUL folder
set guldir [file dirname [info script]]
set utildir [file join $guldir ".."]
source [file join $utildir "version.glf"]
# ----------------------------------------------------------

# *************     cartcyl proc tests     *****************

# ----------------- CartesianToCylindrical -----------------
puts "CartesianToCylindrical"
set p1 [list 1 1 1]
set p2 [gul::CartesianToCylindrical "Z" $p1]
puts $p2
puts "-------------"
#-----------------------------------------------------------

# ----------------- CylindricalToCartesian -----------------
puts "CylindricalToCartesian"
set p1 [list 1 1 1]
set p2 [gul::CylindricalToCartesian "Y" $p1]
puts $p2
puts "-------------"
#-----------------------------------------------------------

# ----------------- rta2xyz_x -----------------
puts "rta2xyz_x"
set p1 [list 1 1 1]
set p2 [gul::rta2xyz_x $p1]
puts $p2
puts "-------------"
#-----------------------------------------------------------

# ----------------- rta2xyz_y -----------------
puts "rta2xyz_y"
set p1 [list 1 1 1]
set p2 [gul::rta2xyz_y $p1]
puts $p2
puts "-------------"
#-----------------------------------------------------------

# ----------------- rta2xyz_z -----------------
puts "rta2xyz_z"
set p1 [list 1 1 1]
set p2 [gul::rta2xyz_z $p1]
puts $p2
puts "-------------"
#-----------------------------------------------------------

# ----------------- xyz2rta_x -----------------
puts "xyz2rta_x"
set p1 [list 1 2 3]
set p2 [gul::xyz2rta_x $p1]
puts $p2
puts "-------------"
#-----------------------------------------------------------

# ----------------- xyz2rta_y -----------------
puts "xyz2rta_y"
set p1 [list 1 2 3]
set p2 [gul::xyz2rta_y $p1]
puts $p2
puts "-------------"
#-----------------------------------------------------------

# ----------------- xyz2rta_z -----------------
puts "xyz2rta_z"
set p1 [list 1 2 3]
set p2 [gul::xyz2rta_z $p1]
puts $p2
puts "-------------"
#-----------------------------------------------------------

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
