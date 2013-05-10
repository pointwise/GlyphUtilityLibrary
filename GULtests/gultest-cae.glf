#
# Proprietray software product of Pointwise, Inc.
# Copyright (c) 1995-2013 Pointwise, Inc.
# All rights reserved.
#
# This sample Glyph script is not supported by Pointwise, Inc.
# It is provided freely for demonstration purposes only.
# SEE THE WARRANTY DISCLAIMER AT THE BOTTOM OF THIS FILE.
#

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

#
# DISCLAIMER:
# TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, POINTWISE DISCLAIMS
# ALL WARRANTIES, EITHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED
# TO, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE, WITH REGARD TO THIS SCRIPT.  TO THE MAXIMUM EXTENT PERMITTED BY
# APPLICABLE LAW, IN NO EVENT SHALL POINTWISE BE LIABLE TO ANY PARTY FOR
# ANY SPECIAL, INCIDENTAL, INDIRECT, OR CONSEQUENTIAL DAMAGES WHATSOEVER
# (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF BUSINESS
# INFORMATION, OR ANY OTHER PECUNIARY LOSS) ARISING OUT OF THE USE OF OR
# INABILITY TO USE THIS SCRIPT EVEN IF POINTWISE HAS BEEN ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGES AND REGARDLESS OF THE FAULT OR NEGLIGENCE OF
# POINTWISE.
#
