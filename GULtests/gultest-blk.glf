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

# ************ blkutil proc tests ************
# Set default connector dimension
gul::ConSetDefaultDimension 20 0.1 0.1

# Create data used for multiple proc tests

# create points for four blocks
set points [list]
for {set k 1} {$k < 19} {incr k} {
  set p$k "[expr {($k-1)%3}] [expr {(($k-1)/3)%3}] [expr {$k/10}]"
  lappend points [subst $[subst p$k]]
}

# create domains and faces
set dom11 [gul::DomStr4Points $p1 $p4 $p13 $p10]
set dom12 [gul::DomStr4Points $p1 $p2 $p5 $p4]
set dom13 [gul::DomStr4Points $p4 $p5 $p14 $p13]
set dom14 [gul::DomStr4Points $p10 $p11 $p14 $p13]
set dom15 [gul::DomStr4Points $p1 $p2 $p11 $p10]
set dom16 [gul::DomStr4Points $p2 $p5 $p14 $p11]
set dom22 [gul::DomStr4Points $p2 $p3 $p6 $p5]
set dom23 [gul::DomStr4Points $p5 $p6 $p15 $p14]
set dom24 [gul::DomStr4Points $p11 $p12 $p15 $p14]
set dom25 [gul::DomStr4Points $p2 $p3 $p12 $p11]
set dom26 [gul::DomStr4Points $p3 $p6 $p15 $p12]
set dom31 [gul::DomUnsPoints [list $p4 $p7 $p16 $p13]]
set dom32 [gul::DomUnsPoints [list $p4 $p5 $p8 $p7]]
set dom33 [gul::DomUnsPoints [list $p7 $p8 $p17 $p16]]
set dom34 [gul::DomUnsPoints [list $p13 $p14 $p17 $p16]]
set dom36 [gul::DomUnsPoints [list $p5 $p8 $p17 $p14]]
set dom42 [gul::DomUnsPoints [list $p5 $p6 $p9 $p8]]
set dom43 [gul::DomUnsPoints [list $p8 $p9 $p18 $p17]]
set dom44 [gul::DomUnsPoints [list $p14 $p15 $p18 $p17]]
set dom46 [gul::DomUnsPoints [list $p6 $p9 $p18 $p15]]

set face11 [gul::DomCreateFace $dom11 1]
set face12 [gul::DomCreateFace $dom12 1]
set face13 [gul::DomCreateFace $dom13 1]
set face14 [gul::DomCreateFace $dom14 1]
set face15 [gul::DomCreateFace $dom15 1]
set face16 [gul::DomCreateFace $dom16 1]
set face3a [gul::DomCreateFace [list $dom31 $dom32 $dom33 $dom34 $dom13 $dom36]]

foreach con [gul::ConGetAll] {
  gul::ConSetSpacingEqual $con
}

# ---------------- BlkStr6Doms ------------------
puts "BlkStr6Doms"

set blk2 [gul::BlkStr6Doms $dom16 $dom22 $dom23 $dom24 $dom25 $dom26]
puts $blk2

puts "--------------"
#-------------------------------------------------

# ---------------- BlkStr6Faces ------------------
puts "BlkStr6Faces"
set blk1 [gul::BlkStr6Faces $face11 $face12 $face13 $face14 $face15 $face16]
puts $blk1

puts "--------------"
#-------------------------------------------------

# ---------------- BlkUnsFaces ------------------
puts "BlkUns6Faces"

set blk3 [gul::BlkUnsFaces $face3a]
puts $blk3
puts "--------------"
#-------------------------------------------------

# ---------------- BlkUnsDoms ------------------
puts "BlkUnsDoms"

set blk4 [gul::BlkUnsDoms [list $dom36 $dom23 $dom42 $dom43 $dom44 $dom46]]
puts $blk4

puts "--------------"
#-------------------------------------------------

# ---------------- BlkCreateSubBlock ------------------*
puts "BlkCreateSubBlock"

set subblock [gul::BlkCreateSub $blk2 [list 3 1 4] [list 5 3 6]]
puts $subblock

puts "--------------"
#-------------------------------------------------

# ---------------- BlkGetSubs ------------------*
puts "BlkGetSubs"

set subBlks [gul::BlkGetSubs $blk2]
puts $subBlks

puts "--------------"
#-------------------------------------------------

# ---------------- BlkStrNormalExtrude -----------------
puts "BlkStrNormalExtrude"

set domList [list $dom14]
set normExtBlk [gul::BlkStrNormalExtrude $domList 0.1 1.1 10 0.5 [list 1 1] [list 1 1]]
puts $normExtBlk

puts "--------------"
#-------------------------------------------------

# ---------------- BlkStrRotationalExtrude -----------------
puts "BlkStrRotationalExtrude"

set domList [list $dom25]
set rotExtBlk [gul::BlkStrRotationalExtrude $domList "-Z" 180 20]
puts $rotExtBlk

puts "--------------"
#-------------------------------------------------

# ---------------- BlkStrTranslationalExtrude -----------------
puts "BlkStrTranslationalExtrude"

set transExtBlk [gul::BlkStrTranslationalExtrude $dom11 "-X" 1 20]
puts $transExtBlk

puts "--------------"
#-------------------------------------------------

# ---------------- BlkStrTranslationalExtrudeSubCons -----------------
puts "BlkStrTranslationalExtrudeSubCons"

set scTransExtBlk [gul::BlkStrTranslationalExtrudeSubCons $dom12 \
                [list [gul::ConMatchEndpoints $p1 $p4]] "-Z"]
puts $scTransExtBlk

puts "--------------"
#-------------------------------------------------

# ---------------- BlkCopyPasteRotate ------------------
puts "BlkCopyPasteRotate"

set blkCPR [gul::BlkCopyPasteRotate $blk4 [list 0 1 0] 270]
puts $blkCPR

puts "--------------"
#-------------------------------------------------

# ---------------- BlkGetDimensions ------------------
puts "BlkGetDimensions"

set dim [gul::BlkGetDimensions $blk2]
puts $dim

puts "--------------"
#-------------------------------------------------

# ---------------- BlkGetFaceDoms ------------------
puts "BlkGetFaceDoms"

set faceDoms [gul::BlkGetFaceDoms $blk2 1]
puts $faceDoms

puts "--------------"
#-------------------------------------------------

# ---------------- BlkGetName ------------------
puts "BlkGetName"

set name [gul::BlkGetName $blk2]
puts $name

puts "--------------"
#-------------------------------------------------

# ---------------- BlkJoin ------------------
puts "BlkJoin"

gul::BlkJoin [list $blk1 $blk2]

puts "--------------"
#-------------------------------------------------

# ---------------- BlkStrReorient ------------------
puts "BlkStrReorient"

gul::BlkStrReorient $blk1 1 4 5

puts "--------------"
#-------------------------------------------------



# ---------------- BlkSetName ------------------
puts "BlkSetName"

gul::BlkSetName $blk4 "Monty"
puts $blk4

puts "--------------"
#-------------------------------------------------

# ---------------- BlkGetByName ------------------
puts "BlkGetByName"

set blkInq [gul::BlkGetByName Monty]
puts $blkInq

puts "--------------"
#-------------------------------------------------


# ---------------- BlkNewTRexCondition -----------
puts "BlkNewTRexCondition"

set trc [gul::BlkNewTRexCondition $blk4 $dom23 Wall "Python" [list TRexFullLayers 4 \
         aniso_layers 7 TRexPushAttributes 1 TRexGrowthRate 1.1]]
gul::BlkSetTRexSpacing $blk4 $dom23 0.04
puts $trc

puts "--------------"
# ------------------------------------------------

# ---------------- BlkInitialize ----------------
puts "BlkInitialize"

gul::BlkInitialize [list $blk3 $blk4]

puts "--------------"

# ---------------- BlkGetAll ------------------
puts "BlkGetAll"

set blkList [gul::BlkGetAll]
puts $blkList

puts "--------------"
#-------------------------------------------------

# ---------------- BlkDelete ------------------
puts "BlkDelete"

gul::BlkDelete $blk3 SPECIAL

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
