#############################################################################
#
# (C) 2021 Cadence Design Systems, Inc. All rights reserved worldwide.
#
# This sample script is not supported by Cadence Design Systems, Inc.
# It is provided freely for demonstration purposes only.
# SEE THE WARRANTY DISCLAIMER AT THE BOTTOM OF THIS FILE.
#
#############################################################################


########################################################################
#--
#--  CARTESIAN / CYLINDRICAL COORDINATE CONVERSION ROUTINES
#--
########################################################################

namespace eval gul {

###############################################################
#-- PROC: CartesianToCylindrical
#--
#-- Convert from xyz to rta coordinates.
#--
###############################################################
proc CartesianToCylindrical { axis point } {
  if {[argCheck $point "vector3"] && \
      [argCheck $axis "axis" 0]} {
    if { $axis == "X" } {
      return [xyz2rta_x $point]
    } elseif { $axis == "Y" } {
      return [xyz2rta_y $point]
    } elseif { $axis == "Z" } {
      return [xyz2rta_z $point]
    }
  } else {
    return -code error [getErrorMsg "CartesianToCylindrical"]
  }
}

###############################################################
#-- PROC: CylindricalToCartesian
#--
#-- Convert from rta to xyz coordinates
#--
###############################################################
proc CylindricalToCartesian { axis point } {
  if {[argCheck $point "vector3"] && \
      [argCheck $axis "axis" 0]} {
    if { $axis == "X" } {
      return [rta2xyz_x $point]
    } elseif { $axis == "Y" } {
      return [rta2xyz_y $point]
    } elseif { $axis == "Z" } {
      return [rta2xyz_z $point]
    }
  } else {
    return -code error [getErrorMsg "CylindricalToCartesian"]
  }
}

###############################################################
#-- PROC: rta2xyz_x
#--
#-- Convert from rta to xyz coordinates about X axis
#--
###############################################################
proc rta2xyz_x { point } {
  if {[argCheck $point "vector3"]} {
    set r [lindex $point 0]
    set t [lindex $point 1]
    set a [lindex $point 2]
    set x $a
    set y [expr $r*cos($t)]
    set z [expr $r*sin($t)]
    return [list $x $y $z]
  } else {
    return -code error [getErrorMsg "rta2xyz_x"]
  }
}

###############################################################
#-- PROC: rta2xyz_y
#--
#-- Convert from rta to xyz coordinates about Y axis
#--
###############################################################
proc rta2xyz_y { point } {
  if {[argCheck $point "vector3"]} {
    set r [lindex $point 0]
    set t [lindex $point 1]
    set a [lindex $point 2]
    set y $a
    set z [expr $r*cos($t)]
    set x [expr $r*sin($t)]
    return [list $x $y $z]
  } else {
    return -code error [getErrorMsg "rta2xyz_y"]
  }
}

###############################################################
#-- PROC: rta2xyz_z
#--
#-- Convert from rta to xyz coordinates about Z axis
#--
###############################################################
proc rta2xyz_z { point } {
  if {[argCheck $point "vector3"]} {
    set r [lindex $point 0]
    set t [lindex $point 1]
    set a [lindex $point 2]
    set z $a
    set x [expr $r*cos($t)]
    set y [expr $r*sin($t)]
    return [list $x $y $z]
  } else {
    return -code error [getErrorMsg "rta2xyz_z"]
  }
}

###############################################################
#-- PROC: xyz2rta_x
#--
#-- Convert from xyz to rta coordinates about X axis
#--
###############################################################
proc xyz2rta_x { point } {
  if {[argCheck $point "vector3"]} {
    set x [lindex $point 0]
    set y [lindex $point 1]
    set z [lindex $point 2]
    set r [expr sqrt( $y*$y + $z*$z )]
    set theta [expr atan2($z,$y)]
    set a $x
    return [list $r $theta $a]
  } else {
    return -code error [getErrorMsg "xyz2rta_x"]
  }
}

###############################################################
#-- PROC: xyz2rta_y
#--
#-- Convert from xyz to rta coordinates about Y axis
#--
###############################################################
proc xyz2rta_y { point } {
  if {[argCheck $point "vector3"]} {
    set x [lindex $point 0]
    set y [lindex $point 1]
    set z [lindex $point 2]
    set r [expr sqrt( $z*$z + $x*$x )]
    set theta [expr atan2($x,$z)]
    set a $y
    return [list $r $theta $a]
  } else {
    return -code error [getErrorMsg "xyz2rta_y"]
  }
}

###############################################################
#-- PROC: xyz2rta_z
#--
#-- Convert from xyz to rta coordinates about Z axis
#--
###############################################################
proc xyz2rta_z { point } {
  if {[argCheck $point "vector3"]} {
    set x [lindex $point 0]
    set y [lindex $point 1]
    set z [lindex $point 2]
    set r [expr sqrt( $x*$x + $y*$y )]
    set theta [expr atan2($y,$x)]
    set a $z
    return [list $r $theta $a]
  } else {
    return -code error [getErrorMsg "xyz2rta_z"]
  }
}

}

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

