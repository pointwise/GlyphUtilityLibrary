#############################################################################
#
# (C) 2021 Cadence Design Systems, Inc. All rights reserved worldwide.
#
# This sample script is not supported by Cadence Design Systems, Inc.
# It is provided freely for demonstration purposes only.
# SEE THE WARRANTY DISCLAIMER AT THE BOTTOM OF THIS FILE.
#
#############################################################################

#############################################################
## GetMesherName
## Determines which Glyph language is supported by the
## parser.  Result used to return the mesher's name.
## Returns empty string on failure.
##

# List of the root names for each GUL file
set utilFiles [list cartcyl caeutil conutil dbutil domutil blkutil guiutil]

# relative directory path for this script
set guldir [file nativename [file dirname [info script]]]

###############################################################
#-- PROC: getVersion
#--
#-- Determine current glyph version and returns a list
#--
###############################################################
proc getVersion { } {
  return [split [package require PWI_Glyph] .]
}

###############################################################
#-- PROC: sourceMostRecentVersion
#--
#-- Finds most recent version of file and sources it
#--
###############################################################
proc sourceMostRecentVersion { file } {
  set glyphVersion [getVersion]
  if {[lindex $glyphVersion 2] == ""} {
    lappend glyphVersion 0
  }
  set copy $file
  append copy "_" [lindex $glyphVersion 0]
  set allVersions [glob -directory $::guldir $copy.*.*.glf]
  set correctVersion [list [lindex $glyphVersion 0] 0 0]
  foreach version $allVersions {
    set temp [split $version .]
    # proceed from the end - might have '.' in directory path
    set tokenLength [llength $temp]
    set minorRev [expr $tokenLength - 3]
    set temp [list [lindex $glyphVersion 0] [lindex $temp $minorRev] [lindex $temp \
      [expr $minorRev + 1]]]
    if {[lindex $temp 1] == [lindex $glyphVersion 1] && [lindex $temp 2] == \
	[lindex $glyphVersion 2]} {
      set correctVersion $temp
      break
    } elseif {[lindex $temp 1] <= [lindex $glyphVersion 1]} {
      if {[lindex $temp 1] > [lindex $correctVersion 1]} {
        set correctVersion $temp
      } elseif {[lindex $temp 1] == [lindex $correctVersion 1] && \
		[lindex $temp 2] > [lindex $correctVersion 2]} {
        set correctVersion $temp
      }
    }
  }
  append file "_" [lindex $glyphVersion 0] "." [lindex $correctVersion 1] "." \
    [lindex $correctVersion 2] ".glf"
  source [file join $::guldir $file]
}

###############################################################
#-- PROC: getErrorMsg
#--
#-- Basic error message informing the user of which proc is raising an error
#--
###############################################################
proc getErrorMsg { procName } {
  return "$procName - Incorrect Argument Type(s)"
}

###############################################################
#-- PROC: printDetails
#--
#-- Informs user of which argument is invalid and what type was expected
#--
###############################################################
proc printDetails { type expected } {
  puts "Invalid Argument: $type -- Expected: $expected"
}

###############################################################
#-- PROC: binarySearch
#--
#-- Binary search on list of strings sorted in increasing order
#-- Returns index on success and -1 on failure
#--
###############################################################
proc binarySearch { theList target low high } {
  if {$high < $low} {
    return -1
  }
  set mid [expr [expr $low + $high]/2]
  set midVal [lindex $theList $mid]
  if  {[string compare $midVal $target] == 1} {
    return [binarySearch $theList $target $low [expr $mid - 1]]
  } elseif {[string compare $midVal $target] == -1} {
    return [binarySearch $theList $target [expr $mid + 1] $high]
  } else {
    return $mid
  }
}

if {[lindex [getVersion] 0] == 1} { #--Gridgen
  namespace eval gul {
    proc ApplicationReset { } {
      gg::memClear
      gg::aswDeleteBC -glob "*"
      gg::aswDeleteVC -glob "*"
      gg::oversetSet "NONE"
      gg::oversetAtt DONOR_QUALITY "1.000000"
      gg::oversetAtt THIN_CUT "OFF"
      gg::oversetAtt CELL_CENTERED "FALSE"
      gg::oversetAtt GRID_STYLE "PLOT3D"
      gg::oversetAtt GRID_FORMAT "UNFORMATTED"
      gg::oversetAtt GRID_PRECISION "DOUBLE"
      gg::oversetAtt GRID_ENDIAN "NATIVE"
      gg::oversetAtt COMMAND_LINE { }
      gg::oversetAtt USER_GLOBAL { }
      gg::oversetAtt CASE_NAME "case"
      gg::oversetAtt QUALITY_CUTOFF "0.100000"
      gg::oversetAtt FRINGE "DOUBLE"
      gg::oversetAtt DATA_IN_CORE "FALSE"
      gg::oversetAtt AUTO_HOLE_CUT "TRUE"
      gg::oversetAtt LEVEL2_INTERP "TRUE"
      gg::oversetAtt PROJECT_WALLS "TRUE"
      gg::oversetAtt FIX_ORPHANS "FALSE"
      gg::oversetAtt HOLE_OFFSET "0"
      gg::aswSet GENERIC -dim 3
      gg::defReset
      gg::tolReset
    }
    # Glyph 1 version of $object isOfType type from Glyph 2
    proc sameType {object type} {
      set ret 0
      switch -- $type {
        gg::Block {
          set blkList [gg::blkGetAll]
          set blkList [lsort $blkList]
          set index [binarySearch $blkList $object 0 [expr [llength $blkList] - 1]]
          if {$index != -1} {
            set ret 1
          }
        }
        gg::BlockStructured {
          set blkList [gg::blkGetAll]
          set index [lsearch -exact $blkList $object]
          if {$index != -1} {
            gg::blkReport ALL diagnosticsArray STRUCTURE
            set blkType [lindex $diagnosticsArray(type) $index]
            if {[string equal $blkType "STRUCTURED"]} {
              set ret 1
            }
          }
        }
        gg::Connector {
          set conList [gg::conGetAll]
          set conList [lsort $conList]
          set index [binarySearch $conList $object 0 [expr [llength $conList] - 1]]
          if {$index != -1} {
            set ret 1
          }
        }
        gg::DatabaseEntity {
          set dbList [gg::dbGetAll]
          set dbList [lsort $dbList]
          set index [binarySearch $dbList $object 0 [expr [llength $dbList] - 1]]
          if {$index != -1} {
            set ret 1
          }
        }
        gg::Domain {
          set domList [gg::domGetAll]
          set domList [lsort $domList]
          set index [binarySearch $domList $object 0 [expr [llength $domList] - 1]]
          if {$index != -1} {
            set ret 1
          }
        }
        gg::DomainStructured {
          set domList [gg::domGetAll]
          set index [lsearch -exact $domList $object]
          if {$index != -1} {
            gg::domReport ALL diagnosticsArray STRUCTURE
            set domainType [lindex $diagnosticsArray(type) $index]
            if {[string equal $domainType "STRUCTURED"]} {
              set ret 1
            }
          }
        }
        gg::Edge { # List of connector IDs
          set ret 1
          if {[llength $object] == 0} {
            set ret 0
          } else {
            foreach con $object {
              if {![sameType $con "gg::Connector"]} {
                set ret 0
                break
              }
            }
          }
          return $ret
        }
        gg::Face { # List of domain IDs
          set ret 1
          if {[llength $object] == 0} {
            set ret 0
          } else {
            foreach dom $object {
              if {![sameType $dom "gg::Domain"]} {
                set ret 0
                break
              }
            }
          }
        }
        gg::FaceStructured { # List of structured domain IDs
          set ret 1
          if {[llength $object] == 0} {
            set ret 0
          } else {
            foreach dom $object {
              if {![sameType $dom "gg::DomainStructured"]} {
                set ret 0
                break
              }
            }
          }
        }
        default {
          puts "$type not supported"
        }
      }
      return $ret
    }

    # actual - passed in argument to be checked
    # expected - expected type of actual
    # min - minimum allowed value for actual (ignore if no minimum value)
    # includeMin - 0 if min is NOT included or 1 if min is included in range
    # max - maximum allowed value for actual (ignore if no maximum value)
    # includeMax - 0 if max is NOT included or 1 if max is included in range
    proc argCheck {actual expected {min ""} {includeMin 1} {max ""} {includeMax 1}} {
      set ret 1
      switch -- $expected {
        axis {
          if {![string equal $min "0"] && \
              ![string equal $actual "X"] && ![string equal $actual "-X"] && \
              ![string equal $actual "Y"] && ![string equal $actual "-Y"] && \
              ![string equal $actual "Z"] && ![string equal $actual "-Z"]} {
            printDetails $actual "< X | Y | Z | -X | -Y | -Z >"
            set ret 0
          } elseif {[string equal $min "0"] && \
                   ![string equal $actual "X"] && \
                   ![string equal $actual "Y"] && \
                   ![string equal $actual "Z"]} {
            printDetails $actual "< X | Y | Z >"
            set ret 0
          }
        }
        boolean {
          set ret 0
          if {[string is integer -strict $actual]} {
            set ret 1
          } elseif {[string equal -nocase $actual "true"] || \
		    [string equal -nocase $actual "false"]} {
            set ret 1
          } elseif {[string equal -nocase $actual "yes"] || \
		    [string equal -nocase $actual "no"]} {
            set ret 1
          } else {
            printDetails $actual "< integer | true | false | yes | no >"
          }
        }
        float {
          if {![string is double -strict $actual]} {
            printDetails $actual "float"
            set ret 0
          } elseif {![string equal $max ""] && [expr $actual > $max]} {
            printDetails $actual "value <= $max"
            set ret 0
          } elseif {![string equal $min ""] && [expr $actual < $min]} {
            printDetails $actual "value >= $min"
            set ret 0
          } elseif {![string equal $max ""] && [expr $includeMax == 0] && \
		    [expr $actual == $max]} {
            printDetails $actual "value < $max"
            set ret 0
          } elseif {![string equal $min ""] && [expr $includeMin == 0] && \
		    [expr $actual == $min]} {
            printDetails $actual "value > $min"
            set ret 0
          }
        }
        integer {
          if {![string is integer -strict $actual]} {
            printDetails $actual "integer"
            set ret 0
          } elseif {![string equal $max ""] && [expr $actual > $max]} {
            printDetails $actual "value <= $max"
            set ret 0
          } elseif {![string equal $min ""] && [expr $actual < $min]} {
            printDetails $actual "value >= $min"
            set ret 0
          } elseif {![string equal $max ""] && [expr $includeMax == 0] && \
		    [expr $actual == $max]} {
            printDetails $actual "value < $max"
            set ret 0
          } elseif {![string equal $min ""] && [expr $includeMin == 0] && \
		    [expr $actual == $min]} {
            printDetails $actual "value > $min"
            set ret 0
          }
        }
        vector2 { # List of two floats
          if {[expr [llength $actual] != 2]} {
            printDetails "\[$actual\]" "list of length 2"
            set ret 0
          } else {
            foreach coord $actual {
              if {![string is double -strict $coord]} {
                printDetails "$coord in \[$actual\]" "double"
                set ret 0
                break
              } elseif {![string equal $max ""] && [expr $coord > $max]} {
                printDetails "$coord in \[$actual\]" "value <= $max"
                set ret 0
                break
              } elseif {![string equal $min ""] && [expr $coord < $min]} {
                printDetails "$coord in \[$actual\]" "value >= $min"
                set ret 0
                break
              } elseif {![string equal $max ""] && [expr $includeMax == 0] && \
			  [expr $coord == $max]} {
                printDetails "$coord in \[$actual\]" "value < $max"
                set ret 0
                break
              } elseif {![string equal $min ""] && [expr $includeMin == 0] && \
			  [expr $coord == $min]} {
                printDetails "$coord in \[$actual\]" "value > $min"
                set ret 0
                break
              }
            }
          }
        }
        vector3 { # List of three floats
          if {[expr [llength $actual] != 3]} {
            printDetails "\[$actual\]" "list of length 3"
            set ret 0
          } else {
            foreach coord $actual {
              if {![string is double -strict $coord]} {
                printDetails "$coord in \[$actual\]" "double"
                set ret 0
                break
              } elseif {![string equal $max ""] && [expr $coord > $max]} {
                printDetails "$coord in \[$actual\]" "value <= $max"
                set ret 0
                break
              } elseif {![string equal $min ""] && [expr $coord < $min]} {
                printDetails "$coord in \[$actual\]" "value >= $min"
                set ret 0
                break
              } elseif {![string equal $max ""] && [expr $includeMax == 0] && \
			  [expr $coord == $max]} {
                printDetails "$coord in \[$actual\]" "value < $max"
                set ret 0
                break
              } elseif {![string equal $min ""] && [expr $includeMin == 0] && \
			  [expr $coord == $min]} {
                printDetails "$coord in \[$actual\]" "value > $min"
                set ret 0
                break
              }
            }
          }
        }
        default {
          if {![string equal -length 4 $expected "gg::"]} {
            puts "Improper use of gul::argCheck"
            printDetails $expected "< axis | boolean | float | integer | vector2 | vector3 | gg::Type >"
            set ret 0
          } elseif {![sameType $actual $expected]} {
            printDetails $actual "type $expected"
            set ret 0
          }
        }
      }
      return $ret
    }
  }
} elseif {[lindex [getVersion] 0] == 2} { #--Pointwise
  namespace eval gul {
    proc ApplicationReset { } {
      pw::Application reset
    }
    # actual - passed in argument to be checked
    # expected - expected type of actual
    # min - minimum allowed value for actual (ignore if no minimum value)
    # includeMin - 0 if min is NOT included or 1 if min is included in range
    # max - maximum allowed value for actual (ignore if no maximum value)
    # includeMax - 0 if max is NOT included or 1 if max is included in range
    proc argCheck {actual expected {min ""} {includeMin 1} {max ""} {includeMax 1}} {
      set ret 1
      # Valid argument until proven otherwise
      switch -- $expected {
        axis {
          if {![string equal $min "0"] && \
              ![string equal $actual "X"] && ![string equal $actual "-X"] && \
              ![string equal $actual "Y"] && ![string equal $actual "-Y"] && \
              ![string equal $actual "Z"] && ![string equal $actual "-Z"]} {
            printDetails $actual "< X | Y | Z | -X | -Y | -Z >"
            set ret 0
          } elseif {[string equal $min "0"] && \
                   ![string equal $actual "X"] && \
                   ![string equal $actual "Y"] && \
                   ![string equal $actual "Z"]} {
            printDetails $actual "< X | Y | Z >"
            set ret 0
          }
        }
        boolean {
          set ret 0
          if {[string is integer -strict $actual]} {
            set ret 1
          } elseif {[string equal -nocase $actual "true"] || \
		    [string equal -nocase $actual "false"]} {
            set ret 1
          } elseif {[string equal -nocase $actual "yes"] || \
		    [string equal -nocase $actual "no"]} {
            set ret 1
          } else {
            printDetails $actual "< integer | true | false | yes | no >"
          }
        }
        float {
          if {![string is double -strict $actual]} {
            printDetails $actual "float"
            set ret 0
          } elseif {![string equal $max ""] && [expr $actual > $max]} {
            printDetails $actual "value <= $max"
            set ret 0
          } elseif {![string equal $min ""] && [expr $actual < $min]} {
            printDetails $actual "value >= $min"
            set ret 0
          } elseif {![string equal $max ""] && [expr $includeMax == 0] && \
		    [expr $actual == $max]} {
            printDetails $actual "value < $max"
            set ret 0
          } elseif {![string equal $min ""] && [expr $includeMin == 0] && \
		    [expr $actual == $min]} {
            printDetails $actual "value > $min"
            set ret 0
          }
        }
        integer {
          if {![string is integer -strict $actual]} {
            printDetails $actual "integer"
            set ret 0
          } elseif {![string equal $max ""] && [expr $actual > $max]} {
            printDetails $actual "value <= $max"
            set ret 0
          } elseif {![string equal $min ""] && [expr $actual < $min]} {
            printDetails $actual "value >= $min"
            set ret 0
          } elseif {![string equal $max ""] && [expr $includeMax == 0] && \
		    [expr $actual == $max]} {
            printDetails $actual "value < $max"
            set ret 0
          } elseif {![string equal $min ""] && [expr $includeMin == 0] && \
		    [expr $actual == $min]} {
            printDetails $actual "value > $min"
            set ret 0
          }
        }
        solver {
          set validSolvers [pw::Application getCAESolverNames]
          set index [lsearch -exact $validSolvers $actual]
          if {$index == -1} {
            set msg "<"
            foreach solv $validSolvers {
              append msg " $solv |"
            }
            set msg [string trimright $msg "|"]
            append msg ">"
            printDetails $actual $msg
            set ret 0
          }
        }
        vector2 {
          if {[expr [llength $actual] != 2]} {
            printDetails "\[$actual\]" "list of length 2"
            set ret 0
          } else {
            foreach coord $actual {
              if {![string is double -strict $coord]} {
                printDetails "$coord in \[$actual\]" "double"
                set ret 0
                break
              } elseif {![string equal $max ""] && [expr $coord > $max]} {
                printDetails "$coord in \[$actual\]" "value <= $max"
                set ret 0
                break
              } elseif {![string equal $min ""] && [expr $coord < $min]} {
                printDetails "$coord in \[$actual\]" "value >= $min"
                set ret 0
                break
              } elseif {![string equal $max ""] && [expr $includeMax == 0] && \
			    [expr $coord == $max]} {
                printDetails "$coord in \[$actual\]" "value < $max"
                set ret 0
                break
              } elseif {![string equal $min ""] && [expr $includeMin == 0] && \
			    [expr $coord == $min]} {
                printDetails "$coord in \[$actual\]" "value > $min"
                set ret 0
                break
              }
            }
          }
        }
        vector3 {
          if {[expr [llength $actual] != 3]} {
            printDetails "\[$actual\]" "list of length 3"
            set ret 0
          } else {
            foreach coord $actual {
              if {![string is double -strict $coord]} {
                printDetails "$coord in \[$actual\]" "double"
                set ret 0
                break
              } elseif {![string equal $max ""] && [expr $coord > $max]} {
                printDetails "$coord in \[$actual\]" "value <= $max"
                set ret 0
                break
              } elseif {![string equal $min ""] && [expr $coord < $min]} {
                printDetails "$coord in \[$actual\]" "value >= $min"
                set ret 0
                break
              } elseif {![string equal $max ""] && [expr $includeMax == 0] && \
			    [expr $coord == $max]} {
                printDetails "$coord in \[$actual\]" "value < $max"
                set ret 0
                break
              } elseif {![string equal $min ""] && [expr $includeMin == 0] && \
			    [expr $coord == $min]} {
                printDetails "$coord in \[$actual\]" "value > $min"
                set ret 0
                break
              }
            }
          }
        }
        default {
          if {![string equal -length 4 $expected "pw::"]} {
            puts "Improper use of gul::argCheck"
            printDetails $expected "< axis | boolean | float | integer | solver | vector2 | vector3 | pw::Type >"
            set ret 0
          } elseif {![$actual isOfType $expected]} {
            printDetails $actual "type $expected"
            set ret 0
          }
        }
      }
      return $ret
    }
  }
} else {
  error "Unknown meshing application"
}

foreach file $::utilFiles {
  sourceMostRecentVersion $file
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
