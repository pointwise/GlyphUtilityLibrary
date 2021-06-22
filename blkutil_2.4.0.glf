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
#--  Define some useful block commands
#--
##########################################################################


##########################################################################
#--
#-- POINTWISE BLOCK COMMANDS
#--
##########################################################################

namespace eval gul {

###############################################################
#-- PROC: BlkGetByName
#--
#-- Get block by name.
#--
###############################################################
proc BlkGetByName { name } {
  if { [catch {
    set blk [pw::GridEntity getByName $name]
  } eid] } {
    puts "No block named $name exists"
    exit 1
  } else {
    if { [argCheck $blk "pw::Block"] } {
      return $blk
    } else {
      return -code error [getErrorMsg "BlkGetByName"]
    }
  }
}

###############################################################
#-- PROC: BlkGetAll
#--
#-- Get a list of all blocks.
#--
###############################################################
proc BlkGetAll { } {
  return [pw::Grid getAll -type pw::Block]
}

###############################################################
#-- PROC: BlkDelete
#--
#-- Delete blocks with an option of special delete specified.
#-- The argument option is a string.
#--
###############################################################
proc BlkDelete { blkList option } {
  foreach blk $blkList {
    if {![argCheck $blk "pw::Block"]} {
      return -code error [getErrorMsg "BlkDelete"]
    }
  }
  if { $option == "SPECIAL" } {
    foreach blk $blkList {
      $blk delete -domains -connectors
    }
  } else {
    foreach blk $blkList {
      $blk delete
    }
  }
}

###############################################################
#-- PROC: BlkGetPt
#--
#-- Get XYZ coordinates of a block point.
#-- The index argument ind is a ij list for structured blocks
#-- and point index for unstructured blocks.
###############################################################
proc BlkGetPt { blk ind } {
  if {![argCheck $blk "PW::Block"]} {
    return -code error [getErrorMsg "BlkGetPt"]
  } else {
    if { [catch {set ptXYZ [$blk getPoint $ind]} eid] } {
      return -code error [getErrorMsg "BlkGetPt"]
    } else {
      return $ptXYZ
    }
  }
}

###############################################################
#-- PROC: BlkGetSubs
#--
#-- Get a list of sub-blocks in a block.
#--
###############################################################
proc BlkGetSubs { blk } {
  if {![argCheck $blk "pw::BlockStructured"]} {
    return -code error [getErrorMsg "BlkGetSubs"]
  } else {
    set subBlkNum [$blk getSubGridCount]
    set i 1
    set subBlkList ""
    while { $i <= $subBlkNum } {
      lappend subBlkList [$blk getSubGrid $i]
      incr i
    }
    return $subBlkList
  }
}

###############################################################
#-- PROC: BlkCreateSub
#--
#-- Create a sub block
#--
###############################################################
proc BlkCreateSub { blk ijkMin ijkMax } {
  if {[argCheck $blk "pw::BlockStructured"] && \
      [argCheck $ijkMin "vector3"] && \
      [argCheck $ijkMax "vector3"] } {
    if { [catch {set subBlk [$blk createSubGrid $ijkMin $ijkMax]} eid] } {
      return -code error [getErrorMsg "BlkCreateSub"]
    } else {
      return $subBlk
      exit 1
    }
  } else {
    return -code error [getErrorMsg "BlkCreateSub"]
  }
}

###############################################################
#-- PROC: BlkStr6Doms
#--
#-- Create a STRUCTURED block from 6 domains.
#-- Returns the new block as an object.
#--
###############################################################
proc BlkStr6Doms { d1 d2 d3 d4 d5 d6 } {
  if {[argCheck $d1 "pw::DomainStructured"] && \
      [argCheck $d2 "pw::DomainStructured"] && \
      [argCheck $d3 "pw::DomainStructured"] && \
      [argCheck $d4 "pw::DomainStructured"] && \
      [argCheck $d5 "pw::DomainStructured"] && \
      [argCheck $d6 "pw::DomainStructured"]} {
    set block [pw::BlockStructured createFromDomains \
      [list $d1 $d2 $d3 $d4 $d5 $d6]]
    return $block
  } else {
    return -code error [getErrorMsg "BlkStr6Doms"]
  }
}

###############################################################
#-- PROC: BlkUnsDoms
#--
#-- Create an UNSTRUCTURED block from a list of domains.
#-- Returns the new block as an object.
#--
###############################################################
proc BlkUnsDoms { domList } {

  foreach d $domList {
    if {![argCheck $d "pw::Domain"]} {
      return -code error [getErrorMsg "BlkUnsDoms"]
    }
  }
  set rejected [list]
  set blk [pw::BlockUnstructured createFromDomains \
           -reject rejected $domList]
  if {[llength $rejected] != 0} {
    puts "[llength $rejected] domains unused"
  }
  return $blk
}

###############################################################
#-- PROC: BlkStr6Faces
#--
#-- Create a STRUCTURED block from 6 face lists.
#-- Returns the new block object.
#--
###############################################################
proc BlkStr6Faces { f1 f2 f3 f4 f5 f6 } {
  if {[argCheck $f1 "pw::FaceStructured"] && \
      [argCheck $f2 "pw::FaceStructured"] && \
      [argCheck $f3 "pw::FaceStructured"] && \
      [argCheck $f4 "pw::FaceStructured"] && \
      [argCheck $f5 "pw::FaceStructured"] && \
      [argCheck $f6 "pw::FaceStructured"]} {
    set block [pw::BlockStructured create]
    set faces [list $f1 $f2 $f3 $f4 $f5 $f6]
    foreach face $faces {
      $block addFace $face
    }
    return $block
  } else {
    return -code error [getErrorMsg "BlkStr6Faces"]
  }
}

###############################################################
#-- PROC: BlkUnsFaces
#--
#-- Create an UNSTRUCTURED block from a list of faces.
#-- Returns the new block as an object.
#--
###############################################################
proc BlkUnsFaces { faceList } {
  foreach face $faceList {
    if {![argCheck $face "pw::Face"]} {
      return -code error [getErrorMsg "BlkUnsFaces"]
    }
  }
  set domList [list]
  foreach face $faceList {
    foreach dom [$face getDomains] {
      lappend domList $dom
    }
  }
  return [pw::BlockUnstructured createFromDomains $domList]
}

###############################################################
#-- PROC: BlkStrNormalExtrude
#--
#-- Create single face normal extrusion from a list of domains.
#--
###############################################################
proc BlkStrNormalExtrude { domList initDs cellGr blDist volSmth expSmooth \
    impSmooth {bcEdge1 0} {bcEdge2 0} {bcEdge3 0} {bcEdge4 0} } {
  if {[llength $domList] > 0 && \
      [argCheck $initDs "float" 0.0 0] && \
      [argCheck $cellGr "float" 0.0 0] && \
      [argCheck $blDist "integer" 0 0] && \
      [argCheck $volSmth "float" 0.0 1 1.0 1] && \
      [argCheck $expSmooth "vector2" 0.0 1 10.0 1] && \
      [argCheck $impSmooth "vector2" 0.0 1 20.0 1]} {
    foreach dom $domList {
      if {![argCheck $dom "pw::DomainStructured"]} {
        return -code error [getErrorMsg "BlkStrNormalExtrude"]
      }
    }
    set blFace [pw::FaceStructured create]
    foreach dom $domList {
      $blFace addDomain $dom
    }

    set bc(edge,1) [lindex $bcEdge1 0]
    set bc(edge,2) [lindex $bcEdge2 0]
    set bc(edge,3) [lindex $bcEdge3 0]
    set bc(edge,4) [lindex $bcEdge4 0]

    if {[llength $bcEdge1] > 1} {
      set bc(edge,1,data) [lindex $bcEdge1 1]
    }
    if {[llength $bcEdge2] > 1} {
      set bc(edge,2,data) [lindex $bcEdge2 1]
    }
    if {[llength $bcEdge3] > 1} {
      set bc(edge,3,data) [lindex $bcEdge3 1]
    }
    if {[llength $bcEdge4] > 1} {
      set bc(edge,4,data) [lindex $bcEdge4 1]
    }

    set edge1      [$blFace getEdge 1]
    set bc(cons,1) [$edge1 getConnectorCount]

    set edge2      [$blFace getEdge 2]
    set bc(cons,2) [$edge2 getConnectorCount]

    set edge3      [$blFace getEdge 3]
    set bc(cons,3) [$edge3 getConnectorCount]

    set edge4      [$blFace getEdge 4]
    set bc(cons,4) [$edge4 getConnectorCount]

    set blBlk [pw::BlockStructured create]
    $blBlk addFace $blFace

    set blExtrude [pw::Application begin ExtrusionSolver $blBlk]

    for {set i 1} {$i < 5} {incr i} {
      if {$bc(edge,$i) != 0 && [string range $bc(edge,$i) 0 end-1] == "Constant"} {
        for {set j 1} {$j < [expr $bc(cons,$i)+1]} {incr j} {
          $blBlk setExtrusionBoundaryCondition [list $i $j] $bc(edge,$i)
        }
      } elseif {$bc(edge,$i) != 0 && [string range $bc(edge,$i) 0 end-1] == "Symmetry"} {
        for {set j 1} {$j < [expr $bc(cons,$i)+1]} {incr j} {
          $blBlk setExtrusionBoundaryCondition [list $i $j] $bc(edge,$i)
        }
      } elseif {$bc(edge,$i) != 0 && [string range $bc(edge,$i) 0 end-1] == "Splay"} {
        for {set j 1} {$j < [expr $bc(cons,$i)+1]} {incr j} {
          $blBlk setExtrusionBoundaryCondition [list $i $j] Splay [string index $bc(edge,$i) end]
        }
      } elseif {$bc(edge,$i) != 0 && $bc(edge,$i) == "DbConstrained"} {
        for {set j 1} {$j < [expr $bc(cons,$i)+1]} {incr j} {
          $blBlk setExtrusionBoundaryCondition [list $i $j] DatabaseConstrained $bc(edge,$i,data)
        }
      }
    }

    $blBlk setExtrusionSolverAttribute NormalInitialStepSize $initDs
    $blBlk setExtrusionSolverAttribute SpacingGrowthFactor $cellGr
    $blBlk setExtrusionSolverAttribute NormalVolumeSmoothing $volSmth

    $blBlk setExtrusionSolverAttribute NormalExplicitSmoothing $expSmooth
    $blBlk setExtrusionSolverAttribute NormalImplicitSmoothing $impSmooth

    $blExtrude run $blDist
    $blExtrude end

    return $blBlk
  } else {
    return -code error [getErrorMsg "BlkStrNormalExtrude"]
  }
}

###############################################################
#-- PROC: BlkStrRotationalExtrude
#--
#-- Create a STRUCTURED rotational extrusion from a domain.
#-- Returns the new block object.
#--
###############################################################
proc BlkStrRotationalExtrude { face_dom_list axis angle pts } {
  if {[llength $face_dom_list] > 0 && \
      [argCheck $pts "integer" 0 1] && \
      [argCheck $axis "axis"] && \
      [argCheck $angle "float" 0.0 1 360.0 1]} {
    foreach face_doms $face_dom_list {
      if {![argCheck $face_doms "pw::DomainStructured"]} {
        return -code error [getErrorMsg "BlkStrRotationalExtrude"]
      }
    }
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

    set blk_list ""
    foreach face_doms $face_dom_list {
      set blkFace [pw::FaceStructured createFromDomains -single $face_doms]
      set extBlk  [pw::BlockStructured create]
      $extBlk addFace $blkFace

      set rotExtrude [pw::Application begin ExtrusionSolver $extBlk]
      $extBlk setExtrusionSolverAttribute Mode Rotate
      $extBlk setExtrusionSolverAttribute RotateAxisStart {0 0 0}
      $extBlk setExtrusionSolverAttribute RotateAxisEnd $axisVec
      $extBlk setExtrusionSolverAttribute RotateAngle $angle
      $rotExtrude run $pts
      $rotExtrude end

      lappend blk_list $extBlk
    }
    return $blk_list
  } else {
    return -code error [getErrorMsg "BlkStrRotationalExtrude"]
  }
}

###############################################################
#-- PROC: BlkStrTranslationalExtrude
#--
#-- Create a STRUCTURED translational extrusion from a domain.
#-- Returns the new block object.
#--
###############################################################
proc BlkStrTranslationalExtrude { dom axis dist pts } {
  if {[argCheck $dom "pw::DomainStructured"] && \
      [argCheck $dist "float"] && \
      [argCheck $pts "integer" 0 1] && \
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

    set blkFace [pw::FaceStructured createFromDomains -single $dom]
    set extBlk  [pw::BlockStructured create]
    $extBlk addFace $blkFace

    set rotExtrude [pw::Application begin ExtrusionSolver $extBlk]
      $extBlk setExtrusionSolverAttribute Mode Translate
      $extBlk setExtrusionSolverAttribute TranslateDirection $axisVec
      $extBlk setExtrusionSolverAttribute TranslateDistance  $dist
      $rotExtrude run $pts
    $rotExtrude end

    return $extBlk
  } else {
    return -code error [getErrorMsg "BlkStrTranslationalExtrude"]
  }
}

###############################################################
#-- PROC: BlkStrTranslationalExtrudeSubCons
#--
#-- Create a STRUCTURED translational extrusion from a domain.
#-- Uses sub cons for dimension and spacing.
#--
###############################################################
proc BlkStrTranslationalExtrudeSubCons { dom conList axis } {
  if {[argCheck $dom "pw::DomainStructured"] && \
      [llength $conList] > 0 && \
      [argCheck $axis "axis"]} {
    foreach con $conList {
      if {![argCheck $con "pw::Connector"]} {
        return -code error [getErrorMsg "BlkStrTranslationalExtrudeSubCons"]
      }
    }
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

    set pts  0
    set dist 0
    foreach con $conList {
       set pts  [expr [[lindex $con 0] getDimension]+$pts-1]
       set dist [expr [[lindex $con 0] getTotalLength]+$dist]
    }

    set blkFace [pw::FaceStructured createFromDomains -single $dom]
    set extBlk  [pw::BlockStructured create]
    $extBlk addFace $blkFace

    set rotExtrude [pw::Application begin ExtrusionSolver $extBlk]
      $extBlk setExtrusionSolverAttribute Mode Translate
      $extBlk setExtrusionSolverAttribute SpacingMode Connector
      $extBlk setExtrusionSolverAttribute SpacingConnectors  $conList
      $extBlk setExtrusionSolverAttribute TranslateDirection $axisVec
      $extBlk setExtrusionSolverAttribute TranslateDistance  $dist
      $rotExtrude run $pts
    $rotExtrude end

    return $extBlk
  } else {
    return -code error [getErrorMsg "BlkStrTranslationalExtrudeSubCons"]
  }
}

###############################################################
#-- PROC: BlkCopyPasteRotate
#--
#-- Copy, Paste, Rotate block by an angle.
#--
###############################################################
proc BlkCopyPasteRotate { blk axisVec {angle 180} } {
  if {[argCheck $blk "pw::Block"] && [argCheck $axisVec "vector3"] && \
      [argCheck $angle "float" 0 1 360 0] } {

    pw::Application setClipboard $blk
    set meshRot [pw::Application begin Paste]
    set entsRot [$meshRot getEntities]
    set begRot [pw::Application begin Modify $entsRot]
    pw::Entity transform [pwu::Transform rotation -anchor {0 0 0} $axisVec \
      $angle] [$begRot getEntities]
    set result [$meshRot getEntities]
    $begRot end
    $meshRot end
    pw::Application clearClipboard

    return $result
  } else {
    return -code error [getErrorMsg "BlkCopyPasteRotate"]
  }
}

###############################################################
#-- PROC: BlkGetDimensions
#--
#-- Get a block's dimensions.
#--
###############################################################
proc BlkGetDimensions { blk } {
  if {[argCheck $blk "pw::Block"]} {
    return [$blk getDimensions]
  } else {
    return -code error [getErrorMsg "BlkGetDims"]
  }
}

###############################################################
#-- PROC: BlkGetFaceDoms
#--
#-- Return domain list from given block face
#--
###############################################################
proc BlkGetFaceDoms { blk face_index } {
  if {[argCheck $blk "pw::BlockStructured"]} {
    if {$face_index == "IMIN"} {
      set face "IMinimum"
    } elseif {$face_index == "IMAX"} {
      set face "IMaximum"
    } elseif {$face_index == "JMIN"} {
      set face "JMinimum"
    } elseif {$face_index == "JMAX"} {
      set face "JMaximum"
    } elseif {$face_index == "KMIN"} {
      set face "KMinimum"
    } elseif {$face_index == "KMAX"} {
      set face "KMaximum"
    } elseif {[argCheck $face_index "integer" 1 1 [$blk getFaceCount] 1]} {
      set face $face_index
    } else {
      puts "or < IMIN | IMAX | JMIN | JMAX | KMIN | KMAX >"
      return -code error [getErrorMsg "BlkGetFaceDoms"]
    }
    set face [$blk getFace $face]
    return [$face getDomains]
  } else {
    return -code error [getErrorMsg "BlkGetFaceDoms"]
  }
}

###############################################################
#-- PROC: BlkGetName
#--
#-- Get a block's name.
#--
###############################################################
proc BlkGetName { blk } {
  if {[argCheck $blk "pw::Block"]} {
    return [$blk getName]
  } else {
    return -code error [getErrorMsg "BlkGetName"]
  }
}

###############################################################
#-- PROC: BlkJoin
#--
#-- Join 2 blocks.
#--
###############################################################
proc BlkJoin { blks } {
  if {[llength $blks] > 0} {
    foreach block $blks {
      if {![argCheck $block "pw::Block"]} {
        return -code error [getErrorMsg "BlkJoin"]
      }
    }
    pw::BlockStructured join $blks
  } else {
    return -code error [getErrorMsg "BlkJoin"]
  }
}

###############################################################
#-- PROC: BlkStrReorient
#--
#-- Reorient a block's topological indices.
#--
###############################################################
proc BlkStrReorient { blk imin jmin kmin } {
  if {[argCheck $blk "pw::BlockStructured"] && \
      [argCheck $imin "integer" 1 1 6 1] && \
      [argCheck $jmin "integer" 1 1 6 1] && \
      [argCheck $kmin "integer" 1 1 6 1]} {
    switch $imin {
      1 { set i_ind "KMinimum"}
      2 { set i_ind "KMaximum"}
      3 { set i_ind "IMinimum"}
      4 { set i_ind "IMaximum"}
      5 { set i_ind "JMinimum"}
      6 { set i_ind "JMaximum"}
      default {error "Bad imin"}
    }
    switch $jmin {
      1 { set j_ind "KMinimum"}
      2 { set j_ind "KMaximum"}
      3 { set j_ind "IMinimum"}
      4 { set j_ind "IMaximum"}
      5 { set j_ind "JMinimum"}
      6 { set j_ind "JMaximum"}
      default {error "Bad jmin"}
    }
    switch $kmin {
      1 { set k_ind "KMinimum"}
      2 { set k_ind "KMaximum"}
      3 { set k_ind "IMinimum"}
      4 { set k_ind "IMaximum"}
      5 { set k_ind "JMinimum"}
      6 { set k_ind "JMaximum"}
      default {error "Bad kmin"}
    }
    $blk setOrientation $i_ind $j_ind $k_ind
  } else {
    return -code error [getErrorMsg "BlkReorient"]
  }
}

###############################################################
#-- PROC: BlkSetName
#--
#-- Set a block's name.
#--
###############################################################
proc BlkSetName { blk name } {
  if {[argCheck $blk "pw::Block"] && [expr [string length $name] > 0]} {
    $blk setName $name
  } else {
    return -code error [getErrorMsg "BlkSetName"]
  }
}

###############################################################
#-- PROC: BlkNewTRexCondition
#--
#-- Create and apply a TRex condition to a set of domains.
#--
###############################################################
proc BlkNewTRexCondition { blk domList type {name 0} {attributes 0} } {

  if {![argCheck $blk "pw::BlockUnstructured"]} {
    return -code error [getErrorMsg "BlkNewTRexCondition"]
  }
  foreach dom $domList {
    if {![argCheck $dom "pw::Domain"]} {
      return -code error [getErrorMsg "BlkNewTRexCondition"]
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
      return -code error [getErrorMsg "BlkNewTRexCondition"]
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
  foreach dom $domList {
    lappend regList [list $blk $dom]
  }

  if {0 != $attributes} {
    BlkSetUnsSolverAttrs $blk $attributes
  }

  $cond apply $regList

  return $cond
}

###############################################################
#-- PROC: BlkSetUnsSolverAttrs
#--
#-- Set unstructured solver attributes for a target block.
#--
###############################################################
proc BlkSetUnsSolverAttrs { block attributes } {
  if {![argCheck $block pw::BlockUnstructured]} {
    return -code error [getErrorMsg "BlkSetUnsSolverAttrs"]
  }
  set pwAttrs [list BoundaryDecay EdgeMaximumLength EdgeMinimumLength \
      PyramidMaximumHeight PyramidMinimumHeight PyramidAspectRatio \
      InitialMemorySize IterationCount TRexMaximumLayers TRexFullLayers \
      TRexGrowthRate TRexSpacingSmoothing TRexSpacingRelaxationFactor \
      TRexCollisionBuffer TRexAnisotropicIsotropicBlend \
      TRexSkewCriteriaDelayLayers TRexSkewCriteriaMaximumAngle \
      TRexSkewCriteriaEquivolume TRexSkewCriteriaEquiangle \
      TRexSkewCriteriaCentroid TRexCheckCombinedElementQuality \
      TRexVolumeFunction TRexPushAttributes TRexIsotropicSeedLayers]

  set ggAttrs [list boundary_decay max_edge min_edge max_height min_height \
      aspect_ratio memory iterations aniso_layers aniso_layers_start_modify \
      aniso_growth_rate aniso_delta_s_smooth_iters aniso_delta_s_smooth_relax \
      aniso_collision_buffer aniso_iso_blend aniso_layers_start_skew \
      aniso_skew_max_angle aniso_skew_volume aniso_skew_angle \
      aniso_skew_centroid aniso_delta_s]

  set n [llength $attributes]
  for {set k 0} {$k < $n} {incr k} {
    set att [lindex $attributes $k]
    set val [lindex $attributes [incr k]]

    if {$k > $n} {
      puts "An attribute does not have any corresponding values."
      return -code error [getErrorMsg "BlkSetUnsSolverAttrs"]
    }

    if {-1 != [lsearch -exact $pwAttrs $att]} {
      $block setUnstructuredSolverAttribute $att $val
    } else {
      set ggindex [lsearch -exact $ggAttrs $att]
      if {"aniso_delta_s" == [lindex $ggAttrs $ggindex]} {
        # Get all T-Rex conditions on the passed domains, then update them
        # as instructed.
        # Create registers first:
        set regList [list]
        set domList $val
        set type [lindex $attributes [incr k]]
        foreach dom $domList {
          lappend regList [list $block $dom]
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
            return -code error [getErrorMsg "BlkSetUnsSolverAttrs"]
          }
        }
      } elseif {-1 != $ggindex} {
        $block setUnstructuredSolverAttribute [lindex $pwAttrs $ggindex] $val
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
#-- PROC: BlkSetTRexSpacing
#--
#-- Set initial spacing for a T-Rex wall boundary condition.
#--
###############################################################
proc BlkSetTRexSpacing { block domList spacing } {
  if {![argCheck $block "pw::BlockUnstructured"]} {
    return -code error [getErrorMsg "BlkSetTRexSpacing"]
  } elseif {![argCheck $spacing "float" 0 0]} {
    return -code error [getErrorMsg "BlkSetTRexSpacing"]
  }
  foreach dom $domList {
    if {![argCheck $dom "pw::Domain"]} {
      return -code error [getErrorMsg "BlkSetTRexSpacing"]
    }
  }

  # Get all T-Rex conditions associated with the selected connectors
  set regList [list]
  foreach dom $domList {
    lappend regList [list $block $dom]
  }
  set condList [pw::TRexCondition getByEntities $regList]
  foreach cond $condList {
    if {"Wall" == [$cond getType]} {
      $cond setSpacing $spacing
    } else {
      puts "The domains associated with condition $cond are not walls."
      puts "Skipping this condition..."
      continue
    }
  }
}

###############################################################
#-- PROC: BlkInitialize
#--
#-- Initializes a list of blocks
#--
###############################################################
proc BlkInitialize { blkList } {
  foreach blk $blkList {
    if {![argCheck $blk "pw::Block"]} {
      return -code error [getErrorMsg "BlkInitialize"]
    }
  }
  foreach blk $blkList {
    if {[$blk isOfType "pw::BlockStructured"]} {
      $blk initialize
    } else {
      set usolver [pw::Application begin UnstructuredSolver $blk]
        $usolver run "Initialize"
      $usolver end
    }
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

