
# Module: Connector

# Group: Connector Creation

###############################################################
#
# Proc: ConPeriodicRot
#   Create connectors as a periodic rotation of existing cons.
#
# Glyph 1 Parameters:
#    conList             - A list of connectors.
#    axisPt1             - The 1st point of the rotation axis.
#    axisPt2             - The 2nd point of the rotation axis.
#    rotAngle            - Value of the rotation angle.
#
# Glyph 2 Parameters:
#    conList             - A list of connectors.
#    axisPt1             - The 1st point of the rotation axis.
#    axisPt2             - The 2nd point of the rotation axis.
#    rotAngle            - Value of the rotation angle.
#
# Returns:
#    A list of periodic connectors that were created via rotation.
#
###############################################################
proc ConPeriodicRot { conList axisPt1 axisPt2 rotAngle } {}

###############################################################
#
# Proc: ConPeriodicTrans
#   Create connectors as a periodic translation of existing cons.
#
# Glyph 1 Parameters:
#    conList             - A list of connectors.
#    offset              - A list of XYZ offset.
#
# Glyph 2 Parameters:
#    conList             - A list of connectors.
#    offset              - A list of XYZ offset.
#
# Returns:
#    A list of periodic domains that were created via translation.
#
###############################################################
proc ConPeriodicTrans { conList offset } {}

###############################################################
# Proc: ConCreateConic
#   Create a CONIC connector from 2 end points, a tangency point, and rho value.
#
# Parameters:
#   pt1    - Starting point for wanted connector.
#            Must be a list of three floats.
#   pt2    - Ending point for wanted connector.
#            Must be a list of three floats.
#   tan_pt - Tangent intersection point for wanted connector.
#            Must be a list of three floats.
#   rho    - Specifies the value of rho.
#            A value of 0.5 results in a parabolic segment,
#            a value between 0 and 0.5 results in an elliptic segment,
#            and a value between 0.5 and 1 results in a hyperbolic segment.
#            Must be a float with range (0.0, 1.0).
#
# Glyph 1 Returns:
#   The new connector's ID.
#
# Glyph 2 Returns:
#   The new pw::Connector object.
#
# Example:
#   Code
#     > set con1 [gul::ConCreateConic [list 0 0 0] [list 1 1 1] \
#             [list 0.5 0.2 -1] 0.5]
#       puts $con1
#
#   Glyph 1 Output
#     > CN1
#
#   Glyph 2 Output
#     > ::pw::Connector_298
#
###############################################################
proc ConCreateConic { pt1 pt2 tan_pt rho } {}

###############################################################
# Proc: ConDbArcLengths
#   Create a DB_LINE connector from a DB ID and two arc lengths.
#
# Glyph 1 Parameters:
#   db_id       - Database entity ID.
#   s1          - Initial arc length to define wanted connector.
#                 Must be a float in the range [0.0, 1.0).
#   s2          - Final arc length to define wanted connector.
#                 Must be a float in the range (s1, 1.0].
#
# Glyph 2 Parameters:
#   dbEnt       - Database entity.
#   s1          - Initial arc length to define wanted connector.
#                 Must be a float in the range [0.0, 1.0).
#   s2          - Final arc length to define wanted connector.
#                 Must be a float in the range (s1, 1.0].
#
# Glyph 1 Returns:
#   The new connector's ID.
#
# Glyph 2 Returns:
#   The new pw::Connector object.
#
# Example:
#   Code
#     > set conDB [gul::ConDbArcLengths $curve1 0.25 0.75]
#       puts $conDB
#
#   Glyph 1 Output
#     > CN2
#
#   Glyph 2 Output
#     > ::pw::Connector_6
#
###############################################################
proc ConDbArcLengths { db_id s1 s2 } {}

###############################################################
# Proc: ConFrom2Points
#   Create a 3D_LINE connector from 2 points.
#
# Parameters:
#   pt1 - First point defining wanted connector.
#         Must be a list of three floats.
#   pt2 - Second point defining wanted connector.
#         Must be a list of three floats.
#
# Glyph 1 Returns:
#   The new connector's ID.
#
# Glyph 2 Returns:
#   The new pw::Connector object.
#
# Example:
#   Code
#     > set con1 [gul::ConFrom2Points [list 0 0 0] [list 1 1 1]]
#       puts $con1
#
#   Glyph 1 Output
#     > CN2
#
#   Glyph 2 Output
#     > ::pw::Connector_299
#
###############################################################
proc ConFrom2Points { pt1 pt2 } {}


###############################################################
# Proc: ConFrom3Points
#   Create a 3D_LINE connector from 3 points.
#
# Parameters:
#   pt1          - First point defining wanted connector.
#                  Must be a list of three floats.
#   pt2          - Second point defining wanted connector.
#                  Must be a list of three floats.
#   pt3          - Third point defining wanted connector.
#                  Must be a list of three floats.
#   type         - Type of connector to be created.
#                  Must be < "LINE" | "AKIMA" | "AKIMA_END_SLOPE_MATCH" >.
#   slope_weight - Must be a float with range [0.0, 1.0].
#
# Glyph 1 Returns:
#   The new connector's ID.
#
# Glyph 2 Returns:
#   The new pw::Connector object.
#
# Example:
#   Code
#     > set con1 [gul::ConFrom3Points [list 0 0 0] [list 1 0 0] \
#       [list 1 1 1] "AKIMA" 0.2]
#       puts $con1
#
#   Glyph 1 Output
#     > CN3
#
#   Glyph 2 Output
#     > ::pw::Connector_300
#
###############################################################
proc ConFrom3Points { pt1 pt2 pt3 {type "LINE"} {slope_weight 0.5} } {}

###############################################################
# Proc: ConOnDbEntities
#   Create a connector on database entities.
#
# Glyph 1 Parameters:
#   dbEnts - List of database entity IDs.
#   angle  - Joining angle used in determining whether two newly
#            created connectors should be joined.
#            Must be a float.
#
# Glyph 2 Parameters:
#   dbEnts - List of pw::DatabaseEntity objects.
#   angle  - Joining angle used in determining whether two newly
#            created connectors should be joined.
#            Must be a float with range [0.0, 180.0).
#
# Glyph 1 Returns:
#   A list of the new Connector ID's
#
# Glyph 2 Returns:
#   A list of the new pw::Connector objects.
#
# Example:
#   Code
#     > set conSurf [gul::ConOnDbEntities $surf 0]
#       puts $conSurf
#
#   Glyph 1 Output
#     > CN5 CN6 CN7 CN8
#
#   Glyph 2 Output
#     > ::pw::Connector_9 ::pw::Connector_10 ::pw::Connector_11 ::pw::Connector_12
#
###############################################################
proc ConOnDbEntities { dbEnts {angle 0} } {}

###############################################################
# Proc: ConOnDbSurface
#   Create a DB_LINE connector from a DB ID and a list of UV pairs.
#
# Glyph 1 Parameters:
#   db_id - Database entity ID.
#   uv1   - Starting point of wanted connector.
#           Must be a list of two floats with range [0.0, 1.0].
#   uv2   - Ending point of wanted connector.
#           Must be a list of two floats with range [0.0, 1.0].
#
# Glyph 2 Parameters:
#   db_id - pw::DatabaseEntity object.
#   uv1   - Starting point of wanted connector.
#           Must be a list of two floats with range [0.0, 1.0].
#   uv2   - Ending point of wanted connector.
#           Must be a list of two floats with range [0.0, 1.0].
#
# Glyph 1 Returns:
#   The new connector's ID.
#
# Glyph 2 Returns:
#   The new pw::Connector object.
#
# Example:
#   Code
#     > set startUV [list 0.2 0.2]; set endUV [list 0.8 0.9];
#       set conSurf [gul::ConOnDbSurface $surf $startUV $endUV]
#       puts $conSurf
#
#   Glyph 1 Output
#     > CN9
#
#   Glyph 2 Output
#     > ::pw::Connector_26
#
###############################################################
proc ConOnDbSurface { db_id uv1 uv2 } {}

###############################################################
# Proc: ConCreateEdge
#   Create an edge from a list of connectors.
#
# Glyph 1 Parameters:
#   conList - List of connector IDs.
#
# Glyph 2 Parameters:
#   conList - List of pw::Connector objects.
#
# Glyph 1 Returns:
#   List of IDs of connectors in the edge.
#
# Glyph 2 Returns:
#   The new pw::Edge object.
#
# Example:
#   Code
#     > gul::ConCreateEdge [list $con1 $con2]
#
#   Glyph 1 Output
#     > CN12 CN13 CN14
#
#   Glyph 2 Output
#     > ::pw::Edge_1
#
###############################################################
proc ConCreateEdge {conList} {}

###############################################################
# Proc: ConEdgeFromPoints
#   Create a piecewise linear edge from a list of points.
#
# Glyph 1 Parameters:
#   ptList - List of points.
#
# Glyph 2 Parameters:
#   ptList - List of points.
#
# Glyph 1 Returns:
#   List of IDs of connectors in the edge.
#
# Glyph 2 Returns:
#   The new pw::Edge object.
#
# Example:
#   Code
#     > gul::ConEdgeFromPoints [list $point1 $point2 $point3]
#
#   Glyph 1 Output
#     > CN22 CN23
#
#   Glyph 2 Output
#     > ::pw::Edge_3
#
###############################################################
proc ConEdgeFromPoints {ptList} {}

# Group: Connector Utilties

###############################################################
#
# Proc: ConAddBreakPt
#   Add break points at given grid points or arc length ratio.
#
# Glyph 1 Parameters:
#    con                 - A connector.
#    type                - String of "X", "Y", "Z" or "ARC".
#    locList             - Value of X, Y, Z or length ratio.
#
# Glyph 2 Parameters:
#    con                 - A connector.
#    type                - String of "X", "Y", "Z" or "ARC".
#    locList             - Value of X, Y, Z or length ratio.
#
# Returns:
#    Nothing.
#
###############################################################
proc ConAddBreakPt { con type locList } {}

###############################################################
#
# Proc: ConGetNumSub
#   Obtain the number of subconnectors of a given connector.
#
# Glyph 1 Parameters:
#    con              - A connector.
#
# Glyph 2 Parameters:
#    con              - A connector.
#
# Returns:
#   The number of the sub-connectors of the target connector.
#
###############################################################
proc ConGetNumSub { con } {}

###############################################################
#
# Proc: ConMerge
#    Merge connectors given a connector topology preference.
#
# Glyph 1 Parameters:
#    topo             - String of "Free", "All" or "NONMANIFOLD_FREE".
#    tol              - Merging tolerance.
#
# Glyph 2 Parameters:
#    topo             - String of "Free", "All" or "NONMANIFOLD_FREE".
#    tol              - Merging tolerance.
#
# Returns:
#   Nothing.
#
###############################################################
proc ConMerge { topo tol } {}

###############################################################
# Proc: ConCalculateSuitableDimension
#   Calculate a suitable connector dimension such that an approximately
#   constant geometric progression of cell size is achieved.
#
# Glyph 1 Parameters:
#   con        - Connector ID.
#   begSpacing - Wanted beginning clustering constraint.
#                Must be a float with range [0.0, infinity).
#   endSpacing - Wanted ending clustering constraint.
#                Must be a float with range [0.0, infinity).
#
# Glyph 2 Parameters:
#   con        - pw::Connector object.
#   begSpacing - Wanted beginning clustering constraint.
#                Mut be a float with range [0.0, infinity).
#   endSpacing - Wanted ending clustering constraint.
#                Must be a float with range [0.0, infinity).
#
# Returns:
#   Calculated dimension as an integer.
#
# Example:
#   Code
#     > set con1 [gul::ConFrom2Points [list 0 0 0] [list 1 1 1]]
#       set dim [gul::ConCalculateSuitableDimension $con1 0.05 0.1]
#       puts $dim
#
#   Glyph 1 Output
#     > 25
#
#   Glyph 2 Output
#     > 25
#
###############################################################
proc ConCalculateSuitableDimension {con begSpacing endSpacing} {}

###############################################################
# Proc: ConDelete
#   Delete connectors.
#
# Glyph 1 Parameters:
#   conList - List of connector IDs.
#
# Glyph 2 Parameters:
#   conList - List of pw::Connector objects.
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > set con1 [gul::ConFrom2Points [list 3 1 4] [list 1 5 9]]
#       set con2 [gul::ConFrom2Points [list 1 5 9] [list 2 6 5]]
#       gul::ConDelete [list $con1 $con2]
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc ConDelete {conList} {}

###############################################################
# Proc: ConFindAllAdjacent
#   Get a list of connectors that are incident on the given connector's end points.
#
# Glyph 1 Parameters:
#   con - Connector ID.
#
# Glyph 2 Parameters:
#   con - pw::Connector object.
#
# Glyph 1 Returns:
#   List of adjacent connector IDs.
#
# Glyph 2 Returns:
#   List of adjacent pw::Connector objects.
#
# Example:
#   Code
#     > set con1 [gul::ConFrom2Points [list 3 1 4] [list 1 5 9]]
#       set con2 [gul::ConFrom2Points [list 1 5 9] [list 2 6 5]]
#       set con3 [gul::ConFrom2Points [list 2 6 5] [list 3 5 8]]
#       set adjCons [gul::ConFindAllAdjacent $con2]
#       puts $adjCons
#
#   Glyph 1 Output
#     > CN12 CN14
#
#   Glyph 2 Output
#     > ::pw::Connector_302 ::pw::Connector_304
#
###############################################################
proc ConFindAllAdjacent {con} {}

###############################################################
# Proc: ConGetAll
#   Get a list of all connectors.
#
# Parameters:
#   None
#
# Glyph 1 Returns:
#   List of connector IDs.
#
# Glyph 2 Returns:
#   List of pw::Connector objects.
#
# Example:
#   Code
#     > set allCons [gul::ConGetAll ]
#       puts $allCons
#
#   Glyph 1 Output
#     > CN1 CN2 CN3
#
#   Glyph 2 Output
#     > ::pw::Connector_298 ::pw::Connector_299 ::pw::Connector_300
#
###############################################################
proc ConGetAll {} {}

###############################################################
# Proc: ConGetBeginSpacing
#   Get the connector's begin spacing.
#
# Glyph 1 Parameters:
#   con - Connector ID.
#
# Glyph 2 Parameters:
#   con - pw::Connector object.
#
# Returns:
#   Connector's begin spacing as a float.
#
# Example:
#   Code
#     > set con1 [gul::ConFrom2Points [list 3 1 4] [list 1 5 9]]
#       set beginSpacing [gul::ConGetBeginSpacing $con1]
#       puts $beginSpacing
#
#   Glyph 1 Output
#     > 0.1
#
#   Glyph 2 Output
#     > 0.1
#
###############################################################
proc ConGetBeginSpacing {con} {}

###############################################################
# Proc: ConGetDimension
#   Get a con's dimension.
#
# Glyph 1 Parameters:
#   con - Connector ID.
#
# Glyph 2 Parameters:
#   con - pw::Connector object.
#
# Returns:
#   Dimension of con as an integer.
#
# Example:
#   Code
#     > set dim [gul::ConGetDimension $con1]
#       puts $dim
#
#   Glyph 1 Output
#     > 5
#
#   Glyph 2 Output
#     > 5
#
###############################################################
proc ConGetDimension { con } {}

###############################################################
# Proc: ConGetEndSpacing
#   Get the connector's end spacing.
#
# Glyph 1 Parameters:
#   con - Connector ID.
#
# Glyph 2 Parameters:
#   con - pw::Connector object.
#
# Returns:
#   Connector end spacing as a float.
#
# Example:
#   Code
#     > set endSpacing [gul::ConGetEndSpacing $con1]
#       puts $endSpacing
#
#   Glyph 1 Output
#     > 0.1
#
#   Glyph 2 Output
#     > 0.1
#
###############################################################
proc ConGetEndSpacing {con} {}

###############################################################
# Proc: ConGetLength
#   Determines length of a connector.
#
# Glyph 1 Parameters:
#   con - Connector ID.
#
# Glyph 2 Parameters:
#   con - pw::Connector object.
#
# Returns:
#   Length of connector as a float.
#
# Example:
#   Code
#     > set con1 [gul::ConFrom2Points [list 3 1 4] [list 1 5 9]]
#       set length [gul::ConGetLength $con1]
#       puts $length
#
#   Glyph 1 Output
#     > 6.7082039325
#
#   Glyph 2 Output
#     > 6.708203932499369
#
###############################################################
proc ConGetLength {con} {}

###############################################################
# Proc: ConGetNodeTolerance
#   Returns the node tolerance.
#
# Parameters:
#   None
#
# Returns:
#   The node tolerance as a float.
#
# Example:
#   Code
#     > set nodeTol [gul::ConGetNodeTolerance ]
#       puts $nodeTol
#
#   Glyph 1 Output
#     > 0.0001
#
#   Glyph 2 Output
#     > 0.0001
#
###############################################################
proc ConGetNodeTolerance {} {}

###############################################################
# Proc: ConGetXYZatU
#   Determines the x,y,z coordinates on a connector at
#   specified U coordinate.
#
# Glyph 1 Parameters:
#   con_id     - Connector ID.
#   arc_length - Position of wanted point on con_id.
#                Must be a float with range [0.0, 1.0].
#
# Glyph 2 Parameters:
#   con_id     - pw::Connector object.
#   arc_length - Position of wanted point on con_id.
#                Must be a float with range [0.0, 1.0].
#
# Returns:
#   Point in terms of xyz coordinates as a list of three floats.
#
# Example:
#   Code
#     > set con1 [gul::ConFrom3Points [list 0 0 0] [list 1 0 0] \
#             [list 1 1 1] "AKIMA" 0.2]
#       set s [gul::ConGetXYZatU $con1 0.34]
#       puts $s
#
#   Glyph 1 Output
#     > 0.8275422978 -0.098849891696 -0.098849891696
#
#   Glyph 2 Output
#     > 0.8275422977980611 -0.09884989169551384 -0.09884989169551384
#
###############################################################
proc ConGetXYZatU {con_id arc_length} {}

###############################################################
# Proc: ConJoin2
#   Join two connectors.
#
# Glyph 1 Parameters:
#   con1 - Connector ID.
#   con2 - Connector ID.
#
# Glyph 2 Parameters:
#   con1 - pw::Connector object.
#   con2 - pw::Connector object.
#
# Glyph 1 Returns:
#   The new single connector ID.
#
# Glyph 2 Returns:
#   The new single pw::Connector object.
#
# Example:
#   Code
#     > set con1 [gul::ConFrom2Points [list 3 1 4] [list 1 5 9]]
#       set con2 [gul::ConFrom2Points [list 1 5 9] [list 2 6 5]]
#       set result [gul::ConJoin2 $con1 $con2]
#       puts $result
#
#   Glyph 1 Output
#     > CN18
#
#   Glyph 2 Output
#     > ::pw::Connector_332
#
###############################################################
proc ConJoin2 {con1 con2} {}

###############################################################
# Proc: ConJoinMultiple
#   Join multiple connectors.
#
# Glyph 1 Parameters:
#   conList - List of connector IDs.
#
# Glyph 2 Parameters:
#   conList - List of pw::Connector objects.
#
# Glyph 1 Returns:
#   The new single connector ID.
#
# Glyph 2 Returns:
#   The new single pw::Connector object.
#
# Example:
#   Code
#     > set con1 [gul::ConFrom2Points [list 3 1 4] [list 1 5 9]]
#       set con2 [gul::ConFrom2Points [list 1 5 9] [list 2 6 5]]
#       set con3 [gul::ConFrom2Points [list 2 6 5] [list 3 5 8]]
#       set wholeCon [gul::ConJoinMultiple [list $con1 $con2 $con3]]
#       puts $wholeCon
#
#   Glyph 1 Output
#     > CN20
#
#   Glyph 2 Output
#     > ::pw::Connector_302
#
###############################################################
proc ConJoinMultiple {conList} {}

###############################################################
# Proc: ConMatchEndpoints
#   Returns the connector matching the given endpoints.
#
# Glyph 1 Parameters:
#   pt1  - Starting point of wanted connector.
#          Must be a list of three floats.
#   pt2  - Ending point of wanted connector.
#          Must be a list of three floats.
#   cons - List of connector IDs to search. If not specified, all
#          connectors will be checked.
#
# Glyph 2 Parameters:
#   pt1  - Starting point of wanted connector.
#          Must be a list of three floats.
#   pt2  - Ending point of wanted connector.
#          Must be a list of three floats.
#   cons - List of pw::Connector objects to search. If not specified, all
#          connectors will be checked.
#
# Glyph 1 Returns:
#   Connector ID if match is found or -1 if match is NOT found.
#
# Glyph 2 Returns:
#   pw::Connector object if match is found or -1 if match is NOT found.
#
# Example:
#   Code
#     > set con1 [gul::ConFrom2Points [list 3 1 4] [list 1 5 9]]
#       set con2 [gul::ConFrom2Points [list 1 5 9] [list 2 6 5]]
#       set con3 [gul::ConFrom2Points [list 2 6 5] [list 3 5 8]]
#       set conList [list $con1 $con2 $con3]
#       set result [gul::ConMatchEndpoints [list 1 5 9] [list 2 6 5] $conList]
#       puts $result
#
#   Glyph 1 Output
#     > CN2
#
#   Glyph 2 Output
#     > ::pw::Connector_337
#
###############################################################
proc ConMatchEndpoints { pt1 pt2 {cons 0}} {}

###############################################################
# Proc: ConPointsAreEqual
#   Determines if two points are within the grid point tolerance.
#
# Parameters:
#   pt1 - First point. Must be a list of three floats.
#   pt2 - Second point. Must be a list of three floats.
#
# Returns:
#   Boolean.
#
# Example:
#   Code
#     > set p1 [list 0 0 0]
#       set p2 [list 0 0 0.0000001]
#       set equal [gul::ConPointsAreEqual $p1 $p2]
#       puts $equal
#
#   Glyph 1 Output
#     > 1
#
#   Glyph 2 Output
#     > 1
#
###############################################################
proc ConPointsAreEqual { pt1 pt2 } {}

##############################################################
# Proc: ConProjectClosestPoint
#   Project connector onto database surface.
#
# Glyph 1 Parameters:
#   con      - Connector ID.
#   dbEnts   - List of database entity IDs.
#   interior - Boolean to set interior_only option when projecting.
#
# Glyph 2 Parameters:
#   con      - pw::Connector object.
#   dbEnts   - List of pw::DatabaseEntity objects.
#   interior - Boolean to set interior option when projecting.
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > gul::ConProjectClosestPoint $con1 $db 0
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc ConProjectClosestPoint {con dbEnts {interior 0}} {}

###############################################################
# Proc: ConSetBeginSpacing
#   Set the connector's beginning spacing.
#
# Glyph 1 Parameters:
#   con     - Connector ID.
#   spacing - New beginning clustering constraint.
#             Must be a float with range [0.0, infinity).
#
# Glyph 2 Parameters:
#   con     - pw::Connector object.
#   spacing - New beginning clustering constraint.
#             Must be a float with range [0.0, infinity).
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > gul::ConSetBeginSpacing $con1 0.05
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc ConSetBeginSpacing { con spacing } {}

###############################################################
# Proc: ConSetDefaultDimension
#   Set default connector dimension and spacing.
#
# Glyph 1 Parameters:
#   dim - New default connector dimension.
#         Must be an integer with range [0, infinity).
#   beg - New default beginning clustering constraint.
#         Must be a float with range (0.0, infinity).
#   end - New default ending clustering constraint.
#         Must be a float with range (0.0, infinity).
#
# Glyph 2 Parameters:
#   dim - New default connector dimension.
#         Must be an integer with range [0, infinity).
#   beg - New default beginning clustering constraint.
#         Must be a float with range [0.0, infinity).
#   end - New default ending clustering constraint.
#         Must be a float with range [0.0, infinity).
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > set dim 10
#       set beg 0.2
#       set end 0.2
#       gul::ConSetDefaultDimension $dim $beg $end
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc ConSetDefaultDimension { dim beg end } {}

###############################################################
# Proc: ConSetDimension
#   Set a con's dimension.
#
# Glyph 1 Parameters:
#   con - Connector ID.
#   dim - New connector dimension.
#         Must be an integer with range [2, infinity).
#
# Glyph 2 Parameters:
#   con - pw::Connector object.
#   dim - New connector dimension.
#         Must be an integer with range [0, 0] and [2, infinity).
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > set con1 [gul::ConFrom2Points [list 3 1 4] [list 1 5 9]]
#       gul::ConSetDimension $con1 10
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc ConSetDimension { con dim } {}

###############################################################
# Proc: ConSetEndSpacing
#   Set the connector's end spacing.
#
# Glyph 1 Parameters:
#   con     - Connector ID.
#   spacing - New end clustering constraint.
#             Must be a float with range [0.0, infinity).
#
# Glyph 2 Parameters:
#   con     - pw::Connector object.
#   spacing - New end clustering constraint.
#             Must be a float with range [0.0, infinity).
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > gul::ConSetEndSpacing $con1 0.05
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc ConSetEndSpacing { con spacing } {}

###############################################################
# Proc: ConSetSpacingEqual
#   Set connector's spacing equal.
#
# Glyph 1 Parameters:
#   con - Connector ID.
#
# Glyph 2 Parameters:
#   con - pw::Connector object.
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > gul::ConSetSpacingEqual $con1
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc ConSetSpacingEqual {con} {}

###############################################################
# Proc: ConSplit
#   Split connector at coordinate.
#
# Glyph 1 Parameters:
#   con   - Connector ID.
#   val   - Describes position on con to split at.
#           Must be either a single float or a list of three floats.
#   const - Must be < "X" | "Y" | "Z" > if val is a single float or
#           "XYZ" if val is a list of three floats.
#
# Glyph 2 Parameters:
#   con   - pw::Connector object.
#   val   - Describes position on con to split at.
#           Must be either a single float or a list of three floats.
#   const - Must be < "X" | "Y" | "Z" > if val is a single float or
#           "XYZ" if val is a list of three floats.
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > set con1 [gul::ConFrom2Points [list 0 0 0] [list 1 1 1]]
#       gul::ConSplit $con1 [list 0.5 0.5 0.5] "XYZ"
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc ConSplit {con val const} {}

