type t = { icon : string option }

let init ?icon () = { icon }

let update () = ()

let now () =
  let time = Unix.gettimeofday () in
  Unix.localtime time

let pp fmt { icon } =
  Format.pp_print_option (fun fmt i -> Format.fprintf fmt "%s " i) fmt icon;
  let Unix.{ tm_min; tm_hour; _ } = now () in
  Format.fprintf fmt "%02d:%02d" tm_hour tm_min
