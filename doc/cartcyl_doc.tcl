
# Module: Cartesian-Cylindrical Coordinate Utilities

# Group: Utilities

###############################################################
# Proc: CartesianToCylindrical 
#   Convert from xyz to rta coordinates.
#
# Parameters:
#   axis  - Specifies wanted direction of z.
#           Must be < "X" | "Y" | "Z" >.
#   point - Point described in terms of xyz coordinates.
#           Must be a list of three floats.
#
# Returns:
#   Point described in terms of rta coordinates as a list of three floats.
#
# Example:
#   Code
#     > set p1 set p1 [list 1 1 1]
#       set p2 [gul::CartesianToCylindrical "Z" $p1]
#	    puts $p2
#
#   Glyph 1 Output
#     > 1.4142135623730951 0.7853981633974483 1
#
#   Glyph 2 Output
#     > 1.4142135623730951 0.7853981633974483 1
#
###############################################################
proc CartesianToCylindrical { axis point } {}


###############################################################
# Proc: CylindricalToCartesian 
#   Convert from rta to xyz coordinates.
#
# Parameters:
#   axis  - Specifies direction of z used by point.
#           Must be < "X" | "Y" | "Z" >.
#   point - Point described in terms of rta coordinates.
#           Must be a list of three floats.
#
# Returns:
#   Point described in terms of xyz coordinates as a list of three floats.
#
# Example:
#   Code 
#     > set p1 [list 1 1 1]
#       set p2 [gul::CylindricalToCartesian "Y" $p1]
#       puts $p2
#
#   Glyph 1 Output
#     > 0.8414709848078965 1 0.5403023058681398
#
#   Glyph 2 Output
#     > 0.8414709848078965 1 0.5403023058681398
#
###############################################################
proc CylindricalToCartesian { axis point } {}

###############################################################
# Proc: rta2xyz_x
#   Convert from rta to xyz coordinates about X axis.
#
# Parameters:
#   point - Point described in terms of rta coordinates with z
#           pointed in the direction of the X axis.
#           Must be a list of three floats.
#
# Returns:
#   Point described in terms of xyz coordinates as a list of three floats.
#
# Example:
#   Code
#     > set p1 [list 1 1 1]
#       set p2 [gul::rta2xyz_x $p1]
#       puts $p2
#
#   Glyph 1 Output
#     > 1 0.5403023058681398 0.8414709848078965
#
#   Glyph 2 Output
#     > 1 0.5403023058681398 0.8414709848078965
#
###############################################################
proc rta2xyz_x { point } {}

###############################################################
# Proc: rta2xyz_y
#   Convert from rta to xyz coordinates about Y axis.
#
# Parameters:
#   point - Point described in terms of rta coordinates with z
#           pointed in the direction of the Y axis.
#           Must be a list of three floats.
#
# Returns:
#   Point described in terms of xyz coordinates as a list of three floats.
#
# Example:
#   Code
#     > set p1 [list 1 1 1]
#       set p2 [gul::rta2xyz_y $p1]
#       puts $p2
#
#   Glyph 1 Output
#     > 0.8414709848078965 1 0.5403023058681398
#
#   Glyph 2 Output
#     > 0.8414709848078965 1 0.5403023058681398
#
###############################################################
proc rta2xyz_y { point } {}

###############################################################
# Proc: rta2xyz_z
#   Convert from rta to xyz coordinates about Z axis.
#
# Parameters:
#   point - Point described in terms of rta coordinates with z
#           pointed in the direction of the Z axis.
#           Must be a list of three floats.
#
# Returns:
#   Point described in terms of xyz coordinates as a list of three floats.
#
# Example:
#   Code
#     > set p1 [list 1 1 1]
#       set p2 [gul::rta2xyz_z $p1]
#       puts $p2
#
#   Glyph 1 Output
#     > 0.5403023058681398 0.8414709848078965 1
#
#   Glyph 2 Output
#     > 0.5403023058681398 0.8414709848078965 1
#
###############################################################
proc rta2xyz_z { point } {}

###############################################################
# Proc: xyz2rta_x
#   Convert from xyz to rta coordinates about X axis.
#
# Parameters:
#   point - Point described in terms of xyz coordinates.
#           Must be a list of three floats.
#
# Returns:
#   Point described in terms of rta coordinates with z pointed
#   in the direction of the X axis.
#
# Example:
#   Code
#     > set p1 [list 1 2 3]
#       set p2 [gul::xyz2rta_x $p1]
#       puts $p2
#
#   Glyph 1 Output
#     > 3.605551275463989 0.982793723247329 1
#
#   Glyph 2 Output
#     > 3.605551275463989 0.982793723247329 1
#
###############################################################
proc xyz2rta_x { point } {}

###############################################################
# Proc: xyz2rta_y
#   Convert from xyz to rta coordinates about Y axis.
#
# Parameters:
#   point - Point described in terms of xyz coordinates.
#           Must be a list of three floats.
#
# Returns:
#   Point described in terms of rta coordinates with z pointed
#   in the direction of the Y axis.
#
# Example:
#   Code
#     > set p1 [list 1 2 3]
#       set p2 [gul::xyz2rta_y $p1]
#       puts $p2
#
#   Glyph 1 Output
#     > 3.1622776601683795 0.3217505543966422 2
#
#   Glyph 2 Output
#     > 3.1622776601683795 0.3217505543966422 2
#
###############################################################
proc xyz2rta_y { point } {}

###############################################################
# Proc: xyz2rta_z
#   Convert from xyz to rta coordinates about Z axis.
#
# Parameters:
#   point - Point described in terms of xyz coordinates.
#           Must be a list of three floats.
#
# Returns:
#   Point described in terms of rta coordinates with z pointed
#   in the direction of the Z axis.
#
# Example:
#   Code
#     > set p1 [list 1 2 3]
#       set p2 [gul::xyz2rta_z $p1]
#       puts $p2
#
#   Glyph 1 Output
#     > 2.23606797749979 1.1071487177940904 3
#
#   Glyph 2 Output
#     > 2.23606797749979 1.1071487177940904 3
#
###############################################################
proc xyz2rta_z { point } {}

