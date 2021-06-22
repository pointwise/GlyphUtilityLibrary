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
#-- Define some useful database commands
#--
##########################################################################


##########################################################################
#--
#-- POINTWISE DATABASE COMMANDS
#--
##########################################################################

namespace eval gul {

###############################################################
#-- PROC: DbGetAll
#--
#-- Get a list of all database entities.
#--
###############################################################
proc DbGetAll { } {
  return [pw::Database getAll]
}

###############################################################
#-- PROC: DbExtractCurves
#--
#-- Extract surfaces and curves from a db shell.
#--
###############################################################
proc DbExtractCurves { db angle } {
  if {![argCheck $db "pw::Shell"]} {
    return -code error [getErrorMsg "DbExtractCurves"]
  }
  if { [catch {
    set extractedDbs [$db extractCurves $angle]
  } eid] } {
    return -code error [getErrorMsg "DbExtractCurves"]
  } else {
    return extractedDbs
  }
}

###############################################################
#-- PROC: DbCreateConic
#--
#-- Create a CONIC DB curve from 2 end points,
#-- a tangency point, and rho value.
#--
#-- Returns the new database ID.
#--
###############################################################
proc DbCreateConic { pt1 pt2 tan_pt rho } {
  if {[argCheck $pt1 "vector3"] && \
      [argCheck $pt2 "vector3"] && \
      [argCheck $tan_pt "vector3"] && \
      [argCheck $rho "float" 0 1 1 1]} {
    set db [pw::Curve create]
    set seg [pw::SegmentConic create]
    $seg addPoint $pt1
    $seg addPoint $pt2
    $seg setIntersectPoint  $tan_pt
    $seg setRho $rho
    $db addSegment $seg
    return $db
  } else {
    return -code error [getErrorMsg "DbCreateConic"]
  }
}

###############################################################
#-- PROC: DbCreateLine
#--
#-- Create a piecewise linear DB curve.
#--
###############################################################
proc DbCreateLine { pt_list } {
  foreach pt $pt_list {
    if {![argCheck $pt "vector3"]} {
      return -code error [getErrorMsg "DbCreateLine"]
    }
  }
  set mode [pw::Application begin Create]
  set seg [pw::SegmentSpline create]
    foreach pt $pt_list {
      $seg addPoint $pt
    }
  set curve [pw::Curve create]
  $curve addSegment $seg
  $mode end
  return $curve
}

###############################################################
#-- PROC: DbCreateSurface
#--
#-- Create a database surface.
#--
###############################################################
proc DbCreateSurface { dbEnts } {
  foreach db $dbEnts {
    if {![argCheck $db "pw::Curve"]} {
      return -code error [getErrorMsg "DbCreateSurface"]
    }
  }
  return [pw::Surface createFromCurves $dbEnts]
}

###############################################################
#-- PROC: DbQuiltFromSurfaces
#--
#-- Create a quilt from trimmed surfaces.
#--
###############################################################
proc DbQuiltFromSurfaces { dbEnts {tol 0} } {
  foreach db $dbEnts {
    if {![argCheck $db "pw::DatabaseEntity"]} {
      return -code error [getErrorMsg "DbQuiltFromSurfaces"]
    }
  }
  if {[argCheck $tol "float" 0 1]} {
    set allDbs [pw::Database getAll]
    foreach db $allDbs {
      if {[$db getDescription]=="Model"} {
        $db explode
      }
    }

    foreach dbEnt $dbEnts {
      set type [$dbEnt getDescription]
      if {$type == "TrimmedSurface"} {
        lappend models [$dbEnt getModel]
        lappend quilts [$dbEnt getQuilt]
      } elseif {$type == "BSplineSurface"} {
        lappend models [pw::Model assemble $dbEnt]
        lappend quilts [[lindex $models end] getQuilt 1]
      } elseif {$type == "Model"} {
        lappend models $dbEnt
        lappend quilts [[lindex $models end] getQuilt 1]
      } else {
        puts "Surfaces consist of entities that are neither trimmed or bspline surfaces. Please redefine."
        puts "[$dbEnt getName] $type"
      }
    }

    if {$tol > 0} {
      pw::Model assemble -tolerance $tol $models
    } else {
      pw::Model assemble $models
    }

    return [pw::Quilt assemble $quilts]
  } else {
    return -code error [getErrorMsg "DbQuiltFromSurfaces"]
  }
}

###############################################################
#-- PROC: DbRevolve
#--
#-- Create a revolved DB surface from DB curve.
#--
#-- Returns the new database surface object.
#--
###############################################################
proc DbRevolve {db angle axis { fixedPt "0 0 0"} } {
  if {[argCheck $db "pw::Curve"] && \
      [argCheck $angle "float" -360 1 360 1] && \
      [argCheck $fixedPt "vector3"]} {
    if {$angle == 0} {
      printDetails $angle "value != 0"
      return -code error [getErrorMsg "DbRevolve"]
    }
    if {![argCheck $axis "axis"] && ![argCheck $axis "vector3"]} {
      puts "Invalid axis"
      return -code error [getErrorMsg "DbRevolve"]
    }

    if { $axis == "X" } {
      set axisVec "1 0 0"
    } elseif { $axis == "Y" } {
      set axisVec "0 1 0"
    } elseif { $axis == "Z" } {
      set axisVec "0 0 1"
    } else {
      set axisVec $axis
    }

    set surface [pw::Surface create]
    $surface revolve -angle $angle $db $fixedPt $axisVec

    return $surface
  } else {
    return -code error [getErrorMsg "DbRevolve"]
  }
}

###############################################################
#-- PROC: DbAdd2Vectors
#--
#-- Add two vectors.
#--
###############################################################
proc DbAdd2Vectors {vecA vecB} {
  if {[argCheck $vecA "vector3"] && \
      [argCheck $vecB "vector3"]} {
    return [pwu::Vector3 add $vecA $vecB]
  } elseif {[argCheck $vecA "vector2"] && \
            [argCheck $vecB "vector2"]} {
    return [pwu::Vector2 add $vecA $vecB]
  } else {
    return -code error [getErrorMsg "DbAdd2Vectors"]
  }
}

###############################################################
#-- PROC: DbArcLengthToU
#--
#-- Convert an arc length location for a DB curve to a U value.
#-- Returns the equivalent U value on the curve.
#--
###############################################################
proc DbArcLengthToU { db_id arc_length } {
  if {[argCheck $db_id "pw::Curve"] && \
      [argCheck $arc_length "float" 0 1 1 1]} {

    #-- Handle the curve endpoints exactly
    if { $arc_length == 0.0 } {
      return 0.0
    }
    if { $arc_length == 1.0 } {
      return 1.0
    }

    set num_intervals 100
    set u_min 0.0
    set u_max 1.0
    set delta [expr ($u_max-$u_min)/$num_intervals]
    set u1 $u_min
    set total_length 0.0
    for {set i 0} {$i < $num_intervals} {incr i} {
      set int($i,u1) $u1
      set int($i,s1) $total_length
      set pt1 [$db_id getXYZ $u1]
      if { $i == [expr $num_intervals-1] } {
        #-- Make sure to include exact curve endpoint
        set u2 1.0
      } else {
        set u2 [expr $u1+$delta]
      }
      set pt2 [$db_id getXYZ $u2]
      set diff [pwu::Vector3 subtract $pt1 $pt2]
      set diff [pwu::Vector3 length $diff]
      set total_length [expr $total_length+$diff]
      set int($i,u2) $u2
      set int($i,s2) $total_length
      set u1 $u2
    }

    set s [expr $arc_length*$total_length]

    for {set i 0} {$i < $num_intervals} {incr i} {
      if {$int($i,s2) >= $s} {
        set w [expr ($s-$int($i,s1)) / ($int($i,s2)-$int($i,s1))]
        set u [expr $int($i,u1) + $w*($int($i,u2)-$int($i,u1))]
        return $u
      }
    }
    puts "DbCrvSToU: Failed to find equivalent U value for arc length $arc_length"
    return -1
  } else {
    return -code error [getErrorMsg "DbArcLengthToU"]
  }
}

###############################################################
#-- PROC: DbDelete
#--
#-- Delete database.
#--
###############################################################
proc DbDelete { db } {
  if {[argCheck $db "pw::Entity"]} {
    pw::Entity delete $db
  } else {
    return -code error [getErrorMsg "DbDelete"]
  }
}

###############################################################
#-- PROC: DbEnableDisable
#--
#-- Changes the enabled status of a list of database entities.
#--
###############################################################
proc DbEnableDisable { dbList {enabled TRUE} } {
  foreach db $dbList {
    if {![argCheck $db "pw::DatabaseEntity"]} {
      return -code error [getErrorMsg "DbEnableDisable"]
    }
  }
  if {[argCheck $enabled "boolean"]} {
    foreach db $dbList {
      $db setEnabled $enabled
    }
  } else {
    return -code error [getErrorMsg "DbEnableDisable"]
  }
}

###############################################################
#-- PROC: DbExportSegment
#--
#-- Export connectors as a segment file.
#--
###############################################################
proc DbExportSegment { conList fname } {
  foreach con $conList {
    if {![argCheck $con "pw::Connector"]} {
      return -code error [getErrorMsg "DbExportSegment"]
    }
  }
  pw::Grid export -type Segment -precision Double $conList $fname
}

###############################################################
#-- PROC: DbGetByName
#--
#-- Get database entity by name.
#--
###############################################################
proc DbGetByName { name } {
  if { [catch {set p [pw::DatabaseEntity getByName $name]} eid] } {
    puts "No database entity named $name exists"
    exit 1
  } else {
    return $p
  }
}

###############################################################
#-- PROC: DbGetClosestPoint
#--
#-- Determines the location of the closest point on a
#-- DB curve to the given point.
#-- Returns the curve point, the non-dimensional S coordinate,
#-- and the non-dimensional U coordinate.
#--
###############################################################
proc DbGetClosestPoint { db_id source_pt } {
  if {[argCheck $db_id "pw::DatabaseEntity"] && \
      [argCheck $source_pt "vector3"]} {
    set umin 0.0
    set umax 1.0
    set num_intervals 200
    set delta [expr ($umax-$umin)/$num_intervals]

    set dist_min 1e9
    set total_dist 0.0

    for {set i 0} {$i <= $num_intervals} {incr i} {
      set u [expr $umin+$i*$delta]
      set pt [$db_id getXYZ $u]
      if { $i > 0 } {
        set dist [pwu::Vector3 subtract $pt $pt_old]
        set dist [pwu::Vector3 length $dist]
        set total_dist [expr $total_dist+$dist]
      }

      set dist [pwu::Vector3 subtract $pt $source_pt]
      set dist [pwu::Vector3 length $dist]
      if { $dist < $dist_min } {       set dist_min $dist
        set dist_min_u $u
        set dist_min_s $total_dist
        set dist_min_pt $pt
      }
      set pt_old $pt
    }

    set dist_min_s [expr $dist_min_s/$total_dist]
    set rtn [list $dist_min_pt $dist_min_s $dist_min_u]
    return $rtn
  } else {
    return -code error [getErrorMsg "DbGetClosestPoint"]
  }
}

###############################################################
#-- PROC: DbGetExtents
#--
#-- Get entity extents box.
#--
###############################################################
proc DbGetExtents { ent } {
  if {[argCheck $ent "pw::Entity"]} {
    return [$ent getExtents]
  } else {
    return -code error [getErrorMsg "DbGetExtents"]
  }
}

###############################################################
#-- PROC: DbGetInPlaneAxis
#--
#-- Get in plane axis.
#--
###############################################################
proc DbGetInPlaneAxis { pt1 pt2 } {
  if {[argCheck $pt1 "vector3"] && \
      [argCheck $pt2 "vector3"]} {
    set crossProd     [pwu::Vector3 cross $pt1 $pt2]
    set normCrossProd [pwu::Vector3 normalize $crossProd]

    if {[lindex $normCrossProd 0] == 1 || [lindex $normCrossProd 0] == -1} {
      set plane X
    } elseif {[lindex $normCrossProd 1] == 1 || [lindex $normCrossProd 1] == -1} {
      set plane Y
    } elseif {[lindex $normCrossProd 2] == 1 || [lindex $normCrossProd 2] == -1} {
      set plane Z
    }
    return $plane
  } else {
    return -code error [getErrorMsg "DbGetInPlaneAxis"]
  }
}

###############################################################
#-- PROC: DbGetModelSize
#--
#-- Get the current model size.
#--
###############################################################
proc DbGetModelSize { } {
  return [pw::Database getModelSize]
}

##############################################################
#-- PROC: DbGetNodeTolerance
#--
#-- Return the current node tolerance.
#--
###############################################################
proc DbGetNodeTolerance { } {
  return [pw::Grid getNodeTolerance]
}

#############################################################
#-- PROC: DbGetTangentCylindricalPoint
#--
#-- Find a tangency point of two DB curve ends in the
#-- Cylindrical theta=0 plane.
#--
#-- Returns a 2 element list:
#--    {status {tangency point in RTA}}
#--
#--    status = 1 if tangency point found, otherwise 0.
#--
#############################################################
proc DbGetTangentCylindricalPoint { crv1 s_end1 crv2 s_end2 axis theta {multiplier 1} } {
  if {[argCheck $crv1 "pw::Curve"] && \
      [argCheck $s_end1 "float" 0 1 1 1] && \
      [argCheck $crv2 "pw::Curve"] && \
      [argCheck $s_end2 "float" 0 1 1 1] && \
      [argCheck $axis "axis" 0] && \
      [argCheck $theta "float" 0 1 360 1] && \
      [argCheck $multiplier "float"]} {
    set delta_s 0.01
    set zero_tol [expr [DbGetModelSize]/1e10]
    if {$s_end1 < 0.5} {
      set s1 $s_end1
      set s2 [expr $s1+$delta_s]
    } else {
      set s2 $s_end1
      set s1 [expr $s2-$delta_s]
    }
    set p1_xyz [DbGetXYZatU $crv1 $s1]
    set p2_xyz [DbGetXYZatU $crv1 $s2]
    set p1_rta [CartesianToCylindrical $axis $p1_xyz]
    set p2_rta [CartesianToCylindrical $axis $p2_xyz]


    if {$s_end2 < 0.5} {
      set s1 $s_end2
      set s2 [expr $s1+$delta_s]
    } else {
      set s2 $s_end2
      set s1 [expr $s2-$delta_s]
    }
    set p3_xyz [DbGetXYZatU $crv2 $s1]
    set p4_xyz [DbGetXYZatU $crv2 $s2]
    set p3_rta [CartesianToCylindrical $axis $p3_xyz]
    set p4_rta [CartesianToCylindrical $axis $p4_xyz]

    # Find intersection of lines P1-P2 and P3-P4 in R-A space
    set p1_r [lindex $p1_rta 0]
    set p1_a [lindex $p1_rta 2]
    set p2_r [lindex $p2_rta 0]
    set p2_a [lindex $p2_rta 2]
    set p3_r [lindex $p3_rta 0]
    set p3_a [lindex $p3_rta 2]
    set p4_r [lindex $p4_rta 0]
    set p4_a [lindex $p4_rta 2]

    set ua_numer [expr ($p4_a-$p3_a)*($p1_r-$p3_r) - ($p4_r-$p3_r)*($p1_a-$p3_a)]

    set ub_numer [expr ($p2_a-$p1_a)*($p1_r-$p3_r) - ($p2_r-$p1_r)*($p1_a-$p3_a)]

    set denom [expr ($p4_r-$p3_r)*($p2_a-$p1_a) - ($p4_a-$p3_a)*($p2_r-$p1_r)]

    if {[expr abs($denom)] < $zero_tol} {
      if {[expr abs($ua_numer)] < $zero_tol && \
          [expr abs($ub_numer)] < $zero_tol} {
        # lines are coincident
        return [list 0 "0 0 0"]
      } else {
        # lines are parallel
        if {$s_end2 < 0.5} {
          set s2 $s_end2
          set s1 [expr $s1+$delta_s]
        } else {
          set s2 $s_end2
          set s1 [expr $s2-$delta_s]
        }
        set p3_xyz [DbGetXYZatU $crv2 $s1]
        set p4_xyz [DbGetXYZatU $crv2 $s2]
        set p3_rta [CartesianToCylindrical $axis $p3_xyz]
        set p4_rta [CartesianToCylindrical $axis $p4_xyz]
        set dirr [expr [lindex $p4_rta 0] - [lindex $p3_rta 0]]
        set dirt [expr [lindex $p4_rta 1] - [lindex $p3_rta 1]]
        set dira [expr [lindex $p4_rta 2] - [lindex $p3_rta 2]]
        set dr [expr pow($dirr,2)]
        set dt [expr pow($dirt,2)]
        set da [expr pow($dira,2)]
        set dist [expr sqrt($dr+$dt+$da)]
        set dirr [expr $dirr/$dist]
        set dirt [expr $dirt/$dist]
        set dira [expr $dira/$dist]

        set p1_xyz [DbGetXYZatU $crv1 $s_end1]
        set p2_xyz [DbGetXYZatU $crv2 $s_end2]
        set p1_rta [CartesianToCylindrical $axis $p1_xyz]
        set p2_rta [CartesianToCylindrical $axis $p2_xyz]

        set midr [expr ([lindex $p1_rta 0] + [lindex $p2_rta 0])/2.0]
        set midt [expr ([lindex $p1_rta 1] + [lindex $p2_rta 1])/2.0]
        set mida [expr ([lindex $p1_rta 2] + [lindex $p2_rta 2])/2.0]

        set dr [expr pow([lindex $p1_rta 0]-[lindex $p2_rta 0],2)]
        set dt [expr pow([lindex $p1_rta 1]-[lindex $p2_rta 1],2)]
        set da [expr pow([lindex $p1_rta 2]-[lindex $p2_rta 2],2)]

        set dist [expr sqrt($dr+$dt+$da) * 5.0]

        set tanR [expr $midr+$dist*$dirr]
        set tanT [expr $midt+$dist*$dirt]
        set tanA [expr $mida+$dist*$dira]

        return [list 1 "$tanR $tanT $tanA"]
      }
    }
    # lines intersect
    set ua [expr $ua_numer / $denom]

    set int_a [expr $p1_a+$multiplier*$ua*($p2_a-$p1_a)]
    set int_r [expr $p1_r+$multiplier*$ua*($p2_r-$p1_r)]

    return [list 1 "$int_r $theta $int_a"]
  } else {
    return -code error [getErrorMsg "DbGetTangentCylindricalPoint"]
  }
}

#############################################################
#-- PROC: DbGetUatTargetAxial
#--
#-- Find the U position (model space parameter) of a point on
#-- a db curve with the target axial value.
#-- Begins by marching in the direction of increasing U
#-- from the given starting U location.
#-- Returns the first point satisfying the target axial value.
#-- Note: because of the nature of the marching algorithm, certain
#-- input can cause the routine to miss finding a valid point.
#-- For example, trying to find a point at or near the inflection point
#-- of an arc.  In this case, the algorithm will not recognize that
#-- it has passed the target point location during the marching step.
#-- Locating an inflection point would be more robust using point projection.
#--
#-- Input:
#--   db            - db curve ID
#--   targetAxial  - target value
#--   axis          - cylindrical axis (X,Y,Z)
#--   u_start       - initial position on curve
#--   tol           - precision
#--
#-- Returns a 2 element list:
#--    {status s}
#--
#--    status = 1 if target point found, otherwise 0.
#--
#############################################################
proc DbGetUatTargetAxial { db targetAxial axis u_start tol } {
  if {[argCheck $db "pw::Curve"] && \
      [argCheck $targetAxial "float"] && \
      [argCheck $axis "axis" 0] && \
      [argCheck $u_start "float" 0 1 1 1] && \
      [argCheck $tol "float" 0 1]} {
    set s_dir 1
    set deltaS [expr 0.1 * $s_dir]
    set s $u_start
    set hit_curve_end 0
    while {1} {
      set xyz [DbGetXYZatU $db $s]
      set rta [CartesianToCylindrical $axis $xyz]
      set a [lindex $rta 2]
      set diff [expr $targetAxial - $a]
      set sign 1
      if {$diff < 0.0} {
        set sign -1
      }
      set absdiff [expr abs($diff)]
      if {$absdiff < $tol} {
        set status 1
        break
      }
      if {[info exists old_sign] && $old_sign != $sign } {
        #-- passed by the target location
        set s_dir [expr -1 * $s_dir];      # reverse direction
        set deltaS [expr $deltaS / 2.0];   # reduce march step
        #puts "reversed direction - s=$s"
      }
      set old_sign $sign
      set s [expr $s + $s_dir * $deltaS]
      if { $s > 1.0 || $s < 0.0} {
        #puts "walked off the end of the curve $hit_curve_end - s=$s"
        if {$hit_curve_end > 10} {
          #-- We have hit the curve ends too many times - get out
          puts "DbCurveGetSatRadius: Failed to find target radius position"
          set status 0
          break
        }
        incr hit_curve_end 1
        set s_dir [expr -1 * $s_dir];      # reverse direction

        if {$hit_curve_end > 1} {
          #-- We have bounced off both ends now.
          #-- Assume we are trying to hit an inflection point.
          #-- Reduce the step size hoping to straddle the target
          #-- point within a monotonic section of the curve
          set deltaS [expr $deltaS / 2.0];   # reduce march step
        }
        if {$s > 1.0} {
	  set s 1.0
        } else {
          set s 0.0
        }

        #puts "s_dir:$s_dir s:$s"
      }
    }
    return [list $status $s]
  } else {
    return -code error [getErrorMsg "DbGetUatTargetAxial"]
  }
}

#############################################################
#-- PROC: DbGetUatTargetRadius
#--
#-- Find the U position (model space parameter) of a point on
#-- a db curve with the target radial value.
#-- Begins by marching in the direction of increasing U
#-- from the given starting U location.
#-- Returns the first point satisfying the target radial value.
#-- Note: because of the nature of the marching algorithm, certain
#-- input can cause the routine to miss finding a valid point.
#-- For example, trying to find a point at or near the inflection point
#-- of an arc.  In this case, the algorithm will not recognize that
#-- it has passed the target point location during the marching step.
#-- Locating an inflection point would be more robust using point projection.
#--
#-- Input:
#--   db            - db curve ID
#--   targetRadius  - target value
#--   axis          - cylindrical axis (X,Y,Z)
#--   u_start       - initial position on curve
#--   tol           - precision
#--
#-- Returns a 2 element list:
#--    {status s}
#--
#--    status = 1 if target point found, otherwise 0.
#--
#############################################################
proc DbGetUatTargetRadius { db targetRadius axis u_start tol } {
  if {[argCheck $db "pw::DatabaseEntity"] && \
      [argCheck $targetRadius "float" 0 1] && \
      [argCheck $axis "axis" 0] && \
      [argCheck $u_start "float" 0 1 1 1] && \
      [argCheck $tol "float" 0 1]} {
    set s_dir 1
    set deltaS [expr 0.1 * $s_dir]
    set s $u_start
    set hit_curve_end 0
    while {1} {
      set xyz [DbGetXYZatU $db $s]
      set rta [CartesianToCylindrical $axis $xyz]
      set r [lindex $rta 0]
      set diff [expr $targetRadius - $r]
      set sign 1
      if {$diff < 0.0} {
        set sign -1
      }
      set absdiff [expr abs($diff)]
      if {$absdiff < $tol} {
        set status 1
          break
        }
      if {[info exists old_sign] && $old_sign != $sign } {
        #-- passed by the target location
        set s_dir [expr -1 * $s_dir];      # reverse direction
        set deltaS [expr $deltaS / 2.0];   # reduce march step
        #puts "reversed direction - s=$s"
      }
      set old_sign $sign
      set s [expr $s + $s_dir * $deltaS]
      if { $s > 1.0 || $s < 0.0} {
        #puts "walked off the end of the curve $hit_curve_end - s=$s"
        if {$hit_curve_end > 10} {
          #-- We have hit the curve ends too many times - get out
          puts "DbCurveGetSatRadius: Failed to find target radius position"
          set status 0
          break
        }
        incr hit_curve_end 1
        set s_dir [expr -1 * $s_dir];      # reverse direction

        if {$hit_curve_end > 1} {
          #-- We have bounced off both ends now.
          #-- Assume we are trying to hit an inflection point.
          #-- Reduce the step size hoping to straddle the target
          #-- point within a monotonic section of the curve
          set deltaS [expr $deltaS / 2.0];   # reduce march step
        }

        if {$s > 1.0} {
          set s 1.0
        } else {
          set s 0.0
        }

        #puts "s_dir:$s_dir s:$s"
      }
    }
    return [list $status $s]
  } else {
    return -code error [getErrorMsg "DbGetUatTargetRadius"]
  }
}

###############################################################
#-- PROC: DbGetWithRootName
#--
#-- Get all database entities with the given rootname.
#--
###############################################################
proc DbGetWithRootName { root } {
  set dbEnts [pw::Database getAll]
  set dbMatches []
  foreach db $dbEnts {
    if {[string match "$root*" [$db getName]]==1} {
      lappend dbMatches $db
    }
  }
  return $dbMatches
}

###############################################################
#-- PROC: DbGetXYZatU
#--
#-- Determines the x,y,z coordinates on a DB curve at
#-- specified U coordinate.
#--
###############################################################
proc DbGetXYZatU { db_id arc_length } {
  if {[argCheck $db_id "pw::DatabaseEntity"] && \
      [argCheck $arc_length "float" 0 1 1 1]} {
    return [$db_id getXYZ $arc_length]
  } else {
    return -code error [getErrorMsg "DbGetXYZatU"]
  }
}

###############################################################
#-- PROC: DbImport
#--
#-- Import database.
#--
###############################################################
proc DbImport { fname } {
  if { [catch {pw::Database import $fname} eid] } {
    puts "The file $fname could not be imported."
    #exit 1
  }
}

###############################################################
#-- PROC: DbIntersect
#--
#-- Intersect two groups of database entities.
#--
###############################################################
proc DbIntersect { group1 group2 } {
  foreach db $group1 {
    if {![argCheck $db "pw::DatabaseEntity"]} {
      return -code error [getErrorMsg "DbIntersect"]
    }
  }
  foreach db $group2 {
    if {![argCheck $db "pw::DatabaseEntity"]} {
      return -code error [getErrorMsg "DbIntersect"]
    }
  }
  return [pw::Database intersect $group1 $group2]
}

###############################################################
#-- PROC: DbIsolateLayer
#--
#-- Isolate a database layer.
#--
###############################################################
proc DbIsolateLayer { layer } {
  if {[argCheck $layer "integer" 0 1 1023 1]} {
    pw::Display isolateLayer $layer
  } else {
    return -code error [getErrorMsg "DbIsolateLayer"]
  }
}

###############################################################
#-- PROC: DbJoin2
#--
#-- Join two database surfaces.
#--
###############################################################
proc DbJoin2 { dbEnts } {
  foreach db $dbEnts {
    if {![argCheck $db "pw::Surface"]} {
      return -code error [getErrorMsg "DbJoin2"]
    }
  }
  return [pw::Surface join $dbEnts]
}

###############################################################
#-- PROC: DbNormalizeVector
#--
#-- Normalize a vector.
#--
###############################################################
proc DbNormalizeVector { vec } {
  if {[expr [llength $vec] == 3]} {
    if {[argCheck $vec "vector3"]} {
      return [pwu::Vector3 normalize $vec]
    }
  } elseif {[expr [llength $vec] == 2]} {
    if {[argCheck $vec "vector2"]} {
      return [pwu::Vector2 normalize $vec]
    }
  }
  return -code error [getErrorMsg "DbNormalizeVector"]
}

###############################################################
#-- PROC: DbSetLayer
#--
#-- Set database entity's layer.
#--
###############################################################
proc DbSetLayer { dbList layer } {
  foreach db $dbList {
    if {![argCheck $db "pw::DatabaseEntity"]} {
      return -code error [getErrorMsg "DbSetLayer"]
    }
  }
  if {[argCheck $layer "integer" 0 1 1023 1]} {
    foreach db $dbList {
      $db setLayer $layer
    }
  } else {
    return -code error [getErrorMsg "DbSetLayer"]
  }
}

###############################################################
#-- PROC: DbSetModelSize
#--
#-- Set current model size.
#--
###############################################################
proc DbSetModelSize { size } {
  if {[argCheck $size "float" 0 0]} {
    pw::Database setModelSize [expr ceil($size)]
  } else {
    return -code error [getErrorMsg "DbSetModelSize"]
  }
}

###############################################################
#-- PROC: DbSetNodeTolerance
#--
#-- Set current node tolerance.
#--
###############################################################
proc DbSetNodeTolerance { tol } {
  if {[argCheck $tol "float" 0 0]} {
    pw::Grid setNodeTolerance $tol
  } else {
    return -code error [getErrorMsg "DbSetNodeTolerance"]
  }
}

###############################################################
#-- PROC: DbSplitCurve
#--
#-- Split database curve at coordinate.
#--
###############################################################
proc DbSplitCurve { db param } {
  if {[argCheck $db "pw::Curve"]} {
    foreach pm $param {
      if {![argCheck $pm "float" 0 1 1 1]} {
        return -code error [getErrorMsg "DbSplitCurve"]
      }
    }
    return [lindex [$db split $param] 1]
  } else {
    return -code error [getErrorMsg "DbSplitCurve"]
  }
}

###############################################################
#-- PROC: DbSubtract2Vectors
#--
#-- Subtract two vectors.
#--
###############################################################
proc DbSubtract2Vectors { vecA vecB } {
  if {[argCheck $vecA "vector3"] && \
      [argCheck $vecB "vector3"]} {
    return [pwu::Vector3 subtract $vecA $vecB]
  } elseif {[argCheck $vecA "vector2"] && \
            [argCheck $vecB "vector2"]} {
    return [pwu::Vector2 subtract $vecA $vecB]
  } else {
    return -code error [getErrorMsg "DbSubtract2Vectors"]
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

