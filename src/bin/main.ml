open Xlib
open System

let with_display f =
  let dpy = xOpenDisplay () in
  Fun.protect ~finally:(fun () -> xCloseDisplay dpy) (fun () -> f dpy)

let set_status (dpy : Xlib.display) msg =
  xStoreName dpy (xDefaultRootWindow dpy) msg;
  xSync ~discard:false dpy

let init_bar () =
  let btc = Bitcoin.init ~icon:"\u{f15a}" () in
  let temp =
    Temp.init ~icon:"\u{f4bc}\u{2009}" "/sys/class/thermal/thermal_zone0/temp"
  in
  let bat = Bat.init ~icon:"\u{f0e7}" "/sys/class/power_supply/BAT0" in
  let date = Date.init ~icon:"\u{f133}\u{2009}" () in
  let time = Time.init ~icon:"\u{f017}\u{2009}" () in
  let bar = Bar.init ~sep:"\u{e0bb}" () in
  let bar = Bar.add_time bar time in
  let bar = Bar.add_date bar date in
  let bar = Bar.add_bat bar bat in
  let bar = Bar.add_temp bar temp in
  let bar = Bar.add_btc bar btc in
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
