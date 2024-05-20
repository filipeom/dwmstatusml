type battery_status = Charging | Discharging | Full | Unknown

type t = { capacity : int; status : battery_status }

let read base =
  let capacity =
    In_channel.with_open_text (Filename.concat base "capacity") (fun file ->
        int_of_string (input_line file))
  in
  let status =
    In_channel.with_open_text (Filename.concat base "status") (fun file ->
        match input_line file with
        | "Charging" -> Charging
        | "Discharging" -> Discharging
        | "Full" -> Full
        | _ -> Unknown)
  in
  { capacity; status }

let pp_battery_status fmt = function
  | Charging -> Format.fprintf fmt "+"
  | Discharging -> Format.fprintf fmt "-"
  | Full -> ()
  | Unknown -> Format.fprintf fmt "?"

let pp fmt { capacity; status } =
  match status with
  | Full -> Format.fprintf fmt "%d%%" capacity
  | _ -> Format.fprintf fmt "%d%% (%a)" capacity pp_battery_status status
