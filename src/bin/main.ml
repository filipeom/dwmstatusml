open Xlib
open System

let with_display f =
  let dpy = xOpenDisplay () in
  Fun.protect ~finally:(fun () -> xCloseDisplay dpy) (fun () -> f dpy)

let set_status (dpy : Xlib.display) msg =
  xStoreName dpy (xDefaultRootWindow dpy) msg;
  xSync ~discard:false dpy

let thermal_sensor = "/sys/class/thermal/thermal_zone0/temp"

let battery_sensor = "/sys/class/power_supply/BAT0"

let init_bar () =
  (* let btc = Bitcoin.init ~icon:"\u{f15a}" () in *)
  let t = Temp.init ~icon:"\u{f4bc}\u{2009}" thermal_sensor in
  let b = Bat.init ~icon:"\u{f0e7}" battery_sensor in
  let dt = Date.init ~icon:"\u{f133}\u{2009}" () in
  let tm = Time.init ~icon:"\u{f017}\u{2009}" () in
  let bar =
    Bar.(init ~sep:"\u{e0bb}" () $ time tm $ date dt $ bat b $ temp t)
  in
  Bar.update bar;
  bar

let () =
  let bar = init_bar () in
  with_display (fun dpy ->
      while true do
        Bar.update bar;
        Format.kasprintf (set_status dpy) "%a" Bar.draw bar;
        Unix.sleepf 5.0
      done)
