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

# ************ domutil proc tests ************
# Set default connector dimension
gul::ConSetDefaultDimension 20 0.1 0.1

# Objects used repeatedly
set p1 "0 0 0"
set p2 "1 0 1"
set p3 "2 0 0.5"
set p4 "0 1 -0.5"
set p5 "1 1 0"
set p6 "2 1 0"
set p7 "0 2 0"
set p8 "1 2 0"
set p9 "2 2 0"

set con1 [gul::ConFrom2Points $p4 $p5]
set con2 [gul::ConFrom2Points $p5 $p8]
set con3 [gul::ConFrom2Points $p8 $p7]
set con4 [gul::ConFrom2Points $p7 $p4]
set con5 [gul::ConFrom2Points $p5 $p6]
set con6 [gul::ConFrom2Points $p6 $p9]
set con7 [gul::ConFrom2Points $p9 $p8]

set con1a [gul::ConFrom3Points $p4 "0.5 1 -0.5" $p5 AKIMA]
set con3a [gul::ConFrom3Points $p8 "0.5 2 -0.5" $p7 AKIMA]
set con5a [gul::ConFrom3Points $p5 "1.5 1 -0.5" $p6 AKIMA]
set con7a [gul::ConFrom3Points $p9 "1.5 2 -0.5" $p8 AKIMA]

set edge1 [gul::ConCreateEdge $con1a]
set edge2 [gul::ConCreateEdge $con2]
set edge3 [gul::ConCreateEdge $con3a]
set edge4 [gul::ConCreateEdge $con4]
set edge5 [gul::ConEdgeFromPoints [list "0.5 1.5 -2" "1 2 -2" "1 1 -2" "0.5 1.5 -2"]]

set curve1 [gul::DbCreateLine [list "0 1 -3" "1 2 -3"]]
set curve2 [gul::DbCreateLine [list "0 2 -2" "1 1 -2"]]
set curve3 [gul::DbCreateLine [list "0 1 -3" "0 2 -2"]]
set curve4 [gul::DbCreateLine [list "1 2 -3" "1 1 -2"]]
set surf [gul::DbCreateSurface [list $curve1 $curve2 $curve3 $curve4]]

# ---------------- DomOnDbEntities ------------------
puts "DomOnDbEntities"

set domDB [gul::DomOnDbEntities $surf UNSTRUCTURED 10 20]
puts $domDB

puts "--------------"
#-------------------------------------------------

# ---------------- DomPeriodicRot ------------------
puts "DomPeriodicRot"

set pRotDom [gul::DomPeriodicRot $domDB "0 0 0" "1 0 0" 90]
puts $pRotDom

puts "--------------"
#-------------------------------------------------

# ---------------- DomDelete ------------------
puts "DomDelete"

gul::DomDelete $pRotDom SPECIAL

puts "--------------"
#-------------------------------------------------

# ---------------- DomPeriodicTrans ------------------
puts "DomPeriodicTrans"

set pTransDom [gul::DomPeriodicTrans $domDB "1 0 0"]
puts $pTransDom

puts "--------------"
#-------------------------------------------------

# ---------------- DomStr4Points ------------------
puts "DomStr4Points"

set domSP [gul::DomStr4Points $p1 $p2 $p5 $p4]
puts $domSP

puts "--------------"
#-------------------------------------------------

# ---------------- DomGetPt -----------------
puts "DomGetPt"

set ptInq1 [gul::DomGetPt $domSP "4 4"]
set ptInq2 [gul::DomGetPt $pTransDom 1]
puts $ptInq1
puts $ptInq2

puts "--------------"
#-------------------------------------------------

# ---------------- DomCreateSub -----------------
puts "DomCreateSub"

set subDom1 [gul::DomCreateSub $domSP "2 2" "5 8"]
set subDom2 [gul::DomCreateSub $domSP "3 2" "15 8"]
puts $subDom1
puts $subDom2
puts "--------------"
#-------------------------------------------------

# ---------------- DomGetSubs -----------------
puts "DomGetSubs"

set subDomNum [gul::DomGetSubs $domSP]
puts $subDomNum
puts "--------------"
#-------------------------------------------------

# ---------------- DomStr4Connectors ------------------
puts "DomStr4Connectors"

set domSC [gul::DomStr4Connectors $con1 $con2 $con3 $con4]
puts $domSC

puts "--------------"
#-------------------------------------------------

# ---------------- DomStr4Edges ------------------
puts "DomStr4Edges"

set domSE [gul::DomStr4Edges $edge1 $edge2 $edge3 $edge4]
puts $domSE

puts "--------------"
#-------------------------------------------------

# ---------------- DomUnsPoints ------------------
puts "DomUnsPoints"

set domUP [gul::DomUnsPoints [list $p2 $p3 $p6 $p5]]
puts $domUP

puts "--------------"
#-------------------------------------------------


# ---------------- DomUnsConnectors ------------------
puts "DomUnsConnectors"

set domUC [gul::DomUnsConnectors [list $con5 $con6 $con7 $con2]]
puts $domUC

puts "--------------"
#-------------------------------------------------

# ---------------- DomUnsEdges ------------------
puts "DomUnsEdges"

set domUE [gul::DomUnsEdges $edge5]
puts $domUE

puts "--------------"
#-------------------------------------------------


# ---------------- DomNewTRexCondition ------------------
puts "DomNewTRexCondition"

set trc [gul::DomNewTRexCondition $domUP $con5 "Wall" "bcwall" \
         [list TRexFullLayers 3 aniso_layers 6 TRexGrowthRate 1.3]]
puts $trc

puts "--------------"
#-------------------------------------------------

# ---------------- DomSetTRexSpacing ------------------
puts "DomSetTRexSpacing"

gul::DomSetTRexSpacing $domUP $con5 0.07

puts "--------------"
#-------------------------------------------------


# ---------------- DomChangeDisplay ------------------
puts "DomChangeDisplay"

set domList [list $domSC $domSE]
gul::DomChangeDisplay $domList "WIREFRAME" 3

puts "--------------"
#-------------------------------------------------

# ---------------- DomEllipticSolve ------------------
puts "DomEllipticSolve"

gul::DomEllipticSolve $domList 50

puts "--------------"
#-------------------------------------------------

# ---------------- DomExtrudeNormal -----------------
puts "DomExtrudeNormal"

set conList1 [list $con5 $con6 $con7 $con2]
set v1 "0 1 0"
set v2 "1 0 0"
set domExt [gul::DomExtrudeNormal $conList1 0.05 1.1 20 0.4 $v1 $v2 "Z" 0 0 "Y" 0 0]
puts $domExt

puts "--------------"
#-------------------------------------------------

# ---------------- DomGetAll ------------------
puts "DomGetAll"

set allDoms [gul::DomGetAll]
puts $allDoms

puts "--------------"
#-------------------------------------------------

# ---------------- DomGetEdgeConnectors ------------------
puts "DomGetEdgeConnectors"

set componentCons [gul::DomGetEdgeConnectors $domSE 1]
puts $componentCons

puts "--------------"
#-------------------------------------------------

# ---------------- DomJoin -----------------
puts "DomJoin"

set domList [list $domSP $domSC]
gul::DomJoin $domList

puts "--------------"
#-------------------------------------------------

# ---------------- DomInitialize ------------------
puts "DomInitialize"

set domList [list $domUP $domUC]
gul::DomInitialize $domList

puts "--------------"
#-------------------------------------------------

# ---------------- DomLinearProjection -----------------
puts "DomLinearProjection"

gul::DomLinearProjection $domUE $surf "Z"

puts "--------------"
#-------------------------------------------------

# ---------------- DomProjectClosestPoint -----------------
puts "DomProjectClosestPoint"

set dom1 [gul::DomUnsPoints [list "0 1.5 -2" "0.5 1.5 -2" "0.5 1 -3" "0 1 -3"]]
gul::DomProjectClosestPoint $dom1 $surf 0

puts "--------------"
#-------------------------------------------------

# ---------------- DomRotate -----------------
puts "DomRotate"

gul::DomRotate $domList "Y" 159

puts "--------------"
#-------------------------------------------------

# ---------------- DomSplit -----------------
puts "DomSplit"

set newDom [gul::DomSplit $domSE "I" 5]
puts $newDom

puts "--------------"
#-------------------------------------------------


# ---------------- DomUsage -----------------
puts "DomUsage"

set blocksUsing [gul::DomUsage $domUE]
puts $blocksUsing

puts "--------------"
#-------------------------------------------------

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
