
# Module: Database

# Group: Database Entity Creation

###############################################################
# Proc: DbCreateConic
#   Create a CONIC DB curve from 2 end points, a tangency point, and rho value.
#
# Parameters:
#   pt1    - First endpoint. Must be a list of three floats.
#   pt2    - Second endpoint. Must be a list of three floats.
#   tan_pt - Tangency point. Must be a list of three floats.
#   rho    - Rho value. Must be a float with range (0.0, 1.0).
#
# Glyph 1 Returns:
#   The new database ID.
#
# Glyph 2 Returns:
#   The new pw::Curve object.
#
# Example:
#   Code
#     > set pt1 "3 1 4"
#       set pt2 "1 5 9"
#       set tan_pt "2 6 5"
#       set rho 0.4
#       set dbConic [gul::DbCreateConic $pt1 $pt2 $tan_pt $rho]
#       puts $dbConic
#
#   Glyph 1 Output
#     > DB1
#   Glyph 2 Output
#     > ::pw::Curve_61
#
###############################################################
proc DbCreateConic { pt1 pt2 tan_pt rho } {}

###############################################################
# Proc: DbCreateLine
#   Create a piecewise linear DB curve.
#
# Parameters:
#   pt_list - List of 3D vectors.
#
# Glyph 1 Returns:
#   The new database curve ID.
#
# Glyph 2 Returns:
#   The new pw::Curve object.
#
# Example:
#   Code
#     > set ptList [list "3 5 8" "9 7 9" "3 2 3" "-1 -2 3"]
#       set dbLine [gul::DbCreateLine $ptList]
#       puts $dbLine
#
#   Glyph 1 Output
#     > DB2
#   Glyph 2 Output
#     > ::pw::Curve_62
#
###############################################################
proc DbCreateLine { pt_list } {}

###############################################################
# Proc: DbCreateSurface
#   Create a database surface.
#
# Glyph 1 Parameters:
#   dbEnts - List of database entity IDs.
#
# Glyph 2 Parameters:
#   dbEnts - List of pw::Curve objects.
#
# Glyph 1 Returns:
#   The new database surface ID.
#
# Glyph 2 Returns:
#   The new pw::Surface object.
#
# Example:
#   Code
#     > set line1 [gul::DbCreateLine [list "0 0 0" "1 1 0"]]
#       set line2 [gul::DbCreateLine [list "1 1 0" "0 1 2"]]
#       set line3 [gul::DbCreateLine [list "0 1 2" "1 0 2"]]
#       set line4 [gul::DbCreateLine [list "1 0 2" "0 0 0"]]
#       set dbSurf [gul::DbCreateSurface [list $line1 $line2 $line3 $line4]]
#       puts $dbSurf
#
#   Glyph 1 Output
#     > DB7
#   Glyph 2 Output
#     > ::pw::Surface_11
#
###############################################################
proc DbCreateSurface {dbEnts} {}

###############################################################
# Proc: DbQuiltFromSurfaces
#   Create a quilt from trimmed surfaces.
#
# Glyph 1 Parameters:
#   dbEnts - List of database IDs.
#   tol    - The coincident edge distance tolerance.
#            Must be a float with range (0.0, infinity).
#
# Glyph 2 Parameters:
#   dbEnts - List of pw::DatabaseEntity objects.
#   tol    - Join tolerance.
#            Must be a float with range [0.0, infinity).
#
# Glyph 1 Returns:
#   The new quilt ID.
#
# Glyph 2 Returns:
#   The new pw::Quilt object.
#
# Example:
#   Code
#     > set quilt [gul::DbQuiltFromSurfaces [list $dbSurf]]
#       puts $quilt
#
#   Glyph 1 Output
#     > DB25
#   Glyph 2 Output
#     > ::pw::Quilt_6
#
###############################################################
proc DbQuiltFromSurfaces {dbEnts {tol 0}} {}

###############################################################
# Proc: DbRevolve
#   Create a revolved DB surface from DB curve.
#
# Glyph 1 Parameters:
#   db    - Database entity ID.
#   angle - Number of degrees to revolve db.
#           Must be a float with range (-360.0, 0.0) and (0.0, 360.0).
#   axis  - Axis to revolve about.  Must be < "X" | "Y" | "Z" >.
#
# Glyph 2 Parameters:
#   db    - pw::Curve object.
#   angle - Number of degrees to revolve db.
#           Must be a float with range [-360.0, 0.0) and (0.0, 360.0].
#   axis  - Axis to revolve about.  Must be < "X" | "Y" | "Z" >.
#
# Glyph 1 Returns:
#   The new database ID.
#
# Glyph 2 Returns:
#   The new pw::Surface object.
#
# Example:
#   Code
#     > set dbRevSurf [gul::DbRevolve $line1 360 "X" "0 0 5"]
#       puts $dbRevSurf
#
#   Glyph 1 Output
#     > DB9
#   Glyph 2 Output
#     > ::pw::Surface_12
#
###############################################################
proc DbRevolve {db angle axis} {}

# Group: Database Entity Utilities

###############################################################
# Proc: DbGetAll
#   Return all database entities.
#
# Parameters:
#   None
#
# Glyph 1 Returns:
#   List of database IDs.
#
# Glyph 2 Returns:
#   List of pw::Database objects.
#
###############################################################
proc DbGetAll {} {}

###############################################################
# Proc: DbExtractCurves
#   Extract surfaces and curves from a db shell..
#
# Glyph 1 Parameters:
#   db     - List of database shell entity IDs.
#   angle  - Value of split angle.
#
# Glyph 2 Parameters:
#   db     - List of database shell entity IDs.
#   angle  - Value of split angle.
#
###############################################################
proc DbExtractCurves { db angle } {}

###############################################################
# Proc: DbAdd2Vectors
#   Add two vectors.
#
# Parameters:
#   vecA - First vector to be added.
#          Must be a list of three floats.
#   vecB - Second vector to be added.
#          Must be a list of three floats.
#
# Returns:
#   Vector resulting from adding vecA and vecB
#   as a list of three floats.
#
# Example:
#   Code
#     > set v1 "1 2 3"
#       set v2 "-3 -2 -1"
#       set v [gul::DbAdd2Vectors $v1 $v2]
#       puts $v
#
#   Glyph 1 Output
#     > -2 0 2
#   Glyph 2 Output
#     > -2.0 0.0 2.0
#
###############################################################
proc DbAdd2Vectors {vecA vecB} {}

###############################################################
# Proc: DbArcLengthToU
#   Convert an arc length location for a DB curve to a U value.
#
# Glyph 1 Parameters:
#   db_id      - Database entity ID.
#   arc_length - Position on DB curve.
#                Must be a float with range [0.0, 1.0].
#
# Glyph 2 Parameters:
#   db_id      - pw::Database object.
#   arc_length - Position on DB curve.
#
# Returns:
#   The equivalent U value on the curve as a float.
#
# Example:
#   Code
#     > set u [gul::DbArcLengthToU $line3 0.5]
#       puts $u
#
#   Glyph 1 Output
#     > 0.499999999959
#   Glyph 2 Output
#     > 0.5000000000000007
#
###############################################################
proc DbArcLengthToU {db_id arc_length} {}

###############################################################
# Proc: DbDelete
#   Delete database entity.
#
# Glyph 1 Parameters:
#   db - Database ID to be deleted.
#
# Glyph 2 Parameters:
#   db - pw::Entity object to be deleted.
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > gul::DbDelete $dbConic
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc DbDelete {db} {}

###############################################################
# Proc: DbEnableDisable
#   Changes the enabled status of a list of database entities.
#
# Glyph 1 Parameters:
#   dbList  - List of database entity IDs.
#   enabled - Boolean.
#
# Glyph 2 Parameters:
#   dbList  - List of pw::DatabaseEntity objects.
#   enabled - Boolean.
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > gul::DbEnableDisable [list $line1 $dbRevSurf $dbSurf] FALSE
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc DbEnableDisable {dbList {enabled TRUE}} {}

###############################################################
# Proc: DbExportSegment
#   Export connectors as a segment file.
#
# Glyph 1 Parameters:
#   conList - List of connector IDs or keyword "ALL".
#   fname   - File name to be written to.
#
# Glyph 2 Parameters:
#   conList - List of pw::Connector objects.
#   fname   - File name to be written to.
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > set con1 [gul::ConFrom2Points "1 1 1" "2 2 2"]
#       set con2 [gul::ConFrom2Points "3 3 3" "4 4 4"]
#       gul::DbExportSegment [list $con1 $con2] "cons.txt"
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc DbExportSegment {conList fname} {}

###############################################################
# Proc: DbGetByName
#   Get database entity by name.
#
# Parameters:
#   name - Name of wanted database entity.
#
# Glyph 1 Returns:
#   Database entity ID.
#
# Glyph 2 Returns:
#   pw::DatabaseEntity object.
#
# Example:
#   Code
#     > set target [gul::DbGetByName "curve-2"]
#       puts $target
#
#   Glyph 1 Output
#     > DB1
#   Glyph 2 Output
#     > ::pw::Curve_62
#
###############################################################
proc DbGetByName {name} {}

###############################################################
# Proc: DbGetClosestPoint
#   Determines the location of the closest point on a
#   DB curve to the given point.
#
# Glyph 1 Parameters:
#   db_id     - Database entity ID.
#   source_pt - List of three floats.
#
# Glyph 2 Parameters:
#   db_id     - pw::Database object.
#   source_pt - List of three floats.
#
# Returns:
#   The curve point, the non-dimensional S coordinate, and the
#   non-dimensional U coordinate as a list.
#
# Example:
#   Code
#     > set targetPoint "0 0 0"
#       set closest [gul::DbGetClosestPoint $line2 $targetPoint]
#       puts $closest
#
#   Glyph 1 Output
#     > {0.8 1.0 0.4} 0.199999999975 0.2
#   Glyph 2 Output
#     > {0.8 1.0 0.4} 0.19999999999999948 0.2
#
###############################################################
proc DbGetClosestPoint { db_id source_pt } {}

###############################################################
# Proc: DbGetExtents
#   Get entity extents box.
#
# Glyph 1 Parameters:
#   ent - Database entity ID.
#
# Glyph 2 Parameters:
#   ent - pw::Entity object.
#
# Glyph 1 Returns:
#   The bounding box encompassing the entity as a list of two 3D vectors.
#
# Glyph 2 Returns:
#   List of two 3D vectors representing the min and max points of the extents.
#
# Example:
#   Code
#     > set extents [gul::DbGetExtents $dbSurf]
#       puts $extents
#
#   Glyph 1 Output
#     > {0.0 0.0 0.0} {1.0 1.0 2.0}
#   Glyph 2 Output
#     > {0.0 0.0 0.0} {1.0 1.0 2.0}
#
###############################################################
proc DbGetExtents {ent} {}

###############################################################
# Proc: DbGetInPlaneAxis
#   Get in plane axis.
#
# Parameters:
#   pt1 - List of three floats.
#   pt2 - List of three floats.
#
# Returns:
#   < "X" | "Y" | "Z" >.
#
# Example:
#   Code
#     > set pt1 "2 3 0"
#       set pt2 "-1 4 0"
#       set planeAxis [gul::DbGetInPlaneAxis $pt1 $pt2]
#       puts $planeAxis
#
#   Glyph 1 Output
#     > Z
#   Glyph 2 Output
#     > Z
#
###############################################################
proc DbGetInPlaneAxis { pt1 pt2 } {}

###############################################################
# Proc: DbGetModelSize
#   Get the current model size.
#
# Parameters:
#
# Returns:
#   Model size as a float.
#
# Example:
#   Code
#     > set ms [gul::DbGetModelSize]
#       puts $ms
#
#   Glyph 1 Output
#     > 1000.0
#
#   Glyph 2 Output
#     > 1000
#
###############################################################
proc DbGetModelSize {} {}

##############################################################
# Proc: DbGetNodeTolerance
#   Return the current node tolerance.
#
# Parameters:
#
# Returns:
#   The current node tolerance as a float.
#
# Example:
#   Code
#     > set nt [gul::DbGetNodeTolerance]
#       puts $nt
#
#   Glyph 1 Output
#     > 0.0001
#
#   Glyph 2 Output
#     > 0.0001
#
###############################################################
proc DbGetNodeTolerance {} {}

#############################################################
# Proc: DbGetTangentCylindricalPoint
#   Find a tangency point of two DB curve ends in the Cylindrical theta=0 plane.
#
# Glyph 1 Parameters:
#   crv1       - Database ID of first curve.
#   s_end1     - U coordinate of first curve.
#                Must be a float with range [0.0, 1.0].
#   crv2       - DatabaseID of second curve.
#   s_end2     - U coordinate of second curve.
#                Must be a float with range [0.0, 1.0].
#   axis       - Direction of z for cylindrical coordinate system.
#                Must be < "X" | "Y" | "Z" >.
#   theta      - Theta value in degrees.
#                Must be a float with range [0.0, 360.0].
#   multiplier - Multiplier value.
#                Must be a float.
#
# Glyph 2 Parameters:
#   crv1       - pw::Database object for first curve.
#   s_end1     - U coordinate of first curve.
#                Must be a float with range [0.0, 1.0].
#   crv2       - pw::Database object for second curve.
#   s_end2     - U coordinate of second curve.
#                Must be a float with range [0.0, 1.0].
#   axis       - Direction of z for cylindrical coordinate system.
#                Must be < "X" | "Y" | "Z" >.
#   theta      - Theta value in degrees.
#                Must be a float with range [0.0, 360.0].
#   multiplier - Multiplier value.
#                Must be a float.
#
# Returns:
#   A 2 element list:
#    - {status {tangency point in RTA}}
#    - status = 1 if tangency point found, otherwise 0.
#
# Example:
#   Code
#     > set tan [gul::DbGetTangentCylindricalPoint $line1 0.7 $line2 0.7 "Z" 20]
#       puts $tan
#
#   Glyph 1 Output
#     > 1 {1.24824125399 20 0.0}
#
#   Glyph 2 Output
#     > 1 {1.2482412539044943 20 0.0}
#
#############################################################
proc DbGetTangentCylindricalPoint {crv1 s_end1 crv2 s_end2 axis theta {multiplier 1}} {}

#############################################################
# Proc: DbGetUatTargetAxial
#   Find the U position (model space parameter) of a point on a db curve with
#   the target axial value.  Begins by marching in the direction of increasing
#   U from the given starting U location.  Returns the first point satisfying
#   the target axial value.
#    - Note: because of the nature of the marching algorithm, certain input
#      can cause the routine to miss finding a valid point.  For example,
#      trying to find a point at or near the inflection point of an arc.
#      In this case, the algorithm will not recognize that it has passed
#      the target point location during the marching step.  Locating an
#      inflection point would be more robust using point projection.
#
# Glyph 1 Parameters:
#   db          - Database curve ID.
#   targetAxial - Target value.
#                 Must be a float with range (0.0, infinity).
#   axis        - Direction of z in cylindrical coordinate system.
#                 Must be < "X" | "Y" | "Z" >.
#   u_start     - Initial position on curve.
#                 Must be a float with range [0.0, 1.0].
#   tol         - Precision. Must be a float with range (0.0, infinity).
#
# Glyph 2 Parameters:
#   db          - pw::Database object.
#   targetAxial - Target value. Must be a float.
#   axis        - Direction of z in cylindrical coordinate system.
#                 Must be < "X" | "Y" | "Z" >.
#   u_start     - Initial position on curve.
#                 Must be a float with range [0.0, 1.0].
#   tol         - Precision. Must be a float with range [0.0, infinity).
#
# Returns:
#   A two element list:
#     - {status U}
#     - status = 1 if target point found, otherwise 0.
#
# Example:
#   Code
#     > set u [gul::DbGetUatTargetAxial $line4 0.25 "Z" 0 0.01]
#       puts $u
#
#   Glyph 1 Output
#     > 1 0.875
#
#   Glyph 2 Output
#     > 1 0.874999999999
#
#############################################################
proc DbGetUatTargetAxial {db targetAxial axis u_start tol} {}

#############################################################
# Proc: DbGetUatTargetRadius
#   Find the U position (model space parameter) of a point on a db curve with
#   the target radial value.  Begins by marching in the direction of increasing
#   U from the given starting U location.  Returns the first point satisfying
#   the target radial value.
#    - Note: because of the nature of the marching algorithm, certain input
#      can cause the routine to miss finding a valid point.  For example,
#      trying to find a point at or near the inflection point of an arc.
#      In this case, the algorithm will not recognize that it has passed
#      the target point location during the marching step.  Locating an
#      inflection point would be more robust using point projection.
#
# Glyph 1 Parameters:
#   db           - Database curve ID.
#   targetRadius - Target value.
#                  Must be a float with range (0.0, infinity).
#   axis         - Direction of z for cylindrical coordinate system.
#                  Must be < "X" | "Y" | "Z" >.
#   u_start      - Initial position on curve.
#                  Must be a float with range [0.0, 1.0].
#   tol          - Precision. Must be a float with range (0.0, infinity).
#
# Glyph 2 Parameters:
#   db           - pw::Database object.
#   targetRadius - Target value.
#                  Must be a float with range [0.0, infinity).
#   axis         - Direction of z for cylindrical coordinate system.
#                  Must be < "X" | "Y" | "Z" >.
#   u_start      - Initial position on curve.
#                  Must be a float with range [0.0, 1.0].
#   tol          - Precision. Must be a float with range [0.0, infinity).
#
# Returns:
#   A 2 element list:
#     - {status U}
#     - status = 1 if target point found, otherwise 0.
#
# Example:
#   Code
#     > set u [gul::DbGetUatTargetRadius $line3 1 "Z" 0 0.01]
#       puts $u
#
#   Glyph 1 Output
#     > 1 0
#
#   Glyph 2 Output
#     > 1 0
#
#############################################################
proc DbGetUatTargetRadius {db targetRadius axis u_start tol} {}

###############################################################
# Proc: DbGetWithRootName
#   Get all database entities with the given root name.
#
# Parameters:
#   root - Root name.
#
# Glyph 1 Returns:
#   List of database entity IDs matching the given root name.
#
# Glyph 2 Returns:
#   List of pw::Database objects matching the given root name.
#
# Example:
#   Code
#     > set matches [gul::DbGetWithRootName "surface"]
#       puts $matches
#
#   Glyph 1 Output
#     > [DB2 DB4 DB5 DB9]
#
#   Glyph 2 Output
#     > ::pw::Surface_9 ::pw::SurfaceTrim_5 ::pw::Quilt_5 ::pw::Model_5 ::pw::Surface_10
#
###############################################################
proc DbGetWithRootName {root} {}

###############################################################
# Proc: DbGetXYZatU
#   Determines the xyz coordinates on a DB curve at specified U coordinate.
#
# Glyph 1 Parameters:
#   db_id      - Database entity ID.
#   arc_length - Specified U coordinate.
#                Must be a float with range [0.0, 1.0].
#
# Glyph 2 Parameters:
#   db_id      - pw::Database object.
#   arc_length - Specified U coordinate.
#                Must be a float with range [0.0, 1.0].
#
# Returns:
#   Point in xyz coordinates as a list of three floats.
#
# Example:
#   Code
#     > set xyz [gul::DbGetXYZatU $line2 0.1]
#       puts $xyz
#
#   Glyph 1 Output
#     > 0.9 1.0 0.2
#
#   Glyph 2 Output
#     > 0.9 1.0 0.2
#
###############################################################
proc DbGetXYZatU {db_id arc_length} {}

###############################################################
# Proc: DbImport
#   Import database.
#
# Parameters:
#   fname - Name of file to import from.
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > gul::DbImport "yourDatabase.iges"
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc DbImport {fname} {}

###############################################################
# Proc: DbIntersect
#   Intersect two groups of database entities.
#
# Glyph 1 Parameters:
#   group1 - First group of db entities.
#            Must be a list of database IDs.
#   group2 - Second group of db entities.
#            Must be a list of database IDs.
#
# Glyph 2 Parameters:
#   group1 - First group of db entities.
#            Must be a list of pw::DatabaseEntity objects.
#   group2 - Second group of db entities.
#            Must be a list of pw::DatabaseEntity objects.
#
# Glyph 1 Returns:
#   List of database entity IDs created from the intersection.
#
# Glyph 2 Returns:
#   List of pw::DatabaseEntity objects created from the intersection.
#
# Example:
#   Code
#     > set intersection [gul::DbIntersect $dbSurf $dbRevSurf]
#       puts $intersection
#
#   Glyph 1 Output
#     > DB10
#
#   Glyph 2 Output
#     > ::pw::Curve_23
#
###############################################################
proc DbIntersect {group1 group2} {}

###############################################################
# Proc: DbIsolateLayer
#   Isolate a database layer.
#
# Glyph 1 Parameters:
#   layer - Layer ID to be isolated.
#           Must be an integer with range [0, infinity).
#
# Glyph 2 Parameters:
#   layer - Layer ID to be isolated.
#           Must be an integer with range [0, 1023].
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > gul::DbIsolateLayer 10
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc DbIsolateLayer {layer} {}

###############################################################
# Proc: DbJoin2
#   Join two database surfaces.
#
# Glyph 1 Parameters:
#   dbEnts - List of two database entity IDs to be joined.
#
# Glyph 2 Parameters:
#   dbEnts - List of pw::Surface objects to be split.
#
# Glyph 1 Returns:
#   The new database ID.
#
# Glyph 2 Returns:
#   The new pw::Surface object.
#
# Example:
#   Code
#     > set union [gul::DbJoin2 [list $dbSurf $dbRevSurf]]
#       puts $union
#
#   Glyph 1 Output
#     > DB13
#
#   Glyph 2 Output
#     > ::pw::Surface_16
#
###############################################################
proc DbJoin2 {dbEnts} {}

###############################################################
# Proc: DbNormalizeVector
#   Normalize a vector.
#
# Parameters:
#   vec - Vector to be normalized.
#         Must be a list of three floats.
#
# Returns:
#   Resulting unit vector as a list of three floats.
#
# Example:
#   Code
#     > set v1 "1 2 3"
#       set v2 "31 4"
#       puts [gul::DbNormalizeVector $v1]
#       puts [gul::DbNormalizeVector $v2]
#
#   Glyph 1 Output
#     > 0.267261241912 0.534522483825 0.801783725737
#       0.991777866634 0.12797133763
#
#   Glyph 2 Output
#     > 0.2672612419124244 0.5345224838248488 0.8017837257372732
#       0.991777866634025 0.12797133763019677
#
###############################################################
proc DbNormalizeVector {vec} {}

###############################################################
# Proc: DbSetLayer
#   Set database entity's layer.
#
# Glyph 1 Parameters:
#   dblist - List of database entity IDs.
#   layer  - Layer ID.
#            Must be an integer with range [0, infinity).
#
# Glyph 2 Parameters:
#   dblist - List of pw::DatabaseEntity objects.
#   layer  - pw::Layer object.
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > gul::DbSetLayer [list $dbSurf $dbRevSurf] 0
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc DbSetLayer {dblist layer} {}

###############################################################
# Proc: DbSetModelSize
#   Set current model size.
#
# Parameters:
#   size - Wanted model size.
#          Must be a float with range (0.0, infinity).
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > gul::DbSetModelSize 100
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc DbSetModelSize {size} {}

###############################################################
# Proc: DbSetNodeTolerance
#   Set current node tolerance.
#
# Parameters:
#   tol - New node tolerance value.
#         Must be a float with range (0.0, infinity).
#
# Returns:
#   Nothing.
#
# Example:
#   Code
#     > gul::DbSetNodeTolerance 0.0001
#
#   Glyph 1 Output
#     >
#   Glyph 2 Output
#     >
#
###############################################################
proc DbSetNodeTolerance {tol} {}

###############################################################
# Proc: DbSplit
#   Split database at coordinate.
#
# Glyph 1 Parameters:
#   db    - Database entity ID to be split.
#   param - U coordinate to split at.
#           Must be a float with range [0.0, 1.0].
#
# Glyph 2 Parameters:
#   db    - pw::Curve object to be split.
#   param - List of U coordinates to split at.
#           Must be a list of float(s) with range [0.0, 1.0].
#
# Glyph 1 Returns:
#   The database ID of the portion greater than the split value.
#   - The portion less than the split value retains the original db ID
#
# Glyph 2 Returns:
#   The pw::Curve object of the portion greater than the split value
#   - The portion less than the split value retains the original db object
#
# Example:
#   Code
#     > set fragments [gul::DbSplit $line1 0.5]
#       puts $fragments
#
#   Glyph 1 Output
#     > DB14
#
#   Glyph 2 Output
#     > ::pw::Curve_24
#
###############################################################
proc DbSplit {db param} {}

###############################################################
# Proc: DbSubtract2Vectors
#   Subtract two vectors.
#
# Parameters:
#   vecA - Vector to be subtracted from.
#          Must be a list of three floats.
#   vecB - Vector to be subtracted.
#          Must be a list of three floats.
#
# Returns:
#   Vector resulting from subtracting vecB from vecA
#   as a list of three floats.
#
# Example:
#   Code
#     > set v1 "1 2 3"
#       set v2 "-3 -2 -1"
#       set v [gul::DbSubtract2Vectors $v1 $v2]
#       puts $v
#
#   Glyph 1 Output
#     > 4 4 4
#
#   Glyph 2 Output
#     > 4.0 4.0 4.0
#
###############################################################
proc DbSubtract2Vectors {vecA vecB} {}

