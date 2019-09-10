#!/usr/bin/env tclsh

package require Tk
package require sha1

wm state . withdrawn

font configure TkDefaultFont -family "Noto Sans" -size 9
font configure TkTextFont -family "Noto Sans" -size 9

proc center_window win {
  if {[string equal $win [winfo toplevel $win]]} {
    set g [split [wm geometry $win] {x+}]
    set resls [exec bash -c {
      xrandr | grep -Po '[0-9]+x[0-9]+\+[0-9]+\+[0-9]'
    }]
    foreach res $resls {
      set sc [split $res {x+}]
      if {[winfo pointerx $win] < [lindex $sc 0] && [winfo pointery $win] < [lindex $sc 1]} {
        break
      }
    }
    set x [expr {([lindex $sc 0]-[lindex $g 0])/2+[lindex $sc 2]}]
    set y [expr {([lindex $sc 1]-[lindex $g 1])/2+[lindex $sc 3]}]
    wm geometry $win +$x+$y
  }
}

proc do_chpwd {oldpw0 newpw0 newpw1} {
  set g0 [sha1::sha1 $oldpw0]
  set g1 [sha1::sha1 $newpw0]
  set g2 [sha1::sha1 $newpw1]
  do_send "__send_chpwd $g0 $g1 $g2"
}

proc do_logon {user pass} {
  set h0 [sha1::sha1 $user]
  set h1 [sha1::sha1 $pass]
  do_send "__send_logon $h0 $h1"
}

proc do_read_code data {
  set h2 [sha1::sha1 $data]
  do_send "__send_read_code $h2"
}

proc win_chpwd {} {
  set oldpw0 {}
  set newpw0 {}
  set newpw1 {}

  toplevel .top_chpwd
  wm geometry .top_chpwd 250x170+9999+9999
  wm resizable .top_chpwd 0 0
  wm title .top_chpwd "Alterar senha"
  wm protocol .top_chpwd WM_DELETE_WINDOW {
    destroy .top_chpwd
  }

  labelframe .top_chpwd.labelframe0 -text "Entre com seus dados"
  label .top_chpwd.labelframe0.label0 -text "Senha atual"
  grid .top_chpwd.labelframe0.label0 -column 0 -padx 5 -pady 5 -row 0

  entry .top_chpwd.labelframe0.entry0 -show * -textvariable oldpw0 -width 19
  grid .top_chpwd.labelframe0.entry0 -column 1 -padx 5 -pady 5 -row 0

  label .top_chpwd.labelframe0.label1 -text "Nova senha"
  grid .top_chpwd.labelframe0.label1 -column 0 -padx 5 -pady 5 -row 1

  entry .top_chpwd.labelframe0.entry1 -show * -textvariable newpw0 -width 19
  grid .top_chpwd.labelframe0.entry1 -column 1 -padx 5 -pady 5 -row 1

  label .top_chpwd.labelframe0.label2 -text "Confirmar"
  grid .top_chpwd.labelframe0.label2 -column 0 -padx 5 -pady 5 -row 2

  entry .top_chpwd.labelframe0.entry2 -show * -textvariable newpw1 -width 19
  grid .top_chpwd.labelframe0.entry2 -column 1 -padx 5 -pady 5 -row 2
  pack .top_chpwd.labelframe0 -expand true -padx 5 -pady 5

  frame .top_chpwd.frame0
  button .top_chpwd.frame0.button0 -text "Fechar" -command {
    destroy .top_chpwd
  }
  grid .top_chpwd.frame0.button0 -column 0 -padx 5 -pady 5 -row 0

  button .top_chpwd.frame0.button1 -text "Limpar" -command {
    set oldpw0 {}
    set newpw0 {}
    set newpw1 {}
    focus .top_chpwd.labelframe0.entry0
  }
  grid .top_chpwd.frame0.button1 -column 1 -padx 5 -pady 5 -row 0

  button .top_chpwd.frame0.button2 -text "Atualizar" -command {
    do_chpwd $oldpw0 $newpw0 $newpw1
    destroy .top_chpwd
  }
  grid .top_chpwd.frame0.button2 -column 2 -padx 5 -pady 5 -row 0
  pack .top_chpwd.frame0 -expand true

  bind .top_chpwd <Return> {
    .top_chpwd.frame0.button2 invoke
  }

  bind .top_chpwd <Destroy> {
    set oldpw0 {}
    set newpw0 {}
    set newpw1 {}
  }

  after 200 {
    center_window .top_chpwd
    focus .top_chpwd.labelframe0.entry0
  }
}

proc win_logon {} {
  set user {}
  set pass {}

  toplevel .top_logon
  wm geometry .top_logon 220x140+9999+9999
  wm resizable .top_logon 0 0
  wm title .top_logon "Logon"
  wm protocol .top_logon WM_DELETE_WINDOW {
    do_exit
  }

  labelframe .top_logon.labelframe0 -text "Entre com seus dados"
  label .top_logon.labelframe0.label0 -text "Usuário"
  grid .top_logon.labelframe0.label0 -column 0 -padx 5 -pady 5 -row 0

  entry .top_logon.labelframe0.entry0 -textvariable user -width 18
  grid .top_logon.labelframe0.entry0 -column 1 -padx 5 -pady 5 -row 0

  label .top_logon.labelframe0.label1 -text "Senha"
  grid .top_logon.labelframe0.label1 -column 0 -padx 5 -pady 5 -row 1

  entry .top_logon.labelframe0.entry1 -show * -textvariable pass -width 18
  grid .top_logon.labelframe0.entry1 -column 1 -padx 5 -pady 5 -row 1
  pack .top_logon.labelframe0 -expand true -padx 5 -pady 5 -side top

  frame .top_logon.frame0
  button .top_logon.frame0.button0 -text "Sair" -command {
    do_exit
  }
  grid .top_logon.frame0.button0 -column 0 -padx 5 -pady 5 -row 0

  button .top_logon.frame0.button1 -text "Limpar" -command {
    set user {}
    set pass {}
    focus .top_logon.labelframe0.entry0
  }
  grid .top_logon.frame0.button1 -column 1 -padx 5 -pady 5 -row 0

  button .top_logon.frame0.button2 -text "Entrar!" -command {
    do_logon $user $pass
    destroy .top_logon
  }
  grid .top_logon.frame0.button2 -column 2 -padx 5 -pady 5 -row 0
  pack .top_logon.frame0 -expand true -side bottom

  bind .top_logon <Return> {
    .top_logon.frame0.button2 invoke
  }

  bind .top_logon <Destroy> {
    set user {}
    set pass {}
  }

  after 200 {
    center_window .top_logon
    focus .top_logon.labelframe0.entry0
  }
}

proc win_read_code {} {
  set data {}

  toplevel .top_read_code
  wm geometry .top_read_code 500x70+9999+9999
  wm resizable .top_read_code 0 0
  wm title .top_read_code "Logon"
  wm protocol .top_read_code WM_DELETE_WINDOW { }

  labelframe .top_read_code.labelframe0 -text "Passe o cartão na leitora"
  entry .top_read_code.labelframe0.entry0 -show * -textvariable data
  pack .top_read_code.labelframe0.entry0 -expand true -fill x -padx 5 -pady 5
  pack .top_read_code.labelframe0 -expand true -fill both -padx 5 -pady 5

  bind .top_read_code <Return> {
    do_read_code $data
    destroy .top_read_code
  }

  bind .top_read_code <Destroy> {
    set data {}
  }

  after 200 {
    center_window .top_read_code
    focus .top_read_code.labelframe0.entry0
  }
}
