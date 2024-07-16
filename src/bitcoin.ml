open Binance

type t = { icon : string option }

let init ?icon () = { icon }

let pp fmt btc =
  Format.pp_print_option (fun fmt i -> Format.fprintf fmt "%s " i) fmt btc.icon;
  try
    match Lwt_main.run (Market.Ticker.price ~symbol:"BTCUSDC") with
    | Ok symbol ->
        let price = Yojson.Safe.Util.(member "price" symbol |> to_string) in
        let price = float_of_string price in
        Format.fprintf fmt "%0.02f" price
    | Error { code = _; msg = _ } -> Format.fprintf fmt "error"
  with _ -> Format.fprintf fmt "offline"
