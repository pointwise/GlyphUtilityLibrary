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
#--  Define some useful GUI commands
#--
##########################################################################


##########################################################################
#--
#-- GRIDGEN ASW COMMANDS
#--
##########################################################################

namespace eval gul {

###############################################################
#-- PROC: GUIbusy
#--
#-- Renders the GUI unresponsive during a block of commands.
#--
###############################################################
proc GUIbusy { cmds } {
    global errorInfo

    set busy {.app .root}
    set list [winfo children .]
    while {[llength $list]} {
	set next { }
	foreach w $list {
	    set class [winfo class $w]
	    set cursor [lindex [$w configure -cursor] 4]
	    if {![string compare $w [winfo toplevel $w]] || \
		    [string compare { } $cursor]} {
		lappend busy [list $w $cursor]
	    }
	    set next [concat $next [winfo children $w]]
	}
	set list $next
    }

    set nrml_cursor [lindex [. configure -cursor] 4]
    catch {. configure -cursor watch}
    foreach w $busy {
	catch {[lindex $w 0] configure -cursor watch}
    }

    update idletasks
    update

    set error [catch {uplevel eval [list $cmds]} result]
    set ei $errorInfo


    catch {. configure -cursor $nrml_cursor}

    foreach w $busy {
	catch {[lindex $w 0] configure -cursor [lindex $w 1]}
    }

    update idletasks
    update

    if {$error} {
	error $result $ei
    } else {
	return -code $error $result
    }
}

###############################################################
#-- PROC: GUIplaceWindow
#--
#-- Places an existing window in a specified location on the screen.
#--
###############################################################
proc GUIplaceWindow { w {region "left"} {parent ""} {xoff "0"} {yoff "0"} } {
    global tcl_platform

  if [winfo exists $parent] {
    set rootx [winfo rootx $parent]
    set rooty [winfo rooty $parent]
    set pwidth [winfo width $parent]
    set pheight [winfo height $parent]
  } else {
    set parent "."
    set rootx 0
    set rooty 0
    set pwidth [winfo screenwidth $parent]
    set pheight [winfo screenheight $parent]

    if [catch {gg::winInfo} winInfo] {
      set winInfo [list $pwidth $pheight 0 0 0]
    }
    set pwidth [lindex $winInfo 0]
    set pheight [lindex $winInfo 1]
  }

  set screenwidth [winfo screenwidth .]
  set screenheight [winfo screenheight .]

  if [catch {gg::winInfo} winInfo] {
    set winInfo [list $screenwidth $screenheight 0 0 0]
  }
  set screenwidth [lindex $winInfo 0]
  set screenheight [lindex $winInfo 1]
  set l_off [lindex $winInfo 2]
  set t_off [lindex $winInfo 3]

  update idletasks
  set wwidth [winfo reqwidth $w]
  set wheight [winfo reqheight $w]


  # Center the window along the left, right, top, or bottom edges of
  # the screen, or place it directly in the screen center.
  # If the region contains none of these, then the window is placed in
  # the screen center.
  set border 4
  if {-1 != [string first "left" $region]} {
    set x0 0
  } elseif {-1 != [string first "right" $region]} {
    set x0 [expr $screenwidth - $wwidth - 2*$border]
  } else {
    set x0 [expr $rootx+($pwidth-$wwidth)/2]
  }

  if {-1 != [string first "top" $region]} {
    set y0 0
  } elseif {-1 != [string first "bottom" $region]} {
    set y0 [expr $screenheight - $wheight - 2*$border]
  } else {
    set y0 [expr $rooty+($pheight-$wheight)/2]
  }

  set x0 [expr $x0 + $xoff]
  set y0 [expr $y0 + $yoff]

  # Check if the window is entirely visible and move it if needed.
  set maxW [expr $x0 + $wwidth + 2*$border]
  if { $maxW > $screenwidth} {
    set x0 [expr $screenwidth-$wwidth - 2*$border]
  } elseif { $x0 < 0 } {
    set x0 0
  }

  set maxH [expr $y0 + $wheight + 2*$border]
  if { $maxH > $screenheight} {
    set y0 [expr $screenheight-$wheight - 2*$border]
  } elseif { $y0 < 0 } {
    set y0 0
  }

  #-- allow for windows taskbar
  if { $tcl_platform(platform) == "windows" } {
    set x0 [expr $x0+$l_off]
    set y0 [expr $y0+$t_off]
  }

  wm geometry $w "+$x0+$y0"
}

######################################################################
#-- PROC: GUIcreateLabelFrame
#--   Creates a fancy label frame widget
#--   Returns the new frame
#--
######################################################################
proc GUIcreateLabelFrame { w args } {
  #-- strip extraneous '.'s in window name
  set w [string trim $w "."]
  set w ".$w"
  frame $w -bd 0
  label $w.l
  frame $w.f -bd 2 -relief groove
  frame $w.f.spc -height 5
  pack $w.f.spc
  frame $w.f.f
  pack $w.f.f
  set text { }
  set font { }
  set padx 3
  set padx 1
  set pady 7
  set pady 5
  set ipadx 2
  set ipadx 0
  set ipady 9
  set ipady 5
  set ipady 0
  foreach {tag value} $args {
    switch -- $tag {
      -font  {set font $value}
      -text  {set text $value}
      -padx  {set padx $value}
      -pady  {set pady $value}
      -ipadx {set ipadx $value}
      -ipady {set ipady $value}
      -bd     {$w.f config -bd $value}
      -relief {$w.f config -relief $value}
    }
  }
  if {"$font" != "" && "$font" != " "} {
    $w.l config -font $font
  }
  $w.l config -text $text
  pack $w.f -padx $padx -pady $pady -fill both -expand 1
  place $w.l -x [expr $padx+10] -y $pady -anchor w
  pack $w.f.f -padx $ipadx -pady $ipady -fill both -expand 1
  raise $w.l
  return $w.f.f
}

###############################################################
#-- PROC: GUIenable
#--
#-- Enable tk GUI
#--
###############################################################
proc GUIenable { } {
 namespace eval :: {
   gg::tkLoad
 }
}

###############################################################
#-- PROC: GUIgeomFileBrowse
#--   Use browser to select a CAD geometry file and open it.
#--
#--
###############################################################
proc GUIgeomFileBrowse { } {
   set types {
     {{IGES Files}  {.igs}   }
     {{IGES Files}  {.iges}  }
     {{DBA Files}   {.dba}   }
     {{All Files}    *       }
   }
   return [tk_getOpenFile -title "Select CAD geometry file" -filetypes $types]
}

###############################################################
#-- PROC: GUIhasInteractMode
#--
#-- Whether display interaction is mode based
#--
###############################################################
proc GUIhasInteractMode { } {
  return 1
}

###############################################################
#-- PROC: GUIinteractionMode
#--
#-- Enter display interaction mode
#--
###############################################################
proc GUIinteractionMode { } {
   gg::dispInteract
}

###############################################################
#-- PROC: GUItextInsert
#--
#-- Inserts a line of text into a specified text field if
#-- possible and to the message window otherwise.
#--
###############################################################
proc GUItextInsert { line msgBox } {
  if { [catch {
      $msgBox configure -state normal
      $msgBox insert end "$line\n"
      $msgBox see end
      $msgBox configure -state disabled
    } error] } {
    puts "Line could not be displayed in the GUI:"
    puts $line
  }
  update
}

###############################################################
#-- PROC: GUIupdate
#--
#-- Update 3D display
#--
###############################################################
proc GUIupdate { } {
#   pw::Display update
}

# sframe.tcl
# Tk implementation of a scrolled frame
# By Mark Ng 2001
# All rights reserved
# markng@alumni.utexas.net
#

#-------------------------------------------------------------------------
# Internal globals:
#
# config - config(<window path>,<option>) holds the configuration
#          option
#
#-------------------------------------------------------------------------


namespace eval lion::scrollableframe {
  variable version 0.3
  namespace export scrollableframe
}

# lion::scrollableframe::parseoptions --
# This procedure parses the command line options passed to the
# creation proc of a Lionscrollableframe and the configure command.
#
# Arguments:
# w -             The scrollableframe window.
# args -          The command line configuration arguments.

proc lion::scrollableframe::parseoptions { w args } {
  variable config
  set configlist { }
  for {set i 0} {$i < [llength $args]} {incr i} {
    set option [string range [lindex $args $i] 1 end]
    incr i
    set config($w,$option) [lindex $args $i]
    switch -- $option {
      colormap - cursor - highlightbackground - highlightcolor -
      highlightthickness - takefocus - background - height - width -
      borderwidth - relief - visual {
        lappend configlist -$option $config($w,$option)
      }
      xscrollcommand - yscrollcommand - xstep - ystep {
      }
      default {
        unset config($w,$option)
        bgerror "unknown option \"-$option\""
      }
    }
  }
  return $configlist
}

# lion::scrollableframe::configure --
# The procedure is called when the user calls pathName configure.
#
# Arguments:
# w -             The scrollableframe window.
# args -          The command line argument list.

proc lion::scrollableframe::configure { w args } {
  switch -- [llength $args] {
    0 {
      # to be implemented
    }
    1 {
      # to be implemented
    }
    default {
      set configlist [eval parseoptions $w $args]
      if {$configlist != ""} {
        eval $w configure $configlist
      }
      setfillmode $w
    }
  }
}

# lion::scrollableframe::parseswallowoptions --
# This procedure parses the command line options passed to the
# swallow command.
#
# Arguments:
# w -             The scrollableframe window.
# args -          The command line configuration arguments.

proc lion::scrollableframe::parseswallowoptions { w args } {
  variable config
  set configlist { }
  for {set i 0} {$i < [llength $args]} {incr i} {
    set option [string range [lindex $args $i] 1 end]
    incr i
    set config($w,$option) [lindex $args $i]
    switch -- $option {
      widthcommand  - heightcommand {
      }
      default {
        unset config($w,$option)
        bgerror "unknown option \"-$option\""
      }
    }
  }
}

# lion::scrollableframe::swallow --
# Insert a widget into the scrollableframe.
#
# Arguments:
# w -             The scrollableframe window.
# widget -        The widget to swallow, or forget
# args -          The command line argument list.

proc lion::scrollableframe::swallow { w widget args } {
  variable config
  eval parseswallowoptions $w $args
  update idletasks
  if {$widget == "forget"} {
    if {$config($w,curwidget) != ""} {
      place forget $config($w,curwidget)
      set config($w,curwidget) ""
      set config($w,widthcommand) ""
      set config($w,heightcommand) ""
      foreach orient {x y} {
        if {$config($w,${orient}scrollcommand) != ""} {
          set config($w,${orient}offset) 0
          eval $config($w,${orient}scrollcommand) 0.0 1.0
        }
      }
    }
  } else {
    set config($w,curwidget) $widget
    place $config($w,curwidget) -in $w -x 0 -y 0 -anchor nw -bordermode inside
    foreach orient {x y} {
      if {$config($w,${orient}scrollcommand) != ""} {
        set config($w,${orient}offset) 0
        eval $config($w,${orient}scrollcommand) [ratios $w $orient]
      }
    }
    setfillmode $w
  }
}

# lion::scrollableframe::setfillmode --
# If no scrollcommand is given, set the widget to fill the frame size.
#
# Arguments:
# w -             The scrollableframe window.

proc lion::scrollableframe::setfillmode { w } {
  variable config
  update idletasks
  if {$config($w,curwidget) != ""} {
    foreach orient {x y} dim {width height} {
      if {$config($w,${orient}scrollcommand) == ""} {
        place configure $config($w,curwidget) -in $w -rel${dim} 1.0
      } else {
        place configure $config($w,curwidget) -in $w \
              -$dim [widgetsize $w $dim]
      }
    }
  }
}

# lion::scrollableframe::dimension --
# Maps x to width and y to height.
#
# Arguments:
# orient -        Either x or y.

proc lion::scrollableframe::dimension { orient } {
  if {$orient == "x"} {
    return width
  } else {
    return height
  }
}

# lion::scrollableframe::widgetsize --
# Gets dimension of the swallowed widget.
#
# Arguments:
# w -             The scrollableframe window.
# dim -           Either width or height.

proc lion::scrollableframe::widgetsize { w dim } {
  variable config
  if {$config($w,curwidget) != ""} {
    if {$config($w,${dim}command) != ""} {
      return [eval $config($w,${dim}command) $config($w,curwidget)]
    } else {
      return [winfo req${dim} $config($w,curwidget)]
    }
  } else {
    return 0
  }
}

# lion::scrollableframe::scrollto --
# Scrolls to the specified offset.
#
# Arguments:
# w -             The scrollableframe window.
# orient -        Either x or y.
# offset -        Offset of the widget from the scrolling begin.

proc lion::scrollableframe::scrollto { w orient offset } {
  variable config
  if {$config($w,curwidget) != ""} {
    set config($w,${orient}offset) $offset
    place $config($w,curwidget) -in $w -${orient} $offset
    if {$config($w,${orient}scrollcommand) != ""} {
      eval $config($w,${orient}scrollcommand) [ratios $w $orient]
    }
    raise $config($w,curwidget)
  }
}

# lion::scrollableframe::ratios --
# Returns the portion of the swallowed widget that is visible.
#
# Arguments:
# w -             The scrollableframe window.
# orient -        Either x or y.

proc lion::scrollableframe::ratios { w orient } {
  variable config
  if {$config($w,curwidget) == "" ||
      ![winfo exists $config($w,curwidget)]} {
    return [list 0.0 1.0]
  }
  set dim [dimension $orient]
  set wsize [widgetsize $w $dim]
  set fsize [winfo $dim $w]
  return [list [expr abs($config($w,${orient}offset)) / double($wsize)] \
               [expr (abs($config($w,${orient}offset)) + $fsize) / double($wsize)]]
}

# lion::scrollableframe::view --
# Called when user calls pathname xview or pathname yview, used to query and
# change position of the swallowed widget.
#
# Arguments:
# w -             The scrollableframe window.
# orient -        Either x or y.
# args -          The command line argument list.

proc lion::scrollableframe::view { w orient args } {
  variable config
  switch -- [lindex $args 0] {
    "" {
      return [ratios $w $orient]
    }
    moveto {
      set fraction [lindex $args 1]
      set dim [dimension $orient]
      set wsize [widgetsize $w $dim]
      set limit [expr ($wsize - [winfo $dim $w]) * -1]
      set config($w,${orient}offset) [expr $fraction * $wsize * -1]
      if {$config($w,${orient}offset) < $limit} {
        set config($w,${orient}offset) $limit
      }
      if {$config($w,${orient}offset) > 0} {
        set config($w,${orient}offset) 0
      }
      scrollto $w ${orient} $config($w,${orient}offset)
    }
    scroll {
      set number [expr [lindex $args 1] * -1 * $config($w,${orient}step)]
      set what [lindex $args 2]
      set dim [dimension $orient]
      set wsize [widgetsize $w $dim]
      switch -- $what {
        units {
          set config($w,${orient}offset) \
              [expr $config($w,${orient}offset) + ($number)]
        }
        pages {
          set config($w,${orient}offset) \
              [expr $config($w,${orient}offset) + ($number * $wsize)]
        }
      }
      set limit [expr ($wsize - [winfo $dim $w]) * -1]
      if {$config($w,${orient}offset) < $limit} {
        set config($w,${orient}offset) $limit
      }
      if {$config($w,${orient}offset) > 0} {
        set config($w,${orient}offset) 0
      }
      scrollto $w ${orient} $config($w,${orient}offset)
    }
  }
}

# lion::scrollableframe::options --
# After the scrolled frame widget is created, the user can call
#   wiget_path option <args>
# this procs handles various different options.
#
# Arguments:
# option -        The scrolled frame option.
# w -             The scrolled frame window.
# args -          The command line argument list.

proc lion::scrollableframe::options { w option args } {
  variable config
  switch -- $option {
    xview {
      return [eval view $w x $args]
    }
    yview {
      return [eval view $w y $args]
    }
    cget {
      set attr [string range $args 1 end]
      if {[info exists config($w,$attr)]} {
        return $config($w,$attr)
      } else {
        return ""
      }
    }
    swallow - configure {
      return [eval $option $w $args]
    }
  }
}

# lion::scrollableframe::cleaninternal --
# Clean up internal memory when a scrollableframe is destroyed
#
# Arguments:
# w -             The scrollableframe window.

proc lion::scrollableframe::cleaninternal { w } {
  variable config
  foreach c [array names config] {
    if {[string match "$w," $c]} {
      unset config($c)
    }
  }
}

# lion::scrollableframe::scrollableframe --
# This procedure creates an scrooled frame widget of class
# Lionscrollableframe.
#
# Arguments:
# w -             The scrollableframe window.
# args -          The command line configuration arguments.

proc lion::scrollableframe::scrollableframe { w args } {
  variable config
  array set config [list $w,xoffset 1 $w,xstep 1 $w,yoffset 0 $w,ystep 1 \
        $w,curwidget "" $w,xscrollcommand "" $w,yscrollcommand "" \
        $w,widthcommand "" $w,heightcommand ""]
  set configlist [eval parseoptions $w $args]

  bind Lionscrollableframe <Configure> {namespace eval lion::scrollableframe {
  foreach orient {x y} {
    if {$config(%W,${orient}scrollcommand) != ""} {
      eval $config(%W,${orient}scrollcommand) [ratios %W $orient]
    }
    scrollto %W $orient 0
    set config(%W,${orient}offset) 0
  }
  }}

  bind Lionscrollableframe <Destroy> {namespace eval lion::scrollableframe {
  cleaninternal %W
  }}

  eval frame $w -class Lionscrollableframe $configlist
  rename $w $w
  proc ::$w {args} [subst -nocommand {
    set option [lindex \$args 0]
    return [eval lion::scrollableframe::options $w \$option [lrange \$args 1 end]]
  }]
  return $w

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

