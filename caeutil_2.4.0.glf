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
#-- POINTWISE CAE COMMANDS
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
   set bc [pw::BoundaryCondition getByName $name]
   $bc apply $blk_dom_pairs
}

###############################################################
#-- PROC: CAEcreateBC
#--
#-- Create a BC
#--
###############################################################
proc CAEcreateBC { name id {overset_bc ""} {solid 0} } {
  if {[argCheck $id "integer"]} {
    set bc [pw::BoundaryCondition create]
    $bc setName $name
    $bc setId $id
    if {$overset_bc == "solid"} {
      set overset_bc "Vis Ad Wall (P extrp)"
    } elseif {$overset_bc == ""} {
      set overset_bc "Unspecified"
    }
    $bc setPhysicalType $overset_bc
    return $bc
  } else {
    return -code error "CAEcreateBC - Incorrect Argument Type(s)"
  }
}

###############################################################
#-- PROC: CAEexportOGA
#--
#-- Export OGA data files
#--
###############################################################
proc CAEexportOGA { } {
   puts "[lindex [info level [info level]] 0] not implemented"
}

###############################################################
#-- PROC: CAEimportOGA
#--
#-- Import OGA results file
#--
###############################################################
proc CAEimportOGA { } {
   puts "[lindex [info level [info level]] 0] not implemented"
}

###############################################################
#-- PROC: CAEset
#--
#-- Set the current CAE
#--
###############################################################
proc CAEset { name {dim 3} } {
  if {[argCheck $name "solver"] && \
      [argCheck $dim "integer" 2 1 3 1]} {
    if {[pw::Application isValidDimension $name $dim]} {
      pw::Application setCAESolver $name $dim
    } else {
      printDetails $dim "valid dimension for $name"
      return -code error "CAEset - Incorrect Argument Type(s)"
    }
  } else {
    return -code error "CAEset - Incorrect Argument Type(s)"
  }
}

###############################################################
#-- PROC: CAEsetOGA
#--
#-- Set the current Overset Grid Assembler
#--
###############################################################
proc CAEsetOGA { name } {
   puts "[lindex [info level [info level]] 0] not implemented"
}

###############################################################
#-- PROC: CAEsetOGAattribute
#--
#-- Set an Overset Grid Assembler attribute
#--
###############################################################

proc CAEsetOGAattribute { attname value } {
   puts "[lindex [info level [info level]] 0] not implemented"
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

