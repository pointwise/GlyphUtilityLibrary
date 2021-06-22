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

# path to GUL folder
set guldir [file dirname [info script]]
set utildir [file join $guldir ".."]
source [file join $utildir "version.glf"]
# ----------------------------------------------------------

# *************     conutil proc tests     *****************

gul::ApplicationReset

# Set defaults to ensure that connectors appear with nonzero spacings
gul::ConSetDefaultDimension 20 0.1 0.1

# ----------------- ConCreateConic -----------------
puts "ConCreateConic"

set con1 [gul::ConCreateConic [list 0 0 0] [list 1 1 1] [list 0.5 0.2 -1] 0.5]
puts $con1

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConDbArcLengths ----------------
puts "ConDbArcLengths"

set dbCurve [gul::DbCreateConic [list 0 0 0] [list 1 -1 1] [list 0.3 0.4 1] 0.7]

set conDB [gul::ConDbArcLengths $dbCurve 0.25 0.75]
puts $conDB

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConFrom2Points -----------------
puts "ConFrom2Points"

set conDiag [gul::ConFrom2Points [list 0 0 0] [list 1 1 1]]
puts $conDiag

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConFrom3Points -----------------
puts "ConFrom3Points"

set curveCon [gul::ConFrom3Points [list 0 0 0] [list 1 0 0] [list 1 1 2] "AKIMA" 0.2]
puts $curveCon

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConAddBreakPt -----------------
puts "ConAddBreakPt"

gul::ConAddBreakPt $curveCon X "0.1"
gul::ConAddBreakPt $curveCon Y "0.1 0.5"
gul::ConAddBreakPt $curveCon Z "0.1"
gul::ConAddBreakPt $curveCon ARC "0.5"

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConGetNumSub -----------------
puts "ConGetNumSub"

set subconNum [gul::ConGetNumSub $curveCon]

puts "$subconNum"
puts "-------------"
#-----------------------------------------------------------

# ----------------- ConPeriodicRot -----------------
puts "ConPeriodicRot"

set pRotCon [gul::ConPeriodicRot $curveCon "0 0 0" "1 1 2" 5]

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConPeriodicTrans -----------------
puts "ConPeriodicTrans"

set pTransCon [gul::ConPeriodicTrans $conDB "5 0 0"]

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConOnDbEntities ----------------
puts "ConOnDbEntities"

set curve1 [gul::DbCreateLine [list "0 0 0" "1 1 0"]]
set curve2 [gul::DbCreateLine [list "0 1 1" "1 0 1"]]
set curve3 [gul::DbCreateLine [list "0 0 0" "0 1 1"]]
set curve4 [gul::DbCreateLine [list "1 1 0" "1 0 1"]]
set surf [gul::DbCreateSurface [list $curve1 $curve2 $curve3 $curve4]]

puts $surf

set conSurf [gul::ConOnDbEntities $surf 0]
puts $conSurf

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConOnDbSurface ----------------
puts "ConOnDbSurface"

set startUV [list 0.21 0.2]; set endUV [list 0.49 0.51];
set conSurf [gul::ConOnDbSurface $surf $startUV $endUV]
puts $conSurf

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConCalculateSuitableDimension -----------------
puts "ConCalculateSuitableDimension"

set dim [gul::ConCalculateSuitableDimension $con1 0.05 0.1]
puts $dim

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConDelete -----------------
puts "ConDelete"

set con1 [gul::ConFrom2Points [list 3 1 4] [list 1 5 9]]
set con2 [gul::ConFrom2Points [list 1 5 9] [list 2 6 5]]
gul::ConDelete [list $con1 $con2]

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConFindAllAdjacent -----------------
puts "ConFindAllAdjacent"

set con1 [gul::ConFrom2Points [list 3 1 4] [list 1 5 9]]
set con2 [gul::ConFrom2Points [list 1 5 9] [list 2 6 5]]
set con3 [gul::ConFrom2Points [list 2 6 5] [list 3 5 8]]
set adjCons [gul::ConFindAllAdjacent $con2]
puts $adjCons

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConGetAll -----------------
puts "ConGetAll"

set allCons [gul::ConGetAll ]
puts $allCons

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConGetBeginSpacing -----------------
puts "ConGetBeginSpacing"

set beginSpacing [gul::ConGetBeginSpacing $con1]
puts $beginSpacing

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConGetDimension -----------------
puts "ConGetDimension"

set dim [gul::ConGetDimension $con1]
puts $dim

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConGetEndSpacing -----------------
puts "ConGetEndSpacing"

set endSpacing [gul::ConGetEndSpacing $con1]
puts $endSpacing

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConGetLength -----------------
puts "ConGetLength"

set length [gul::ConGetLength $con1]
puts $length

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConGetNodeTolerance -----------------
puts "ConGetNodeTolerance"

set nodeTol [gul::ConGetNodeTolerance ]
puts $nodeTol

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConGetXYZatU -----------------
puts "ConGetXYZatU"

set s [gul::ConGetXYZatU $curveCon 0.34]
puts $s

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConJoin2 -----------------
puts "ConJoin2"

set part1 [gul::ConFrom2Points "-1 -2 -3" "-2 -1 -4"]
set part2 [gul::ConFrom2Points "-2 -1 -4" "0 0 -3"]
set result [gul::ConJoin2 $part1 $part2]
puts $result

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConJoinMultiple -----------------
puts "ConJoinMultiple"

set part1 [gul::ConFrom2Points "-1 -2 -3" "-2 -1 -4"]
set part2 [gul::ConFrom2Points "-2 -1 -4" "0 0 -3"]
set part3 [gul::ConFrom2Points "0 0 -3" "0.5 0.5 0.5"]
set wholeCon [gul::ConJoinMultiple [list $part1 $part2 $part3]]
puts $wholeCon

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConMatchEndpoints -----------------
puts "ConMatchEndpoints"

set conList [list $con1 $con2 $con3]
set result [gul::ConMatchEndpoints [list 1 5 9] [list 2 6 5] $conList]
puts $result

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConPointsAreEqual -----------------
puts "ConPointsAreEqual"

set p1 [list 0 0 0]
set p2 [list 0 0 0.0000001]
set equal [gul::ConPointsAreEqual $p1 $p2]
puts $equal

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConProjectClosestPoint ----------------
puts "ConProjectClosestPoint"

set conProj [gul::ConFrom2Points [list 1 1 0] [list 0 1 1]]
gul::ConProjectClosestPoint $conProj $surf 0

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConSetBeginSpacing -----------------
puts "ConSetBeginSpacing"

set beginSpacing [gul::ConSetBeginSpacing $con1 0.05]
puts $beginSpacing

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConSetDefaultDimension -----------------
puts "ConSetDefaultDimension"

set dim 10
set beg 0.2
set end 0.2
gul::ConSetDefaultDimension $dim $beg $end

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConSetDimension -----------------
puts "ConSetDimension"

set dim 10
gul::ConSetDimension $con1 $dim

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConSetEndSpacing -----------------
puts "ConSetEndSpacing"

set endSpacing [gul::ConSetEndSpacing $con1 0.05]
puts $endSpacing

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConSetSpacingEqual -----------------
puts "ConSetSpacingEqual"

gul::ConSetSpacingEqual $con1

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConSplit -----------------
puts "ConSplit"

gul::ConSplit $conDiag [list 0.5 0.5 0.5] "XYZ"

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConCreateEdge -----------------
puts "ConCreateEdge"

set leadingEdge [gul::ConCreateEdge [list $con1 $con2 $con3]]
puts $leadingEdge

puts "-------------"

#-----------------------------------------------------------

# ----------------- ConEdgeFromPoints -----------------
puts "ConEdgeFromPoints"

set cuttingEdge [gul::ConEdgeFromPoints [list "0 1 1" "2 3 5" "8 13 21"]]
puts $cuttingEdge

puts "-------------"
#-----------------------------------------------------------

# ----------------- ConMerge -----------------
puts "ConMerge"

gul::ConMerge FREE 1.0

puts "-------------"
#-----------------------------------------------------------

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
