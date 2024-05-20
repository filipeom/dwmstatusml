let read sensor =
  In_channel.with_open_text sensor (fun ic ->
      match In_channel.input_line ic with
      | None -> -1
      | Some line -> (
          match int_of_string_opt line with None -> -1 | Some n -> n))

let pp fmt temperature =
  let temperature = float_of_int temperature /. 1000. in
  Format.fprintf fmt "%02.0f°C" temperature
