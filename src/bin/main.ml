open X11.Xlib
open System
open Format

let update_time = 5.0

module Icon = struct
  let sep = "\u{e0bb}"
  let bolt = "\u{f0e7}"
  let cpu = "\u{f4bc}\u{2009}"
  let clk = "\u{f017}\u{2010}"
  let cal = "\u{f133}\u{2009}"
end

let pp_battery fmt bat =
  let icon = Icon.bolt in
  fprintf fmt "%s %a" icon Battery.pp bat

let set_status dpy msg =
  xStoreName dpy (xDefaultRootWindow dpy) msg;
  xSync dpy ~discard:false

let () =
  let dpy = open_display () in
  while true do
    let battery = Battery.read "/sys/class/power_supply/BAT0" in
    let time = Time.now () in
    let temp = Temperature.read "/sys/class/thermal/thermal_zone8/temp" in
    let status =
      asprintf " %s %a    %s %a" Icon.sep pp_battery battery Icon.sep Time.pp time
    in
    set_status dpy status;
    Unix.sleepf update_time
  done;
  xCloseDisplay dpy
