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
#-- GRIDGEN BLOCK COMMANDS
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
    set blkList [gg::blkGetAll]
    foreach blk $blkList {
      set blkName [gg::blkName $blk]
      if { $blkName == "$name" } {
        return blk
      }
    }
  } eid] } {
    puts "No block named $name exists"
    exit 1
  }
}

###############################################################
#-- PROC: BlkGetAll
#--
#-- Get a list of all blocks.
#--
###############################################################
proc BlkGetAll { } {
  return [gg::blkGetAll]
}

###############################################################
#-- PROC: BlkDelete
#--
#-- Delete blocks with an option of special delete specified.
#-- The argument option is a string.
#--
###############################################################
proc BlkDelete {blkList option} {
  foreach blk $blkList {
    if {![argCheck $blk "gg::Block"]} {
      return -code error [getErrorMsg "BlkDelete"]
    }
  }
  if { $option == "SPECIAL" } {
    gg::blkDelete $blkList -doms -cons
  } else {
    gg::blkDelete $blkList
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
  if {![argCheck $blk "gg::Block"]} {
    return -code error [getErrorMsg "BlkGetPt"]
  } else {
    gg::blkReport $blk diag
    set type $diag(type)
    if { $type != "STRUCTURED" && $type != "UNSTRUCTURED" } {
      return -code error [getErrorMsg "BlkGetPt"]
    } else {
      if { [catch {set ptXYZ [gg::blkGetPt $blk $ind]} eid] } {
        return -code error [getErrorMsg "BlkGetPt"]
      } else {
        return ptXYZ
      }
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
  if {![argCheck $blk "gg::BlockStructured"]} {
    return -code error [getErrorMsg "BlkGetSubs"]
  } else {
    set subBlkList [gg::blkGetSubs $blk]
    return $subBlkList
  }
}


###############################################################
#-- PROC: BlkCreateSub
#--
#-- Create a sub block
#--
###############################################################
proc BlkCreateSub { blk minCornerIJK maxCornerIJK } {
  if {[argCheck $blk "gg::Block"]} {
    gg::blkReport $blk dataArray STRUCTURE
    set maxI [lindex $dataArray(dimensions) 0]
    set maxJ [lindex $dataArray(dimensions) 1]
    set maxK [lindex $dataArray(dimensions) 2]
    if {[llength $minCornerIJK] == 3 && \
        [llength $maxCornerIJK] == 3 && \
        [argCheck [lindex $minCornerIJK 0] "integer" 1 1 $maxI 1] && \
        [argCheck [lindex $minCornerIJK 1] "integer" 1 1 $maxJ 1] && \
        [argCheck [lindex $minCornerIJK 2] "integer" 1 1 $maxK 1] && \
        [argCheck [lindex $maxCornerIJK 0] "integer" 1 1 $maxI 1] && \
        [argCheck [lindex $maxCornerIJK 1] "integer" 1 1 $maxJ 1] && \
        [argCheck [lindex $maxCornerIJK 2] "integer" 1 1 $maxK 1]} {
      gg::blkAddSub $blk $minCornerIJK $maxCornerIJK
    } else {
      return -code error [getErrorMsg "BlkCreateSub"]
    }
  } else {
    return -code error [getErrorMsg "BlkCreateSub"]
  }
}

###############################################################
#-- PROC: BlkStr6Doms
#--
#-- Create a STRUCTURED block from 6 domains.
#-- Returns the new block's id.
#--
###############################################################
proc BlkStr6Doms { d1 d2 d3 d4 d5 d6 } {
  if {[argCheck $d1 "gg::DomainStructured"] && \
      [argCheck $d2 "gg::DomainStructured"] && \
      [argCheck $d3 "gg::DomainStructured"] && \
      [argCheck $d4 "gg::DomainStructured"] && \
      [argCheck $d5 "gg::DomainStructured"] && \
      [argCheck $d6 "gg::DomainStructured"]} {
    gg::blkBegin -type STRUCTURED
      for {set i 1} {$i <= 6} {incr i} {
        gg::faceBegin
        gg::faceAddDom [set d$i]
        gg::faceEnd
      }
    return [gg::blkEnd]
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
  gg::blkBegin -type UNSTRUCTURED
  gg::faceBegin
  foreach dom $domList {
    if {![argCheck $dom "gg::Domain"]} {
      return -code error [getErrorMsg "BlkUnsDoms"]
    } else {
      gg::faceAddDom $dom
    }
  }
  gg::faceEnd
  return [gg::blkEnd]

}

###############################################################
#-- PROC: BlkStr6Faces
#--
#-- Create a STRUCTURED block from 6 face lists.
#-- Returns the new block's id.
#--
###############################################################
proc BlkStr6Faces { f1 f2 f3 f4 f5 f6 } {
  if {[argCheck $f1 "gg::FaceStructured"] && \
      [argCheck $f2 "gg::FaceStructured"] && \
      [argCheck $f3 "gg::FaceStructured"] && \
      [argCheck $f4 "gg::FaceStructured"] && \
      [argCheck $f5 "gg::FaceStructured"] && \
      [argCheck $f6 "gg::FaceStructured"]} {
    gg::blkBegin -type STRUCTURED
      for {set i 1} {$i <= 6} {incr i} {
        set face [set f$i]
        gg::faceBegin
          foreach dom $face {
            gg::faceAddDom $dom
          }
        gg::faceEnd
      }
    return [gg::blkEnd]
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
  gg::blkBegin -type UNSTRUCTURED
  gg::faceBegin
  foreach face $faceList {
    if {![argCheck $face "gg::Face"]} {
      return -code error [getErrorMsg "BlkUnsDoms"]
    } else {
      foreach dom $face {
        gg::faceAddDom $dom
      }
    }
  }
  gg::faceEnd
  return [gg::blkEnd]
}

###############################################################
#-- PROC: BlkStrNormalExtrude
#--
#-- Create single face normal extrusion from a list of domains.
#--
###############################################################
proc BlkStrNormalExtrude { domList initDs cellGr blDist volSmth expSmooth \
    impSmooth {bcEdge1 0} {bcEdge2 0} {bcEdge3 0} {bcEdge4 0} } {
  if {[llength $domList] > 0 &&
      [argCheck $initDs "float" 0.0 0] && \
      [argCheck $cellGr "float" 0.0 0] && \
      [argCheck $blDist "integer" 0 0] && \
      [argCheck $volSmth "float" 0.0 1 1.0 1] && \
      [argCheck $expSmooth "vector2" -1.0 1 1.0 1] && \
      [argCheck $impSmooth "vector2" 0.0 1]} {
    foreach dom $domList {
      if {![argCheck $dom "gg::DomainStructured"]} {
	  return -code error [getErrorMsg "BlkStrNormalExtrude"]
      }
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

    if [catch {gg::blkExtrusionBegin $domList -face -default HYPERBOLIC} msg] {
      puts "Extrusion failed"
      error $msg
    }

    for {set i 1} {$i < 5} {incr i} {
      if {[string range $bc(edge,$i) 0 end-1]=="Constant"} {
	gg::blkExtrusionAtt -edge [list $i] -constant \
	  [string index $bc(edge,$i) end]
      } elseif {[string range $bc(edge,$i) 0 end-1]=="Symmetry"} {
	  gg::blkExtrusionAtt -edge [list $i] -symmetry \
	      [string index $bc(edge,$i) end]
      } elseif {[string range $bc(edge,$i) 0 end-1]=="Splay"} {
	  gg::blkExtrusionAtt -edge [list $i] -splay \
	      [string index $bc(edge,$i) end]
      } elseif {$bc(edge,$i)=="DbConstrained"} {
	  gg::blkExtrusionAtt -edge [list $i] -db_constrained \
	      $bc(edge,$i,data)
      }
    }

    gg::blkExtrusionAtt -s_init $initDs
    gg::blkExtrusionAtt -growth_geometric $cellGr
    gg::blkExtrusionAtt -vol_smoothing $volSmth
    gg::blkExtrusionAtt -exp_smoothing $expSmooth
    gg::blkExtrusionAtt -imp_smoothing $impSmooth
    for {set nsteps 1} {$nsteps <=$blDist} {incr nsteps} {
      gg::blkExtrusionStep  -result result 1
      if {$result != "OK"} {
	puts "$result != \"OK\" || $nsteps != $blDist"
	gg::blkExtrusionStep -back 1
	break
      }
    }

    return [gg::blkExtrusionEnd]
  } else {
    return -code error [getErrorMsg "BlkStrNormalExtrude"]
  }
}

###############################################################
#-- PROC: BlkStrRotationalExtrude
#--
#-- Create a STRUCTURED rotational extrusion from a domain.
#-- Returns the new block's id.
#--
###############################################################
proc BlkStrRotationalExtrude { face_dom_list axis angle pts } {
  if {[llength $face_dom_list] > 0 &&
      [argCheck $pts "integer" 0 0] && \
      [argCheck $axis "axis"] && \
      [argCheck $angle "float" 0.0 0 360.0 0]} {
    foreach face_doms $face_dom_list {
      if {![argCheck $face_doms "gg::DomainStructured"]} {
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
      gg::blkExtrusionBegin $face_doms  -default HYPERBOLIC -face
      gg::blkExtrusionMode ROTATE -local 1
      gg::blkExtrusionAtt -local 1 -angle $angle
      gg::blkExtrusionAtt -local 1 -axis "0 0 0" $axisVec
      gg::blkExtrusionStep $pts
      lappend blk_list [gg::blkExtrusionEnd]
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
#-- Returns the new block's id.
#--
###############################################################
proc BlkStrTranslationalExtrude { dom axis dist pts } {
  if {[argCheck $dom "gg::DomainStructured"] && \
      [argCheck $dist "float" 0.0 0] && \
      [argCheck $pts "integer" 0 0] && \
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
    gg::blkExtrusionBegin $dom  -default HYPERBOLIC
    gg::blkExtrusionMode TRANSLATE -local 1
    gg::blkExtrusionAtt -local 1 -direction $axisVec
    gg::blkExtrusionAtt -local 1 -distance  $dist
    gg::blkExtrusionStep $pts
    return [gg::blkExtrusionEnd]
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
  if {[argCheck $dom "gg::DomainStructured"] && \
      [llength $conList] > 0 && \
      [argCheck $axis "axis"]} {
    foreach con $conList {
      if {![argCheck $con "gg::Connector"]} {
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
       set pts  [expr [gg::conDim [lindex $con 0]]+$pts-1]
       set dist [expr [gg::conGetLength [lindex $con 0]]+$dist]
    }

    gg::blkExtrusionBegin $dom  -default HYPERBOLIC
    gg::blkExtrusionMode TRANSLATE -local 1
    gg::blkExtrusionAtt -local 1 -growth_subcon $conList
    gg::blkExtrusionAtt -local 1 -direction $axisVec
    gg::blkExtrusionAtt -local 1 -distance  $dist
    gg::blkExtrusionStep $pts
    return [gg::blkExtrusionEnd]
  } else {
    return -code error [getErrorMsg "BlkStrTranslationalExtrudeSubCons"]
  }
}

###############################################################
#-- PROC: BlkCopyPasteRotate
#--
#-- Copy, Paste, Rotate block by a specified angle.
#--
###############################################################
proc BlkCopyPasteRotate { blk axisVec {angle 180} } {
  if {[argCheck $blk "gg::Block"] && [argCheck $axisVec "vector3"] && \
      [argCheck $angle "float" 0 1 360 0]} {
    gg::blkCopyBegin $blk
      gg::xformRotate {0.0 0.0 0.0} $axisVec $angle
    set copies [gg::blkCopyEnd]

    return $copies
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
  if {[argCheck $blk "gg::Block"]} {
    gg::blkReport $blk data STRUCTURE
    return $data(dimensions)
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
  if {[argCheck $blk "gg::BlockStructured"]} {
    if {$face_index == "IMIN"} {
    } elseif {$face_index == "IMAX"} {
    } elseif {$face_index == "JMIN"} {
    } elseif {$face_index == "JMAX"} {
    } elseif {$face_index == "KMIN"} {
    } elseif {$face_index == "KMAX"} {
    } elseif {[argCheck $face_index "integer" 1 1 6 1]} {
    } else {
      puts "or < IMIN | IMAX | JMIN | JMAX | KMIN | KMAX >"
      return -code error "BlkGetFaceDoms"
    }
    set faceList [gg::blkGetFace $blk $face_index]
    return [lindex $faceList 0]
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
  if {[argCheck $blk "gg::Block"]} {
    return [gg::blkName $blk]
  } else {
    return -code error "BlkGetName"
  }
}

###############################################################
#-- PROC: BlkJoin
#--
#-- Join 2 blocks.
#--
###############################################################
proc BlkJoin { blks } {
  if {[expr [llength $blks] == 2] && \
      [argCheck [lindex $blks 0] "gg::Block"] && \
      [argCheck [lindex $blks 1] "gg::Block"]} {

    set blk1 [lindex $blks 0]
    set blk2 [lindex $blks 1]
    gg::blkJoin $blk1 $blk2

  } else {
    return -code error "BlkJoin"
  }
}

###############################################################
#-- PROC: BlkStrReorient
#--
#-- Reorient a block's topological indices.
#--
###############################################################
proc BlkStrReorient { blk imin jmin kmin } {
  if {[argCheck $blk "gg::BlockStructured"] && \
      [argCheck $imin "integer" 0 1] && \
      [argCheck $jmin "integer" 0 1] && \
      [argCheck $kmin "integer" 0 1]} {
    gg::blkSpecifyIJK $blk $imin $jmin $kmin
  } else {
    return -code error [getErrorMsg "BlkStrReorient"]
  }
}

###############################################################
#-- PROC: BlkSetName
#--
#-- Set a block's name.
#--
###############################################################
proc BlkSetName { blk name } {
  if {[argCheck $blk "gg::Block"] && [string length $name] > 0} {
    gg::blkName $blk $name
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
  if {![argCheck $blk gg::Block]} {
    return -code error [getErrorMsg "BlkNewTRexCondition"]
  }
  foreach dom $domList {
    if {![argCheck $dom "gg::Domain"]} {
      return -code error [getErrorMsg "BlkNewTRexCondition"]
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
    return -code error [getErrorMsg "BlkNewTRexCondition"]
  }
  gg::blkUnsSolverBegin $blk
    gg::blkUnsSolverAtt $blk -aniso_delta_s $domList $actualType
  gg::blkUnsSolverEnd
  if {0 != $attributes} {
    BlkSetUnsSolverAttrs $blk $attributes
  }

  return 0
}

###############################################################
#-- PROC: BlkSetUnsSolverAttrs
#--
#-- Set unstructured solver attributes for a target domain.
#--
###############################################################
proc BlkSetUnsSolverAttrs { block attributes } {
  if {![argCheck $block gg::Block]} {
    return -code error [getErrorMsg "BlkSetUnsSolverAttrs"]
  }

  set pwAttrs [list BoundaryDecay EdgeMaximumLength EdgeMinimumLength \
      PyramidMaximumHeight PyramidMinimumHeight PyramidAspectRatio \
      InitialMemorySize IterationCount TRexMaximumLayers TRexFullLayers \
      TRexGrowthRate TRexSpacingSmoothing TRexSpacingRelaxationFactor \
      TRexCollisionBuffer TRexAnisotropicIsotropicBlend \
      TRexSkewCriteriaDelayLayers TRexSkewCriteriaMaximumAngle \
      TRexSkewCriteriaEquivolume TRexSkewCriteriaEquiangle \
      TRexSkewCriteriaCentroid]

  set ggAttrs [list boundary_decay max_edge min_edge max_height min_height \
      aspect_ratio memory iterations aniso_layers aniso_layers_start_modify \
      aniso_growth_rate aniso_delta_s_smooth_iters aniso_delta_s_smooth_relax \
      aniso_collision_buffer aniso_iso_blend aniso_layers_start_skew \
      aniso_skew_max_angle aniso_skew_volume aniso_skew_angle \
      aniso_skew_centroid aniso_delta_s min_size max_size]

  set n [llength $attributes]
  for {set k 0} {$k < $n} {incr k} {
    set att [lindex $attributes $k]
    set val [lindex $attributes [incr k]]

    if {$k > $n} {
      puts "An attribute does not have any corresponding values."
      return -code error [getErrorMsg "BlkSetUnsSolverAttrs"]
    }

    gg::blkUnsSolverBegin $block
    if {"aniso_delta_s" == $att} {
      set type [lindex $attributes [incr k]]
      gg::blkUnsSolverAtt $block -aniso_delta_s $val $type
    } elseif {-1 != [lsearch -exact $ggAttrs $att]} {
      gg::blkUnsSolverAtt $block -$att $val
    } else {
      set pwindex [lsearch -exact $pwAttrs $att]
      if {-1 != $pwindex} {
        set att [lindex $ggAttrs $pwindex]
        gg::blkUnsSolverAtt $block -$att $val
      } else {
        puts "Invalid attribute - $att"
        puts "Attribute must be one of: "
        puts "Gridgen:    $ggAttrs"
        puts "Pointwise:  $pwAttrs"
        puts "This attribute may have no analog in Gridgen. Skipping..."
      }
    }
    gg::blkUnsSolverEnd
  }
}

###############################################################
#-- PROC: BlkSetTRexSpacing
#--
#-- Set T-Rex wall spacing on a set of domains.
#--
###############################################################
proc BlkSetTRexSpacing { block domList spacing } {
  if {![argCheck $block "gg::Block"]} {
    return -code error [getErrorMsg "BlkSetTRexSpacing"]
  } elseif {![argCheck $spacing "float" 0 0]} {
    return -code error [getErrorMsg "BlkSetTRexSpacing"]
  }
  foreach dom $domList {
    if {![argCheck $dom "gg::Domain"]} {
      return -code error [getErrorMsg "BlkSetTRexSpacing"]
    }
  }

  gg::blkUnsSolverBegin $block
    gg::blkUnsSolverAtt $block -aniso_delta_s $domList $spacing
  gg::blkUnsSolverEnd
}

###############################################################
#-- PROC: BlkInitialize
#--
#-- Initializes a list of blocks
#--
###############################################################
proc BlkInitialize { blkList } {
  foreach blk $blkList {
    if {![argCheck $blk "gg::Block"]} {
      return -code error [getErrorMsg "BlkInitialize"]
    }
  }
  foreach blk $blkList {
    gg::blkReport $blk data STRUCTURE
    if {"STRUCTURED" == $data(type)} {
      gg::blkEllSolverBegin $blk
      gg::blkTFISolverRun $blk
      gg::blkEllSolverEnd
    } else {
      gg::blkUnsSolverBegin $blk
      gg::blkUnsSolverInit $blk
      gg::blkUnsSolverFree
      gg::blkUnsSolverEnd
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


