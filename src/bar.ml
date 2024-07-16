type components =
  | Bat of Bat.t
  | Temp of Temp.t
  | Date of Date.t
  | Time of Time.t
  | Btc of Bitcoin.t

type t = { components : components list; sep : string option }

let bat b = Bat b

let temp t = Temp t

let date t = Date t

let time t = Time t

let btc b = Btc b

let init ?sep () = { components = []; sep }

let add bar c = { bar with components = c :: bar.components }

let ( $ ) = add

let update bar =
  let update_component = function
    | Bat b -> Bat.update b
    | Temp t -> Temp.update t
    | Date _ | Time _ | Btc _ -> ()
  in
  List.iter update_component bar.components

let draw_component fmt = function
  | Bat b -> Bat.pp fmt b
  | Temp t -> Temp.pp fmt t
  | Date d -> Date.pp fmt d
  | Time t -> Time.pp fmt t
  | Btc b -> Bitcoin.pp fmt b

let draw fmt { components; sep } =
  Format.pp_print_list
    ~pp_sep:(fun fmt () ->
      Format.pp_print_option
        (fun fmt sep -> Format.fprintf fmt " %s " sep)
        fmt sep)
    draw_component fmt components
