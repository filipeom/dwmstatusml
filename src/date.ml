type t = { icon : string option }

let init ?icon () = { icon }

let update () = ()

let now () =
  let time = Unix.gettimeofday () in
  Unix.localtime time

let pp fmt { icon } =
  Format.pp_print_option (fun fmt i -> Format.fprintf fmt "%s " i) fmt icon;
  let Unix.{ tm_mday; tm_mon; tm_wday; _ } = now () in
  let month =
    match tm_mon with
    | 0 -> "Jan"
    | 1 -> "Feb"
    | 2 -> "Mar"
    | 3 -> "Apr"
    | 4 -> "May"
    | 5 -> "Jun"
    | 6 -> "Jul"
    | 7 -> "Aug"
    | 8 -> "Sep"
    | 9 -> "Oct"
    | 10 -> "Nov"
    | 11 -> "Dec"
    | _ -> assert false
  in
  let day = tm_mday in
  let weekday =
    match tm_wday with
    | 0 -> "Sun"
    | 1 -> "Mon"
    | 2 -> "Tue"
    | 3 -> "Wed"
    | 4 -> "Thu"
    | 5 -> "Fri"
    | 6 -> "Sat"
    | _ -> assert false
  in
  Format.fprintf fmt "%s %d %s" weekday day month
