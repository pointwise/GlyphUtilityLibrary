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


