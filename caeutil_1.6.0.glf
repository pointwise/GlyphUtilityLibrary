#
# Proprietray software product of Pointwise, Inc.
# Copyright (c) 1995-2013 Pointwise, Inc.
# All rights reserved.
#
# This sample Gridgen script is not supported by Pointwise, Inc.
# It is provided freely for demonstration purposes only.
# SEE THE WARRANTY DISCLAIMER AT THE BOTTOM OF THIS FILE.
#

##########################################################################
#--
#--  Define some useful CAE commands
#--
##########################################################################


##########################################################################
#--
#-- GRIDGEN ASW COMMANDS
#--
##########################################################################

namespace eval gul {

###############################################################
#-- PROC: CAEapplyBC
#--
#-- Apply a BC to a list of block-domain pairs
#--
###############################################################
proc CAEapplyBC { name blk_dom_pairs } {
   set doms [list]
   foreach blkdom $blk_dom_pairs {
      lappend doms [lindex $blkdom 1]
   }
   gg::aswSetBC $doms $name
}

###############################################################
#-- PROC: CAECreateBC
#--
#-- Create a BC
#--
###############################################################
proc CAEcreateBC { name id {overset_bc ""} {solid 0} } {
  if {[argCheck $solid "boolean"] && \
      [argCheck $id "integer"]} {
    gg::aswCreateBC $name -solid $solid -id $id -overset_bc $overset_bc
  } else {
    return -code error [getErrorMsg "CAEcreateBC"]
  }
}

###############################################################
#-- PROC: CAEexportOGA
#--
#-- Export OGA data files
#--
###############################################################
proc CAEexportOGA { } {
   gg::oversetExport
}

###############################################################
#-- PROC: CAEimportOGA
#--
#-- Import OGA results file
#--
###############################################################
proc CAEimportOGA { } {
   gg::oversetImport
}

###############################################################
#-- PROC: CAEset
#--
#-- Set the current CAE
#--
###############################################################
proc CAEset { name {dim 3} } {
  if {[argCheck $dim "integer" 2 1 3 1]} {
    gg::aswSet $name -dim $dim
  } else {
    return -code error [getErrorMsg "CAEset"]
  }
}

###############################################################
#-- PROC: CAEsetOGA
#--
#-- Set the current Overset Grid Assembler
#--
###############################################################
proc CAEsetOGA { name } {
   gg::oversetSet $name
}

###############################################################
#-- PROC: CAEsetOGAattribute
#--
#-- Set an Overset Grid Assembler attribute
#--
###############################################################
proc CAEsetOGAattribute { attname value } {
   gg::oversetAtt $attname $value
}

}

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


