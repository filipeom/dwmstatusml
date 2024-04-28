open Xlib

let set_status dpy msg =
  xStoreName ~dpy ~win:(xDefaultRootWindow ~dpy) ~name:msg;
  xSync ~dpy ~discard:false

let () =
  let open Format in
  let dpy = open_display () in
  while true do
    let battery = Battery.read "/sys/class/power_supply/BAT0" in
    let time = Time.time () in
    let status = asprintf "BAT: %a | %a" Battery.pp battery Time.pp time in
    set_status dpy status;
    Unix.sleepf 5.0
  done;
  xCloseDisplay ~dpy
