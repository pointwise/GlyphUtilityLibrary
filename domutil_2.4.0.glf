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
#-- POINTWISE DOMAIN COMMANDS
#--
##########################################################################

namespace eval gul {

###############################################################
#-- PROC: DomDelete
#--
#-- Delete domains with an option of special delete specified.
#-- Returns nothing.
#--
###############################################################
proc DomDelete { DomList option } {
  foreach dom $DomList {
    if {![argCheck $dom "pw::Domain"]} {
      return -code error [getErrorMsg "DomDelete"]
    }
    if { $option == "SPECIAL" } {
      $dom delete -connectors
    } else {
      $dom delete
    }
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
  if {![argCheck $dom "pw::Domain"]} {
    return -code error [getErrorMsg "DomGetPt"]
  } else {
    if { [catch {set ptXYZ [$dom getXYZ -grid $ind]} eid] } {
       return -code error [getErrorMsg "DomGetPt"]
    } else {
      return $ptXYZ
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
  if {[argCheck $dom "pw::DomainStructured"] && \
      [argCheck $ijMin "vector2"] && \
      [argCheck $ijMax "vector2"] } {
    if { [catch {set subDom [$dom createSubGrid $ijMin $ijMax]} eid] } {
      return -code error [getErrorMsg "DomCreateSub"]
    } else {
      return $subDom
      exit 1
    }
  } else {
    return -code error [getErrorMsg "DomCreateSub"]
  }
}


###############################################################
#-- PROC: DomGetSubs
#--
#-- Get a list of sub-domains in a domain.
#--
###############################################################
proc DomGetSubs { dom } {
  if {![argCheck $dom "pw::DomainStructured"]} {
    return -code error [getErrorMsg "DomGetSubs"]
  } else {
    set subDomNum [$dom getSubGridCount]
    set i 1
    set subDomList ""
    while { $i <= $subDomNum } {
      lappend subDomList [$dom getSubGrid $i]
      incr i
    }
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
  if [catch {
    if { $domType == "STRUCTURED" } {
      set domList [pw::DomainStructured createOnDatabase -splitConnectors $splitAng \
        -joinConnectors $joinAng $dbList]
    } elseif { $domType == "UNSTRUCTURED" } {
      set domList [pw::DomainUnstructured createOnDatabase -splitConnectors $splitAng \
        -joinConnectors $joinAng $dbList]
    }
  } eid] {
    return -code error [getErrorMsg "DomOnDbEntities"]
  } else {
    return $domList
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
      if {![argCheck $dom "pw::Domain"]} {
        return -code error [getErrorMsg "DomPeriodicRot"]
      }
    }
    if [catch {
      set periodicDomList ""
      foreach dom $domList {
        lappend periodicDomList [$dom createPeriodic -rotate $axisPt1 $axisPt2 $rotAngle]
      }
    } eid] {
      return -code error [getErrorMsg "DomPeriodicRot"]
    } else {
      return $periodicDomList
      exit 1
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
  if {[argCheck $offset "vector3"] } {
    foreach dom $domList {
      if {![argCheck $dom "pw::Domain"]} {
        return -code error [getErrorMsg "DomPeriodicTrans"]
      }
    }
    if [catch {
      set periodicDomList ""
      foreach dom $domList {
        lappend periodicDomList [$dom createPeriodic -translate $offset]
      }
    } eid] {
      return -code error [getErrorMsg "DomPeriodicTrans"]
    } else {
      return $periodicDomList
      exit 1
    }
  } else {
    return -code error [getErrorMsg "DomPeriodicTrans"]
  }
}


###############################################################
#-- PROC: DomStr4Connectors
#--
#-- Create a STRUCTURED domain from 4 connectors.
#-- Returns the new domain object.
#--
###############################################################
proc DomStr4Connectors { c1 c2 c3 c4 } {
  if {[argCheck $c1 "pw::Connector"] && \
      [argCheck $c2 "pw::Connector"] && \
      [argCheck $c3 "pw::Connector"] && \
      [argCheck $c4 "pw::Connector"]} {

    set e1 [pw::Edge create]; $e1 addConnector $c1
    set e2 [pw::Edge create]; $e2 addConnector $c2
    set e3 [pw::Edge create]; $e3 addConnector $c3
    set e4 [pw::Edge create]; $e4 addConnector $c4
    set edges [list $e1 $e2 $e3 $e4]

    if {![pw::DomainStructured qualifyEdges $edges]} {
      puts "Edges from selected connectors cannot define a structured domain"
      return -code error [getErrorMsg "DomStr4Edges"]
    }

    set domain [pw::DomainStructured create]
    foreach e $edges {
      $domain addEdge $e
    }
    return $domain
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
    set edgeList [list]
    set pCurr $p1
    for {set k 1} {$k < 5} {incr k} {
      set pNext [lindex $ptList $k]
      set e [pw::Edge create]
      $e addConnector [gul::ConFrom2Points $pCurr $pNext]
      lappend edgeList $e
      set pCurr $pNext
    }
    if {[pw::DomainStructured qualifyEdges $edgeList]} {
      set dom [pw::DomainStructured create]
      foreach e $edgeList {
        $dom addEdge $e
      }
      return $dom
    }
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

  set edge [pw::Edge create]
  foreach con $conList {
    if {![argCheck $con "pw::Connector"]} {
      return -code error [getErrorMsg "DomUnsConnectors"]
    }
    $edge addConnector $con
  }
  if {![pw::DomainUnstructured qualifyEdges $edge]} {
    puts "Edges from selected connectors cannot define an unstructured domain"
    return -code error [getErrorMsg "DomUnsConnectors"]
  }

  set domain [pw::DomainUnstructured create]
  $domain addEdge $edge
  return $domain
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

  # Check that all points except the first and last points are distinct
  for {set k 1} {$k < $n} {incr k} {
    set pNext [lindex $ptList $k]
    if {![argCheck $pNext "vector3"]} {
      return -code error [getErrorMsg "DomUnsPoints"]
    }
    if {-1 != [lsearch -exact -start [expr {$k+1}] $ptList $pNext]} {
      puts "A duplicate point was found: $pNext"
      return -code error [getErrorMsg "DomUnsPoints"]
    }
  }

  set edge [pw::Edge create]

  # pCurr is still set to the first point
  for {set k 1} {$k < $n} {incr k} {
    set pNext [lindex $ptList $k]
    $edge addConnector [gul::ConFrom2Points $pCurr $pNext]
    set pCurr $pNext
  }

  if {![pw::DomainUnstructured qualifyEdges $edge]} {
    puts "Selected points cannot define an unstructured domain"
    return -code error [getErrorMsg "DomUnsPoints"]
  }

  set domain [pw::DomainUnstructured create]
  $domain addEdge $edge
  return $domain
}

###############################################################
#-- PROC: DomStr4Edges
#--
#-- Create a STRUCTURED domain from 4 edge lists.
#-- Returns the new domain's id.
#--
###############################################################
proc DomStr4Edges { e1 e2 e3 e4 } {
  if {[argCheck $e1 "pw::Edge"] && \
      [argCheck $e2 "pw::Edge"] && \
      [argCheck $e3 "pw::Edge"] && \
      [argCheck $e4 "pw::Edge"]} {

    set edges [list $e1 $e2 $e3 $e4]
    if {![pw::DomainStructured qualifyEdges $edges]} {
      puts "Selected edges cannot define a structured domain"
      return -code error [getErrorMsg "DomStr4Edges"]
    }

    set domain [pw::DomainStructured create]
    foreach e $edges {
      $domain addEdge $e
    }
    return $domain
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
    if {![argCheck $e "pw::Edge"]} {
      return -code error [getErrorMsg "DomUnsEdges"]
    }
  }
  if {![pw::DomainUnstructured qualifyEdges $edgeList]} {
    puts "Selected edges cannot define an unstructured domain"
    return -code error [getErrorMsg "DomUnsEdges"]
  }

  set domain [pw::DomainUnstructured create]
  foreach e $edgeList {
    $domain addEdge $e
  }
  return $domain
}

###############################################################
#-- PROC: DomChangeDisplay
#--
#-- Change the display style of a list of domains.
#--
###############################################################
proc DomChangeDisplay { domList style {color 1} } {
  foreach dom $domList {
    if {![argCheck $dom "pw::Domain"]} {
      return -code error [getErrorMsg "DomChangeDisplay"]
    }
  }
  if {![string equal $style "WIREFRAME"] && \
      ![string equal $style "OFF"]} {
    printDetails $style "< WIREFRAME | OFF >"
    return -code error [getErrorMsg "DomChangeDisplay"]
  }
  if {[argCheck $color "integer" 0 1 8 1]} {
    set colors(0) 0x00ffa0a0
    set colors(1) 0x0000af00
    set colors(2) 0x00ff8800
    set colors(3) 0x000000af
    set colors(4) 0x00ffff00
    set colors(5) 0x00af0000
    set colors(6) 0x00ff00ff
    set colors(7) 0x00888800
    set colors(8) 0x00008888

    set col [pw::Collection create]
    $col set $domList
    $col do setRenderAttribute ColorMode Entity

    if {$style == "WIREFRAME"} {
      $col do setRenderAttribute ColorMode Entity
      $col do setRenderAttribute LineMode All
      $col do setColor $colors($color)
    } elseif {$style == "OFF"} {
      $col do setRenderAttribute LineMode Boundary
    }

    $col delete
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
    if {![argCheck $dom "pw::Domain"]} {
      return -code error [getErrorMsg "DomEllipticSolve"]
    }
  }
  if {[argCheck $iterations "integer" 0 1]} {
    set mode [pw::Application begin EllipticSolver $domList]
    foreach dom $domList {
      foreach bc [list 1 2 3 4] {
        $dom setEllipticSolverAttribute -edge $bc EdgeAngleCalculation Interpolate
        $dom setEllipticSolverAttribute -edge $bc EdgeControl StegerSorenson
      }
    }
    $mode run $iterations
    $mode end
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
    if {![argCheck $con "pw::Connector"]} {
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
    set crossProd     [pwu::Vector3 cross $vec1 $vec2]
    set normCrossProd [pwu::Vector3 normalize $crossProd]
    if {$constAxis!=0} {
      if {![argCheck $constAxis "axis" 0]} {
        return -code error [getErrorMsg "DomExtrudeNormal"]
      }
      set axis $constAxis
      if { $axis == "X" } {
        set constBC "ConstantX"
      } elseif { $axis == "Y" } {
        set constBC "ConstantY"
      } elseif { $axis == "Z" } {
        set constBC "ConstantZ"
      }
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
      set symVec [pwu::Vector3 cross $normCrossProd $axisVec]
      if {[expr round(abs([lindex $symVec 0]))] == 1} {
        set symBC "SymmetryX"
      } elseif {[expr round(abs([lindex $symVec 1]))] == 1} {
        set symBC "SymmetryY"
      } elseif {[expr round(abs([lindex $symVec 2]))] == 1} {
        set symBC "SymmetryZ"
      }
    }
    set blEdge [pw::Edge create]
    foreach con $conList {
      $blEdge addConnector $con
    }
    set blDom [pw::DomainStructured create]
    $blDom addEdge $blEdge
    set blExtrude [pw::Application begin ExtrusionSolver $blDom]
    $blDom setExtrusionSolverAttribute NormalInitialStepSize $initDs
    $blDom setExtrusionSolverAttribute SpacingGrowthFactor $cellGr
    $blDom setExtrusionSolverAttribute NormalMarchingVector $normCrossProd
    $blDom setExtrusionSolverAttribute NormalKinseyBarthSmoothing 0.0
    $blDom setExtrusionSolverAttribute NormalVolumeSmoothing $volSmth
    if {$constBegin==1} {
      $blDom setExtrusionBoundaryCondition Begin $constBC
    }
    if {$constEnd==1} {
      $blDom setExtrusionBoundaryCondition End $constBC
    }
    if {$symBegin==1} {
      $blDom setExtrusionBoundaryCondition Begin $symBC
    }
    if {$symEnd==1} {
      $blDom setExtrusionBoundaryCondition End $symBC
    }
    $blExtrude run $blDist
    $blExtrude end
    return $blDom
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
   return [pw::Grid getAll -type "pw::Domain"]
}

###############################################################
#-- PROC: DomGetEdgeConnectors
#--
#-- Return a list of cons making up a domain's edge.
#--
###############################################################
proc DomGetEdgeConnectors { dom edgeNum }  {
  if {[argCheck $dom "pw::Domain"] && \
      [argCheck $edgeNum "integer" 1 1 [$dom getEdgeCount] 1]} {
    set edge [$dom getEdge $edgeNum]
    set num [$edge getConnectorCount]
    set edgeCons ""
    for {set i 1} {$i <= $num} {incr i} {
      lappend edgeCons [$edge getConnector $i]
    }
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
    if {![argCheck $dom "pw::Domain"]} {
      return -code error [getErrorMsg "DomInitialize"]
    }
  }
  foreach dom $domList {
     $dom initialize
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
    if {![argCheck $dom "pw::Domain"]} {
      return -code error [getErrorMsg "DomJoin"]
    }
  }
  pw::DomainStructured join $domList
}

###############################################################
#-- PROC: DomLinearProjection
#--
#-- Linear projection of a domain.
#--
###############################################################
proc DomLinearProjection { dom db axis } {
  if {[argCheck $dom "pw::Domain"] && \
      [argCheck $db "pw::DatabaseEntity"] && \
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
    $dom project -type Linear -direction $axisVec $db
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

  if {![argCheck $domain pw::DomainUnstructured]} {
    return -code error [getErrorMsg "DomNewTRexCondition"]
  }
  foreach con $cons {
    if {![argCheck $con "pw::Connector"]} {
      if {2 != [llength $con] || -1 == [lsearch -exact ["SAME" "OPPOSITE"] [lindex $con 1]]} {
        return -code error [getErrorMsg "DomNewTRexCondition"]
      }
    }
  }

  set pwTypes [list "Off" "AdjacentGrid" "Wall" "Match"]
  set ggTypes [list "OFF" "DEFAULT"]
  set spacing [pw::TRexCondition getAutomaticWallSpacing]
  set actualType $type
  if {-1 == [lsearch -exact $pwTypes $type]} {
    set ggindex [lsearch -exact $ggTypes $type]
    if {[argCheck $type float 0 0]} {
      set spacing $type
      set actualType "Wall"
    } elseif {-1 == $ggindex} {
      puts "Invalid boundary condition type - $type"
      puts "Condition type must be one of: "
      puts "Pointwise:  $pwTypes"
      puts "Gridgen:    $ggTypes"
      return -code error [getErrorMsg "DomNewTRexCondition"]
    } else {
      set actualType [lindex $pwTypes $ggindex]
    }
  }

  set cond [pw::TRexCondition create]
  if {0 != $name} {
    set allBCNames [pw::TRexCondition getNames]
    if {-1 != [lsearch -exact $name $allBCNames]} {

      #Using the length of the name list guarantees that the new name will
      #not also be a duplicate, without requiring a running count of all BCs
      #that have the same root name.
      set name2 "$name-[llength $allBCNames]"
      puts "A boundary condition named $name already exists."
      puts "This boundary condition was renamed to $name2"
      $cond setName $name2
    } else {
      $cond setName $name
    }
  }
  $cond setType $actualType
  $cond setSpacing $spacing

  #create registers
  set regList [list]
  foreach con $cons {
    lappend regList [list $domain $con]
  }

  if {0 != $attributes} {
    DomSetUnsSolverAttrs $domain $attributes
  }

  $cond apply $regList

  return $cond
}

###############################################################
#-- PROC: DomSetUnsSolverAttrs
#--
#-- Set unstructured solver attributes for a target domain.
#--
###############################################################
proc DomSetUnsSolverAttrs { domain attributes } {
  if {![argCheck $domain pw::DomainUnstructured]} {
    return -code error [getErrorMsg "DomSetUnsSolverAttrs"]
  }
  set pwAttrs [list ShapeConstraint ShapeProjection RelaxationFactor \
      BoundaryDecay EdgeMaximumLength EdgeMinimumLength NormalMaximumDeviation \
      SurfaceMaximumDeviation TRexMaximumLayers TRexFullLayers TRexGrowthRate \
      TRexSpacingSmoothing TRexSpacingRelaxationFactor \
      TRexPushAttributes SwapCellsWithNoInteriorPoints]

  set ggAttrs [list shape projection relax boundary_decay max_edge min_edge \
      angle_deviation deviation aniso_layers aniso_layers_start_modify \
      aniso_growth_rate aniso_delta_s_smooth_iters \
      aniso_delta_s_smooth_omega aniso_delta_s]

  set n [llength $attributes]
  for {set k 0} {$k < $n} {incr k} {
    set att [lindex $attributes $k]
    set val [lindex $attributes [incr k]]

    if {$k > $n} {
      puts "An attribute does not have any corresponding values."
      return -code error [getErrorMsg "DomSetUnsSolverAttrs"]
    }

    if {-1 != [lsearch -exact $pwAttrs $att]} {
      $domain setUnstructuredSolverAttribute $att $val
    } else {
      set ggindex [lsearch -exact $ggAttrs $att]
      if {"aniso_delta_s" == [lindex $ggAttrs $ggindex]} {
        # Get all T-Rex conditions on the passed connectors, then update them
        # as instructed.
        # Create registers first:
        set regList [list]
        set conList $val
        set type [lindex $attributes [incr k]]
        foreach con $conList {
          lappend regList [list $domain $con]
        }
        foreach trc [pw::TRexCondition getByEntities $regList] {
          if {[argCheck $type "float" 0 0]} {
            $trc setType "Wall"
            $trc setSpacing $type
          } elseif {"OFF" == $type} {
            $trc setType "Off"
          } elseif {"DEFAULT" == $type} {
            $trc setType "AdjacentGrid"
          } else {
            puts "Invalid parameter for Gridgen attribute aniso_delta_s - $type"
            return -code error [getErrorMsg "DomSetUnsSolverAttrs"]
          }
        }
      } elseif {-1 != $ggindex} {
        $domain setUnstructuredSolverAttribute [lindex $pwAttrs $ggindex] $val
      } else {
        puts "Invalid attribute - $att"
        puts "Attribute must be one of: "
        puts "Pointwise:  $pwAttrs"
        puts "Gridgen:    $ggAttrs"
        puts "This attribute may have no analog in Pointwise. Skipping..."
      }
    }
  }
}

###############################################################
#-- PROC: DomSetTRexSpacing
#--
#-- Set T-Rex wall spacing on a set of connectors.
#--
###############################################################
proc DomSetTRexSpacing { domain conList spacing } {
  if {![argCheck $domain "pw::DomainUnstructured"]} {
    return -code error [getErrorMsg "DomSetTRexSpacing"]
  } elseif {![argCheck $spacing "float" 0 0]} {
    return -code error [getErrorMsg "DomSetTRexSpacing"]
  }
  foreach con $conList {
    if {![argCheck $con "pw::Connector"]} {
      return -code error [getErrorMsg "DomSetTRexSpacing"]
    }
  }

  # Get all T-Rex conditions associated with the selected connectors
  set regList [list]
  foreach con $conList {
    lappend regList [list $domain $con]
  }
  set condList [pw::TRexCondition getByEntities $regList]
  foreach cond $condList {
    if {"Wall" == [$cond getType]} {
      $cond setSpacing $spacing
    } else {
      puts "The connectors associated with condition $cond are not walls."
      puts "Skipping this condition..."
      continue
    }
  }
}

###############################################################
#-- PROC: DomProjectClosestPoint
#--
#-- Closest point projection of a domain.
#--
###############################################################
proc DomProjectClosestPoint { dom db {interior 0} } {
  if {[argCheck $dom "pw::Domain"] && \
      [argCheck $db "pw::DatabaseEntity"] && \
      [argCheck $interior "boolean"]} {
    if {$interior == 0} {
      pw::GridEntity project $dom $db
    } else {
      pw::GridEntity project -interior $dom $db
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
    if {![argCheck $dom "pw::Domain"]} {
      return -code error [getErrorMsg "DomRotate"]
    }
  }
  if {[argCheck $axis "axis" 0] && \
      [argCheck $angle "float" -360 1 360 1]} {
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
    pw::Entity transform [pwu::Transform rotation -anchor {0 0 0} \
        $axisVec $angle] $domList
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
  if {[argCheck $dom "pw::DomainStructured"] && \
      [argCheck $index "integer" 1 0]} {
    if {$dir=="I"} {
      return [lindex [$dom split -I $index] 1]
    } elseif {$dir=="J"} {
      return [lindex [$dom split -J $index] 1]
    } else {
      printDetails "$dir" "< I | J >"
      return -code error [getErrorMsg "DomSplit"]
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
  if {[argCheck $dom "pw::Domain"]} {
    return [pw::Block getBlocksFromDomains $dom]
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
  if {![argCheck $structured "boolean"]} {
    return -code error [getErrorMsg "DomCreateFace"]
  }
  foreach dom $domList {
    if {![argCheck $dom "pw::Domain"]} {
      return -code error [getErrorMsg "DomCreateFace"]
    }
  }
  if {0 == $structured} {
    return [pw::FaceUnstructured createFromDomains $domList]
  } else {
    return [pw::FaceStructured createFromDomains $domList]
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

