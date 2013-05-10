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
