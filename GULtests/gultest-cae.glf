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

# ************ caeutil proc tests ************
# Set default connector dimension
gul::ConSetDefaultDimension 20 0.1 0.1

# data used for proc tests
set dom1 [gul::DomStr4Points "0 0 0" "1 0 0" "1 1 0" "0 1 0"]
set dom2 [gul::DomStr4Points "0 0 0" "1 0 0" "1 0 1" "0 0 1"]
set dom3 [gul::DomStr4Points "1 0 0" "1 0 1" "1 1 1" "1 1 0"]
set dom4 [gul::DomStr4Points "0 1 0" "1 1 0" "1 1 1" "0 1 1"]
set dom5 [gul::DomStr4Points "0 0 0" "0 0 1" "0 1 1" "0 1 0 "]
set dom6 [gul::DomStr4Points "0 0 1" "1 0 1" "1 1 1" "0 1 1"]
set blk1 [gul::BlkStr6Doms $dom1 $dom2 $dom3 $dom4 $dom5 $dom6]
puts $blk1

# ---------------- CAEcreateBC ------------------
puts "CAEcreateBC"

set newBC [gul::CAEcreateBC "isothermal" 1]
puts $newBC

puts "--------------"
#-------------------------------------------------

# ---------------- CAEapplyBC ------------------
puts "CAEapplyBC"

gul::CAEapplyBC "isothermal" [list [list $blk1 $dom1]]

puts "--------------"
#-------------------------------------------------

# ---------------- CAEexportOGA ------------------
puts "CAEexportOGA"

#gul::CAEexportOGA

puts "--------------"
#-------------------------------------------------

# ---------------- CAEimportOGA ------------------
puts "CAEimportOGA"

#gul::CAEimportOGA

puts "--------------"
#-------------------------------------------------

# ---------------- CAEset ------------------
puts "CAEset"

gul::CAEset "CFD++" 3

puts "--------------"
#-------------------------------------------------

# ---------------- CAEsetOGA ------------------
puts "CAEsetOGA"

gul::CAEsetOGA "SUGGAR"

puts "--------------"
#-------------------------------------------------

# ---------------- CAEsetOGAattribute ------------------
puts "CAEsetOGAattribute"

gul::CAEsetOGAattribute CASE_NAME "seaGUL"

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
