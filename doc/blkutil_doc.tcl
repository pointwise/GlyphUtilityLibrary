
# Module: Block

# Group: Block Creation

###############################################################
#
# Proc: BlkCreateSubBlock
#   Create a sub block.
#
# Glyph 1 Parameters:
#   blk          - Block ID.
#   minCornerIJK - Sub block starts at this coordinate.
#                  Must be a list of three integers with range [1, IJK dimension of blk].
#   maxCornerIJK - Sub block extends to this coordinate.
#                  Must be a list of three integers with range [1, IJK dimension of blk].
#
# Glyph 2 Parameters:
# ----------------- NOT IMPLEMENTED -------------------
#   blk          - pw::BlockStructured object
#   minCornerIJK - Starting coordinate of sub-block.
#                  Must be a list of three integers with range [1, IJK dimension of blk].
#   maxCornerIJK - Ending coordinate of sub-block.
#                  Must be a list of three integers with range [1, IJK dimension of blk].
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > set subBlock [gul::BlkCreateSubBlock $blk1 "2 3 4" "12 13 14"]
#       puts $subBlock
#
#   Glyph 1 Output
#     > BL2
#
#   Glyph 2 Output
#     >
#
###############################################################
proc BlkCreateSubBlock {blk minCornerIJK maxCornerIJK} {}

###############################################################
#
# Proc: BlkStr6Doms
#   Create a structured block from 6 domains.
#
# Glyph 1 Parameters:
#   d1 - Structured domain ID.
#   d2 - Structured domain ID.
#   d3 - Structured domain ID.
#   d4 - Structured domain ID.
#   d5 - Structured domain ID.
#   d6 - Structured domain ID.
#
# Glyph 2 Parameters:
#   d1 - pw::DomainStructured object.
#   d2 - pw::DomainStructured object.
#   d3 - pw::DomainStructured object.
#   d4 - pw::DomainStructured object.
#   d5 - pw::DomainStructured object.
#   d6 - pw::DomainStructured object.
#
# Glyph 1 Returns:
#   The new structured block ID.
#
# Glyph 2 Returns:
#   The new pw::BlockStructured object.
#
# Example:
#   Code
#     > set blk [BlkStr6Doms $dom_list]
#     > puts $blk
#
#   Glyph 1 Output
#     > BL1
#
#   Glyph 2 Output
#     > ::pw::BlockStructured_1
#
###############################################################
proc BlkStr6Doms {d1 d2 d3 d4 d5 d6} {}

###############################################################
#
# Proc: BlkStr6Faces
#   Create a structured block from 6 face lists.
#
# Glyph 1 Parameters:
#   f1 - Structured domain ID.
#   f2 - Structured domain ID.
#   f3 - Structured domain ID.
#   f4 - Structured domain ID.
#   f5 - Structured domain ID.
#   f6 - Structured domain ID.
#
# Glyph 2 Parameters:
#   f1 - pw::FaceStructured object.
#   f2 - pw::FaceStructured object.
#   f3 - pw::FaceStructured object.
#   f4 - pw::FaceStructured object.
#   f5 - pw::FaceStructured object.
#   f6 - pw::FaceStructured object.
#
# Glyph 1 Returns:
#   The new structured Block ID.
#
# Glyph 2 Returns:
#   The new pw::BlockStructured object.
#
# Example:
#   Code
#     > set blk1 [gul::BlkStr6Faces $face1 $face2 $face3 $face4 $face5 $face6]
#       puts $blk1
#
#   Glyph 1 Output
#     > BL1
#
#   Glyph 2 Output
#     > ::pw::BlockStructured_35
#
###############################################################
proc BlkStr6Faces {f1 f2 f3 f4 f5 f6} {}

###############################################################
#
# Proc: BlkStrNormalExtrude
#   Create single face normal extrusion from a list of domains.
#
# Glyph 1 Parameters:
#   domList   - List of structured domain IDs.
#   initDs    - Size of first marching step.
#               Must be a float with range (0.0, infinity).
#   cellGr    - Growth rate of marching step size.
#               Must be a float with range (0.0, infinity).
#   blDist    - Number of marching steps to make.
#               Must be an integer with range (0, infinity).
#   volSmth   - Rate at which grid point clustering along the initial grid will
#               be relaxed as the grid is extruded.
#               Must be a float with range [0.0, 1.0].
#               A value of 0.0 retains the clustering to the outer boundary.
#   expSmooth - Explicit smoothing coefficient for the transverse direction.
#               Must be a list of two floats with range [-1.0, 1.0].
#   impSmooth - Implicit smoothing coefficient for the transverse direction.
#               Must be a list of two floats with range (0.0, infinity).
#
# Glyph 2 Parameters:
#   domList   - List of pw::DomainStructured objects.
#   initDs    - Size of first marching step.
#               Must be a float with range (0.0, infinity).
#   cellGr    - Growth rate of marching step size.
#               Must be a float with range (0.0, infinity).
#   blDist    - Number of marching steps to make.
#               Must be an integer with range (0, infinity).
#   volSmth   - Rate at which grid point clustering along the initial grid will
#               be relaxed as the grid is extruded.
#               Must be a float with range [0.0, 1.0].
#               A value of 0.0 retains the clustering to the outer boundary.
#   expSmooth - Explicit smoothing coefficients for the transverse direction.
#               Must be a list of two floats with range [0.0, 10.0].
#   impSmooth - Implicit smoothing coefficients for the transverse direction.
#               Must be a list of two floats with range [0.0, 20.0].
#
# Glyph 1 Returns:
#   The new extruded block ID.
#
# Glyph 2 Returns:
#   The new pw::BlockExtruded object.
#
# Example:
#   Code
#     > set domList [list $dom5]
#       set normExtBlk [gul::BlkStrNormalExtrude $domList 0.1 1.1 10 0.5 [list 1 1] [list 1 1]]
#       puts $normExtBlk
#
#   Glyph 1 Output
#     > BL2
#
#   Glyph 2 Output
#     > ::pw::BlockStructured_61
#
###############################################################
proc BlkStrNormalExtrude {domList initDs cellGr blDist volSmth expSmooth impSmooth {bcEdge1 0} {bcEdge2 0} {bcEdge3 0} {bcEdge4 0}} {}

###############################################################
#
# Proc: BlkStrRotationalExtrude
#   Create a structured rotational extrusion from a domain.
#
# Glyph 1 Parameters:
#   face_dom_list - List of structured domain IDs.
#   axis          - Axis about which the rotational extrusion proceeds.
#                   Must be < "X" | "Y" | "Z" | "-X" | "-Y" | "-Z" >.
#   angle         - Total rotational angle in degrees for the extrusion.
#                   Must be a float with range (0.0, 360.0).
#   pts           - Number of iterations to run.
#                   Must be an integer with range (0, infinity)
#
# Glyph 2 Parameters:
#   face_dom_list - List of pw::DomainStructured objects.
#   axis          - Axis about which the rotational extrusion proceeds.
#                   Must be < "X" | "Y" | "Z" | "-X" | "-Y" | "-Z" >.
#   angle         - Total rotational angle in degrees for the extrusion.
#                   Must be a float with range [0.0, 360.0].
#   pts           - Number of iterations to run.
#                   Must be an integer with range [0, infinity)
#
#
# Glyph 1 Returns:
#   The new extruded block ID.
#
# Glyph 2 Returns:
#   The new pw::BlockStructured object.
#
# Example:
#   Code
#     > set domList [list $dom6]
#       set rotExtBlk [gul::BlkStrRotationalExtrude $domList "-Y" 90 20]
#       puts $rotExtBlk
#
#   Glyph 1 Output
#     > BL3
#
#   Glyph 2 Output
#     > ::pw::BlockStructured_62
#
###############################################################
proc BlkStrRotationalExtrude {face_dom_list axis angle pts} {}

###############################################################
#
# Proc: BlkStrTranslationalExtrude
#   Create a structured translational extrusion from a domain.
#
# Glyph 1 Parameters:
#   dom  - Structured domain ID.
#   dist - Total distance to be extruded.
#          Must be a float with range (0.0, infinity).
#   pts  - Number of iterations to run.
#          Must be an integer with range (0, infinity).
#   axis - Axis along which the grid will be extruded.
#          Must be < "X" | "Y" | "Z" | "-X" | "-Y" | "-Z" >.
#
# Glyph 2 Parameters:
#   dom  - pw::DomainStructured object.
#   axis - Axis along which the grid will be extruded.
#          Must be < "X" | "Y" | "Z" | "-X" | "-Y" | "-Z" >.
#   dist - Total distance to be extruded.
#          Must be a float.
#   pts  - Number of iterations to run.
#          Must be an integer with range [0, infinity).
#
# Glyph 1 Returns:
#   The new extruded block ID.
#
# Glyph 2 Returns:
#   The new pw::BlockStructured object.
#
# Example:
#   Code
#     > set transExtBlk [gul::BlkStrTranslationalExtrude $dom1 "-Z" 1 20]
#       puts $transExtBlk
#
#   Glyph 1 Output
#     > BL4
#
#   Glyph 2 Output
#     > ::pw::BlockStructured_63
#
###############################################################
proc BlkStrTranslationalExtrude {dom axis dist pts} {}

###############################################################
#
# Proc: BlkStrTranslationalExtrudeSubCons
#   Create a structured translational extrusion from a domain
#   using sub cons for dimension and spacing.
#
# Glyph 1 Parameters:
#   dom     - Structured domain ID.
#   conList - List of connector IDs.
#   axis    - Axis along which the grid will be extruded.
#             Must be < "X" | "Y" | "Z" | "-X" | "-Y" | "-Z" >.
#
# Glyph 2 Parameters:
#   dom     - pw::DomainStructured object.
#   conList - List of pw::Connector objects.
#   axis    - Axis along which the grid will be extruded.
#             Must be < "X" | "Y" | "Z" | "-X" | "-Y" | "-Z" >.
#
# Glyph 1 Returns:
#   The new extruded block ID.
#
# Glyph 2 Returns:
#   The new pw::BlockStructured object.
#
# Example:
#   Code
#     > set scTransExtBlk [gul::BlkStrTranslationalExtrudeSubCons $dom2 \
#                [list $con9] "Z"]
#       puts $scTransExtBlk
#
#   Glyph 1 Output
#     > BL5
#
#   Glyph 2 Output
#     > ::pw::BlockStructured_64
#
###############################################################
proc BlkStrTranslationalExtrudeSubCons {dom conList axis} {}

###############################################################
#
# Proc: BlkUnsDoms
#   Create an unstructured block from a list of domains.
#
# Glyph 1 Parameters:
#   domList - List of domains.
#
# Glyph 2 Parameters:
#   domList - List of domains.
#
# Glyph 1 Returns:
#   The new block's ID.
#
# Glyph 2 Returns:
#   The new pw::BlockUnstructured object.
#
# Example:
#   Code
#     > set unsBlock [gul::BlkUnsDoms $domList]
#     > puts $unsBlock
#
#   Glyph 1 Output
#     > BL1
#
#   Glyph 2 Output
#     > ::pw::BlockUnstructured_1
#
###############################################################
proc BlkUnsDoms {domList} {}

###############################################################
#
# Proc: BlkUnsFaces
#   Create an unstructured block from a list of faces.
#
# Glyph 1 Parameters:
#   faceList - List of faces.
#
# Glyph 2 Parameters:
#   faceList - List of faces.
#
# Glyph 1 Returns:
#   The new block's ID.
#
# Glyph 2 Returns:
#   The new pw::BlockUnstructured object.
#
# Example:
#   Code
#     > gul::BlkUnsFaces $faceList
#
#   Glyph 1 Output
#     > BL1
#
#   Glyph 2 Output
#     > ::pw::BlockUnstructured_1
#
###############################################################
proc BlkUnsFacess {faceList} {}

# Group: Block Utilities

###############################################################
#
# Proc: BlkGetByName
#   Obtain the block name.
#
# Glyph 1 Parameters:
#   name          - Block name.
#
# Glyph 2 Parameters:
#   name          - Block name.
#
# Returns:
#   Block ID.
#
###############################################################
proc BlkGetByName {name} {}

###############################################################
#
# Proc: BlkGetAll
#   Obtain a list of all the existing blocks in a grid.
#
# Glyph 1 Parameters: N/A
#
# Glyph 2 Parameters: N/A
#
# Returns:
#   A list of block entities.
#
###############################################################
proc BlkGetByName {} {}

###############################################################
#
# Proc: BlkDelete
#   Delete blocks with an option of special delete specified.
#
# Glyph 1 Parameters:
#    blkList          - A list of blocks.
#    option           - A string.
#
# Glyph 2 Parameters:
#    blkList          - A list of blocks.
#    option           - A string.
#
# Returns:
#   Specified blocks are deleted. If the option is "Special",
#   all the parent entities are deleted as well.
#
###############################################################
proc BlkDelete {blkList option} {}

###############################################################
#
# Proc: BlkGetPt
#   Obtain xyz coordinates of a point given an index.
#
# Glyph 1 Parameters:
#    blk              - A block.
#    ind              - Index of the target point. It must be
#                       ijk list for structured block and point
#                       index for unstructured block.
#
# Glyph 2 Parameters:
#    blk              - A block.
#    ind              - Index of the target point. It must be
#                       ijk list for structured block and point
#                       index for unstructured block.
#
# Returns:
#   XYZ coordinates of the point at the given the index.
#
###############################################################
proc BlkGetPt { blk ind } {}

###############################################################
#
# Proc: BlkGetSubs
#   Obtain a list of the sub-blocks in a given block.
#
# Glyph 1 Parameters:
#    blk              - Target block.
#
# Glyph 2 Parameters:
#    blk              - Target block.
#
# Returns:
#    A list of sub-blocks.
#
###############################################################
proc BlkGetSubs {blk} {}

###############################################################
#
# Proc: BlkCopyPasteRotate
#   Copy, Paste, Rotate block by a specified angle.
#
# Glyph 1 Parameters:
#   blk  - Block ID.
#   axisVec - Vector to rotate block about.
#   angle - Angle through which to rotate the block.
#           Must be a float within [0, 360).
#
# Glyph 2 Parameters:
#   blk  - pw::Block object.
#   axisVec - Vector to rotate block about.
#   angle - Angle through which to rotate the block.
#           Must be a float within [0, 360).
#
# Glyph 1 Returns:
#   The newly positioned block ID.
#
# Glyph 2 Returns:
#   The newly positioned pw::Block object.
#
# Example:
#   Code
#     > set blk2 [gul::BlkCopyPasteRotate $blk1 [list 0 1 0] 270]
#       puts $blk2
#
#   Glyph 1 Output
#     > BL6
#
#   Glyph 2 Output
#     > ::pw::BlockStructured_36
#
###############################################################
proc BlkCopyPasteRotate {blk axis {angle 180}} {}

###############################################################
#
# Proc: BlkGetDimensions
#   Get a block's dimensions.
#
# Glyph 1 Parameters:
#   blk - Block ID.
#
# Glyph 2 Parameters:
#   blk - pw::Block object.
#
# Returns:
#   Dimension of specified block as an integer.
#
# Example:
#   Code
#     > set dim [gul::BlkGetDimensions $blk1]
#       puts $dim
#
#   Glyph 1 Output
#     > 20 20 20
#
#   Glyph 2 Output
#     > 20 20 20
#
###############################################################
proc BlkGetDimensions {blk} {}

###############################################################
#
# Proc: BlkGetFaceDoms
#   Return domain list from given block face.
#
# Glyph 1 Parameters:
#   blk        - Structured block ID.
#   face_index - Location of the face containing the wanted domains.
#                Must be an integer with range [1, 6] or
#                < "IMIN" | "IMAX" | "JMIN" | "JMAX" | "KMIN" | "KMAX" >.
#
# Glyph 2 Parameters:
#   blk        - pw::BlockStructured object.
#   face_index - Location of the face containing the wanted domains.
#                Must be an integer with range [1, number of faces] or
#                < "IMIN" | "IMAX" | "JMIN" | "JMAX" | "KMIN" | "KMAX" >.
#
# Glyph 1 Returns:
#   List of structured domain IDs.
#
# Glyph 2 Returns:
#   List of pw::DomainStructured objects.
#
# Example:
#   Code
#     > set faceDoms [gul::BlkGetFaceDoms $blk1 1]
#       puts $faceDoms
#
#   Glyph 1 Output
#     > DM1
#
#   Glyph 2 Output
#     > ::pw::DomainStructured_138
#
###############################################################
proc BlkGetFaceDoms {blk face_index} {}

###############################################################
#
# Proc: BlkGetName
#   Get a block's name.
#
# Glyph 1 Parameters:
#   blk - Block ID.
#
# Glyph 2 Parameters:
#   blk - pw::Block object.
#
# Returns:
#   Name of specified block.
#
# Example:
#   Code
#     > set name [gul::BlkGetName $blk1]
#       puts $name
#
#   Glyph 1 Output
#     > A
#
#   Glyph 2 Output
#     > blk-1
#
###############################################################
proc BlkGetName {blk} {}

###############################################################
#
# Proc: BlkJoin
#   Join 2 blocks.
#
# Glyph 1 Parameters:
#   blks - List of the two block IDs to be joined.
#
# Glyph 2 Parameters:
#   blks - List of pw::Block objects to be joined.
#          Note that the Glyph 2 version of this command allows
#          arbitrarily many blocks to be joined at once.
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > gul::BlkJoin [list $blk1 $blk2]
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc BlkJoin {blks} {}

###############################################################
# Proc: BlkNewTRexCondition
#   Create and apply a T-Rex condition to a set of domains.
#
# Glyph 1 Parameters:
#   name      - Name of the new condition.
#   type      - New condition type.
#               Must be one of "Off", "Wall", "Match", "AdjacentGrid"
#   registers - List of block-domain pairs, optionally with an
#               orientation string that must be one of "Same" or "Opposite"
#
# Glyph 2 Parameters:
#   name      - Name of the new condition.
#   type      - New condition type.
#               Must be one of "Off", "Wall", "Match", "AdjacentGrid"
#   registers - List of block-domain pairs, optionally with an
#               orientation string that must be one of "Same" or "Opposite"
#
# Glyph 1 Returns:
#   0 on success.
#
# Glyph 2 Returns:
#   The new pw::TRexCondition object
#
# Example:
#   Code
#     > gul::BlkNewTRexCondition "cond1" Wall [list $reg1 $reg2]
#
#   Glyph 1 Output
#     > 0
#
#   Glyph 2 Output
#     > ::pw::TRexCondition_3
#
###############################################################
proc BlkNewTRexCondition {name type registers} {}

###############################################################
# Proc: BlkSetUnsSolverAttrs
#   Set a list of attributes for an unstructured solver. Attributes from one of
#   Pointwise or Gridgen are automatically translated into their equivalents
#   (if they exist) for the current preprocessor.
#
# Glyph 1 Parameters:
#   blk        - Block ID.
#   attributes - List of unstructured solver attributes in the form
#                [list att1 val1 val2 ... valn att2 val1 val2 ...valn att3...]
#
# Glyph 2 Parameters:
#   blk        - pw::DomainUnstructured object.
#   attributes - List of unstructured solver attributes in the form
#                [list att1 val1 val2 ... valn att2 val1 val2 ...valn att3...]
#
# Returns:
#   Nothing
#
# Example:
#   Code
#     > gul::BlkSetUnsSolverAttrs $blk1 [list -aniso_delta_s_smooth_relax 0.4 \
#            TRexMaximumLayers 7]
#
#   Glyph 1 Output
#     >
#
#   Glyph 2 Output
#     >
#
###############################################################
proc BlkSetUnsSolverAttrs {blk attributes} {}

###############################################################
# Proc: BlkSetTRexSpacing
#   Set the initial spacing for T-Rex wall boundaries.
#
# Glyph 1 Parameters:
#   blk  - Block ID.
#   domList - List of IDs for domains on which to apply the desired spacing.
#   spacing - The desired spacing.
#
# Glyph 2 Parameters:
#   blk  - pw::BlockUnstructured object
#   domList - List of pw::Domain objects on which to apply the desired spacing.
#   spacing - The desired spacing.
#
# Returns:
#   Nothing
#
# Example:
#   Code
#     > gul::BlkSetTRexSpacing $blk1 [list $dom1 $dom2] 0.05
#
#   Glyph 1 Output
#     >
#
#   Glyph 2 Output
#     >
#
###############################################################
proc BlkSetTRexSpacing {blk domList spacing} {}

###############################################################
#
# Proc: BlkStrReorient
#   Reorient a structured block's topological indices.
#
# Glyph 1 Parameters:
#   blk  - Structured block ID.
#   imin - Face index/boundary to be used as the Imin Face.
#          Must be an integer with range [0, infinity).
#   jmin - Face index/boundary to be used as the Jmin Face.
#          Must be an integer with range [0, infinity).
#   kmin - Face index/boundary to be used as the Kmin Face.
#          Must be an integer with range [0, infinity).
#
# Glyph 2 Parameters:
#   blk  - pw::BlockStructured object.
#   imin - Face index/boundary to be used as the Imin Face.
#          Must be an integer with range [1, 6].
#   jmin - Face index/boundary to be used as the Jmin Face.
#          Must be an integer with range [1, 6].
#   kmin - Face index/boundary to be used as the Kmin Face.
#          Must be an integer with range [1, 6].
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > gul::BlkStrReorient $blk1 1 4 5
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc BlkStrReorient {blk imin jmin kmin} {}

###############################################################
#
# Proc: BlkSetName
#   Set a block's name.
#
# Glyph 1 Parameters:
#   blk  - Block ID.
#   name - New name of specified block.
#
# Glyph 2 Parameters:
#   blk  - pw::Block object.
#   name - New name of specified block.
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > gul::BlkSetName $blk1 "Who"
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc BlkSetName {blk name} {}

###############################################################
# Proc: BlkInitialize
#   Initialize a list of blocks.
#
# Glyph 1 Parameters:
#   blkList - List of block IDs.
#
# Glyph 2 Parameters:
#   blkList - List of pw::Block objects.
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > set blkList [list $blk1 $blk2]
#       gul::BlkInitialize $blkList
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc BlkInitialize {blkList} {}
