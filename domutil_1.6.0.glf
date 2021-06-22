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
#--  Define some useful domain commands
#--
##########################################################################


##########################################################################
#--
#-- GRIDGEN DOMAIN COMMANDS
#--
##########################################################################

namespace eval gul {

###############################################################
#-- PROC: DomDelete
#--
#-- Delete domains with an option of special delete specified.
#-- The argument option is a string.
#--
###############################################################
proc DomDelete { DomList option } {
  foreach dom $DomList {
    if {![argCheck $dom "gg::Domain"]} {
      return -code error [getErrorMsg "DomDelete"]
    }
  }
  if { $option == "SPECIAL" } {
    gg::domDelete $DomList -cons
  } else {
    gg::domDelete $DomList
  }
}


###############################################################
#-- PROC: DomGetPt
#--
#-- Get XYZ coordinates of a domain point.
#-- The index argument ind is a ij list for structured domains
#-- and point index for unstructured domains.
###############################################################
proc DomGetPt { dom ind } {
  if {![argCheck $dom "gg::Domain"]} {
    return -code error [getErrorMsg "DomGetPt"]
  } else {
    gg::domReport $dom diag
    set type $diag(type)
    if { $type != "STRUCTURED" && $type != "UNSTRUCTURED"} {
      return -code error [getErrorMsg "DomGetPt"]
    } else {
      if { [catch {set ptXYZ [gg::domGetPt $dom $ind]} eid] } {
        return -code error [getErrorMsg "DomGetPt"]
      } else {
        return $ptXYZ
      }
    }
  }
}

###############################################################
#-- PROC: DomCreateSub
#--
#-- Create sub-domains in a domain.
#--
###############################################################
proc DomCreateSub { dom ijMin ijMax } {
  if {![argCheck $dom "gg::DomainStructured"]} {
    return -code error [getErrorMsg "DomCreateSub"]
  } else {
    set subDom [gg::domAddSub $dom $ijMin $ijMax]
    return $subDom
  }
}

###############################################################
#-- PROC: DomGetSubs
#--
#-- Get a list of sub-domains in a domain.
#--
###############################################################
proc DomGetSubs { dom } {
  if {![argCheck $dom "gg::DomainStructured"]} {
    return -code error [getErrorMsg "DomGetSubs"]
  } else {
    set subDomList [gg::domGetSubs $dom]
    return $subDomList
  }
}

###############################################################
#-- PROC: DomOnDbEntities
#--
#-- Get a list of domains created on a list of db entities.
#--
###############################################################
proc DomOnDbEntities { dbList domType splitAng joinAng } {
  if { $domType != "STRUCTURED" && $domType != "UNSTRUCTURED" } {
    return -code error [getErrorMsg "DomOnDbEntities"]
  } else {
    if [catch {
      set domList [gg::domOnDBEnt $dbList -join_angle $joinAng -join_cons \
         -split_cons $splitAng -type $domType]
    } eid] {
      return -code error [getErrorMsg "DomOnDbEntities"]
    } else {
      return $domList
      exit 1
    }
  }
}

###############################################################
#-- PROC: DomPeriodicRot
#--
#-- Create domains as a periodic rotation of existing domains.
#--
###############################################################
proc DomPeriodicRot { domList axisPt1 axisPt2 rotAngle } {
  if {[argCheck $axisPt1 "vector3"] && \
      [argCheck $axisPt2 "vector3"] } {
    foreach dom $domList {
      if {![argCheck $dom "gg::Domain"]} {
        return -code error [getErrorMsg "DomPeriodicRot"]
      }
    }
    if [catch {
      set periodicDomList [gg::domPeriodicRot $domList $axisPt1 $axisPt2 $rotAngle]
    } eid] {
      return -code error [getErrorMsg "DomPeriodicRot"]
    } else {
      return $periodicDomList
    }
  } else {
    return -code error [getErrorMsg "DomPeriodicRot"]
  }
}

###############################################################
#-- PROC: DomPeriodicTrans
#--
#-- Create domains as a periodic translation of existing domains.
#--
###############################################################
proc DomPeriodicTrans { domList offset } {
  foreach dom $domList {
    if {![argCheck $dom "gg::Domain"]} {
      return -code error [getErrorMsg "DomPeriodicTrans"]
    }
  }
  if {[argCheck $offset "vector3"] } {
    if [catch {
      set periodicDomList [gg::domPeriodicTrans $domList $offset]
    } eid] {
      return -code error [getErrorMsg "DomPeriodicTrans"]
    } else {
      return $periodicDomList
    }
  } else {
    return -code error [getErrorMsg "DomPeriodicTrans"]
  }
}


###############################################################
#-- PROC: DomStr4Connectors
#--
#-- Create a STRUCTURED domain from 4 connectors.
#-- Returns the new domain's id.
#--
###############################################################
proc DomStr4Connectors { c1 c2 c3 c4 } {
  if {[argCheck $c1 "gg::Connector"] && \
      [argCheck $c2 "gg::Connector"] && \
      [argCheck $c3 "gg::Connector"] && \
      [argCheck $c4 "gg::Connector"]} {
    gg::domBegin -type STRUCTURED
    gg::edgeBegin
    gg::edgeAddCon $c1
    gg::edgeEnd
    gg::edgeBegin
    gg::edgeAddCon $c2
    gg::edgeEnd
    gg::edgeBegin
    gg::edgeAddCon $c3
    gg::edgeEnd
    gg::edgeBegin
    gg::edgeAddCon $c4
    gg::edgeEnd
    return [gg::domEnd]
  } else {
    return -code error [getErrorMsg "DomStr4Connectors"]
  }
}

###############################################################
#-- PROC: DomStr4Points
#--
#-- Create a STRUCTURED domain from 4 points.
#-- Returns the new domain object.
#--
###############################################################
proc DomStr4Points { p1 p2 p3 p4 } {
  if {[argCheck $p1 "vector3"] && \
      [argCheck $p2 "vector3"] && \
      [argCheck $p3 "vector3"] && \
      [argCheck $p4 "vector3"]} {

    set ptList [list $p1 $p2 $p3 $p4 $p1]
    set conList [list]
    set pCurr $p1

    # Create necessary connectors, outside domain mode
    for {set k 1} {$k < 5} {incr k} {
      set pNext [lindex $ptList $k]
      set conExists [gul::ConMatchEndpoints $pCurr $pNext [gg::conGetAll]]
      if {-1 == $conExists} {
        lappend conList [gul::ConFrom2Points $pCurr $pNext]
      } else {
        lappend conList $conExists
      }

      set pCurr $pNext
    }

    gg::domBegin -type STRUCTURED

    foreach con $conList {
      gg::edgeBegin
      gg::edgeAddCon $con
      gg::edgeEnd
    }
    return [gg::domEnd]
  }
  return -code error [getErrorMsg "DomStr4Points"]
}

###############################################################
#-- PROC: DomUnsConnectors
#--
#-- Create an UNSTRUCTURED domain from a list of connectors.
#-- Returns the new domain object.
#--
###############################################################
proc DomUnsConnectors { conList } {
  gg::domBegin -type UNSTRUCTURED
  gg::edgeBegin
  foreach con $conList {
    if {![argCheck $con "gg::Connector"]} {
      return -code error [getErrorMsg "DomUnsConnectors"]
    }
    gg::edgeAddCon $con
  }
  gg::edgeEnd

  return [gg::domEnd]
}

###############################################################
#-- PROC: DomUnsPoints
#--
#-- Create an UNSTRUCTURED domain from a list of
#-- points. Returns the new domain object.
#--
###############################################################
proc DomUnsPoints { ptList } {

  # Guarantee that the point list forms a closed curve by
  # appending the first point to the end of the list if it
  # is not there already.
  set pCurr [lindex $ptList 0]

  if {![string equal $pCurr [lindex $ptList end]]} {
    lappend ptList [lindex $ptList 0]
    puts "DomUnsPoints - First point appended to end of list for a closed curve"
  }
  set n [llength $ptList]
  if {$n < 4} {
    puts "The point list must contain at least 4 points"
    return -code error [getErrorMsg "DomUnsPoints"]
  }

  for {set k 1} {$k < [expr {$n - 1}]} {incr k} {
    set pNext [lindex $ptList $k]
    if {![argCheck $pNext "vector3"]} {
      return -code error [getErrorMsg "DomUnsPoints"]
    }
    if {$k != [lsearch -exact $ptList $pNext]} {
      puts "A duplicate point was found: $pNext"
      return -code error [getErrorMsg "DomUnsPoints"]
    }
  }

  # Create all necessary connectors
  # pCurr is still set to the first point
  set conList [list]
  for {set k 1} {$k < $n} {incr k} {
    set pNext [lindex $ptList $k]
    set conExists [gul::ConMatchEndpoints $pCurr $pNext [gg::conGetAll]]
    if {-1 == $conExists} {
      lappend conList [gul::ConFrom2Points $pCurr $pNext]
    } else {
      # now conExists is a connector
      lappend conList $conExists
    }

    set pCurr $pNext
  }

  gg::domBegin -type UNSTRUCTURED
  gg::edgeBegin
  foreach con $conList {
    gg::edgeAddCon $con
  }
  gg::edgeEnd
  return [gg::domEnd]
}

###############################################################
#-- PROC: DomStr4Edges
#--
#-- Create a STRUCTURED domain from 4 edge lists.
#-- Returns the new domain's id.
#--
###############################################################
proc DomStr4Edges { e1 e2 e3 e4 } {
  if {[argCheck $e1 "gg::Edge"] && \
      [argCheck $e2 "gg::Edge"] && \
      [argCheck $e3 "gg::Edge"] && \
      [argCheck $e4 "gg::Edge"]} {
    gg::domBegin -type STRUCTURED
    for {set i 1} {$i <= 4} {incr i} {
      set edge [set e$i]
      gg::edgeBegin
        foreach con $edge {
          gg::edgeAddCon $con
        }
      gg::edgeEnd
    }
    return [gg::domEnd]
  } else {
    return -code error [getErrorMsg "DomStr4Edges"]
  }
}

###############################################################
#-- PROC: DomUnsEdges
#--
#-- Create an UNSTRUCTURED domain from a list of edges.
#-- Returns the new domain object.
#--
###############################################################
proc DomUnsEdges { edgeList } {
  foreach e $edgeList {
    if {![argCheck $e "gg::Edge"]} {
      return -code error [getErrorMsg "DomUnsEdges"]
    }
  }
  gg::domBegin -type UNSTRUCTURED
  gg::edgeBegin
  foreach edge $edgeList {
      foreach con $edge {
        gg::edgeAddCon $con
      }
  }
  gg::edgeEnd
  return [gg::domEnd]
  return -code error [getErrorMsg "DomUnsEdges"]
}

###############################################################
#-- PROC: DomChangeDisplay
#--
#-- Change the display style of a list of domains.
#--
###############################################################
proc DomChangeDisplay { domList style {color 1} } {
  foreach dom $domList {
    if {![argCheck $dom "gg::Domain"]} {
      return -code error [getErrorMsg "DomChangeDisplay"]
    }
  }
  if {![string equal $style "WIREFRAME"] && \
      ![string equal $style "OFF"]} {
    printDetails $style "< WIREFRAME | OFF >"
    return -code error [getErrorMsg "DomChangeDisplay"]
  }
  if {[argCheck $color "integer" 0 1 6 1]} {
    if {$style == "WIREFRAME"} {
      #set color [expr $color % 7]
      gg::domDisp $domList -linecolor $color -style WIREFRAME
    } elseif {$style == "OFF"} {
      gg::domDisp $domList -style OFF
    }
  } else {
    return -code error [getErrorMsg "DomChangeDisplay"]
  }
}

###############################################################
#-- PROC: DomEllipticSolve
#--
#-- Run the elliptic solver on a domain.
#--
###############################################################
proc DomEllipticSolve { domList {iterations 10} } {
  foreach dom $domList {
    if {![argCheck $dom "gg::Domain"]} {
      return -code error [getErrorMsg "DomEllipticSolve"]
    }
  }
  if {[argCheck $iterations "integer" 0 0]} {
    gg::domEllSolverBegin $domList
    foreach dom $domList {
      gg::domEllSolverAtt $dom -fg_control SORENSON
      gg::domEllSolverAtt $dom -angle_calc INTERPOLATE
    }
    gg::domEllSolverStep -iterations $iterations -nodisplay
    gg::domEllSolverEnd
  } else {
    return -code error [getErrorMsg "DomEllipticSolve"]
  }
}

###############################################################
#-- PROC: DomExtrudeNormal
#--
#-- Extrude domain from list of connectors.
#--
###############################################################
proc DomExtrudeNormal { conList initDs cellGr blDist volSmth vec1 vec2 \
    {constAxis 0} {constBegin 0} {constEnd 0} {symAxis 0} {symBegin 0} {symEnd 0} } {
  foreach con $conList {
    if {![argCheck $con "gg::Connector"]} {
      return -code error [getErrorMsg "DomExtrudeNormal"]
    }
  }
  if {[argCheck $initDs "float" 0 0] && \
      [argCheck $cellGr "float" 0 0] && \
      [argCheck $blDist "integer" 0 1] && \
      [argCheck $volSmth "float" 0 1 1 1] && \
      [argCheck $vec1 "vector3"] && \
      [argCheck $vec2 "vector3"] && \
      [argCheck $constBegin "boolean"] && \
      [argCheck $constEnd "boolean"] && \
      [argCheck $symBegin "boolean"] && \
      [argCheck $symEnd "boolean"]} {

    set crossProd     [ggu::vec3Cross $vec1 $vec2]
    set normCrossProd [ggu::vec3Normalize $crossProd]
    if {$constAxis!=0} {
      if {![argCheck $constAxis "axis" 0]} {
        return -code error [getErrorMsg "DomExtrudeNormal"]
      }
      set constBC $constAxis
    }
    if {$symAxis!=0} {
      if {![argCheck $symAxis "axis" 0]} {
        return -code error [getErrorMsg "DomExtrudeNormal"]
      }
      set axis $symAxis
      if { $axis == "X" } {
        set axisVec "1 0 0"
      } elseif { $axis == "Y" } {
        set axisVec "0 1 0"
      } elseif { $axis == "Z" } {
        set axisVec "0 0 1"
      }
      set symVec [ggu::vec3Cross $normCrossProd $axisVec]
      if {[expr round(abs([lindex $symVec 0]))] == 1} {
        set symBC "X"
      } elseif {[expr round(abs([lindex $symVec 1]))] == 1} {
        set symBC "Y"
      } elseif {[expr round(abs([lindex $symVec 2]))] == 1} {
        set symBC "Z"
      }
    }
    gg::domExtrusionBegin $conList -edge -default HYPERBOLIC
    gg::domExtrusionAtt -local 1 -march_plane $normCrossProd
    gg::domExtrusionAtt -local 1 -s_init $initDs
    gg::domExtrusionAtt -local 1 -growth_geometric $cellGr
    gg::domExtrusionAtt -local 1 -kb_smoothing 0.0
    gg::domExtrusionAtt -local 1 -vol_smoothing $volSmth
    if {$constBegin==1} {
      gg::domExtrusionAtt -local 1 -start_constant $constBC
    }
    if {$constEnd==1} {
      gg::domExtrusionAtt -local 1 -end_constant $constBC
    }
    if {$symBegin==1} {
      gg::domExtrusionAtt -local 1 -start_symmetry $symBC
    }
    if {$symEnd==1} {
      gg::domExtrusionAtt -local 1 -end_symmetry $symBC
    }
    gg::domExtrusionStep $blDist
    return [gg::domExtrusionEnd]
  } else {
    return -code error [getErrorMsg "DomExtrudeNormal"]
  }
}

###############################################################
#-- PROC: DomGetAll
#--
#-- Return all domains in the grid.
#--
###############################################################
proc DomGetAll { } {
   return [gg::domGetAll]
}

###############################################################
#-- PROC: DomGetEdgeConnectors
#--
#-- Return a list of cons making up a domain's edge.
#--
###############################################################
proc DomGetEdgeConnectors { dom edgeNum }  {
  if {[argCheck $dom "gg::Domain"] && \
      [argCheck $edgeNum "integer" 0 0]} {
    set edgeList [gg::domGetEdge $dom $edgeNum]
    set edgeCons [lindex $edgeList 0]
    return $edgeCons
  } else {
    return -code error [getErrorMsg "DomGetEdgeConnectors"]
  }
}

###############################################################
#-- PROC: DomInitialize
#--
#-- Initialize a list of domains.
#--
###############################################################
proc DomInitialize { domList } {
  foreach dom $domList {
    if {![argCheck $dom "gg::Domain"]} {
      return -code error [getErrorMsg "DomInitialize"]
    }
  }
  foreach dom $domList {
    gg::domReport $dom data STRUCTURE
    if {$data(type) == "STRUCTURED"} {
      gg::domTFISolverRun $domList
    } else {
      gg::domUnsSolverBegin $dom
        gg::domUnsSolverInit
      gg::domUnsSolverEnd
    }
  }


}

###############################################################
#-- PROC: DomJoin
#--
#-- Join a list of domains.
#--
###############################################################
proc DomJoin { domList } {
  foreach dom $domList {
    if {![argCheck $dom "gg::Domain"]} {
      return -code error [getErrorMsg "DomJoin"]
    }
  }
  set startDom [lindex $domList 0]
  set domList [lreplace $domList 0 0]
  gg::domJoinBegin $startDom
  foreach dom $domList {
    gg::domJoinAddDom $dom
  }
  gg::domJoinEnd
}

###############################################################
#-- PROC: DomLinearProjection
#--
#-- Linear projection of a domain.
#--
###############################################################
proc DomLinearProjection { dom db axis } {
  if {[argCheck $dom "gg::Domain"] && \
      [argCheck $db "gg::DatabaseEntity"] && \
      [argCheck $axis "axis"]} {
    if {$axis == "X"} {
      set axisVec "1 0 0"
    } elseif {$axis == "-X"} {
      set axisVec "-1 0 0"
    } elseif {$axis == "Y"} {
      set axisVec "0 1 0"
    } elseif {$axis == "-Y"} {
      set axisVec "0 -1 0"
    } elseif {$axis == "Z"} {
      set axisVec "0 0 1"
    } elseif {$axis == "-Z"} {
      set axisVec "0 0 -1"
    }
    gg::domProject $dom -type LINEAR -dir $axisVec -db $db -maintain_linkage
  } else {
    return -code error [getErrorMsg "DomLinearProjection"]
  }
}

###############################################################
#-- PROC: DomNewTRexCondition
#--
#-- Create and apply a T-Rex condition to a set of connectors
#--
###############################################################
proc DomNewTRexCondition { domain cons type {name 0} {attributes 0} } {

  if {![argCheck $domain gg::Domain]} {
    return -code error [getErrorMsg "DomNewTRexCondition"]
  }
  foreach con $cons {
    if {![argCheck $con "gg::Connector"]} {
      return -code error [getErrorMsg "DomNewTRexCondition"]
    }
  }

  set pwTypes [list "Off" "AdjacentGrid" "Wall" "Match"]
  set ggTypes [list "OFF" "DEFAULT"]
  set ggindex [lsearch -exact $ggTypes $type]
  set pwindex [lsearch -exact $pwTypes $type]

  set actualType $type
  if {$pwindex < 2 && -1 != $pwindex} {
    set actualType [lindex $ggTypes $pwindex]
  } elseif {2 == $pwindex} {
    # A default wall spacing value. This should be overridden by an attribute
    # or function that sets the spacing, i.e. aniso_delta_s or DomSetTRexSpacing
    set actualType 0.1
  } elseif {-1 != $ggindex || [argCheck $type "float" 0 0]} {
    set actualType $type
  } else {
    puts "Invalid boundary condition type - $type"
    puts "Condition type must be one of: "
    puts "Pointwise:  $pwTypes"
    puts "Gridgen:    $ggTypes"
    return -code error [getErrorMsg "DomNewTRexCondition"]
  }
  gg::domUnsSolverBegin $domain
    gg::domUnsSolverAtt $domain -aniso_delta_s $cons $actualType
  gg::domUnsSolverEnd
  if {0 != $attributes} {
    DomSetUnsSolverAttrs $domain $attributes
  }

  return 0
}

###############################################################
#-- PROC: DomSetUnsSolverAttrs
#--
#-- Set unstructured solver attributes for a target domain.
#--
###############################################################
proc DomSetUnsSolverAttrs { domain attributes } {
  if {![argCheck $domain gg::Domain]} {
    return -code error [getErrorMsg "DomSetUnsSolverAttrs"]
  }

  set ggAttrs [list shape projection relax boundary_decay max_edge min_edge \
      angle_deviation deviation aniso_layers aniso_layers_start_modify \
      aniso_growth_rate aniso_delta_s_smooth_iters \
      aniso_delta_s_smooth_relax aniso_delta_s db min_size max_size]

  set pwAttrs [list ShapeConstraint ShapeProjection RelaxationFactor \
      BoundaryDecay EdgeMaximumLength EdgeMinimumLength NormalMaximumDeviation \
      SurfaceMaximumDeviation TRexMaximumLayers TRexFullLayers TRexGrowthRate \
      TRexSpacingSmoothing TRexSpacingRelaxationFactor]

  set n [llength $attributes]
  for {set k 0} {$k < $n} {incr k} {
    set att [lindex $attributes $k]
    set val [lindex $attributes [incr k]]

    if {$k > $n} {
      puts "An attribute does not have any corresponding values."
      return -code error [getErrorMsg "DomSetUnsSolverAttrs"]
    }

    gg::domUnsSolverBegin $domain
    if {"aniso_delta_s" == $att} {
      set type [lindex $attributes [incr k]]
      gg::domUnsSolverAtt $domain -aniso_delta_s $val $type
    } elseif {-1 != [lsearch -exact $ggAttrs $att]} {
      gg::domUnsSolverAtt $domain -$att $val
    } else {
      set pwindex [lsearch -exact $pwAttrs $att]
      if {-1 != $pwindex} {
        set att [lindex $ggAttrs $pwindex]
        gg::domUnsSolverAtt $domain -$att $val
      } else {
        puts "Invalid attribute - $att"
        puts "Attribute must be one of: "
        puts "Gridgen:    $ggAttrs"
        puts "Pointwise:  $pwAttrs"
        puts "This attribute may have no analog in Gridgen. Skipping..."
      }
    }
    gg::domUnsSolverEnd
  }
}

###############################################################
#-- PROC: DomSetTRexSpacing
#--
#-- Set T-Rex wall spacing on a set of connectors.
#--
###############################################################
proc DomSetTRexSpacing { domain conList spacing } {
  if {![argCheck $domain "gg::Domain"]} {
    return -code error [getErrorMsg "DomSetTRexSpacing"]
  } elseif {![argCheck $spacing "float" 0 0]} {
    return -code error [getErrorMsg "DomSetTRexSpacing"]
  }
  foreach con $conList {
    if {![argCheck $con "gg::Connector"]} {
      return -code error [getErrorMsg "DomSetTRexSpacing"]
    }
  }

  gg::domUnsSolverBegin $domain
    gg::domUnsSolverAtt $domain -aniso_delta_s $conList $spacing
  gg::domUnsSolverEnd
}

###############################################################
#-- PROC: DomProjectClosestPoint
#--
#-- Closest point projection of a domain.
#--
###############################################################
proc DomProjectClosestPoint { dom dbEnts {interior 0} } {
  if {[argCheck $dom "gg::Domain"] && \
      [argCheck $interior "boolean"]} {
    foreach db $dbEnts {
      if {![argCheck $db "gg::DatabaseEntity"]} {
        return -code error [getErrorMsg "DomProjectClosestPoint"]
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
      puts "The database entity list is empty"
      return -code error [getErrorMsg "DomProjectClosestPoint"]
    }


    if {$interior == 0} {
      gg::domProject $dom -type CLOSEST_PT -maintain_linkage
    } else {
      gg::domProject $dom -type CLOSEST_PT -interior_only -maintain_linkage
    }
    if {[llength $allEnDbs] != 0} {
      gg::dbEnable $allEnDbs TRUE
    }
    if {[llength $allDisDbs] != 0} {
      gg::dbEnable $allDisDbs FALSE
    }

  } else {
    return -code error [getErrorMsg "DomProjectClosestPoint"]
  }
}

###############################################################
#-- PROC: DomRotate
#--
#-- Rotate a list of domains.
#--
###############################################################
proc DomRotate { domList axis angle } {
  foreach dom $domList {
    if {![argCheck $dom "gg::Domain"]} {
      return -code error [getErrorMsg "DomRotate"]
    }
  }
  if {[argCheck $axis "axis" 0] && \
      [argCheck $angle "float" -360 0 360 0]} {
    if {[expr $angle == 0]} {
      printDetails $angle "value != 0"
      return -code error [getErrorMsg "DomRotate"]
    }
    if { $axis == "X" } {
      set axisVec "1 0 0"
    } elseif { $axis == "Y" } {
      set axisVec "0 1 0"
    } elseif { $axis == "Z" } {
      set axisVec "0 0 1"
    }
    gg::domTransformBegin $domList
    gg::xformRotate [list 0 0 0] $axisVec $angle
    gg::domTransformEnd
  } else {
    return -code error [getErrorMsg "DomRotate"]
  }
}

###############################################################
#-- PROC: DomSplit
#--
#-- Split a domain.
#--
###############################################################
proc DomSplit { dom dir index } {
  if {[argCheck $dom "gg::Domain"] && \
      [argCheck $index "integer" 0 0]} {
    if {![string equal $dir "I"] && \
        ![string equal $dir "J"]} {
      printDetails $dir "< I | J >"
      return -code error [getErrorMsg "DomSplit"]
    }
    if {$dir=="I"} {
      return [gg::domSplit $dom -i $index]
    } elseif {$dir=="J"} {
      return [gg::domSplit $dom -j $index]
    }
  } else {
    return -code error [getErrorMsg "DomSplit"]
  }
}

###############################################################
#-- PROC: DomUsage
#--
#-- Return a list of blocks using a domain.
#--
###############################################################
proc DomUsage { dom } {
  if {[argCheck $dom "gg::Domain"]} {
    gg::domReport $dom data REFERENCE
    return $data(refBlocks)
  } else {
    return -code error [getErrorMsg "DomUsage"]
  }
}

###############################################################
#-- PROC: DomCreateFace
#--
#-- Create a face from a list of domains
#--
###############################################################
proc DomCreateFace { domList {structured 0} } {
  # In GG it is not possible to create faces without starting a
  # domain. Therefore the user will only ever create faces when
  # he or she wants to create a domain, in which case the user
  # would use one of the preceding domain creation functions.
  # There is thus no use for this function in Glyph 1, so it
  # returns the domain list with no further action.
  return $domList
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


