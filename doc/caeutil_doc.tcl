
# Module: CAE Utilities

# Group: Utilities

###############################################################
#
# Proc: CAEapplyBC
#   Apply a BC to a list of block-domain pairs.
#
# Glyph 1 Parameters:
#   name          - Name of new BC.
#   blk_dom_pairs - List of block IDs and domain IDs?
#                   Alternate blocks with domains, e.g.
#                   set blk_dom_pairs [list $blk1 $dom1 $blk2 $dom2 ...]
#
# Glyph 2 Parameters:
#   name          - Name of new BC.
#   blk_dom_pairs - List of pw::Domain objects and pw::Block objects
#                   Alternate blocks with domains, e.g.
#                   set blk_dom_pairs [list $blk1 $dom1 $blk2 $dom2 ...]
#
# Returns:
#   Nothing.
#
# Example:
#   Glyph 1 Code
#     > gul::CAEapplyBC "isothermal" [list $blk1 $dom1]
#
#   Glyph 2 Code
#     > set bc [pw::BoundaryCondition create]
#       $bc setName "isothermal"
#       gul::CAEapplyBC "isothermal" [list [list $blk1 $dom1] [list $blk1 $dom2]]
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc CAEapplyBC { name blk_dom_pairs } {}

###############################################################
#
# Proc: CAEcreateBC
#   Create a boundary condition.
#
# Glyph 1 Parameters:
#   name       - Name of new BC.
#   id         - Specifies the integer flag to export for the BC.
#                The default value is the BC index.
#                Must be an integer.
#   overset_bc - Specifies the overset assembler boundary condition for the new bc.
#                The default value is the default overset assembler BC.
#   solid      - Boolean option to treat new BC as a wall (impermeable boundary)
#                in the FIELDVIEW post-processor.
#                The default value is 0 (not a wall).
#
# Glyph 2 Parameters:
#   name       - Name of new BC.
#   id         - Integer ID of the new BC.
#   overset_bc - Physical type of the new BC.
#   solid      - Unused
#
# Glyph 1 Returns:
#   Nothing.
#
# Glyph 2 Returns:
#   The created boundary condition.
#
# Example:
#   Code
#     > set newBC [gul::CAEcreateBC "isothermal" 1]
#       puts $newBC
#
#   Glyph 1 Output
#     > 
#
#   Glyph 2 Output
#     > ::pw::BoundaryCondition_9
#
###############################################################
proc CAEcreateBC { name id {overset_bc ""} {solid 0} } {}

###############################################################
#
# Proc: CAEexportOGA
#   Export OGA data files. Note: Not implemented for Glyph 2.
#
# Parameters:
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > gul::CAEexportOGA
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc CAEexportOGA { } {}

###############################################################
#
# Proc: CAEimportOGA
#   Import OGA results file. Note: Not implemented for Glyph 2.
#
# Parameters:
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > gul::CAEimportOGA
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc CAEimportOGA { } {}

###############################################################
#
# Proc: CAEset
#   Set the current CAE.
#
# Parameters:
#   name - Name of wanted CAE.
#   dim  - Wanted dimension.
#          Must be an integer with range [2, 3].
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > gul::CAEset "COBALT" 2
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc CAEset { name {dim 3}} {}

###############################################################
#
# Proc: CAEsetOGA
#   Set the current Overset Grid Assembler.
#
# Glyph 1 Parameters:
#   name - Name of wanted OGA.
#
# Glyph 2 Parameters:
#   name - Not implemented.
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > gul::CAEsetOGA SUGGAR
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc CAEsetOGA { name } {}

###############################################################
#
# Proc: CAEsetOGAattribute
#   Set an Overset Grid Assembler attribute.
#
# Glyph 1 Parameters:
#   attname - Name of attribute to set.
#   value   - Value to set specified attribute to.
#
# Glyph 2 Parameters:
#   attname - Not implemented.
#   value   - Not implemented.
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > gul::CAEsetOGAattribute $attr $val
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc CAEsetOGAattribute { attname value } {}

