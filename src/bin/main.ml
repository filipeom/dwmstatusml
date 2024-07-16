open Xlib
open System
open Format

let btc = "\u{f15a}"

let sep = "\u{e0bb}"

let bolt = "\u{f0e7}"

let cpu = "\u{f4bc}\u{2009}"

let clock = "\u{f017}\u{2009}"

let cal = "\u{f133}\u{2009}"

let interval = 5.0

let pp_btc fmt () =
  let open Binance in
  Format.fprintf fmt "%s " btc;
  try
    let btc_price = Market.Ticker.price ~symbol:"BTCUSDC" in
    match Lwt_main.run btc_price with
    | Ok symbol ->
        let price = Yojson.Safe.Util.(member "price" symbol |> to_string) in
        let price = float_of_string price in
        Format.fprintf fmt "%0.02f" price
    | Error { code; msg } -> Format.fprintf fmt "%d: %s" code msg
  with _ -> Format.fprintf fmt "-1"

let pp_temp fmt temp = fprintf fmt "%s %a" cpu Temperature.pp temp

let pp_battery fmt bat = fprintf fmt "%s %a" bolt Battery.pp bat

let pp_date fmt datetime = fprintf fmt "%s %a" cal Time.pp_date datetime

let pp_time fmt datetime = fprintf fmt "%s %a" clock Time.pp_time datetime

let set_status dpy msg =
  xStoreName dpy (xDefaultRootWindow dpy) msg;
  xSync ~discard:false dpy

let () =
  let dpy = xOpenDisplay () in
  while true do
    let datetime = Time.now () in
    let bat = Battery.read "/sys/class/power_supply/BAT0" in
    let temp = Temperature.read "/sys/class/thermal/thermal_zone0/temp" in
    let status =
      asprintf " %s %a %s %a %s %a %s %a %s %a" sep pp_btc () sep pp_temp temp
        sep pp_battery bat sep pp_date datetime sep pp_time datetime
    in

    set_status dpy status;
    Unix.sleepf interval
  done;
  xCloseDisplay dpy
