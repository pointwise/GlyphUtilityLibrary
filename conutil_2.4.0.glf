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
#-- POINTWISE CONNECTOR COMMANDS
#--
##########################################################################

namespace eval gul {

###############################################################
#-- PROC: ConGetNumSub
#-- Obtain the number of subconnectors of a given connector.
#--
###############################################################
proc ConGetNumSub { con } {
  if {[argCheck $con "pw::Connector"]} {
    set numSub [$con getSubConnectorCount]
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
    if { $topo == "ALL" } {
      set topo "None"
    } elseif { $topo == "FREE" } {
      set topo "NonFree"
    } else {
      set topo "Manifold"
    }
    pw::Grid mergeConnectors -exclude $topo -tolerance $tol
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
      if {![argCheck $con "pw::Connector"]} {
        return -code error [getErrorMsg "ConPeriodicRot"]
      }
    }
    if [catch {
      set creator [pw::Application begin Create]
      set periodicConList [pw::Collection create]
      $periodicConList set $conList
      $periodicConList do createPeriodic -rotate $axisPt1 $axisPt2 $rotAngle
      $creator end
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
  if {[argCheck $offset "vector3"] } {
    foreach con $conList {
      if {![argCheck $con "pw::Connector"]} {
        return -code error [getErrorMsg "ConPeriodicTrans"]
      }
    }
    if [catch {
      set creator [pw::Application begin Create]
      set periodicConList [pw::Collection create]
      $periodicConList set $conList
      $periodicConList do createPeriodic -translate $offset
      $creator end
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
  if {![argCheck $con "pw::Connector"]} {
    return -code error [getErrorMsg "ConAddBreakPt"
  } elseif {$type != "X" && $type != "Y" && $type != "Z" \
            && $type != "ARC" } {
    return -code error [getErrorMsg "ConAddBreakPt"]
  }
  set breakPtList ""
  if { [catch {
    foreach loc $locList {
      if { $type == "X" } {
        $con addBreakPoint -X $loc
      } elseif {$type == "Y"} {
        $con addBreakPoint -Y $loc
      } elseif {$type == "Z"} {
        $con addBreakPoint -Z $loc
      } else {
        $con addBreakPoint -arc $loc
      }
    }
  } eid] } {
    return -code error [getErrorMsg "ConAddBreakPt"]
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
    set con [pw::Connector create]
    set seg [pw::SegmentConic create]
    $seg addPoint $pt1
    $seg addPoint $pt2
    $seg setIntersectPoint  $tan_pt
    $seg setRho $rho
    $con addSegment $seg
    return $con
  } else {
    return -code error [getErrorMsg "ConCreateConic"]
  }
}

###############################################################
#-- PROC: ConDbArcLengths
#--
#-- Create a DB_LINE connector from a DB ID and two arc-lengths.
#-- Returns the new connector's id.
#--
###############################################################
proc ConDbArcLengths { dbEnt s1 s2 } {
  # check
  if {![argCheck $dbEnt "pw::DatabaseEntity"]} {
    return -code error [getErrorMsg "ConDbArcLengths"]
  }
  if { ![argCheck $s1 "float" 0 1 1 0] } {
     return -code error [getErrorMsg "ConDbArcLengths"]
  }
  if { ![argCheck $s2 "float" 0 0 1 1] } {
     return -code error [getErrorMsg "ConDbArcLengths"]
  }
  if {$s1 >= $s2} {
	return -code error [getErrorMsg "ConDbArcLengths"]
  }

  set v_min 0.0

  set seg [pw::SegmentTrim create]
  $seg addPoint [list $s1 $v_min $dbEnt]
  $seg addPoint [list $s2 $v_min $dbEnt]

  set con [pw::Connector create]
  $con addSegment $seg
  $con calculateDimension
  unset seg

  return $con
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
    set _mode [pw::Application begin Create]
    set _seg [pw::SegmentSpline create]
    $_seg addPoint $pt1
    $_seg addPoint $pt2
    set _con [pw::Connector create]
    $_con addSegment $_seg
    unset _seg
    $_con calculateDimension
    $_mode end
    unset _mode
    return $_con
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
      [argCheck $slope_weight "float"]} {
    set con [pw::Connector create]
    set seg [pw::SegmentSpline create]

    set addSlopeControlPts 0
    if {$type == "LINE"} {
      $seg setSlope Linear
    } elseif {$type == "AKIMA"} {
      $seg setSlope Akima
    } elseif {$type == "AKIMA_END_SLOPE_MATCH"} {
      # An Akima curve with end point slope defined by the points
      $seg setSlope Akima
      set addSlopeControlPts 1
    } else {
      # Should I delete $con and $seg?
      printDetails $type "< LINE | AKIMA | AKIMA_END_SLOPE_MATCH >"
      return -code error [getErrorMsg "ConFrom3Points"]
    }

    if {$addSlopeControlPts} {
      set w $slope_weight
      set pt12 [pwu::Vector3 add [pwu::Vector3 scale $pt1 [expr 1.0-$w]] [pwu::Vector3 scale $pt2 $w]]
      set pt23 [pwu::Vector3 add [pwu::Vector3 scale $pt2 $w] [pwu::Vector3 scale $pt3 [expr 1.0-$w]]]
    }

      $seg addPoint $pt1
      if {$addSlopeControlPts} {
  	  $seg addPoint $pt12
  	}
      $seg addPoint $pt2
      if {$addSlopeControlPts} {
  	  $seg addPoint $pt23
  	}
      $seg addPoint $pt3

    $con addSegment $seg

    return $con
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
    if {![argCheck $db "pw::DatabaseEntity"]} {
      return -code error [getErrorMsg "ConOnDbEntities"]
    }
  }
  if {[argCheck $angle "float" 0 1 180 0]} {
    return [pw::Connector createOnDatabase -joinConnectors $angle $dbEnts]
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
  if {[argCheck $db_id "pw::DatabaseEntity"] && \
      [argCheck $uv1 "vector2" 0 1 1 1] && \
      [argCheck $uv2 "vector2" 0 1 1 1]} {

#    if { [llength $uv1] < 2 } {
#      puts "ConOnDbSurf: Must specify UV for both points"
#      return -1
#    }
#    if { [llength $uv2] < 2 } {
#      puts "ConOnDbSurf: Must specify UV for both points"
#      return -1
#    }
#    foreach param $uv1 {
#      if { $param < 0.0 || $param > 1.0 } {
#        puts "ConOnDbSurf: Invalid UV $uv1"
#        return -1
#      }
#    }
#    foreach param $uv2 {
#      if { $param < 0.0 || $param > 1.0 } {
#        puts "ConOnDbSurf: Invalid UV $uv2"
#        return -1
#      }
#    }

    set u_min 0.0
    set u_max 1.0
    set v_min 0.0

    lappend uv1 $db_id
    lappend uv2 $db_id

    set seg [pw::SegmentSurfaceSpline create]
    $seg addPoint $uv1
    $seg addPoint $uv2
    set con [pw::Connector create]
    $con addSegment $seg
    $con calculateDimension
    return $con
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
  if {[argCheck $con "pw::Connector"] && \
      [argCheck $begSpacing "float" 0 1] && \
      [argCheck $endSpacing "float" 0 1]} {
    set conLength [ConGetLength $con]
    set tol [expr [DbGetModelSize]/1e7]
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
    if {![argCheck $con "pw::Connector"]} {
      return -code error [getErrorMsg "ConDelete"]
    }
  }
  pw::Entity delete $conList
}

###############################################################
#-- PROC: ConFindAllAdjacent
#--
#-- Get a list of connectors that are incident on the given connector's end points.
#--
###############################################################

proc ConFindAllAdjacent { con } {
  if {[argCheck $con "pw::Connector"]} {
    return [pw::Connector getAdjacentConnectors $con]
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
  return [pw::Grid getAll -type pw::Connector]
}

###############################################################
#-- PROC: ConGetBeginSpacing
#--
#-- Get the connector's begin spacing.
#--
###############################################################
proc ConGetBeginSpacing { con } {
  if {[argCheck $con "pw::Connector"]} {
    set a [$con getXYZ -grid 1]
    set b [$con getXYZ -grid 2]
    set spc [pwu::Vector3 length [pwu::Vector3 subtract $a $b]]
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
  if {[argCheck $con "pw::Connector"]} {
    $con getDimension
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
proc ConGetEndSpacing { con } {
  if {[argCheck $con "pw::Connector"]} {
    set dim [ConGetDimension $con]
    set a [$con getXYZ -grid $dim]
    set b [$con getXYZ -grid [expr $dim-1]]
    set spc [pwu::Vector3 length [pwu::Vector3 subtract $a $b]]
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
  if {[argCheck $con "pw::Connector"]} {
    $con getTotalLength
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
  set tol [pw::Grid getNodeTolerance]
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
  if {[argCheck $con_id "pw::Connector"] && \
      [argCheck $arc_length "float" 0 1 1 1]} {
#   if { $arc_length < 0.0 || $arc_length > 1.0 } {
#      puts "GetXYZPoint: Invalid arc length $s"
#      return -1
#   }
    $con_id getXYZ -arc $arc_length
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
  if {[argCheck $con1 "pw::Connector"] && \
      [argCheck $con2 "pw::Connector"]} {
    $con1 join -keepDistribution $con2
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
  if {[llength $conList] > 1} {
    foreach con $conList {
      if {![argCheck $con "pw::Connector"]} {
        return -code error [getErrorMsg "ConJoinMultiple"]
      }
    }
    return [pw::Connector join $conList]
  } else {
    return $conList
  }
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
    if { 0 == $cons} {
      set cons [gul::ConGetAll]
    } else {
      foreach cn $cons {
        if {![argCheck $cn "pw::Connector"]} {
          return -code error [getErrorMsg "ConMatchEndpoints"]
        }
      }
    }
    set ncons [llength $cons]
    for {set i 0} {$i < $ncons} {incr i} {
      set con [lindex $cons $i]
      set con_pt1 [$con getXYZ -arc 0.0]
      set con_pt2 [$con getXYZ -arc 1.0]

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
    set tol [pw::Grid getGridPointTolerance]
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
proc ConProjectClosestPoint { con db {interior 0} } {
  if {[argCheck $con "pw::Connector"] && \
      [argCheck $interior "boolean"]} {
    foreach entity $db {
      if {![argCheck $entity "pw::DatabaseEntity"]} {return
        return -code error [getErrorMsg "ConProjectClosestPoint"]
      }
    }
    if {$interior == 0} {
      $con project $db
    } else {
      $con project -interior $db
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
  if {[argCheck $con "pw::Connector"] && \
      [argCheck $spacing "float" 0 1]} {
    set _m [pw::Application begin Modify $con]
    set _d [$con getDistribution 1]
    $_d setBeginSpacing $spacing
    unset _d
    $_m end
    unset _m
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
      [argCheck $beg "float" 0 1] && \
      [argCheck $end "float" 0 1]} {
    if {$dim == 1} {
      printDetails $dim "dimension != 1"
      return -code error [getErrorMsg "ConSetDefaultDimension"]
    }
    pw::Connector setDefault Dimension    $dim
    pw::Connector setDefault BeginSpacing $beg
    pw::Connector setDefault EndSpacing   $end
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
  if {[argCheck $con "pw::Connector"] && \
      [argCheck $dim "integer" 0 1]} {
    if {$dim == 1} {
      printDetails $dim "dimension != 1"
      return -code error [getErrorMsg "ConSetDimension"]
    }
    $con setDimension $dim
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
  if {[argCheck $con "pw::Connector"] && \
      [argCheck $spacing "float" 0 1]} {
    set _m [pw::Application begin Modify $con]
    set _d [$con getDistribution 1]
    $_d setEndSpacing $spacing
    unset _d
    $_m end
    unset _m
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
  if {[argCheck $con "pw::Connector"]} {
    $con setDistribution 1 [pw::DistributionTanh create]
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
  if {[argCheck $con "pw::Connector"]} {
    if {$const == "X"} {
      if {![argCheck $val "float"]} {
        return -code error [getErrorMsg "ConSplit"]
      }
      set param [$con getParameter -X $val]
    } elseif {$const == "Y"} {
      if {![argCheck $val "float"]} {
        return -code error [getErrorMsg "ConSplit"]
      }
      set param [$con getParameter -Y $val]
    } elseif {$const == "Z"} {
      if {![argCheck $val "float"]} {
        return -code error [getErrorMsg "ConSplit"]
      }
      set param [$con getParameter -Z $val]
    } elseif {$const == "XYZ"} {
      if {![argCheck $val "vector3"]} {
        return -code error [getErrorMsg "ConSplit"]
      }
      set param [$con getParameter -closest $val]
    } else {
      printDetails $const "< X | Y | Z | XYZ >"
      return -code error [getErrorMsg "ConSplit"]
    }
    return [lindex [$con split $param] 1]
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
proc ConCreateEdge {conList} {
  foreach con $conList {
    if {![argCheck $con "pw::Connector"]} {
      return -code error [getErrorMsg "ConCreateEdge"]
    }
  }
  set edge [pw::Edge create]
  foreach con $conList {
    $edge addConnector $con
  }
  return $edge
}

###############################################################
#-- PROC: ConEdgeFromPoints
#--
#-- Create an edge from a list of points.
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
  set edge [pw::Edge create]
  set pCurr [lindex $ptList 0]
  for {set k 1} {$k < $n} {incr k} {
    set pNext [lindex $ptList $k]
    $edge addConnector [gul::ConFrom2Points $pCurr $pNext]
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

