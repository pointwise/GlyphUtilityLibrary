#############################################################################
#
# (C) 2021 Cadence Design Systems, Inc. All rights reserved worldwide.
#
# This sample script is not supported by Cadence Design Systems, Inc.
# It is provided freely for demonstration purposes only.
# SEE THE WARRANTY DISCLAIMER AT THE BOTTOM OF THIS FILE.
#
#############################################################################

package require PWI_Glyph

# path to GUL folder:
set guldir [file dirname [info script]]
set utildir [file join $guldir ".."]
source [file join $utildir "version.glf"]
# ----------------------------------------------------

gul::ApplicationReset

# ************ dbutil proc tests ************
# Set default connector dimension
gul::ConSetDefaultDimension 20 0.1 0.1

# ---------------- DbCreateConic ------------------
puts "DbCreateConic"

set pt1 "3 1 4"
set pt2 "1 5 9"
set tan_pt "2 6 5"
set rho 0.4
set dbConic [gul::DbCreateConic $pt1 $pt2 $tan_pt $rho]
puts $dbConic

puts "--------------"
#-------------------------------------------------

# ---------------- DbCreateLine ------------------
puts "DbCreateLine"

set ptList [list "3 5 8" "9 7 9" "3 2 3" "-1 -2 3"]
set dbLine [gul::DbCreateLine $ptList]
puts $dbLine

puts "--------------"
#-------------------------------------------------

# ---------------- DbCreateSurface ------------------
puts "DbCreateSurface"

set line1 [gul::DbCreateLine [list "0 0 0" "1 1 0"]]
set line2 [gul::DbCreateLine [list "1 1 0" "1 1 2"]]
set line3 [gul::DbCreateLine [list "1 1 2" "0 0 2"]]
set line4 [gul::DbCreateLine [list "0 0 2" "0 0 0"]]
set dbSurf [gul::DbCreateSurface [list $line1 $line2 $line3 $line4]]
puts $dbSurf

set line1 [gul::DbCreateLine [list "0 0 0" "-1 1 0"]]
set line2 [gul::DbCreateLine [list "-1 1 0" "-1 1 2"]]
set line3 [gul::DbCreateLine [list "-1 1 2" "0 0 2"]]
set line4 [gul::DbCreateLine [list "0 0 2" "0 0 0"]]
set dbSurf2 [gul::DbCreateSurface [list $line1 $line2 $line3 $line4]]
puts $dbSurf2

puts "--------------"
#-------------------------------------------------

# ---------------- DbQuiltFromSurfaces ------------------*
puts "DbQuiltFromSurfaces"

set quilt [gul::DbQuiltFromSurfaces [list $dbSurf $dbSurf2] 0.01]
puts $quilt

puts "--------------"
#-------------------------------------------------

# ---------------- DbRevolve ------------------
puts "DbRevolve"

set dbRevSurf [gul::DbRevolve $line1 360 "X" "0 0 5"]
puts $dbRevSurf

puts "--------------"
#-------------------------------------------------

# ---------------- DbAdd2Vectors ------------------
puts "DbAdd2Vectors"

set v1 "1 2 3"
set v2 "-3 -2 -1"
set v [gul::DbAdd2Vectors $v1 $v2]
puts $v

puts "--------------"
#-------------------------------------------------

# ---------------- DbArcLengthToU ------------------
puts "DbArcLengthToU"

set u [gul::DbArcLengthToU $line3 0.5]
puts $u

puts "--------------"
#-------------------------------------------------

# ---------------- DbDelete ------------------
puts "DbDelete"

gul::DbDelete $dbConic

puts "--------------"
#-------------------------------------------------

# ---------------- DbEnableDisable ------------------
puts "DbEnableDisable"

gul::DbEnableDisable [list $line1 $dbRevSurf $dbSurf] FALSE

puts "--------------"
#-------------------------------------------------

gul::DbEnableDisable [list $line1 $dbRevSurf $dbSurf] TRUE

# ---------------- DbExportSegment ------------------
puts "DbExportSegment"

set con1 [gul::ConFrom2Points "1 1 1" "2 2 2"]
set con2 [gul::ConFrom2Points "3 3 3" "4 4 4"]
gul::DbExportSegment [list $con1 $con2] "cons.txt"

puts "--------------"
#-------------------------------------------------

# ---------------- DbGetByName ------------------
puts "DbGetByName"

set target [gul::DbGetByName "curve-2"]
puts $target

puts "--------------"
#-------------------------------------------------

# ---------------- DbGetClosestPoint ------------------
puts "DbGetClosestPoint"

set targetPoint "0 0 0"
set closest [gul::DbGetClosestPoint $line2 $targetPoint]
puts $closest

puts "--------------"
#-------------------------------------------------

# ---------------- DbGetExtents ------------------
puts "DbGetExtents"

set extents [gul::DbGetExtents $dbSurf]
puts $extents

puts "--------------"
#-------------------------------------------------

# ---------------- DbGetInPlaneAxis ------------------
puts "DbGetInPlaneAxis"

set pt1 "2 3 0"
set pt2 "-1 4 0"
set planeAxis [gul::DbGetInPlaneAxis $pt1 $pt2]
puts $planeAxis

puts "--------------"
#-------------------------------------------------

# ---------------- DbGetModelSize ------------------
puts "DbGetModelSize"

set ms [gul::DbGetModelSize]
puts $ms

puts "--------------"
#-------------------------------------------------

# ---------------- DbGetNodeTolerance ------------------
puts "DbGetNodeTolerance"

set nt [gul::DbGetNodeTolerance]
puts $nt

puts "--------------"
#-------------------------------------------------

# ---------------- DbGetTangentCylindricalPoint ------------------
puts "DbGetTangentCylindricalPoint"

set tan [gul::DbGetTangentCylindricalPoint $line1 0.7 $line2 0.7 "Z" 20]
puts $tan

puts "--------------"
#-------------------------------------------------

# ---------------- DbGetUatTargetAxial ------------------
puts "DbGetUatTargetAxial"

set u [gul::DbGetUatTargetAxial $line4 0.25 "Z" 0 0.01]
puts $u

puts "--------------"
#-------------------------------------------------

# ---------------- DbGetUatTargetRadius ------------------
puts "DbGetUatTargetRadius"

set u [gul::DbGetUatTargetRadius $line3 1 "Z" 0 0.01]
puts $u

puts "--------------"
#-------------------------------------------------

# ---------------- DbGetWithRootName ------------------
puts "DbGetWithRootName"

set matches [gul::DbGetWithRootName "surface"]
puts $matches

puts "--------------"
#-------------------------------------------------

# ---------------- DbGetXYZatU ------------------
puts "DbGetXYZatU"

set xyz [gul::DbGetXYZatU $line2 0.1]
puts $xyz

puts "--------------"
#-------------------------------------------------

# ---------------- DbIsolateLayer ------------------
puts "DbIsolateLayer"

gul::DbIsolateLayer 10

puts "--------------"
#-------------------------------------------------

gul::DbIsolateLayer 0

# ---------------- DbJoin2 ------------------
puts "DbJoin2"

set line5 [gul::DbCreateLine [list "0 0 2" "0 -1 2"]]
set line6 [gul::DbCreateLine [list "0 -1 2" "-1 -1 2"]]
set line7 [gul::DbCreateLine [list "-1 -1 2" "-1 1 2"]]

set dbSurf3 [gul::DbCreateSurface [list $line3 $line5 $line6 $line7]]

set line8 [gul::DbCreateLine [list "-1 -1 2" "-3 -1 2"]]
set line9 [gul::DbCreateLine [list "-3 -1 2" "-3 1 2"]]
set line10 [gul::DbCreateLine [list "-3 1 2" "-1 1 2"]]

set dbSurf4 [gul::DbCreateSurface [list $line7 $line8 $line9 $line10]]

# The DbJoin2 command is not tested here due to the fact that Gridgen
# and Pointwise performs differntly as db surfaces are joined.
#set union [gul::DbJoin2 [list $dbSurf3 $dbSurf4]]
#puts $union

puts "--------------"
#-------------------------------------------------

# ---------------- DbIntersect ------------------
puts "DbIntersect"

set intersection [gul::DbIntersect $dbSurf $dbRevSurf]
puts $intersection

puts "--------------"
#-------------------------------------------------

# ---------------- DbNormalizeVector ------------------
puts "DbNormalizeVector"

set v1 "1 2 3"
set v2 "31 4"
puts [gul::DbNormalizeVector $v1]
puts [gul::DbNormalizeVector $v2]

puts "--------------"
#-------------------------------------------------

# ---------------- DbSetLayer ------------------
puts "DbSetLayer"

gul::DbSetLayer [list $dbSurf $dbRevSurf] 0

puts "--------------"
#-------------------------------------------------

# ---------------- DbSetModelSize ------------------
puts "DbSetModelSize"

gul::DbSetModelSize 100

puts "--------------"
#-------------------------------------------------

# ---------------- DbSetNodeTolerance ------------------
puts "DbSetNodeTolerance"

gul::DbSetNodeTolerance 0.0001

puts "--------------"
#-------------------------------------------------

# ---------------- DbSplitCurve ------------------
puts "DbSplitCurve"

set fragments [gul::DbSplitCurve $line1 0.5]
puts $fragments

puts "--------------"
#-------------------------------------------------

# ---------------- DbSubtract2Vectors ------------------
puts "DbSubtract2Vectors"

set v1 "1 2 3"
set v2 "-3 -2 -1"
set v [gul::DbSubtract2Vectors $v1 $v2]
puts $v

puts "--------------"
#-------------------------------------------------

# ---------------- DbImport ------------------
puts "DbImport"

gul::DbImport "./sternSurf.stl"

puts "--------------"
#-------------------------------------------------

puts "DbGetAll"

puts "Database are [gul::DbGetAll]"

puts "--------------"

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
