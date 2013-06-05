
# Module: Domain

# Group: Domain Creation

###############################################################
#
# Proc: DomCreateSubs
#   Create sub-domains in a domain given the index.
#
# Glyph 1 Parameters:
#    dom              - Target domain.
#    ijMin            - List of
#
# Glyph 2 Parameters:
#    dom              - Target domain.
#
# Returns:
#    A list of sub-domains.
#
###############################################################
proc DomCreateSubs {dom ijMin ijMax} {}

###############################################################
# Proc: DomUnsPoints
#   Create an unstructured domain with edges given by
#   consecutive points in a list.
#
# Glyph 1 Parameters:
#   ptList - List of points. If the first and last points are
#            not equal (i.e., the list does not define a closed
#            curve), the first point will be appended to the end
#            the list. Except possibly the first and last, all
#            points must be distinct.
#
# Glyph 2 Parameters:
#   ptList - List of points. If the first and last points are
#            not equal (i.e., the list does not define a closed
#            curve), the first point will be appended to the end
#            the list. Except possibly the first and last, all
#            points must be distinct.
#
# Glyph 1 Returns:
#   The new domain's ID.
#
# Glyph 2 Returns:
#   The new domain object.
#
# Example:
#   Code
#     > gul::DomUnsPoints [list "0 0 0" "1 0 1" "1 1 1" "0 1 1"]
#
#   Glyph 1 Output
#     > DM1
#   Glyph 2 Output
#     > ::pw::DomainUnstructured_1
#
###############################################################
proc DomUnsPoints {ptList} {}

###############################################################
# Proc: DomCreateFace
#   Create a face from a list of domains.
#
# Glyph 1 Parameters:
#   domList - List of domain IDs.
#
# Glyph 2 Parameters:
#   domList    - List of pw::Domain objects
#   structured - Boolean flag to indicate whether the resulting
#                face is to be structured. The default is
#                unstructured.
#
# Glyph 1 Returns:
#   0
#
# Glyph 2 Returns:
#   The new pw::FaceStructured or pw::FaceUnstructured object.
#
# Example:
#   Code
#     > gul::DomCreateFace [list $dom1 $dom2] 1
#
#   Glyph 1 Output
#     > 0
#
#   Glyph 2 Output
#     > ::pw::FaceStructured_1
#
###############################################################
proc DomUnsPoints {ptList} {}

###############################################################
#
# Proc: DomOnDbEntities
#   Get a list of domains created on a list of db entities
#
# Glyph 1 Parameters:
#    dbList              - A list of database entities.
#    domType             - String of "Structured" or "Unstructured"
#    splitAng            - Value of the splitting angle
#    JoinAng             - Value of the joining angle
#
# Glyph 2 Parameters:
#    dbList              - A list of database entities.
#    domType             - String of "Structured" or "Unstructured"
#    splitAng            - Value of the splitting angle
#    JoinAng             - Value of the joining angle
#
# Returns:
#    A list of domains that were created on target database.
#
###############################################################
proc DomOnDbEntities { dbList domType splitAng joinAng } {}

###############################################################
# Proc: DomStr4Connectors
#   Create a STRUCTURED domain from 4 connectors.
#
# Glyph 1 Parameters:
#   c1 - Connector ID.
#   c2 - Connector ID.
#   c3 - Connector ID.
#   c4 - Connector ID.
#
# Glyph 2 Parameters:
#   c1 - pw::Connector object.
#   c2 - pw::Connector object.
#   c3 - pw::Connector object.
#   c4 - pw::Connector object.
#
# Glyph 1 Returns:
#   The new structured domain ID.
#
# Glyph 2 Returns:
#   The new pw::DomainStructured object.
#
# Example:
#   Code
#     > set dom2 [gul::DomStr4Connectors $con5 $con6 $con7 $con8]
#       puts $dom2
#
#   Glyph 1 Output
#     > DM1
#
#   Glyph 2 Output
#     > ::pw::DomainStructured_93
#
###############################################################
proc DomStr4Connectors {c1 c2 c3 c4} {}

###############################################################
# Proc: DomStr4Points
#   Create a STRUCTURED domain from 4 points. Points may be
#   repeated to form poles.
#
# Glyph 1 Parameters:
#   p1 - Point
#   p2 - Point
#   p3 - Point
#   p4 - Point
#
# Glyph 2 Parameters:
#   p1 - Point
#   p2 - Point
#   p3 - Point
#   p4 - Point
#
# Glyph 1 Returns:
#   The new structured domain ID.
#
# Glyph 2 Returns:
#   The new pw::DomainStructured object.
#
# Example:
#   Code
#     > set dom1 [gul::DomStr4Points "3 1 4" "1 5 9" "2 6 5" "3 5 8"]
#       puts $dom1
#
#   Glyph 1 Output
#     > DM2
#
#   Glyph 2 Output
#     > ::pw::DomainStructured_3
#
###############################################################
proc DomStr4Points {p1 p2 p3 p4} {}

###############################################################
# Proc: DomUnsConnectors
#   Create an unstructured domain with edges generated from a
#   list of connectors.
#
# Glyph 1 Parameters:
#   conList - List of connectors.
#
# Glyph 2 Parameters:
#   conList - List of connectors.
#
# Glyph 1 Returns:
#   The new domain's ID.
#
# Glyph 2 Returns:
#   The new domain object.
#
# Example:
#   Code
#     > gul::DomUnsConnectors [list $con1 $con2 $con3]
#
#   Glyph 1 Output
#     > DM3
#
#   Glyph 2 Output
#     > ::pw::DomainUnstructured_1
#
###############################################################
proc DomUnsConnectors {conList} {}

###############################################################
# Proc: DomStr4Edges
#   Create a STRUCTURED domain from 4 edge lists.
#
# Glyph 1 Parameters:
#   e1 - List of connector IDs.
#   e2 - List of connector IDs.
#   e3 - List of connector IDs.
#   e4 - List of connector IDs.
#
# Glyph 2 Parameters:
#   e1 - pw::Edge object.
#   e2 - pw::Edge object.
#   e3 - pw::Edge object.
#   e4 - pw::Edge object.
#
# Glyph 1 Returns:
#   The new structured domain ID.
#
# Glyph 2 Returns:
#   The new pw::DomainStructured object.
#
# Example:
#   Code
#     > set dom1 [gul::DomStr4Edges $edge1 $edge2 $edge3 $edge4]
#       puts $dom1
#
#   Glyph 1 Output
#     > DM2
#
#   Glyph 2 Output
#     > ::pw::DomainStructured_94
#
###############################################################
proc DomStr4Edges {e1 e2 e3 e4} {}

###############################################################
# Proc: DomUnsEdges
#   Create an unstructured domain from a list of edges.
#
# Glyph 1 Parameters:
#   edgeList - List of edges.
#
# Glyph 2 Parameters:
#  edgeList - List of edges.
#
# Glyph 1 Returns:
#   The new domain's ID.
#
# Glyph 2 Returns:
#   The new domain object.
#
# Example:
#   Code
#     > gul::DomUnsConnectors [list $e1 $e2 $e3]
#
#   Glyph 1 Output
#     > DM3
#
#   Glyph 2 Output
#     > ::pw::DomainUnstructured_1
#
###############################################################
proc DomUnsEdges {edgeList} {}

# Group: Domain Utilities

###############################################################
#
# Proc: DomDelete
#   Delete domains with an option of special delete specified.
#
# Glyph 1 Parameters:
#    domList          - A list of domains.
#    option           - A string.
#
# Glyph 2 Parameters:
#    domList          - A list of domains.
#    option           - A string.
#
# Returns:
#   Specified domains are deleted. If the option is "Special",
#   all the parent entities are deleted as well.
#
###############################################################
proc DomDelete {domList option} {}

###############################################################
#
# Proc: DomGetPt
#   Obtain xyz coordinates of a point given an index.
#
# Glyph 1 Parameters:
#    dom              - A domain.
#    ind              - Index of the target point. It must be
#                       ij list for structured domain and point
#                       index for unstructured domain.
#
# Glyph 2 Parameters:
#    dom              - A domain.
#    ind              - Index of the target point. It must be
#                       ijk list for structured domain and point
#                       index for unstructured domain.
#
# Returns:
#   XYZ coordinates of the point at the given the index.
#
###############################################################
proc DomGetPt { dom ind } {}

###############################################################
#
# Proc: DomGetSubs
#   Obtain a list of the sub-domains in a given domain.
#
# Glyph 1 Parameters:
#    dom              - Target domain.
#
# Glyph 2 Parameters:
#    dom              - Target domain.
#
# Returns:
#    A list of sub-domains.
#
###############################################################
proc DomGetSubs {dom} {}

###############################################################
#
# Proc: DomPeriodicRot
#   Get a list of periodic domains created via rotation
#
# Glyph 1 Parameters:
#    domList             - A list of domains.
#    axisPt1             - The 1st point of the rotation axis.
#    axisPt2             - The 2nd point of the rotation axis.
#    rotAngle            - Value of the rotation angle.
#
# Glyph 2 Parameters:
#    domList             - A list of domains.
#    axisPt1             - The 1st point of the rotation axis.
#    axisPt2             - The 2nd point of the rotation axis.
#    rotAngle            - Value of the rotation angle.
#
# Returns:
#    A list of periodic domains that were created via rotation.
#
###############################################################
proc DomPeriodicRot {  domList axisPt1 axisPt2 rotAngle } {}

###############################################################
#
# Proc: DomPeriodicTrans
#   Get a list of periodic domains created via translation
#
# Glyph 1 Parameters:
#    domList             - A list of domains.
#    offset              - A list of XYZ offset.
#
# Glyph 2 Parameters:
#    domList             - A list of domains.
#    offset              - A list of XYZ offset.
#
# Returns:
#    A list of periodic domains that were created via translation.
#
###############################################################
proc DomPeriodicTrans { domList offset } {}

###############################################################
# Proc: DomChangeDisplay
#   Change the display style of a list of domains.
#
# Glyph 1 Parameters:
#   domList - List of domain IDs.
#   style   - Wanted style.
#             Must be < "WIREFRAME" | "OFF" >.
#   color   - Wanted color.
#             Must be an integer with range [0, 6].
#
# Glyph 2 Parameters:
#   domList - List of pw::Domain ojects.
#   style   - Wanted style.
#             Must be < "WIREFRAME" | "OFF" >.
#   color   - Wanted color.
#             Must be an integer with range [0, 8].
#             - 0: 0x00ffa0a0
#             - 1: 0x0000af00
#             - 2: 0x00ff8800
#             - 3: 0x000000af
#             - 4: 0x00ffff00
#             - 5: 0x00af0000
#             - 6: 0x00ff00ff
#             - 7: 0x00888800
#             - 8: 0x00008888
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > set domList [list $dom1 $dom2]
#       gul::DomChangeDisplay $domList "WIREFRAME" 3
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc DomChangeDisplay {domList style {color 1}} {}

###############################################################
# Proc: DomEllipticSolve
#   Run the elliptic solver on a domain.
#
# Glyph 1 Parameters:
#   domList    - List of domain IDs.
#   iterations - Number of iterations to run.
#                Must be an integer with range (0, infinity).
#
# Glyph 2 Parameters:
#   domList    - List of pw::Domain objects.
#   iterations - Number of iterations to run.
#                Must be an integer with range [0, infinity).
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > set domList [list $dom1 $dom2]
#       gul::DomEllipticSolve $domList 50
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc DomEllipticSolve {domList {iterations 10}} {}

###############################################################
# Proc: DomExtrudeNormal
#   Extrude domain from list of connectors.
#
# Glyph 1 Parameters:
#   conList    - List of connector IDs.
#   initDs     - Initial marching step size.
#                Must be a float with range (0.0, infinity).
#   cellGr     - Growth rate of marching step size.
#                Must be a float with range (0.0, infinity).
#   blDist     - Number of iterations to run.
#                Must be an integer with range [0, infinity).
#   volSmth    - Rate at which grid point clustering will be relaxed
#                as the grid is extruded.
#                Must be a float with range [0.0, 1.0].
#                A value of 0.0 retains the clustering out to the
#                outer boundary.
#                The NOMINAL or default value of 0.5 rapidly
#                relaxes the clustering.
#   vec1       - First vector. Must be a list of floats.
#   vec2       - Second vector. Must be a list of floats.
#   constAxis  - Must be < "X" | "Y" | "Z" >.
#   constBegin - Boolean option to keep the coordinate specified by
#                constAxis constant along the starting boundary.
#   constEnd   - Boolean option to keep the coordinate specified by
#                constAxis constant along the ending boundary.
#   symAxis    - Must be < "X" | "Y" | "Z" >.
#   symBegin   - Boolean option to keep the grid symmetric about the
#                axis specified by symAxis for the starting boundary.
#   symEnd     - Boolean option to keep the grid symmetric about the
#                axis specified by symAxis for the ending boundary.
#
# Glyph 2 Parameters:
#   conList    - List of pw::Connector objects.
#   initDs     - Initial marching step size.
#                Must be a float with range (0.0, infinity).
#   cellGr     - Growth rate of marching step size.
#                Must be a float with range (0.0, infinity).
#   blDist     - Number of iterations to run.
#                Must be an integer with range [0, infinity).
#   volSmth    - Rate at which grid point clustering will be relaxed
#                as the grid is extruded.
#                Must be a float with range [0.0, 1.0].
#                A value of 0.0 retains the clustering out to the
#                outer boundary.
#                The NOMINAL or default value of 0.5 rapidly
#                relaxes the clustering.
#   vec1       - First vector. Must be a list of floats.
#   vec2       - Second vector. Must be a list of floats.
#   constAxis  - Must be < "X" | "Y" | "Z" >.
#   constBegin - Boolean option to keep the coordinate specified by
#                constAxis constant along the starting boundary.
#   constEnd   - Boolean option to keep the coordinate specified by
#                constAxis constant along the ending boundary.
#   symAxis    - Must be < "X" | "Y" | "Z" >.
#   symBegin   - Boolean option to keep the grid symmetric about the
#                axis specified by symAxis for the starting boundary.
#   symEnd     - Boolean option to keep the grid symmetric about the
#                axis specified by symAxis for the ending boundary.
#
# Glyph 1 Returns:
#   The new structured domain ID.
#
# Glyph 2 Returns:
#   The new pw::DomainStructured object.
#
# Example:
#   Code
#     > set conList1 [list $con5 $con6 $con7 $con8]
#       set v1 [pwu::Vector3 set 0 1 0]
#       set v2 [pwu::Vector3 set 1 0 0]
#       set domExt [gul::DomExtrudeNormal $conList1 0.05 1.1 20 0.4 $v1 $v2 "Z" 0 0 "Y" 0 0]
#       puts $domExt
#
#   Glyph 1 Output
#     > DM3
#   Glyph 2 Output
#     > ::pw::DomainStructured_95
#
###############################################################
proc DomExtrudeNormal {conList initDs cellGr blDist volSmth vec1 vec2 \
                       {constAxis 0} {constBegin 0} {constEnd 0} \
                       {symAxis 0} {symBegin 0} {symEnd 0}} {}

###############################################################
# Proc: DomGetAll
#   Return all domains in the grid.
#
# Parameters:
#   None
#
# Glyph 1 Returns:
#   List of domain IDs.
#
# Glyph 2 Returns:
#   List of pw::Domain objects.
#
# Example:
#   Code
#     > set allDoms [gul::DomGetAll]
#       puts $allDoms
#
#   Glyph 1 Output
#     > DM1 DM2 DM3
#   Glyph 2 Output
#     > ::pw::DomainStructured_93 ::pw::DomainStructured_94 ::pw::DomainStructured_95
#
###############################################################
proc DomGetAll {} {}

###############################################################
# Proc: DomGetEdgeConnectors
#   Return a list of cons making up a domain's edge.
#
# Glyph 1 Parameters:
#   dom     - Domain ID.
#   edgeNum - Edge number. Must be an integer with range (0, infinity).
#
# Glyph 2 Parameters:
#   dom     - pw::Domain object.
#   edgeNum - Edge number.
#             Must be an integer with range [1, number edges in dom].
#
# Glyph 1 Returns:
#   List of connector IDs.
#
# Glyph 2 Returns:
#   List of pw::Connector objects.
#
# Example:
#   Code
#     > set componentCons [gul::DomGetEdgeConnectors $dom1 1]
#       puts $componentCons
#
#   Glyph 1 Output
#     > CN5
#   Glyph 2 Output
#     > ::pw::Connector_281
#
###############################################################
proc DomGetEdgeConnectors {dom edgeNum}  {}

###############################################################
# Proc: DomInitialize
#   Initialize a list of domains.
#
# Glyph 1 Parameters:
#   domList - List of domain IDs.
#
# Glyph 2 Parameters:
#   domList - List of pw::Domain objects.
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > set domList [list $dom1 $dom2]
#       gul::DomInitialize $domList
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc DomInitialize {domList} {}

###############################################################
# Proc: DomJoin
#   Join a list of domains.
#
# Glyph 1 Parameters:
#   domList - List of domain IDs.
#
# Glyph 2 Parameters:
#   domList - List of pw::Domain objects.
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > set domList [list $dom1 $dom2]
#       gul::DomJoin $domList
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc DomJoin {domList} {}

###############################################################
# Proc: DomLinearProjection
#   Linear projection of a domain.
#
# Glyph 1 Parameters:
#   dom  - Domain ID.
#   db   - Database entity ID.
#   axis - Specify which direction to project.
#          Must be < "X" | "Y" | "Z" | "-X" | "-Y" | "-Z" >.
#
# Glyph 2 Parameters:
#   dom  - pw::Domain object.
#   db   - pw::DatabaseEntity object.
#   axis - Specify which direction to project.
#          Must be < "X" | "Y" | "Z" | "-X" | "-Y" | "-Z" >.
#
# Returns:
#   Nothing
#
# Example:
#   Code
#     > gul::DomLinearProjection $dom1 $dbSurf "Y"
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc DomLinearProjection {dom db axis} {}

###############################################################
# Proc: DomNewTRexCondition
#   Create and apply a T-Rex condition to a set of connectors. This procedure
#   accepts parameters specific to one of Gridgen or Pointwise and replaces them
#   automatically with their equivalents in the current preprocessor, if any
#   such equivalents exist. For instance, a list of Gridgen attributes will
#   produce the same results in Pointwise as in Gridgen without requiring the
#   attributes to be changed manually.
#
# Glyph 1 Parameters:
#   domain     - ID of domain owning the target connectors.
#   cons       - List of connector IDs on which to apply the condition.
#   type       - New condition type.
#                Must be one of "Off", "Wall", "Match", "AdjacentGrid" (PW) or
#                "OFF", "DEFAULT", or a positive real number (GG). Pointwise types
#                are replaced with their Gridgen equivalents during execution.
#   name       - Name of the new condition.
#   attributes - List of unstructured solver attributes in the form
#                [list att1 val1 val2 ... valn att2 val1 val2 ...valn att3...]
#                The attributes may be either Gridgen or Pointwise attributes
#                which will be translated into their equivalent commands if
#                necessary and if such commands exist.
#
# Glyph 2 Parameters:
#   domain     - Domain object owning the target connectors.
#   cons       - List of target connectors on which to apply the condition.
#                Each list entry may be a pw::Connector object or a list of a
#                connector and one of the strings "SAME" or "OPPOSITE" to
#                indicate the connector's orientation.
#   type       - New condition type.
#                Must be one of "Off", "Wall", "Match", "AdjacentGrid" (PW) or
#                "OFF", "DEFAULT", or a positive real number (GG). Gridgen types
#                are replaced with their Pointwise equivalents during execution.
#   name       - Name of the new condition.
#   attributes - List of unstructured solver attributes in the form
#                [list att1 val1 val2 ... valn att2 val1 val2 ...valn att3...]
#                The attributes may be either Gridgen or Pointwise attributes
#                which will be translated into their equivalent commands if
#                necessary and if such commands exist.
#
# Glyph 1 Returns:
#   0 on success
#
# Glyph 2 Returns:
#   The new pw::TRexCondition object
#
# Example:
#   Code
#     > set trc1 [gul::DomNewTRexCondition $dom1 $con1 Wall "wall_1" \
#          [list -aniso_growth_rate 1.2 TRexFullLayers 3 TRexMaximumLayers 5]]
#     > puts $trc1
#
#   Glyph 1 Output
#     > 0
#
#   Glyph 2 Output
#     > ::pw::TRexCondition_3
#
###############################################################
proc DomNewTRexCondition {domain cons type {name 0} {attributes 0}} {}

###############################################################
# Proc: DomSetUnsSolverAttrs
#   Set a list of attributes for an unstructured solver. Attributes from one of
#   Pointwise or Gridgen are automatically translated into their equivalents
#   (if they exist) for the current preprocessor. Unsupported attributes are
#   skipped.
#
# Glyph 1 Parameters:
#   domain     - Domain ID.
#   attributes - List of unstructured solver attributes in the form
#                [list att1 val1 val2 ... valn att2 val1 val2 ...valn att3...]
#
# Glyph 2 Parameters:
#   domain     - pw::DomainUnstructured object
#   attributes - List of unstructured solver attributes in the form
#                [list att1 val1 val2 ... valn att2 val1 val2 ...valn att3...]
#
# Returns:
#   Nothing
#
# Example:
#   Code
#     > gul::DomSetUnsSolverAttrs $dom [list -aniso_delta_s_smooth_relax 0.4 \
#            TRexMaximumLayers 7]
#
#   Glyph 1 Output
#     >
#
#   Glyph 2 Output
#     >
#
###############################################################
proc DomSetUnsSolverAttrs {domain attributes} {}

###############################################################
# Proc: DomSetTRexSpacing
#   Set the initial spacing for T-Rex wall boundaries.
#
# Glyph 1 Parameters:
#   domain  - Domain ID.
#   conList - List of connector IDs on which to apply the desired spacing.
#   spacing - The desired spacing.
#
# Glyph 2 Parameters:
#   domain  - pw::DomainUnstructured object
#   conList - List of connector objects on which to apply the desired spacing.
#   spacing - The desired spacing.
#
# Returns:
#   Nothing
#
# Example:
#   Code
#     > gul::DomSetTRexSpacing $dom1 [list $con1 $con2] 0.05
#
#   Glyph 1 Output
#     >
#
#   Glyph 2 Output
#     >
#
###############################################################
proc DomSetTRexSpacing {domain conList spacing} {}


###############################################################
# Proc: DomProjectClosestPoint
#   Closest point projection of a domain.
#
# Glyph 1 Parameters:
#   dom      - Domain ID.
#   dbEnts   - List of database entity IDs.
#   interior - Boolean option to use only interior points when projecting.
#
# Glyph 2 Parameters:
#   dom      - pw::Domain object.
#   dbEnts   - List of pw::DatabaseEntity objects.
#   interior - Boolean option to use only interior points when projecting.
#
# Returns:
#   Nothing
#
# Example:
#   Code
#     > gul::DomProjectClosestPoint $dom1 $dbSurf 0
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc DomProjectClosestPoint {dom dbEnts {interior 0}} {}

###############################################################
# Proc: DomRotate
#   Rotate a list of domains.
#
# Glyph 1 Parameters:
#   domList  - Domains to be rotated. Must be a list of domain IDs.
#   axis     - Axis to rotate about. Must be < "X" | "Y" | "Z" >.
#   angle    - Number of degrees to rotate.
#              Must be a float with range (-360.0, 0.0) and (0.0, 360.0).
#
# Glyph 2 Parameters:
#   domList  - Domains to be rotated. Must be a list of pw::Domain objects.
#   axis     - Axis to rotate about. Must be < "X" | "Y" | "Z" >.
#   angle    - Number of degrees to rotate.
#              Must be a float with range [-360.0, 0.0) and (0.0, 360.0].
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > gul::DomRotate $domList "Y" 159
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc DomRotate {domList axis angle} {}

###############################################################
# Proc: DomSplit
#   Split a domain.
#
# Glyph 1 Parameters:
#   dom   - Domain ID.
#   dir   - Specify which coordinate index is referring to.
#           Must be < "I" | "J" >.
#   index - Position to split at.
#           Must be an integer with range (0, infinity).
#
# Glyph 2 Parameters:
#   dom   - pw::DomainStructured object.
#   dir   - Specify which coordinate index is referring to.
#           Must be < "I" | "J" >.
#   index - Position to split at.
#           Must be an integer with range (0, infinity).
#
# Glyph 1 Returns:
#   Domain ID of the second portion of dom having grid lines
#   greater than index.
#   - The first portion of dom retains the original identifier.
#
# Glyph 2 Returns:
#   pw::DomainStructured object for the second portion of dom
#   having grid lines greater than index.
#   - The first portion of dom retains the original identifier.
#
# Example:
#   Code
#     > set newDom [gul::DomSplit $dom1 "I" 5]
#       puts $newDom
#
#   Glyph 1 Output
#     > DM4
#   Glyph 2 Output
#     > ::pw::DomainStructured_96
#
###############################################################
proc DomSplit {dom dir index} {}

###############################################################
# Proc: DomUsage
#   Return a list of blocks using a domain.
#
# Glyph 1 Parameters:
#   dom - Domain ID.
#
# Glyph 2 Parameters:
#   dom - pw::Domain object.
#
# Glyph 1 Returns:
#   List of block IDs.
#
# Glyph 2 Returns:
#   List of pw::Block objects.
#
# Example:
#   Code
#     > set blocksUsing [gul::DomUsage $dom1]
#       puts $blocksUsing
#
#   Glyph 1 Output
#     > BL1
#   Glyph 2 Output
#     > ::pw::BlockStructured_89
#
###############################################################
proc DomUsage {dom} {}

