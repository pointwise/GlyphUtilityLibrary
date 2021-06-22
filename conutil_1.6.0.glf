#############################################################################
#
# (C) 2021 Cadence Design Systems, Inc. All rights reserved worldwide.
#
# This sample script is not supported by Cadence Design Systems, Inc.
# It is provided freely for demonstration purposes only.
# SEE THE WARRANTY DISCLAIMER AT THE BOTTOM OF THIS FILE.
#
#############################################################################

##########################################################################
#--
#-- Define some useful connector commands
#--
##########################################################################


##########################################################################
#--
#-- GRIDGEN CONNECTOR COMMANDS
#--
##########################################################################

namespace eval gul {

###############################################################
#-- PROC: ConGetNumSub
#-- Obtain the number of subconnectors of a given connector.
#--
###############################################################
proc ConGetNumSub { con } {
  if {[argCheck $con "gg::Connector"]} {
    set numSub [gg::conGetNumSubCons $con]
    return $numSub
    exit 1
  } else {
    return -code error [getErrorMsg "ConGetNumSub"]
  }
}

###############################################################
#-- PROC: ConMerge
#-- Merge connectors given a connector topology preference:
#-- FREE|ALL|NONMANIFOLD_FREE and tolerance.
#--
###############################################################
proc ConMerge { topo tol } {
  if { $topo == "FREE" || $topo == "ALL" || $topo == "NONMANIFOLD_FREE" } {
    if { $topo == "NONMANIFOLD_FREE" } { set topo "MANIFOLD" }
    gg::conMerge -filter $topo $tol
  } else {
    return -code error [getErrorMsg "ConMerge"]
  }
}

###############################################################
#-- PROC: ConPeriodicRot
#--
#-- Create connectors as a periodic rotation of existing cons.
#--
###############################################################
proc ConPeriodicRot { conList axisPt1 axisPt2 rotAngle } {
  if {[argCheck $axisPt1 "vector3"] && \
      [argCheck $axisPt2 "vector3"] } {
    foreach con $conList {
      if {![argCheck $con "gg::Connector"]} {
        return -code error [getErrorMsg "ConPeriodicRot"]
      }
    }
    if [catch {
      set periodicConList [gg::conPeriodicRot $conList $axisPt1 $axisPt2 $rotAngle]
    } eid] {
      return -code error [getErrorMsg "ConPeriodicRot"]
    } else {
      return $periodicConList
    }
  } else {
    return -code error [getErrorMsg "ConPeriodicRot"]
  }
}

###############################################################
#-- PROC: ConPeriodicTrans
#--
#-- Create connectors as a periodic translation of existing cons.
#--
###############################################################
proc ConPeriodicTrans { conList offset } {
  foreach con $conList {
      if {![argCheck $con "gg::Connector"]} {
        return -code error [getErrorMsg "ConPeriodicTrans"]
      }
  }
  if {[argCheck $offset "vector3"] } {
    if [catch {
      set periodicConList [gg::conPeriodicTrans $conList $offset]
    } eid] {
      return -code error [getErrorMsg "ConPeriodicTrans"]
    } else {
      return $periodicConList
    }
  } else {
    return -code error [getErrorMsg "ConPeriodicTrans"]
  }
}

###############################################################
#-- PROC: ConAddBreakPt
#--
#-- Add break points at given grid points or arc length ratio,
#-- where type is either X, Y, Z or ARC; locList is a list of
#-- X, Y, Z or arc length ratio.
#--
###############################################################
proc ConAddBreakPt { con type locList } {
  if { ![argCheck $con "gg::Connector"] } {
    return -code error [getErrorMsg "ConAddBreakPt"]
  } elseif {$type != "X" && $type != "Y" && $type != "Z" \
            && $type != "ARC" } {
    return -code error [getErrorMsg "ConAddBreakPt"]
  }
  foreach loc $locList {
    if { $type == "X" } {
      set ptXYZ [gg::conGetPt $con -x $loc]
    } elseif {$type == "Y"} {
      set ptXYZ [gg::conGetPt $con -y $loc]
    } elseif {$type == "Z"} {
      set ptXYZ [gg::conGetPt $con -z $loc]
    } else {
      set ptXYZ [gg::conGetPt $con -arc $loc]
    }
    if { [catch {
        gg::conSetBreakPt $con $ptXYZ
    } eid] } {
      return -code error [getErrorMsg "ConAddBreakPt"]
    }
  }
}


###############################################################
#-- PROC: ConCreateConic
#--
#-- Create a CONIC connector from 2 end points,
#-- a tangency point, and rho value.
#--
#-- Returns the new connector's id.
#--
###############################################################
proc ConCreateConic { pt1 pt2 tan_pt rho } {
  if {[argCheck $pt1 "vector3"] && \
      [argCheck $pt2 "vector3"] && \
      [argCheck $tan_pt "vector3"] && \
      [argCheck $rho "float" 0 0 1 0]} {
    gg::conBegin
    gg::segBegin -type CONIC -rho $rho
    gg::segAddControlPt $pt1
    gg::segAddControlPt $pt2
    gg::segAddControlPt -alternate INTERSECTION $tan_pt
    gg::segEnd
    return [gg::conEnd]
  } else {
    return -code error [getErrorMsg "ConCreateConic"]
  }
}

###############################################################
#-- PROC: ConDbArcLengths
#--
#-- Create a DB_LINE connector from a DB ID and a list of arc-lengths.
#-- Returns the new connector's id.
#--
###############################################################
proc ConDbArcLengths { db_id s1 s2 } {
  if {[argCheck $db_id "gg::DatabaseEntity"] && \
      [argCheck $s1 "float" 0 1 1 0] && [argCheck $s2 "float" 0 0 1 1] } {

    if {$s1 >= $s2} {
      return -code error [getErrorMsg "ConDbArcLengths"]
    }

    set v_min 0.0

    gg::conBegin
    gg::segBegin -type DB_LINE
    gg::segAddControlPt -db [list $s1 $v_min $db_id]
    gg::segAddControlPt -db [list $s2 $v_min $db_id]
    gg::segEnd
    return [gg::conEnd]
  } else {
    return -code error [getErrorMsg "ConDbArcLengths"]
  }
}

###############################################################
#-- PROC: ConFrom2Points
#--
#-- Create a 3D_LINE connector from 2 points.
#-- Returns the new connector's ID.
#--
###############################################################
proc ConFrom2Points { pt1 pt2 } {
  if {[argCheck $pt1 "vector3"] && \
      [argCheck $pt2 "vector3"]} {
    gg::conBegin
    gg::segBegin -type 3D_LINE
    gg::segAddControlPt  $pt1
    gg::segAddControlPt  $pt2
    gg::segEnd
    return [gg::conEnd]
  } else {
    return -code error [getErrorMsg "ConFrom2Points"]
  }
}


###############################################################
#-- PROC: ConFrom3Points
#--
#-- Create a 3D_LINE connector from 3 points.
#-- Returns the new connector's id.
#--
###############################################################
proc ConFrom3Points { pt1 pt2 pt3 {type "LINE"} {slope_weight 0.5} } {
  if {[argCheck $pt1 "vector3"] && \
      [argCheck $pt2 "vector3"] && \
      [argCheck $pt3 "vector3"] && \
      [argCheck $slope_weight "float" 0 1 1 1]} {
    gg::conBegin

    set addSlopeControlPts 0
    if {$type == "LINE"} {
      gg::segBegin -type 3D_LINE
    } elseif {$type == "AKIMA"} {
      gg::segBegin -type AKIMA
    } elseif {$type == "AKIMA_END_SLOPE_MATCH"} {
      # An Akima curve with end point slope defined by the points
      gg::segBegin -type AKIMA
      set addSlopeControlPts 1
    } else {
      printDetails $type "< LINE | AKIMA | AKIMA_END_SLOPE_MATCH >"
      return -code error [getErrorMsg "ConFrom3Points"]
    }

    if {$addSlopeControlPts} {
      set w $slope_weight
      set pt12 [ggu::vec3Add [ggu::vec3Scale $pt1 [expr 1.0-$w]] [ggu::vec3Scale $pt2 $w]]
      set pt23 [ggu::vec3Add [ggu::vec3Scale $pt2 $w] [ggu::vec3Scale $pt3 [expr 1.0-$w]]]
    }

    gg::segAddControlPt  $pt1
    if {$addSlopeControlPts} {
      gg::segAddControlPt  $pt12
    }
    gg::segAddControlPt  $pt2
    if {$addSlopeControlPts} {
      gg::segAddControlPt  $pt23
    }
    gg::segAddControlPt  $pt3
    gg::segEnd

    return [gg::conEnd]
  } else {
    return -code error [getErrorMsg "ConFrom3Points"]
  }
}

###############################################################
#-- PROC: ConOnDbEntities
#--
#-- Create a connector on database entities.
#--
###############################################################
proc ConOnDbEntities { dbEnts {angle 0} } {
  foreach db $dbEnts {
    if {![argCheck $db "gg::DatabaseEntity"]} {
      return -code error [getErrorMsg "ConOnDbEntities"]
    }
  }
  if {[argCheck $angle "float"]} {
    set defAngle [gg::defJoinAng]
    gg::defJoinAng $angle
    set cons [gg::conOnDBEnt $dbEnts]
    gg::defJoinAng $defAngle
    return $cons
  } else {
    return -code error [getErrorMsg "ConOnDbEntities"]
  }
}

###############################################################
#-- PROC: ConOnDbSurface
#--
#-- Create a DB_LINE connector from a DB ID and a list of UV pairs.
#-- Returns the new connector's ID.
#--
###############################################################
proc ConOnDbSurface { db_id uv1 uv2 } {
  if {[argCheck $db_id "gg::DatabaseEntity"] && \
      [argCheck $uv1 "vector2" 0 1 1 1] && \
      [argCheck $uv2 "vector2" 0 1 1 1]} {

#  if { [llength $uv1] < 2 } {
#    puts "ConOnDbSurf: Must specify UV for both points"
#    return -1
#  }
#  if { [llength $uv2] < 2 } {
#    puts "ConOnDbSurf: Must specify UV for both points"
#    return -1
#  }
#  foreach param $uv1 {
#    if { $param < 0.0 || $param > 1.0 } {
#      puts "ConOnDbSurf: Invalid UV $uv1"
#      return -1
#    }
#  }
#  foreach param $uv2 {
#    if { $param < 0.0 || $param > 1.0 } {
#      puts "ConOnDbSurf: Invalid UV $uv2"
#      return -1
#    }
#  }

  set u_min 0.0
  set u_max 1.0
  set v_min 0.0

  lappend uv1 $db_id
  lappend uv2 $db_id
  gg::conBegin
  gg::segBegin -type DB_LINE
  gg::segAddControlPt -db $uv1
  gg::segAddControlPt -db $uv2
  gg::segEnd
  return [gg::conEnd]
  } else {
    return -code error [getErrorMsg "ConOnDbSurface"]
  }
}

###############################################################
#-- PROC: ConCalculateSuitableDimension
#--
#-- Calculate a suitable connector dimension
#-- such that an approximately constant geometric
#-- progression of cell size is achieved.
#--
###############################################################
proc ConCalculateSuitableDimension { con begSpacing endSpacing } {
  if {[argCheck $con "gg::Connector"] && \
      [argCheck $begSpacing "float" 0 1] && \
      [argCheck $endSpacing "float" 0 1]} {
    set conLength [ConGetLength $con]
    set tol [expr [gg::tolModelSize]/1e7]
    if {$conLength < $tol} {
      # unable to handle zero length curve
      return 0
    }
    if {$begSpacing < $endSpacing} {
      set s1 $begSpacing
      set sm $endSpacing
    } else {
      set sm $begSpacing
      set s1 $endSpacing
    }
    if {$s1 < $tol} {
      # unable to handle zero begin spacing
      return 0
    }
    if {[expr $conLength * 0.9] < $sm} {
      # unable to handle large end spacing
      return 0
    }
    if {[expr $sm-$s1] < $tol} {
      # equal spacing
      set dim [expr round($conLength / $s1)]
      return $dim
    }

    # calc constant growth rate that will achieve end spacing
    set g [expr ($conLength - $s1)/($conLength - $sm)]

    # calc num intervals based on constant growth rate
    set nint [expr round(1.0 + log($sm/$s1)/log($g))]

    set dim [expr $nint + 1]
    return $dim
  } else {
    return -code error [getErrorMsg "ConCalculateSuitableDimension"]
  }
}

###############################################################
#-- PROC: ConDelete
#--
#-- Delete connectors.
#--
###############################################################
proc ConDelete { conList } {
  foreach con $conList {
    if {![argCheck $con "gg::Connector"]} {
      return -code error [getErrorMsg "ConDelete"]
    }
  }
  gg::conDelete $conList
}

###############################################################
#-- PROC: ConFindAllAdjacent
#--
#-- Get a list of connectors that are incident on the given connector's end points.
#--
###############################################################

proc ConFindAllAdjacent { con } {
  if {[argCheck $con "gg::Connector"]} {
    set c1_p1 [gg::conGetPt $con -arc 0.0]
    set c1_p2 [gg::conGetPt $con -arc 1.0]
    set adjCons ""
    set end1Cons ""
    set end2Cons ""
    set cons [gg::conGetAll]
    foreach con2 $cons {
      if {$con2 == $con} {
        continue
      }
      set c2_p1 [gg::conGetPt $con2 -arc 0.0]
      set c2_p2 [gg::conGetPt $con2 -arc 1.0]

      set tol [gg::tolNode]
      if {$tol > [ggu::vec3Length [ggu::vec3Sub $c1_p2 $c2_p1]]} {
        #-- cons join at c1_p2 and c2_p1
        lappend end2Cons $con2
      } elseif {$tol > [ggu::vec3Length [ggu::vec3Sub $c2_p2 $c1_p1]]} {
        #-- cons join at c1_p1 and c2_p2
        lappend end1Cons $con2
      } elseif {$tol > [ggu::vec3Length [ggu::vec3Sub $c1_p1 $c2_p1]]} {
        #-- cons join at c1_p1 and c2_p1
        lappend end1Cons $con2
      } elseif {$tol > [ggu::vec3Length [ggu::vec3Sub $c2_p2 $c1_p2]]} {
        #-- cons join at c2_p2 and c1_p2
        lappend end2Cons $con2
      } else {
        #-- cons not adjacent
      }
    }

    set adjCons [concat $end1Cons $end2Cons]
    return $adjCons
  } else {
    return -code error [getErrorMsg "ConFindAllAdjacent"]
  }
}

###############################################################
#-- PROC: ConGetAll
#--
#-- Get a list of all connectors.
#--
###############################################################

proc ConGetAll { } {
  return [gg::conGetAll]
}

###############################################################
#-- PROC: ConGetBeginSpacing
#--
#-- Get the connector's begin spacing.
#--
###############################################################
proc ConGetBeginSpacing { con } {
  if {[argCheck $con "gg::Connector"]} {
    set a [gg::conGetPt $con 1]
    set b [gg::conGetPt $con 2]
    set spc [ggu::vec3Length [ggu::vec3Sub $a $b]]
    return $spc
  } else {
    return -code error [getErrorMsg "ConGetBeginSpacing"]
  }
}

###############################################################
#-- PROC: ConGetDimension
#--
#-- Get a con's dimension.
#--
###############################################################
proc ConGetDimension { con } {
  if {[argCheck $con "gg::Connector"]} {
    gg::conDim $con
  } else {
    return -code error [getErrorMsg "ConGetDimension"]
  }
}

###############################################################
#-- PROC: ConGetEndSpacing
#--
#-- Get the connector's end spacing.
#--
###############################################################
proc ConGetEndSpacing {con} {
  if {[argCheck $con "gg::Connector"]} {
    set dim [gg::conDim $con]
    set a [gg::conGetPt $con $dim]
    set b [gg::conGetPt $con [expr $dim-1]]
    set spc [ggu::vec3Length [ggu::vec3Sub $a $b]]
    return $spc
  } else {
    return -code error [getErrorMsg "ConGetEndSpacing"]
  }
}

###############################################################
#-- PROC: ConGetLength
#--
#-- Determines length of a connector.
#--
###############################################################
proc ConGetLength { con } {
  if {[argCheck $con "gg::Connector"]} {
    gg::conGetLength $con
  } else {
    return -code error [getErrorMsg "ConGetLength"]
  }
}

###############################################################
#-- PROC: ConGetNodeTolerance
#--
#-- Returns the node tolerance.
#--
###############################################################
proc ConGetNodeTolerance { } {
  set tol [gg::tolNode]
  return $tol
}

###############################################################
#-- PROC: ConGetXYZatU
#--
#-- Determines the x,y,z coordinates on a connector at
#-- specified U coordinate.
#--
###############################################################
proc ConGetXYZatU { con_id arc_length } {
  if {[argCheck $con_id "gg::Connector"] && \
      [argCheck $arc_length "float" 0 1 1 1]} {
#  if { $arc_length < 0.0 || $arc_length > 1.0 } {
#     puts "GetXYZPoint: Invalid arc length $s"
#     return -1
#  }
    gg::conGetPt $con_id -arc $arc_length
  } else {
    return -code error [getErrorMsg "ConGetXYZatU"]
  }
}

###############################################################
#-- PROC: ConJoin2
#--
#-- Join two connectors.
#--
###############################################################
proc ConJoin2 { con1 con2 } {
  if {[argCheck $con1 "gg::Connector"] && \
      [argCheck $con2 "gg::Connector"]} {
    gg::conJoin $con1 $con2
	return $con1
  } else {
    return -code error [getErrorMsg "ConJoin2"]
  }
}

###############################################################
#-- PROC: ConJoinMultiple
#--
#-- Join multiple connectors.
#--
###############################################################
proc ConJoinMultiple { conList } {
  foreach con $conList {
    if {![argCheck $con "gg::Connector"]} {
      return -code error [getErrorMsg "ConJoinMultiple"]
    }
  }
  set numCons [llength $conList ]
  set con_1   [lindex $conList 0]
  set i       $numCons
  set nIter   0

  while {[llength $conList] > 1} {
    if {$nIter > [expr $numCons*$numCons]} {
      break
    }
    if [catch {gg::conJoin $con_1 [lindex $conList [expr $i-1]]} con_1] {
      set con_1 [lindex $conList 0]
      set i [expr $i-1]
      incr nIter
      continue
    } else {
      set conList [lreplace $conList [expr $i-1] [expr $i-1]]
      set i [llength $conList]
    }
  }
  return $con_1
}

###############################################################
#-- PROC: ConMatchEndpoints
#--
#-- Returns the connector matching the given endpoints.
#-- Returns con id if match found, -1 otherwise.
#--
###############################################################
proc ConMatchEndpoints { pt1 pt2 {cons 0} } {
  if {[argCheck $pt1 "vector3"] && \
      [argCheck $pt2 "vector3"]} {
    if {0 == $cons} {
      set cons [gg::conGetAll]
    } else {
      foreach cn $cons {
        if {![argCheck $cn "gg::Connector"]} {
          return -code error [getErrorMsg "ConMatchEndPoints"]
        }
      }
    }
    set ncons [llength $cons]
    for {set i 0} {$i < $ncons} {incr i} {
      set con [lindex $cons $i]
      set con_pt1 [gg::conGetPt $con -arc 0.0]
      set con_pt2 [gg::conGetPt $con -arc 1.0]

      if { [ConPointsAreEqual $con_pt1 $pt1] } {
        if { [ConPointsAreEqual $con_pt2 $pt2] } {
          #-- Both points match - we have our con
          return $con
        }
      } elseif { [ConPointsAreEqual $con_pt2 $pt1] } {
        if { [ConPointsAreEqual $con_pt1 $pt2] } {
          #-- Both points match - we have our con
          return $con
        }
      }
    }
    #-- No matching con
    return -1
  } else {
    return -code error [getErrorMsg "ConMatchEndpoints"]
  }
}

###############################################################
#-- PROC: ConPointsAreEqual
#--
#-- Determines if two points are within the grid point tolerance.
#--
###############################################################
proc ConPointsAreEqual { pt1 pt2 } {
  if {[argCheck $pt1 "vector3"] && \
      [argCheck $pt2 "vector3"]} {
    set tol [gg::tolGP]
    foreach x0 $pt1 x1 $pt2 {
      set diff [expr {abs($x0-$x1)}]
      if { $diff > $tol } { return 0 }
    }
    #-- The points match
    return 1
  } else {
    return -code error [getErrorMsg "ConPointsAreEqual"]
  }
}

###############################################################
#-- PROC: ConProjectClosestPoint
#--
#-- Project connector onto database surface.
#--
###############################################################
proc ConProjectClosestPoint { con dbEnts {interior 0} } {
  if {[argCheck $con "gg::Connector"] && \
      [argCheck $interior "boolean"]} {
    foreach db $dbEnts {
      if {![argCheck $db "gg::DatabaseEntity"]} {
        return -code error [getErrorMsg "ConProjectClosestPoint"]
      }
    }

    set allEnDbs  [gg::dbGetAll -enabled]
    set allDisDbs [gg::dbGetAll -disabled]

    if {[llength $allEnDbs] != 0} {
      gg::dbEnable $allEnDbs FALSE
    }
    if {[llength $dbEnts] != 0} {
      gg::dbEnable $dbEnts TRUE
    } else {
      puts "Database entity list is empty"
      return -code error [getErrorMsg "ConProjectClosestPoint"]
    }

    if {$interior == 0} {
      gg::conProject $con -type CLOSEST_PT -maintain_linkage
    } else {
      gg::conProject $con -type CLOSEST_PT -interior_only -maintain_linkage
    }

    if {[llength $allEnDbs] != 0} {
      gg::dbEnable $allEnDbs TRUE
    }
    if {[llength $allDisDbs] != 0} {
      gg::dbEnable $allDisDbs FALSE
    }

  } else {
    return -code error [getErrorMsg "ConProjectClosestPoint"]
  }
}

###############################################################
#-- PROC: ConSetBeginSpacing
#--
#-- Set the connector's beginning spacing.
#--
###############################################################
proc ConSetBeginSpacing { con spacing } {
  if {[argCheck $con "gg::Connector"] && \
      [argCheck $spacing "float" 0 1]} {
    gg::conBeginSpacing $con $spacing
  } else {
    return -code error [getErrorMsg "ConSetBeginSpacing"]
  }
}

###############################################################
#-- PROC: ConSetDefaultDimension
#--
#-- Set default connector dimension and spacing.
#--
###############################################################
proc ConSetDefaultDimension { dim beg end } {
  if {[argCheck $dim "integer" 0 1] && \
      [argCheck $beg "float" 0 0] && \
      [argCheck $end "float" 0 0]} {
    gg::defConDim     $dim
    gg::defConDistBeg $beg
    gg::defConDistEnd $end
  } else {
    return -code error [getErrorMsg "ConSetDefaultDimension"]
  }
}

###############################################################
#-- PROC: ConSetDimension
#--
#-- Set a con's dimension.
#--
###############################################################
proc ConSetDimension { con dim } {
  if {[argCheck $con "gg::Connector"] && \
      [argCheck $dim "integer" 2 1]} {
    gg::conDim $con $dim
  } else {
    return -code error [getErrorMsg "ConSetDimension"]
  }
}

###############################################################
#-- PROC: ConSetEndSpacing
#--
#-- Set the connector's end spacing.
#--
###############################################################
proc ConSetEndSpacing { con spacing } {
  if {[argCheck $con "gg::Connector"] && \
      [argCheck $spacing "float" 0 1]} {
    gg::conEndSpacing $con $spacing
  } else {
    return -code error [getErrorMsg "ConSetEndSpacing"]
  }
}

###############################################################
#-- PROC: ConSetSpacingEqual
#--
#-- Set connector's spacing equal.
#--
###############################################################
proc ConSetSpacingEqual { con } {
  if {[argCheck $con "gg::Connector"]} {
    gg::conDistFunc $con -function TANH
    gg::conBeginSpacing $con 0.0
    gg::conEndSpacing $con 0.0
  } else {
    return -code error [getErrorMsg "ConSetSpacingEqual"]
  }
}

###############################################################
#-- PROC: ConSplit
#--
#-- Split connector at coordinate.
#--
###############################################################
proc ConSplit { con val const } {
  if {[argCheck $con "gg::Connector"]} {
    if {$const == "X"} {
      if {![argCheck $val "float"]} {
        return -code error [getErrorMsg "ConSplit"]
      }
      set param [gg::conGetPt $con -x $val]
    } elseif {$const == "Y"} {
      if {![argCheck $val "float"]} {
        return -code error [getErrorMsg "ConSplit"]
      }
      set param [gg::conGetPt $con -y $val]
    } elseif {$const == "Z"} {
      if {![argCheck $val "float"]} {
        return -code error [getErrorMsg "ConSplit"]
      }
      set param [gg::conGetPt $con -z $val]
    } elseif {$const == "XYZ"} {
      if {![argCheck $val "vector3"]} {
        return -code error [getErrorMsg "ConSplit"]
      }
      set param $val
    } else {
      printDetails $const "< X | Y | Z | XYZ >"
      return -code error [getErrorMsg "ConSplit"]
    }
    gg::conSplit $con $param
  } else {
    return -code error [getErrorMsg "ConSplit"]
  }
}

###############################################################
#-- PROC: ConCreateEdge
#--
#-- Create an edge from a list of connectors
#--
###############################################################
proc ConCreateEdge { conList } {
  # Since a GG edge is a list of connectors, this function
  # basically does nothing.
  foreach con $conList {
    if {![argCheck $con "gg::Connector"]} {
      return -code error [getErrorMsg "ConCreateEdge"]
    }
  }
  return $conList
}

###############################################################
#-- PROC: ConEdgeFromPoints
#--
#-- Create a piecewise linear edge from a list of points.
#--
###############################################################
proc ConEdgeFromPoints { ptList } {
  set n [llength $ptList]
  if {$n < 2} {
    puts "At least two points are required."
    return -code error [getErrorMsg "ConEdgeFromPoints"]
  }
  foreach pt $ptList {
    if {![argCheck $pt "vector3"]} {
      return -code error [getErrorMsg "ConEdgeFromPoints"]
    }
  }
  set pCurr [lindex $ptList 0]

  # A GG edge is a list of connectors.
  set edge [list]
    for {set k 1} {$k < $n} {incr k} {
      set pNext [lindex $ptList $k]
      lappend edge [gul::ConFrom2Points $pCurr $pNext]
      set pCurr $pNext
    }
  return $edge
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


