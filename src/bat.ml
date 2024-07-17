type battery_status = Charging | Discharging | Full | Unknown

type reading = { capacity : int; status : battery_status }

type t = { icon : string option; sensor : string; mutable reading : reading }

let read sensor =
  let capacity =
    try
      In_channel.with_open_text (Filename.concat sensor "capacity") (fun file ->
          int_of_string (input_line file))
    with Sys_error _ -> 0
  in
  let status =
    try
      In_channel.with_open_text (Filename.concat sensor "status") (fun file ->
          match input_line file with
          | "Charging" -> Charging
          | "Discharging" -> Discharging
          | "Full" -> Full
          | _ -> Unknown)
    with Sys_error _ -> Unknown
  in
  { capacity; status }

let init ?icon sensor =
  { icon; sensor; reading = { capacity = 0; status = Unknown } }

let update bat = bat.reading <- read bat.sensor

let pp_battery_status fmt = function
  | Charging -> Format.fprintf fmt "+"
  | Discharging -> Format.fprintf fmt "-"
  | Full -> ()
  | Unknown -> Format.fprintf fmt "?"

let pp fmt { icon; reading = { capacity; status }; _ } =
  Format.pp_print_option (fun fmt i -> Format.fprintf fmt "%s " i) fmt icon;
  match status with
  | Full -> Format.fprintf fmt "%d%%" capacity
  | _ -> Format.fprintf fmt "%d%% (%a)" capacity pp_battery_status status
