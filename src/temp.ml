type t = { icon : string option; sensor : string; mutable reading : int }

let read sensor =
  try
    In_channel.with_open_text sensor (fun ic ->
        match In_channel.input_line ic with
        | None -> -1
        | Some line -> (
            match int_of_string_opt line with None -> -1 | Some n -> n))
  with Sys_error _ -> -1

let init ?icon sensor = { icon; sensor; reading = -1 }

let update t = t.reading <- read t.sensor

let pp fmt t =
  Format.pp_print_option (fun fmt i -> Format.fprintf fmt "%s " i) fmt t.icon;
  let temperature = float_of_int t.reading /. 1000. in
  Format.fprintf fmt "%02.0f°C" temperature
